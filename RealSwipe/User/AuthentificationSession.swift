//
//  AuthentificationSession.swift
//  RealSwipe
//
//  Created by nlorrain on 21/05/2025.
//

import Foundation
import Combine

@MainActor
class AuthentificationService {
  
  enum Error: Swift.Error {
    case failure
  }
  
  private let authTokenKey = "auth_token_key"
  static let shared = AuthentificationService()
  
  private let keychainHelper: KeychainHelper
  private let apiClient: APIClientProtocol
  private var bag = Set<AnyCancellable>()
  
  private var _userSessionPublisher = CurrentValueSubject<UserSession?, Never>(nil)
  var userSessionPublisher: AnyPublisher<UserSession?, Never> {
    _userSessionPublisher.eraseToAnyPublisher()
  }
  
  var userSession: UserSession? {
    _userSessionPublisher.value
  }
  
  var isAuthenticated: Bool { _userSessionPublisher.value != nil }
  
  init(apiClient: APIClientProtocol = APIClient(),
       keychainHelper: KeychainHelper = KeychainHelper()) {
    
    self.keychainHelper = keychainHelper
    self.apiClient = apiClient
    
    guard let authTokenKeyData = keychainHelper.read(authTokenKey) else { return }
    
    guard let authTokenKey = String(data: authTokenKeyData, encoding: .utf8) else {
      keychainHelper.delete(authTokenKey)
      return
    }
    
    guard let userSession = UserSession.loadFromCache(token: authTokenKey) else {
      keychainHelper.delete(authTokenKey)
      return
    }
    
    _userSessionPublisher.send(userSession)
  }
  
  func disconnect() {
    keychainHelper.delete(authTokenKey)
    userSession?.reset()
    _userSessionPublisher.send(nil)
  }
  
  func register(firstName: String,
                genderId: Int,
                email: String,
                password: String,
                birthday: TimeInterval) async throws {
    let logginData = try await apiClient.sendRequest(to: RegisterEndpoint( data: .init(firstName: firstName,
                                                                                       genderId: 1,
                                                                                       email: email,
                                                                                       password: password,
                                                                                       birthday: birthday)))
    
    guard let authTokenData = logginData.authToken.data(using: .utf8) else { throw Error.failure }
    keychainHelper.save(authTokenKey, data: authTokenData)
    let userSession = UserSession.build(from: logginData.authToken,
                                        user: User(userId: logginData.user.id,
                                                   firstName: logginData.user.firstName,
                                                   birthday: Date(timeIntervalSince1970: logginData.user.birthday)))
    _userSessionPublisher.send(userSession)
    
  }
  
  func loggin(email: String, password: String) async throws {
    let logginData = try await apiClient.sendRequest(to: LoggingEndpoint(data: .init(email: email,
                                                                                        password: password)))
    guard let authTokenData = logginData.authToken.data(using: .utf8) else { throw Error.failure }
    keychainHelper.save(authTokenKey, data: authTokenData)
    let userSession = UserSession.build(from: logginData.authToken,
                                        user: User(userId: logginData.user.id,
                                                   firstName: logginData.user.firstName,
                                                   birthday: Date(timeIntervalSince1970: logginData.user.birthday)))
    _userSessionPublisher.send(userSession)
  }
}

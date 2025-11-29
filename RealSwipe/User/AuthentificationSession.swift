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
  

  private var _userSessionDataPublisher: CurrentValueSubject<(usesrSession: UserSession?, didlaunched: Bool), Never>
  var userSessionDataPublisher: AnyPublisher<(usesrSession: UserSession?, didlaunched: Bool), Never> {
    _userSessionDataPublisher.eraseToAnyPublisher()
  }
  
  var userSession: UserSession? {
    _userSessionDataPublisher.value.usesrSession
  }
  
  var isAuthenticated: Bool { _userSessionDataPublisher.value.usesrSession != nil }
  
  init(apiClient: APIClientProtocol = APIClient(),
       keychainHelper: KeychainHelper = KeychainHelper()) {
    
    self.keychainHelper = keychainHelper
    self.apiClient = apiClient
    
    guard let authTokenKeyData = keychainHelper.read(authTokenKey) else {
      _userSessionDataPublisher = .init((usesrSession: nil, didlaunched: true))
      return
    }
    
    guard let authTokenKey = String(data: authTokenKeyData, encoding: .utf8) else {
      keychainHelper.delete(authTokenKey)
      _userSessionDataPublisher = .init((usesrSession: nil, didlaunched: true))
      return
    }
    
    guard let userSession = UserSession.loadFromCache(token: authTokenKey) else {
      keychainHelper.delete(authTokenKey)
      _userSessionDataPublisher = .init((usesrSession: nil, didlaunched: true))
      return
    }
    
    _userSessionDataPublisher = .init((usesrSession: userSession, didlaunched: true))
  }
  
  func disconnect() {
    keychainHelper.delete(authTokenKey)
    userSession?.reset()
    _userSessionDataPublisher.send((usesrSession: nil, didlaunched: false))
  }
  
  func register(firstName: String,
                genderId: Int,
                email: String,
                password: String,
                birthday: TimeInterval) async throws {
    let logginData = try await apiClient.sendRequest(to: RegisterEndpoint( data: .init(firstName: firstName,
                                                                                       genderId: genderId,
                                                                                       email: email,
                                                                                       password: password,
                                                                                       birthday: birthday)))
    
    guard let authTokenData = logginData.authToken.data(using: .utf8) else { throw Error.failure }
    keychainHelper.save(authTokenKey, data: authTokenData)
    let userSession = UserSession.build(from: logginData.authToken,
                                        user: UserSessionData(userId: logginData.user.id,
                                                   firstName: logginData.user.firstName,
                                                              birthday: Date(timeIntervalSince1970: logginData.user.birthday),
                                                              gender: Gender(rawValue: logginData.user.genderId)))
    _userSessionDataPublisher.send((usesrSession: userSession, didlaunched: false))
    
  }
  
  func loggin(email: String, password: String) async throws {
    let logginData = try await apiClient.sendRequest(to: LoggingEndpoint(data: .init(email: email,
                                                                                        password: password)))
    guard let authTokenData = logginData.authToken.data(using: .utf8) else { throw Error.failure }
    keychainHelper.save(authTokenKey, data: authTokenData)
    print("tototo \( logginData.user.genderId)")
    print("tototo \( Gender(rawValue: logginData.user.genderId))")
    let userSession = UserSession.build(from: logginData.authToken,
                                        user: UserSessionData(userId: logginData.user.id,
                                                              firstName: logginData.user.firstName,
                                                              birthday: Date(timeIntervalSince1970: logginData.user.birthday),
                                                              gender: Gender(rawValue: logginData.user.genderId)))
    _userSessionDataPublisher.send((usesrSession: userSession, didlaunched: false))
  }
}


//
//  UserSession.swift
//  RealSwipe
//
//  Created by Utilisateur on 21/05/2025.
//

import Foundation
import Combine

struct UserSession: Identifiable {
  let id = UUID()
  
  static let key = "UserDefaults_User_Key"
  private let _didUpdate = PassthroughSubject<Void, Never>()
  var didUpdate: AnyPublisher<Void, Never> { _didUpdate.eraseToAnyPublisher() }
  
  let token: String
  
  var user: User {
    didSet {
      save()
      _didUpdate.send(())
    }
  }
  
  private init(token: String, user: User) {
    self.token = token
    self.user = user
    save()
  }
  
  func reset() {
    UserDefaults.standard.removeObject(forKey: Self.key)
  }
  
  func save() {
    guard let encoded = try? JSONEncoder().encode(user) else { return }
    UserDefaults.standard.set(encoded, forKey: Self.key)
  }
  
  static func build(from token: String, user: User) -> UserSession {
    let userSession = UserSession.init(token: token, user: user)
    userSession.save()
    return userSession
  }
  
  static func loadFromCache(token: String) -> UserSession? {
    if let userData = UserDefaults.standard.data(forKey: Self.key) {
      if let user = try? JSONDecoder().decode(User.self, from: userData) {
        return .init(token: token, user: user)
      } else {
        UserDefaults.standard.removeObject(forKey: key)
        return nil
      }
    } else {
      return nil
    }
  }
}

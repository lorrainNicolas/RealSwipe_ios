//
//  AuthResponce.swift
//  RealSwipe
//
//  Created by Utilisateur on 21/05/2025.
//

import Foundation

struct AuthResponce: Decodable {
  let authToken: String
  let user: UserResponce
  
  enum CodingKeys : String, CodingKey {
      case authToken = "auth_token"
      case user = "user"
  }
}

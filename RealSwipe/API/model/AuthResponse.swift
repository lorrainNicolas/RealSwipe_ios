//
//  AuthResponse.swift
//  RealSwipe
//
//  Created by Utilisateur on 21/05/2025.
//

import Foundation

struct AuthResponse: Decodable {
  
  let authToken: String
  let user: UserResponse
  
  enum CodingKeys : String, CodingKey {
      case authToken = "auth_token"
      case user = "user"
  }
}

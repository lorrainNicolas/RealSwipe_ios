//
//  UserResponse.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import Foundation

struct UserResponse: Decodable {
  
  let id: UUID
  let firstName: String
  let genderId: Int
  let email: String
  let birthday: Double
  let profileImageUrl: URL?
  
  enum CodingKeys : String, CodingKey {
    case id = "id"
    case firstName = "first_name"
    case genderId = "gender_id"
    case email = "email"
    case birthday = "birthdate"
    case profileImageUrl = "profile_image"
  }
}

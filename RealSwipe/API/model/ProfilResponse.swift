//
//  ProfilResponse.swift
//  RealSwipe
//
//  Created by Utilisateur on 14/06/2025.
//

import Foundation

struct ProfilResponse: Decodable {
  
  let id: UUID
  let firstName: String
  let genderId: Int
  let birthdate: Double?
  let profileImageUrl: URL?
  
  enum CodingKeys : String, CodingKey {
    case id = "id"
    case firstName = "first_name"
    case genderId = "gender_id"
    case birthdate = "birthdate"
    case profileImageUrl = "profile_image"
  }
}

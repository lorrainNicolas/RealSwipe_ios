//
//  UserResponce.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import Foundation

struct UserResponce: Decodable {
  
  let id: String
  let firstName: String
  let genderId: Int
  let email: String
  
  enum CodingKeys : String, CodingKey {
    case id = "id"
    case firstName = "first_name"
    case genderId = "gender_id"
    case email = "email"
  }
}

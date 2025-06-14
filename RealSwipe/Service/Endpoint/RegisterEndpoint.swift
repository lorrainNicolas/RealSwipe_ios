//
//  RegisterEndpoint.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation

struct RegisterEndpoint: Endpoint {
  
  struct InputData: Encodable, Sendable {
    let firstName: String
    let genderId: Int
    let email: String
    let password: String
    let birthday: Double
    
    enum CodingKeys : String, CodingKey {
      case firstName = "first_name"
      case genderId = "gender_id"
      case email = "email"
      case password = "password"
      case birthday = "birthdate"
    }
  }
  
  let input: POST<InputData>
  
  typealias Output = AuthResponse
  
  var token: String? = nil
  var path: String { "auth/register" }
  
  init(data: InputData) {
    self.input = POST<InputData>(data: data)
  }
}

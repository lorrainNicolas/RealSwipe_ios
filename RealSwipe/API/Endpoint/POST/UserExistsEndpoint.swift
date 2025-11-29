//
//  UserExistsEndpoint.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/06/2023.
//

import Foundation

struct UserExistsEndpoint: Endpoint {
  
  struct InputData: Encodable, Sendable {
    let email: String
  }
  
  struct OutputData: Decodable {
    let didExist: Bool
    
    enum CodingKeys : String, CodingKey {
        case didExist = "did_exist"
    }
  }
  
  let input: POST<InputData>

  typealias Output = Self.OutputData
  
  var token: String? = nil
  var path: String { "auth/user-exists" }
  
  init(data: InputData) {
    self.input = POST<InputData>(data: data)
  }
  
}

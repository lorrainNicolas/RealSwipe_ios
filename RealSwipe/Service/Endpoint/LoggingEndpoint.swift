//
//  LoggingEndpoint.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/06/2023.
//

import Foundation

struct LoggingEndpoint: Endpoint {
  
  struct InputData: Encodable, Sendable {
    let email: String
    let password: String
  }
  
  let input: POST<InputData>
  
  typealias Output = AuthResponce
  
  var token: String? = nil
  var path: String { "auth/login" }
  
  init(data: InputData) {
    self.input = POST<InputData>(data: data)
  }
}

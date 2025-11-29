//
//  GetMeEndpoint.swift
//  RealSwipe
//
//  Created by Utilisateur on 29/11/2025.
//

struct GetMeEndpoint: Endpoint, TokenHandler {
  
  let input = GET()
  
  typealias Output = UserResponse
  
  let token: String
  
  var path: String { "user/me" }
}

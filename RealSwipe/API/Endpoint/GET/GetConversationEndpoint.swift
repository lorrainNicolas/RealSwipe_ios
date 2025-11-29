//
//  GetConversationEndpoint.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import Foundation

struct GetConversationEndpoint: Endpoint, TokenHandler {
  
  struct OutputData: Decodable {
    let id: UUID
    let profile: ProfilResponse
    let seq: Int
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case profile = "profile"
        case seq = "seq"
    }
  }
  
  let input = GET()
  
  typealias Output = [GetConversationEndpoint.OutputData]
  
  let token: String
  
  var path: String { "conversation/" }
}

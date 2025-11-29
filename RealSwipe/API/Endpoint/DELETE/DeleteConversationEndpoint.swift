//
//  DeleteConversationEndpoint.swift
//  RealSwipe
//
//  Created by Utilisateur on 22/11/2025.
//

import Foundation

struct DeletetConversationEndpoint: Endpoint, TokenHandler {
  
  let input = DELETE()
  
  struct OutputData: Decodable {
    let conversationId: UUID
    
    enum CodingKeys : String, CodingKey {
        case conversationId = "conversation_id"
    }
  }
  
  typealias Output = Self.OutputData
  
  let token: String
  
  let path: String
  
  init(conversation: UUID, token: String) {
    self.token = token
    self.path = "conversation/\(conversation)"
  }
}

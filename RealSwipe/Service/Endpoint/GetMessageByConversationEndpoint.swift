//
//  GetMessageByConversationEndpoint.swift
//  RealSwipe
//
//  Created by Utilisateur on 09/11/2025.
//

import Foundation

struct GetMessageByConversationEndpoint: Endpoint, TokenHandler {
  
  struct OutputData: Decodable {
    let conversationId: UUID
    let messages: [MessageResponse]
    
    enum CodingKeys : String, CodingKey {
        case conversationId = "conversation_id"
        case messages = "messages"
    }
  }
  
  let input = GET()
  
  typealias Output = GetMessageByConversationEndpoint.OutputData
  
  let token: String
  
  let path: String
  
  init(conversation: UUID, token: String) {
    self.token = token
    self.path = "conversation/\(conversation)/messages"
  }
}


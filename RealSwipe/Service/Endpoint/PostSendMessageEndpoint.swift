//
//  PostSendMessageEndpoint.swift
//  RealSwipe
//
//  Created by Utilisateur on 15/06/2025.
//

import Foundation

struct PostSendMessageEndpoint: Endpoint, TokenHandler {
  
  struct InputData: Encodable, Sendable {
    let message: String
  }
  
  
  struct OutputData: Decodable {
    let id: UUID
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
    }
  }
  
  typealias Output = GetConversationEndpoint.OutputData
  
  let input: POST<InputData>
  let token: String
  let path: String
  
  init(data: InputData, conversation: UUID, token: String) {
    self.input = POST<InputData>(data: data)
    self.token = token
    self.path = "conversation/\(conversation)/messages"
  }
}


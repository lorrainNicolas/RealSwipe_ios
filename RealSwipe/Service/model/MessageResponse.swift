//
//  MessageResponse.swift
//  RealSwipe
//
//  Created by Utilisateur on 09/11/2025.
//

import Foundation

struct MessageResponse: Codable {
    let id: UUID
    let message: String
    let conversationId: UUID
    let senderId: UUID
    let seq: Int64
  
  enum CodingKeys : String, CodingKey {
      case id, message, seq
      case conversationId = "conversation_id"
      case senderId = "sender_id"
  }
}

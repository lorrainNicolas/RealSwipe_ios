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
    let sentAt: TimeInterval
    let seq: Int
  
  enum CodingKeys : String, CodingKey {
      case id, message, seq
      case sentAt = "sent_at"
      case conversationId = "conversation_id"
      case senderId = "sender_id"
  }
}

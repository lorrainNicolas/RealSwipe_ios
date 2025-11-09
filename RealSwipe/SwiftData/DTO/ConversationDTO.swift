//
//  ConversationDTO.swift
//  RealSwipe
//
//  Created by Utilisateur on 08/11/2025.
//

import Foundation

struct ConversationDTO {
  let id: UUID
  let createdAt: Date
  let participant: UserDTO
  
  static func map(from conversationModel: ConversationModel) -> Self {
    .init(id: conversationModel.id, createdAt: conversationModel.createdAt, participant: .map(from: conversationModel.participant))
  }
}

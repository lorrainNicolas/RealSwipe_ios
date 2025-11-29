//
//  MessageDTO.swift
//  RealSwipe
//
//  Created by Utilisateur on 09/11/2025.
//

import Foundation

struct MessageDTO {
  
  let localId: UUID
  let backendId: UUID?
  let text: String
  let sentAt: Double
  let seq: Int
  let isCurrentUser: Bool
  let conversationModel: ConversationDTO
  
  static func map(from messageModel: MessageModel) -> Self {
    .init(localId: messageModel.localId,
          backendId: messageModel.backendId,
          text: messageModel.text,
          sentAt: messageModel.sentAt,
          seq: messageModel.seq,
          isCurrentUser: messageModel.isCurrentUser,
          conversationModel: .map(from: messageModel.conversation))
  }
}

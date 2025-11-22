//
//  MessageDTO.swift
//  RealSwipe
//
//  Created by Utilisateur on 09/11/2025.
//

import Foundation

struct MessageDTO {
  
  let id: UUID
  let backendId: UUID?
  let text: String
  let sentAt: Date
  let seq: Int64
  let isCurrentUser: Bool
  
  static func map(from messageModel: MessageModel) -> Self {
    .init(id: messageModel.id,
          backendId: messageModel.backendId,
          text: messageModel.text,
          sentAt: messageModel.sentAt,
          seq: messageModel.seq,
          isCurrentUser: messageModel.isCurrentUser)
  }
}

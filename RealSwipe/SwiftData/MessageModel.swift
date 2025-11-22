//
//  MessageModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 08/11/2025.
//

import SwiftData
import Foundation

@Model
class MessageModel {
  
  #Index<MessageModel>([\.sentAt])
  
  @Attribute(.unique)
  var id: UUID = UUID()
  
  var backendId: UUID?
  var text: String
  var sentAt: Date
  var isCurrentUser: Bool
  var seq: Int64
  var conversation: ConversationModel
  
  
  init(text: String,
       backendId: UUID?,
       sentAt: Date,
       seq: Int64,
       isCurrentUser: Bool,
       
       conversation: ConversationModel) {
    self.text = text
    self.backendId = backendId
    self.sentAt = sentAt
    self.seq = seq
    self.isCurrentUser = isCurrentUser
    self.conversation = conversation
  }
}

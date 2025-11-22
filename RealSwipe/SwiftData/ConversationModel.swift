//
//  ConversationModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 08/11/2025.
//

import SwiftData
import Foundation

@Model
class ConversationModel {
  
  @Attribute(.unique)
  var id: UUID = UUID()
  var backendId: UUID
  
  var createdAt: Date
  var seq: Int64 = 0
  var participant: UserModel
  var isSync: Bool
  
  @Relationship(deleteRule: .cascade)
  var messages: [MessageModel] = []
  
  init(backendId: UUID,
       createdAt: Date,
       participant: UserModel,
       isSync: Bool) {
    self.backendId = backendId
    self.createdAt = createdAt
    self.participant = participant
    self.isSync = isSync
  }
}

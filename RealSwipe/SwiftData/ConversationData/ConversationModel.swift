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
  var localId: UUID = UUID()
  var backendId: UUID
  
  var createdAt: Date
  var seq: Int = 0
  
  @Relationship(deleteRule: .cascade)
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

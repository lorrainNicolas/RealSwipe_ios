//
//  UserModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 08/11/2025.
//

import SwiftData
import Foundation

@Model
class UserModel {
  
  @Attribute(.unique)
  var id: UUID = UUID()
  
  var backendId: UUID
  var username: String
  
  @Relationship(deleteRule: .cascade)
  var conversation: ConversationModel?
  
  init(backendId: UUID,
       username: String,
       conversation: ConversationModel? = nil) {
    self.backendId = backendId
    self.username = username
    self.conversation = conversation
  }
}


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
  var localId: UUID = UUID()
  var backendId: UUID
  var username: String
  var conversation: ConversationModel?
  var profileImage: URL?
  
  init(backendId: UUID,
       username: String,
       profileImage: URL?,
       conversation: ConversationModel? = nil) {
    self.backendId = backendId
    self.username = username
    self.profileImage = profileImage
    self.conversation = conversation
  }
}

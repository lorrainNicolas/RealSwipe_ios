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
    @Attribute(.unique) var id: UUID
    var text: String
    var sentAt: Date
    var isCurrentUser: Bool
    var conversation: ConversationModel?

    init(id: UUID,
         text: String,
         sentAt: Date,
         isCurrentUser: Bool,
         conversation: ConversationModel? = nil) {
        self.id = id
        self.text = text
        self.sentAt = sentAt
        self.isCurrentUser = isCurrentUser
        self.conversation = conversation
    }
}

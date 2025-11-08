//
//  UserModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 08/11/2025.
//

import SwiftData
import Foundation

@Model
class UserModel{
    @Attribute(.unique) var id: UUID
    var username: String
    var conversations: [Conversation] = []

    init(id: UUID,
         username: String) {
        self.id = id
        self.username = username
    }
}


@Model
class Conversation {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var participants: User
    var messages: [Message] = []

    init(id: UUID,
         createdAt: Date,
         participants: User) {
        self.id = id
        self.createdAt = createdAt
        self.participants = participants
    }
}

@Model
class Message {
    @Attribute(.unique) var id: UUID
    var text: String
    var sentAt: Date
    var sender: User?
    var conversation: Conversation?

    init(id: UUID, text: String, sentAt: Date = Date(), isRead: Bool = false, sender: User? = nil, conversation: Conversation? = nil) {
        self.id = id
        self.text = text
        self.sentAt = sentAt
        self.isRead = isRead
        self.sender = sender
        self.conversation = conversation
    }
}

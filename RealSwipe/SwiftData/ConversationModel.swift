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
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var participant: UserModel
  
    @Relationship(deleteRule: .cascade)
    var messages: [MessageModel] = []

    init(id: UUID,
         createdAt: Date,
         participant: UserModel) {
        self.id = id
        self.createdAt = createdAt
        self.participant = participant
    }
}

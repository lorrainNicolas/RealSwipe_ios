//
//  LocalIdentifiableModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 28/11/2025.
//

import Foundation

protocol LocalIdentifiableModel {
    var localId: UUID { get }
}

extension UserModel: LocalIdentifiableModel {}
extension ConversationModel: LocalIdentifiableModel {}
extension MessageModel: LocalIdentifiableModel {}

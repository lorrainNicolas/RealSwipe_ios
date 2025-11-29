//
//  ConversationDataBaseInput.swift
//  RealSwipe
//
//  Created by Utilisateur on 27/11/2025.
//

import Foundation

struct ConversationDataBaseInput {
  let id: UUID
  let seq: Int
  let profile: ProfileDataBaseInput
}

struct ProfileDataBaseInput {
  let userBackendId: UUID
  let profileImageUrl: URL?
  let firstName: String
}

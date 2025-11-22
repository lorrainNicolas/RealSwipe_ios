//
//  Input.swift
//  RealSwipe
//
//  Created by Utilisateur on 21/11/2025.
//

import Foundation

struct MessageDataBaseInput {
  let backendId: UUID
  let text: String
  let sentAt: Date
  let isCurrentUser: Bool
  let seq: Int64
}

//
//  DeleteConversationTask.swift
//  RealSwipe
//
//  Created by Utilisateur on 28/11/2025.
//

import Foundation

struct DeleteConversationTask: SyncMessageServiceProviderTask {
  
  let conversationBackendId: UUID
  let chatDataBase: ChatDataBase = .shared
  
  var key: SyncMessageServiceTaskKey { .deleteConversationTask(conversationBackendId: conversationBackendId) }
  
  func perform() async throws {
    try Task.checkCancellation()
    
    if let conversationDTO = try await chatDataBase.deleteConversation(conversationBackendId: conversationBackendId) {
      try Task.checkCancellation()
      NotificationCenter.default.post(name: .syncMessageDidDeleteConversation, object: conversationDTO)
    }
  }
}

//
//  SyncMessageServiceProviderTask.swift
//  RealSwipe
//
//  Created by Utilisateur on 28/11/2025.
//

import Foundation

protocol SyncMessageServiceProviderTask {
  var key: SyncMessageServiceTaskKey { get }
  associatedtype Value: Sendable
  func perform() async throws -> Value
}

enum SyncMessageServiceTaskKey: Hashable, Sendable {
  case syncAllConversationsTask
  case fetchAllNotSyncConversationsTask
  case syncConversationTask(conversationBackendId: UUID)
  case deleteConversationTask(conversationBackendId: UUID)
  case addMessageInDatabaseTask(messageBackendId: UUID)
}


//
//  FetchAllNotSyncConversationsTask.swift
//  RealSwipe
//
//  Created by Utilisateur on 28/11/2025.
//

import Foundation

struct FetchAllNotSyncConversationsTask: SyncMessageServiceProviderTask {
  
  let chatDataBase: ChatDataBase = .shared
  var key: SyncMessageServiceTaskKey { .fetchAllNotSyncConversationsTask }
  
  func perform() async throws -> [UUID] {
    try Task.checkCancellation()
    let backendId = try await chatDataBase.fetchAllNotSyncConversations().map(\.backendId)
    try Task.checkCancellation()
    return backendId
  }
}

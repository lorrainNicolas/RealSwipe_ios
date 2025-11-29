//
//  AddMessageInDatabaseTask.swift
//  RealSwipe
//
//  Created by Utilisateur on 28/11/2025.
//

import Foundation

struct AddMessageInDatabaseTask: SyncMessageServiceProviderTask {
  
  let messageResponse: MessageResponse
  let userId: UUID
  let chatDataBase: ChatDataBase = .shared
  
  var key: SyncMessageServiceTaskKey { .addMessageInDatabaseTask(messageBackendId: messageResponse.id) }
  
  func perform() async throws {
    try Task.checkCancellation()
    let messageDTO = try await chatDataBase.insertMessageIfNotExist(conversationBackendId: messageResponse.conversationId,
                                                                    message: .init(backendId: messageResponse.id,
                                                                                   text: messageResponse.message,
                                                                                   sentAt: messageResponse.sentAt,
                                                                                   isCurrentUser: userId == messageResponse.senderId,
                                                                                   seq: messageResponse.seq))
    try Task.checkCancellation()
    NotificationCenter.default.post(name: .syncMessageDidReceiveMessage, object: messageDTO)
  }
}

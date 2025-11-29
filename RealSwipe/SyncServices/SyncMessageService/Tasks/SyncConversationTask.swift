//
//  SyncConversationTask.swift
//  RealSwipe
//
//  Created by Utilisateur on 28/11/2025.
//

import Foundation

struct SyncConversationTask: SyncMessageServiceProviderTask {
  
  struct UserSession {
    let userId: UUID
    let token: String
  }
  
  let conversationBackendId: UUID
  let userSession: UserSession
  let chatDataBase: ChatDataBase = .shared
  let api: APIClient = APIClient()
  
  var key: SyncMessageServiceTaskKey { .syncConversationTask(conversationBackendId: conversationBackendId) }
  
  func perform() async throws {
    try Task.checkCancellation()
    
    let getMessageByConversationEndpointData = try await api.sendRequest(to: GetMessageByConversationEndpoint(conversation: conversationBackendId,
                                                                                                              token: userSession.token))
    try Task.checkCancellation()
    let messages = getMessageByConversationEndpointData.messages.map {
      MessageDataBaseInput(backendId: $0.id,
                           text: $0.message,
                           sentAt: $0.sentAt,
                           isCurrentUser: userSession.userId == $0.senderId,
                           seq: $0.seq)
    }
    
    let conversationDTO = try await chatDataBase.syncMessages(conversationBackendId: conversationBackendId, messages: messages)
    try Task.checkCancellation()
    NotificationCenter.default.post(name: .syncMessageDidSyncConversation, object: conversationDTO)
  }
}

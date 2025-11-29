//
//  SyncAllConversationsTask.swift
//  RealSwipe
//
//  Created by Utilisateur on 28/11/2025.
//

import Foundation

struct SyncAllConversationsTask: SyncMessageServiceProviderTask {
  
  let token: String
  
  let chatDataBase: ChatDataBase = .shared
  let api: APIClient = APIClient()
  
  var key: SyncMessageServiceTaskKey { .syncAllConversationsTask }
  
  func perform() async throws {
    try Task.checkCancellation()
    
    let conversations = try await api.sendRequest(to: GetConversationEndpoint(token: token))
    
    try Task.checkCancellation()
    
    let conversationDataBaseInput = conversations.map {
      return ConversationDataBaseInput(id: $0.id,
                                       seq: $0.seq,
                                       profile: ProfileDataBaseInput.init(userBackendId: $0.profile.id,
                                                                          profileImageUrl: $0.profile.profileImageUrl,
                                                                          firstName: $0.profile.firstName))
    }
    
    await chatDataBase.syncConversations(conversations: conversationDataBaseInput)
    
    try Task.checkCancellation()
    NotificationCenter.default.post(name: .syncMessageDidSyncAllConversations, object: nil)
  }
}


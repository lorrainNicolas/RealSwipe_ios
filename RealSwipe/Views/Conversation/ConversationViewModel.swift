//
//  ConversationViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation

@MainActor
final class ConversationViewModel: ObservableObject {
  
  class ViewModel: ObservableObject, Identifiable {
    let id: UUID
    let name: String
    
    init(id: UUID, name: String) {
      self.id = id
      self.name = name
    }
  }
 
  @Published var conversations = [ViewModel]()
  private let userSession: UserSession
  private let api: APIClient
  private let syncMessageService: SyncMessageService
  private let chatDataBase: ChatDataBase
  
  init(userSession: UserSession,
       api: APIClient,
       syncMessageService: SyncMessageService = .shared,
       chatDataBase: ChatDataBase = .shared) {
    self.userSession = userSession
    self.api = api
    self.chatDataBase = chatDataBase
    self.syncMessageService = syncMessageService
    
    Task {
      for await notification in NotificationCenter.default.publisher(for: .syncMessageServiceDidUpdate)
        .buffer(size: .max, prefetch: .byRequest, whenFull: .dropOldest) // ici on va refresg a chaque event
        .values {
        do {
          print("toto refreash")
          try await refreash()
        }
      }
    }
    
    Task {
      try await refreash()
    }
   
  }
  
  func refreshable() async {
    await syncMessageService.syncConversation()
  }
  
}

private extension ConversationViewModel {
  func refreash() async throws {
    print( try await chatDataBase.fetchAllConversations().count)
    conversations = try await chatDataBase.fetchAllConversations().map({
      .init(id: $0.id, name: $0.participant.username)
    })
  }
}

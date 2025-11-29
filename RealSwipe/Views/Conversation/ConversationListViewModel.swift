//
//  ConversationListViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation
import Combine

@MainActor
final class ConversationListViewModel: ObservableObject {
  
  @Published var conversations = [ConversationViewModel]()
  private let userSession: UserSession
  private let api: APIClient
  private let syncMessageService: SyncMessageService
  private let chatDataBase: ChatDataBase
  
  private var bag: Set<AnyCancellable> = []
  private var refreshTask: Task<Void, any Error>?
  
  init(userSession: UserSession,
       api: APIClient,
       syncMessageService: SyncMessageService = .shared,
       chatDataBase: ChatDataBase = .shared) {
    self.userSession = userSession
    self.api = api
    self.chatDataBase = chatDataBase
    self.syncMessageService = syncMessageService
    
    refreash()
    
    NotificationCenter.default
      .publisher(for: .syncMessageDidSyncAllConversations)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.refreash()
      }
      .store(in: &bag)
    
    NotificationCenter.default
      .publisher(for: .syncMessageDidDeleteConversation)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.refreash()
      }
      .store(in: &bag)
  }
  
  func refreshable() async {
    await syncMessageService.syncConversations()
  }
}

private extension ConversationListViewModel {
  func refreash() {
    refreshTask?.cancel()
    refreshTask = Task {[weak self] in
      guard let conversations = try await self?.chatDataBase.fetchAllConversations().map({
        ConversationViewModel(conversationLocalId: $0.localId,
                              profileImageUrl: $0.participant.profileImageUrl,
                              name: $0.participant.username)
      }), !Task.isCancelled else { return }
      self?.conversations = conversations
    }
  }
}

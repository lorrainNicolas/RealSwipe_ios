//
//  ConversationViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation
import Combine

@MainActor
final class ConversationViewModel: ObservableObject {
  
  class ViewModel: ObservableObject, Identifiable {
    let id: UUID
    let conversationBackendId: UUID
    let name: String
    
    init(id: UUID, conversationBackendId: UUID,  name: String) {
      self.id = id
      self.conversationBackendId = conversationBackendId
      self.name = name
    }
  }
  
  @Published var conversations = [ViewModel]()
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
      .publisher(for: .syncMessageServiceDidUpdate)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in  self?.refreash() }
      .store(in: &bag)
  }
  
  func refreshable() async {
    await syncMessageService.syncConversation()
  }
}

private extension ConversationViewModel {
  func refreash() {
    refreshTask?.cancel()
    refreshTask = Task {[weak self] in
      guard let conversations = try await self?.chatDataBase.fetchAllConversations().map({
        ViewModel(id: $0.id,conversationBackendId: $0.backendId, name: $0.participant.username)
      }), !Task.isCancelled else { return }
      self?.conversations = conversations
    }
  }
}

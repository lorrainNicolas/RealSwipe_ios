//
//  ChatViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import Foundation
import ExyteChat
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
  
  struct InputData {
    let convesationId: UUID
    let user: String
  }
  
  @Published var messages: [Message] = []
  var chatTitle: String { inputData.user }
  
  private var bag = Set<AnyCancellable>()
  private var refreshTask: Task<Void, any Error>?

  let apiClient: APIClientProtocol
  let userSession: UserSession
  let chatDataBase: ChatDataBase
  let inputData: InputData

  init(apiClient: APIClientProtocol = APIClient(),
       userSession: UserSession,
       chatDataBase: ChatDataBase = .shared,
       inputData: InputData) {
    self.apiClient = apiClient
    self.inputData = inputData
    self.userSession = userSession
    self.chatDataBase = chatDataBase
    
    NotificationCenter.default
      .publisher(for: .syncMessageServiceDidUpdate)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.refresh()
      }.store(in: &bag)
    
    NotificationCenter.default
      .publisher(for: .didReceiveMessage)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] value in
        
        guard let message = value.object as? MessageResponse else { return }
        self?.messages.append(Message(id: "\(message.id)",
                                      user: .init(id: "", name: "", avatarURL: nil, isCurrentUser: false),
                                      status: .error(.init(text: "ded", medias: [], giphyMedia: nil, recording: nil, replyMessage: nil, createdAt: Date())),
                                      text: message.message))
      }.store(in: &bag)

    refresh()
  }
  
  func send(draft: DraftMessage) {
    let convesationId = inputData.convesationId
    let token = userSession.token
    Task {[weak self, apiClient, chatDataBase] in
      do {
        guard let conversationId = try await chatDataBase.fetchConversation(id: convesationId) else { return }
        let message = try await apiClient.sendRequest(to: PostSendMessageEndpoint(data: .init(message: draft.text),
                                                                                  conversationId: conversationId.backendId,
                                                                                  token: token))
        self?.messages.append(Message(id: "\(message.id)",
                                      user: .init(id: "", name: "", avatarURL: nil, isCurrentUser: true),
                                      status: .read,
                                      text: draft.text))
        
      } catch { }
    }
  }
}

private extension ChatViewModel {
  
  func refresh() {
    let conversationId = inputData.convesationId
    refreshTask?.cancel()
    refreshTask = Task {[weak self] in
      
      guard let messages = try await self?.chatDataBase.fetchAllMessages(in: conversationId).map ({
        Message(id: "\($0.id)",
                user: .init(id: "", name: "", avatarURL: nil, isCurrentUser: $0.isCurrentUser),
                text: $0.text)
      }), !Task.isCancelled else { return }
      self?.messages = messages
    }
  }
}

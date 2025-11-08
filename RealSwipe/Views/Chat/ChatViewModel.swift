//
//  ChatViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import Foundation
import ExyteChat
import Combine

struct WebSocketMessageData: Codable {
    let message: String
    let conversationId: UUID
    let userId: UUID
}

@MainActor
final class ChatViewModel: ObservableObject {

  @Published var messages: [Message] = []
  @Published var chatTitle: String = ""
  
  private var bag = Set<AnyCancellable>()

  let conversation: UUID
  let apiClient: APIClientProtocol
  let userSession: UserSession
  
  init(apiClient: APIClientProtocol = APIClient(),
       userSession: UserSession,
       conversation: UUID) {
    self.apiClient = apiClient
    self.conversation = conversation
    self.userSession = userSession
    
    SyncMessageService.shared.didReceivedMessage.sink {
      self.messages.append(Message(id: UUID().uuidString,
                                   user: .init(id: "", name: "", avatarURL: nil, isCurrentUser: false),
                                   text: $0.message))
    }.store(in: &bag)

  }
  
  func send(draft: DraftMessage) {
    Task {
      self.messages.append(Message(id: UUID().uuidString,
                                   user: .init(id: "", name: "", avatarURL: nil, isCurrentUser: true),
                                   text: draft.text))
      
      try await apiClient.sendRequest(to: PostSendMessageEndpoint(data: .init(message: draft.text),
                                                                  conversation: conversation,
                                                                  token: userSession.token))
      
    }
  }
}

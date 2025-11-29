//
//  ChatViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import UIKit
import ExyteChat
import Combine
import ImageCaching

@MainActor
final class ChatViewModel: ObservableObject {
  
  struct InputData {
    let conversationLocalId: UUID
    let user: String
  }
  
  @Published var messages: [Message] = []
  var chatTitle: String { inputData.user }
  @Published var profileImage: UIImage?
  private var bag = Set<AnyCancellable>()
  private var refreshTask: Task<Void, any Error>?
  private var name: String?
  let apiClient: APIClientProtocol
  let userSession: UserSession
  let chatDataBase: ChatDataBase
  let inputData: InputData
  let syncMessageService: SyncMessageService
  let imageLoader: ImageLoaderProtocol
  
  init(apiClient: APIClientProtocol = APIClient(),
       userSession: UserSession,
       syncMessageService: SyncMessageService = .shared,
       chatDataBase: ChatDataBase = .shared,
       imageLoader: ImageLoaderProtocol = ImageLoader.shared,
       inputData: InputData) {
    self.apiClient = apiClient
    self.inputData = inputData
    self.userSession = userSession
    self.syncMessageService = syncMessageService
    self.chatDataBase = chatDataBase
    self.imageLoader = imageLoader
    
    NotificationCenter.default
      .publisher(for: .syncMessageDidSyncConversation)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] value in
        guard let object = value.object as? ConversationDTO,
              object.localId ==  self?.inputData.conversationLocalId else { return }
        self?.refresh()
      }.store(in: &bag)
    
    NotificationCenter.default
      .publisher(for: .syncMessageDidReceiveMessage)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] value in
        
        guard let message = value.object as? MessageDTO,
        message.conversationModel.localId == self?.inputData.conversationLocalId else { return }
        let name = message.isCurrentUser ? nil : self?.name
        print(" toto \(self?.name)")
        self?.messages.append(Message(id: "\(message.localId)",
                                      user: .init(id: "", name: name ?? "", avatarURL: nil, isCurrentUser: message.isCurrentUser),
                                      status: .error(.init(text: "ded", medias: [], giphyMedia: nil, recording: nil, replyMessage: nil, createdAt: Date())),
                                      text: message.text))
      }.store(in: &bag)

    loadData()
    refresh()
    
  }
   
  func loadData() {
    let conversationLocalId = inputData.conversationLocalId
    Task {[weak self, imageLoader, chatDataBase] in
      do {
        guard let conversation = try await chatDataBase.fetchConversation(conversationLocalId: conversationLocalId) else { return }
        self?.name = conversation.participant.username
        if let profileImageUrl = conversation.participant.profileImageUrl {
          self?.profileImage = try await imageLoader.load(from: profileImageUrl)
        }
      } catch {}

    }
  }
  
  func send(draft: DraftMessage) {
    let conversationLocalId = inputData.conversationLocalId
    let token = userSession.token
    Task {[weak self, apiClient, chatDataBase] in
      do {
        guard let conversation = try await chatDataBase.fetchConversation(conversationLocalId: conversationLocalId) else { return }
        let message = try await apiClient.sendRequest(to: PostSendMessageEndpoint(data: .init(message: draft.text),
                                                                                  conversationId: conversation.backendId,
                                                                                  token: token))
        self?.messages.append(Message(id: "\(message.id)",
                                      user: .init(id: "", name: "", avatarURL: nil, isCurrentUser: true),
                                      status: .read,
                                      text: draft.text))
        
      } catch { }
    }
  }
  
  func delete() {
    let conversationLocalId = inputData.conversationLocalId
    Task { [chatDataBase, syncMessageService] in
      do {
        guard let conversation = try await chatDataBase.fetchConversation(conversationLocalId: conversationLocalId) else {
          return
        }
        
        try await syncMessageService.deleteConversation(conversationBackendId: conversation.backendId)
      } catch {
        print("errror \(error)")
      }
    }
  }
}

private extension ChatViewModel {
  
  func refresh() {
    let conversationLocalId = inputData.conversationLocalId
    refreshTask?.cancel()
    refreshTask = Task {[weak self] in
      
      guard let messages = try await self?.chatDataBase.fetchAllMessages(conversationLocalId: conversationLocalId).map ({
        let name = $0.isCurrentUser ? nil : self?.name
        
       return Message(id: "\($0.localId)",
                user: .init(id: "", name: name ?? "", avatarURL: nil, isCurrentUser: $0.isCurrentUser),
                text: $0.text)
      }), !Task.isCancelled else { return }
      self?.messages = messages
    }
  }
}

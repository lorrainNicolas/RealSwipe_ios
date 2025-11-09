//
//  SyncMessageService.swift
//  RealSwipe
//
//  Created by Utilisateur on 07/11/2025.
//

 import Combine
import Foundation


extension Notification.Name {
  static let syncMessageServiceDidUpdate = Notification.Name("SyncMessageService_didUpdate")
}

@MainActor
final class SyncMessageService: Sendable {
  enum NotificationState {
    case didSyncConversation
  }
  
  private let webSocketService: WebSocketService
  private let authentificationSession: AuthentificationService
  private let api: APIClient
  private let chatDataBase: ChatDataBase
  
  let didReceivedMessage: PassthroughSubject<WebSocketMessageData, Never> = .init()
  
  static let shared = SyncMessageService()
  
  init(webSocketService: WebSocketService = .init(),
       api: APIClient = .init(),
       chatDataBase: ChatDataBase = .shared,
       authentificationSession: AuthentificationService = .shared) {
    self.webSocketService = webSocketService
    self.authentificationSession = authentificationSession
    self.api = api
    self.chatDataBase = chatDataBase
    
    Task {
      for await message in webSocketService.stream {
        switch message {
        case.didReceive(let message):
          guard let data = message.data(using: .utf8) else { return }
          do {
            didReceivedMessage.send(try await decode(data: data))
          } catch {
            print("Erreur de décodage: \(error)")
          }
          
        default: break
        }
      }
    }
  }
  
  private var syncTask: Task<(), any Error>?
  
  static func launch() {
    Task {
      for try await userSessionData in shared
        .authentificationSession
        .userSessionDataPublisher
        .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
        .values {
          if userSessionData.didlaunched == false {
            try await shared.chatDataBase.clean()
          }
        
          if let token = userSessionData.usesrSession?.token {
            try await shared.syncConversation(token: token)
            shared.webSocketService.launch(token: token)
          } else {
            shared.webSocketService.stop()
          }
      }
    }
  }
  
  @concurrent func decode(data: Data) async throws -> WebSocketMessageData {
    return try JSONDecoder().decode(WebSocketMessageData.self, from: data)
  }
  
  func syncConversation() async {
    guard let token = authentificationSession.userSession?.token else { return }
    do {
      try await syncConversation(token: token)
    } catch {}
  }
}

private extension SyncMessageService {
  func syncConversation(token: String) async throws {
    if let syncTask {
     try await syncTask.value
    } else {
     let task = Task {
        defer { syncTask = nil }
        do {
          let conversations = try await api.sendRequest(to: GetConversationEndpoint(token: token))
          guard authentificationSession.userSession?.token == token else { return }
          
          for conversation in conversations {
            do {
              if try await chatDataBase.userDidExist(id: conversation.profile.id) {
                try await chatDataBase.updateUser(id: conversation.profile.id,
                                                  username: conversation.profile.firstName)
              } else {
                try await chatDataBase.insertUser(id: conversation.profile.id,
                                                  username: conversation.profile.firstName)
              }
              
              if try await chatDataBase.conversationDidExist(id: conversation.id) == false {
                try await chatDataBase.insertConversation(id: conversation.id,
                                                          createdAt: Date(), // FIXE me
                                                          userId: conversation.profile.id)
              }
            } catch {
              
            }
          }
        }
       
       NotificationCenter.default.post(name: .syncMessageServiceDidUpdate, object: NotificationState.didSyncConversation)
      }
      syncTask = task
      try await task.value
    }
  }
}


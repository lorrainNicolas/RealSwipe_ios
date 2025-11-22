//
//  SyncMessageService.swift
//  RealSwipe
//
//  Created by Utilisateur on 07/11/2025.
//

import Foundation
import UIKit


extension Notification.Name {
  static let syncMessageServiceDidUpdate = Notification.Name("SyncMessageService_didUpdate")
  static let didReceiveMessage = Notification.Name("SyncMessageService_didReceiveMessage")
}

actor SyncMessageService: Sendable {
  
  enum TaskKey: Hashable {
    case syncAllConversations
    case syncConversation(conversationId: UUID)
  }
  
  private var pendingTasks: [TaskKey: Task<Void, Never>] = [:]
  
  struct UserSession {
    let userId: UUID
    let token: String
  }
  
  enum NotificationState {
    case didSyncConversation
  }
  
  private var webSocketService: WebSocketService?
  private let api: APIClient
  private let chatDataBase: ChatDataBase
  private var userSession: UserSession?
  private var isCleaningData: Bool = false
  private var webSocketTask: Task<Void, Never>?
  
  static let shared = SyncMessageService()
  
  init(api: APIClient = .init(),
       chatDataBase: ChatDataBase = .shared) {
    
    self.api = api
    self.chatDataBase = chatDataBase
    
  }
  
  static func launch() {
    _ = shared
  }
  
  func updateUserSession(_ userSession: UserSession?, hasToBeenClean: Bool) async {
    self.userSession = userSession
    self.pendingTasks.values.forEach { $0.cancel() }
    self.pendingTasks = [:]
    
    webSocketTask?.cancel()
    webSocketService = nil
    
    if hasToBeenClean == true {
      try? await chatDataBase.clean()
    }
    
    if let userSession = userSession {
      
      webSocketTask = Task {
        do {
          try Task.checkCancellation()
          let webSocketService = WebSocketService(token: userSession.token)
          self.webSocketService = webSocketService
          await webSocketService.launch()
          try Task.checkCancellation()
          for await message in webSocketService.stream {
            switch message {
            case.didReceive(let messageResponse):
              NotificationCenter.default.post(name: .didReceiveMessage, object: messageResponse)
            case .didConnected:
              async let _ = syncConversation()
            }
          }
        } catch {}
      }
    }
  }
  
  func syncConversation() async {
    guard let userSession else { return }
    await syncAllConversations(userSession: userSession)
  }
}

private extension SyncMessageService {
  
  func syncAllConversations(userSession: UserSession) async {
    
    let key = TaskKey.syncAllConversations
    
    if let task = pendingTasks[key] {
      await task.value
    } else {
      let task = Task {
        
        defer {
          pendingTasks.removeValue(forKey: key)
        }
        
        do {
          let conversations = try await api.sendRequest(to: GetConversationEndpoint(token: userSession.token))
          try Task.checkCancellation()
          
          for conversation in conversations {
            
            do {
              
              try await chatDataBase.upsertUser(backendId: conversation.profile.id, username: conversation.profile.firstName)
              try Task.checkCancellation()
              try await chatDataBase.upsertConversation(backendId: conversation.id,
                                                        createdAt: Date(), // FIXE me
                                                        userBackendId: conversation.profile.id,
                                                        referenceSeq: conversation.seq)
            } catch {
              
            }
          }
          try Task.checkCancellation()
          let allNotSyncConversations = try await chatDataBase.fetchAllNotSyncConversations()
          
          for conversation in allNotSyncConversations {
            async let _ = syncConversation(conversationId: conversation.id, userSession: userSession)
          }
          NotificationCenter.default.post(name: .syncMessageServiceDidUpdate, object: NotificationState.didSyncConversation)
        } catch {}
      }
      pendingTasks[key] = task
      await task.value
    }
  }
  
  func syncConversation(conversationId: UUID, userSession: UserSession) async {
    let key = TaskKey.syncConversation(conversationId: conversationId)
    
    if let task = pendingTasks[key] {
      await task.value
    } else {
      let task = Task {
        defer {
          pendingTasks.removeValue(forKey: key)
        }
        
        do {
          guard let conversation = try await chatDataBase.fetchConversation(id: conversationId) else { return }
          let getMessageByConversationEndpointData = try await api.sendRequest(to: GetMessageByConversationEndpoint(conversation: conversation.backendId,
                                                                                                                    token: userSession.token))
          try Task.checkCancellation()
          let messages = getMessageByConversationEndpointData.messages.map {
            MessageDataBaseInput(backendId: $0.id,
                                 text: $0.message,
                                 sentAt: Date(), // FIX ME
                                 isCurrentUser: userSession.userId == $0.senderId,
                                 seq: $0.seq)
          }
       
          try await chatDataBase.insertMessages(in: conversation.id, messages: messages)
        } catch {
          
        }
      }
      pendingTasks[key] = task
      await task.value
    }
  }
}

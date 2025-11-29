//
//  SyncMessageService.swift
//  RealSwipe
//
//  Created by Utilisateur on 07/11/2025.
//

import Foundation
import UIKit


extension Notification.Name {
  static let syncMessageDidSyncAllConversations = Notification.Name("SyncMessageService_didSyncConversations")
  static let syncMessageDidSyncConversation = Notification.Name("SyncMessageService_didSyncConversations")
  static let syncMessageDidReceiveMessage = Notification.Name("SyncMessageService_didReceiveMessage")
  static let syncMessageDidDeleteConversation = Notification.Name("SyncMessageService_didDeleteConversation")
}

actor SyncMessageService: Sendable {
  
  struct UserSession {
    let userId: UUID
    let token: String
  }
  
  private var pendingTasks: [SyncMessageServiceTaskKey: Task<Void, Never>] = [:]
  
  private var webSocketService: WebSocketService?
  private let api: APIClient
  private var userSession: UserSession?
  private var webSocketTask: Task<Void, Never>?
  
  static let shared = SyncMessageService()
  
  init(api: APIClient = .init()) {
    self.api = api
  }
  
  static func launch() {
    _ = shared
  }
  
  func stop() {
    self.pendingTasks.values.forEach { $0.cancel() }
    self.pendingTasks = [:]
    webSocketTask?.cancel()
    webSocketService = nil
  }
  
  func updateUserSession(_ userSession: UserSession?) {
    self.userSession = userSession

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
              lauchAddMessageInDatabaseTask(messageResponse: messageResponse, userSession: userSession)
            case .didConnected:
              launchSyncAllConversationsTask(userSession: userSession)
            case .didDeleteConversation(let conversationBackendId):
              launchDeleteConversationTask(conversationBackendId: conversationBackendId)
            case .didCreateConversation:
              launchSyncAllConversationsTask(userSession: userSession)
            }
          }
        } catch {}
      }
    }
  }
  
  func syncConversations() async {
    guard let userSession else { return }
    await launchSyncAllConversationsTask(userSession: userSession).value
  }
  
  func deleteConversation(conversationBackendId: UUID) async throws {
    guard let userSession else { return }
    let _ = try await api.sendRequest(to: DeletetConversationEndpoint(conversation: conversationBackendId,
                                                                      token: userSession.token))
    launchDeleteConversationTask(conversationBackendId: conversationBackendId)
  }
}

private extension SyncMessageService {
  
  @discardableResult
  func launchSyncAllConversationsTask(userSession: UserSession) -> Task<Void, Never> {
    return addTask(provider: SyncAllConversationsTask(token: userSession.token)) { _ in
      launchFetchAllNotSyncConversationsTask()
    }
  }
  
  @discardableResult
  func launchFetchAllNotSyncConversationsTask() -> Task<Void, Never>? {
    return addTask(provider: FetchAllNotSyncConversationsTask()) {
      guard case .success(let conversationBackendIds) = $0 else { return }
      for id in conversationBackendIds {
        launchSyncConversationTask(conversationBackendId: id)
      }
    }
  }
  
  @discardableResult
  func launchSyncConversationTask(conversationBackendId: UUID) -> Task<Void, Never>? {
    if pendingTasks.contains(where: { (key, value) in
      guard case .deleteConversationTask(conversationBackendId: let conversationBackendId) = key,
              conversationBackendId == conversationBackendId else { return false }
      return true
    }) { return nil }
    guard let userSession else { return nil }
    return addTask(provider: SyncConversationTask(conversationBackendId: conversationBackendId,
                                                  userSession: .init(userId: userSession.userId, token: userSession.token)))
  }
  
  @discardableResult
  func launchDeleteConversationTask(conversationBackendId: UUID) -> Task<Void, Never>? {
    
    for (key, value) in pendingTasks {
      if case .syncConversationTask(conversationBackendId: let conversationBackendId) = key, conversationBackendId == conversationBackendId {
        value.cancel()
      }
    }
    
    return addTask(provider: DeleteConversationTask(conversationBackendId: conversationBackendId))
  }
  
  @discardableResult
  func lauchAddMessageInDatabaseTask(messageResponse: MessageResponse, userSession: UserSession) -> Task<Void, Never>? {
    return addTask(provider: AddMessageInDatabaseTask(messageResponse: messageResponse, userId: userSession.userId)) {
      guard case .failure(let error as ChatDataBase.Failure) = $0,
              error == ChatDataBase.Failure.conversationNotFound else { return }
      
      launchSyncAllConversationsTask(userSession: userSession)
    }
  }
  
  func addTask<T: SyncMessageServiceProviderTask>(provider: T,
                                                  @_implicitSelfCapture onFinished: ((Result<T.Value, Error>) -> ())? = nil ) -> Task<Void, Never> {
    
    if let task = pendingTasks[provider.key] {
      return task
    } else {
      let task = Task {
        defer { pendingTasks.removeValue(forKey: provider.key) }
        do {
          let value = try await provider.perform()
          onFinished?(.success(value))
        } catch {
          onFinished?(.failure(error))
        }
      }
      
      pendingTasks[provider.key] = task
      return task
    }
  }
}

//
//  ChatDataBase.swift
//  RealSwipe
//
//  Created by Utilisateur on 08/11/2025.
//

import SwiftData
import Foundation

extension Notification.Name {
  static let chatDataBaseDidUpdate = Notification.Name("ChatDataBase_didUpdate")
}

@ModelActor
actor ChatDataBase: Sendable {
  
  enum NotificationState {
    case didInsertConversation(UUID)
    case didRemoveConversation(UUID)
    
    case didInsertUser(UUID)
    case didUpdateUser(UUID)
    case didRemoveUser(UUID)
  }
  
  enum ChatDataBaseError: Error {
    case invalidUserId
  }
  
  static let shared = ChatDataBase()
  
  private init() {
    let modelContainer = try! ModelContainer(for: MessageModel.self, ConversationModel.self, UserModel.self)
    self.init(modelContainer: modelContainer)
  }
  
  private var context: ModelContext { modelExecutor.modelContext }
 
  // MARK: - USER
  func userDidExist(id: UUID) throws -> Bool {
    return try _fetchUser(id: id) != nil
  }
  
  func fetchUser(id: UUID) throws -> UserDTO? {
    try _fetchUser(id: id).map(UserDTO.map)
  }
  
  func insertUser(id: UUID, username: String) throws {
    let newUser = UserModel(id: id, username: username)
    context.insert(newUser)
    try save(notificationState: .didInsertUser(id))
  }
  
  func updateUser(id: UUID, username: String) throws {
    guard let user = try _fetchUser(id: id) else { return }
    user.username = username
    try save(notificationState: .didUpdateUser(id))
  }
  
  func removeUser(id: UUID, context: ModelContext) throws {
    guard let user = try _fetchUser(id: id) else { return }
    context.delete(user)
    try save(notificationState: .didRemoveUser(id))
  }
  
  // MARK: - Conversation
  func conversationDidExist(id: UUID) throws -> Bool {
   return try _fetchConversation(id: id) != nil
  }
  
  func fetchonversation(id: UUID) throws -> ConversationDTO? {
    try _fetchConversation(id: id).map(ConversationDTO.map)
  }
  
  func fetchAllConversations() async throws -> [ConversationDTO] {
    
      let descriptor = FetchDescriptor<ConversationModel>(
          sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
      )

      let conversations = try context.fetch(descriptor)
      return conversations.map(ConversationDTO.map)
  }
  
  func insertConversation(id: UUID, createdAt: Date, userId: UUID) throws {
    guard let participant = try _fetchUser(id: userId) else {
      throw ChatDataBaseError.invalidUserId
    }
    
    let newConversation = ConversationModel.init(id: id,
                                                 createdAt: createdAt,
                                                 participant: participant)
    context.insert(newConversation)
    try save(notificationState: .didInsertConversation(id))
  }
  
  func removeConversation(id: UUID) throws {
    guard let conversation = try _fetchConversation(id: id) else { return }
    context.delete(conversation)
    try save(notificationState: .didRemoveConversation(id))
  }
  
  // MARK: - other
  
  func clean() throws {
    try context.delete(model: MessageModel.self)
    try context.delete(model: ConversationModel.self)
    try context.delete(model: UserModel.self)
  }
}

private extension ChatDataBase {
  func _fetchUser(id: UUID) throws -> UserModel? {
    let descriptor = FetchDescriptor<UserModel>(
      predicate: #Predicate { $0.id == id }
    )
    
    return try context.fetch(descriptor).first
  }
  
  func _fetchConversation(id: UUID) throws -> ConversationModel? {
    let descriptor = FetchDescriptor<ConversationModel>(
      predicate: #Predicate { $0.id == id }
    )
    
    return try context.fetch(descriptor).first
  }
  
  private func save(notificationState: NotificationState) throws {
    try context.save()
    NotificationCenter.default.post(name: .chatDataBaseDidUpdate, object: notificationState)
  }
}

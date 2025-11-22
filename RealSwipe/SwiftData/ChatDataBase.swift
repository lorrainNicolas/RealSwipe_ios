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
  enum ChatDataBaseError: Error {
    case invalidUserId
    case invalideConversationId
  }
  
  static let shared = ChatDataBase()
  
  private init() {
    let modelContainer = try! ModelContainer(for: MessageModel.self, ConversationModel.self, UserModel.self)
    self.init(modelContainer: modelContainer)
  }
  
  private var context: ModelContext { modelExecutor.modelContext }
  
  // MARK: - USER
  
  func upsertUser(backendId: UUID, username: String) throws {
    if let user = try _fetchUser(backendId: backendId) {
      try updateUser(userModel: user, username: username)
    } else {
      try insertUser(backendId: backendId, username: username)
      
    }
  }
  
  func insertUser(backendId: UUID, username: String) throws {
    let newUser = UserModel(backendId: backendId, username: username)
    context.insert(newUser)
    try context.save()
  }
  
  func updateUser(userModel: UserModel, username: String) throws {
    userModel.username = username
    try context.save()
  }
  
  func removeUser(id: UUID, context: ModelContext) throws {
    guard let user = try _fetchUser(id: id) else { return }
    context.delete(user)
    try context.save()
  }
  
  // MARK: - Conversation
  
  func upsertConversation(backendId: UUID, createdAt: Date, userBackendId: UUID, referenceSeq: Int64) throws {
    if let conversation = try _fetchConversation(backendId: backendId) {
      try updateConversation(conversationModel: conversation, referenceSeq: referenceSeq)
    } else {
      try insertConversation(backendId: backendId, createdAt: createdAt, userBackendId: userBackendId, referenceSeq: referenceSeq)
    }
  }
  
  func insertConversation(backendId: UUID, createdAt: Date, userBackendId: UUID, referenceSeq: Int64) throws {
    guard let participant = try _fetchUser(backendId: userBackendId) else {
      throw ChatDataBaseError.invalidUserId
    }
    
    let newConversation = ConversationModel(backendId: backendId,
                                            createdAt: createdAt,
                                            participant: participant,
                                            isSync: referenceSeq == 0)
    context.insert(newConversation)
    try context.save()
  }
  
  func updateConversation(conversationModel: ConversationModel, referenceSeq: Int64) throws {
    conversationModel.isSync = conversationModel.seq >= referenceSeq
    try context.save()
  }
  
  func removeConversation(id: UUID) throws {
    guard let conversation = try _fetchConversation(id: id) else { return }
    context.delete(conversation)
    try context.save()
  }
  
  func fetchConversation(id: UUID) throws -> ConversationDTO? {
    try _fetchConversation(id: id).map(ConversationDTO.map(from:))
  }
  
  func fetchAllConversations() async throws -> [ConversationDTO] {
    
    let descriptor = FetchDescriptor<ConversationModel>(
      sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
    )
    
    let conversations = try context.fetch(descriptor)
    return conversations.map(ConversationDTO.map)
  }
  
  func fetchAllNotSyncConversations() async throws -> [ConversationDTO] {
    
    let descriptor = FetchDescriptor<ConversationModel>(
      predicate: #Predicate { $0.isSync == false },
      sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
    )
    
    let conversations = try context.fetch(descriptor)
    return conversations.map(ConversationDTO.map)
  }
  
  // MARK: - Message
  
  func insertMessages(in conversationId: UUID, messages: [MessageDataBaseInput]) throws {
    guard let conversation = try _fetchConversation(id: conversationId) else {
      throw ChatDataBaseError.invalideConversationId
    }
    
    let allMessage = try _fetchAllMessages(in: conversationId)
    guard let minSeq = messages.map(\.seq).min() else { return }
    
    if conversation.seq > minSeq {
      for massage in allMessage where massage.seq < minSeq {
        context.delete(massage)
      }
    }
    
    for message in messages {
      
      if message.seq > conversation.seq {
        conversation.seq = message.seq
      }
      
      guard (try? _fetchMessage(backendId: message.backendId)) == nil else { continue }
      let newMessage = MessageModel(text: message.text,
                                    backendId: message.backendId,
                                    sentAt: message.sentAt,
                                    seq: message.seq,
                                    isCurrentUser: message.isCurrentUser,
                                    conversation: conversation)
    
      context.insert(newMessage)
    }
    
    conversation.isSync = true
    try context.save()
  }
  
  func fetchAllMessages(in conversationId: UUID) throws -> [MessageDTO] {
    
    return try _fetchAllMessages(in: conversationId).map(MessageDTO.map)
  }
  
  // MARK: - other
  
  func clean() throws {
    try? context.delete(model: MessageModel.self)
    try? context.delete(model: ConversationModel.self)
    try? context.delete(model: UserModel.self)
    try context.save()
  }
}

private extension ChatDataBase {
  func _fetchUser(id: UUID) throws -> UserModel? {
    let descriptor = FetchDescriptor<UserModel>(
      predicate: #Predicate { $0.id == id }
    )
    
    return try context.fetch(descriptor).first
  }
  
  func _fetchUser(backendId: UUID) throws -> UserModel? {
    let descriptor = FetchDescriptor<UserModel>(
      predicate: #Predicate { $0.backendId == backendId }
    )
    
    return try context.fetch(descriptor).first
  }
  
  func _fetchConversation(id: UUID) throws -> ConversationModel? {
    let descriptor = FetchDescriptor<ConversationModel>(
      predicate: #Predicate { $0.id == id }
    )
    
    return try context.fetch(descriptor).first
  }
  
  func _fetchConversation(backendId: UUID) throws -> ConversationModel? {
    let descriptor = FetchDescriptor<ConversationModel>(
      predicate: #Predicate { $0.backendId == backendId }
    )
    
    return try context.fetch(descriptor).first
  }
  
  func _fetchMessage(id: UUID) throws -> MessageModel? {
    let descriptor = FetchDescriptor<MessageModel>(
      predicate: #Predicate { $0.id == id }
    )
    
    return try context.fetch(descriptor).first
  }
  
  func _fetchMessage(backendId: UUID) throws -> MessageModel? {
    let descriptor = FetchDescriptor<MessageModel>(
      predicate: #Predicate { $0.backendId == backendId }
    )
    
    return try context.fetch(descriptor).first
  }
  
  
  func _fetchAllMessages(in conversationId: UUID) throws -> [MessageModel] {
    
    let descriptor = FetchDescriptor<MessageModel>(
      
      predicate: #Predicate { $0.conversation.id == conversationId },
      sortBy: [SortDescriptor(\.sentAt, order: .reverse)]
    )
    
    return try context.fetch(descriptor)
  }
}


extension Array where Element == Int64 {
    func firstSequenceBreak() -> Int? {
        guard count > 1 else { return nil }

        for i in 1 ..< count {
            if self[i] != self[i - 1] + 1 {
                return i
            }
        }
        return nil
    }
}

//
//  ChatDataBase.swift
//  RealSwipe
//
//  Created by Utilisateur on 08/11/2025.
//

import SwiftData
import Foundation

@ModelActor
actor ChatDataBase: Sendable {
  enum Failure: Error {
    case conversationNotFound
  }
  
  static let shared = ChatDataBase()
  
  private init() {
    let modelContainer = try! ModelContainer(for: MessageModel.self, ConversationModel.self, UserModel.self)
    self.init(modelContainer: modelContainer)
  }
  
  private var context: ModelContext { modelExecutor.modelContext }
  
  func performOnContex(value: (ChatDataBase,ModelContext) -> ())  {
    value(self, context)
  }
  // MARK: - USER
  
  func syncConversations(conversations: [ConversationDataBaseInput]) {
    for conversation in conversations {
      do {
        let userModel = try upsertUser(userBackendId: conversation.profile.userBackendId,
                                       username: conversation.profile.firstName,
                                       profileImageUrl: conversation.profile.profileImageUrl)
        try upsertConversation(conversationBackendId: conversation.id, createdAt: Date(), participant: userModel, referenceSeq: conversation.seq)
      } catch {}
    }
    
    for conversation in (try? fetchAllConversations()) ?? [] {
      if conversations.contains(where: {$0.id == conversation.backendId }) == false {
        do {
          try self.deleteConversation(conversationBackendId: conversation.backendId)
        } catch {}
      }
    }
  }
  
  @discardableResult
  private func upsertUser(userBackendId: UUID, username: String, profileImageUrl: URL?) throws -> UserModel {
    try _fetchUser(userBackendId: userBackendId).map {
      try updateUser(userModel: $0, username: username, profileImageUrl: profileImageUrl)
    } ?? (try insertUser(userBackendId: userBackendId, username: username, profileImageUrl: profileImageUrl))
  }
  
  private func insertUser(userBackendId: UUID, username: String, profileImageUrl: URL?) throws -> UserModel  {
    let userModel = UserModel(backendId: userBackendId, username: username, profileImage: profileImageUrl)
    context.insert(userModel)
    try context.save()
    return userModel
  }
  
  private func updateUser(userModel: UserModel, username: String, profileImageUrl: URL?) throws -> UserModel  {
    userModel.username = username
    userModel.profileImage = profileImageUrl
    try context.save()
    return userModel
  }
  
  // MARK: - Conversation
  
  @discardableResult
  func upsertConversation(conversationBackendId: UUID, createdAt: Date, participant: UserModel, referenceSeq: Int) throws -> ConversationModel {
    return try _fetchConversation(conversationBackendId: conversationBackendId).map {
      try updateConversation(conversationModel: $0, referenceSeq: referenceSeq)
    } ?? ( try insertConversation(conversationBackendId: conversationBackendId, createdAt: createdAt, participant: participant, referenceSeq: referenceSeq))
  }
  
  private func updateConversation(conversationModel: ConversationModel, referenceSeq: Int) throws -> ConversationModel {
    guard conversationModel.isSync else { return conversationModel }
    conversationModel.isSync = conversationModel.seq >= referenceSeq
    try context.save()
    return conversationModel
  }
  
  private func insertConversation(conversationBackendId: UUID, createdAt: Date, participant: UserModel, referenceSeq: Int) throws -> ConversationModel {
    let conversationModel = ConversationModel(backendId: conversationBackendId, createdAt: createdAt, participant: participant, isSync: referenceSeq == 0)
    context.insert(conversationModel)
    try context.save()
    return conversationModel
  }
  
  @discardableResult
  func deleteConversation(conversationBackendId: UUID) throws -> ConversationDTO? {
    guard let conversationModel = try _fetchConversation(conversationBackendId: conversationBackendId) else { return nil }
    let conversationDTO = ConversationDTO.map(from: conversationModel)
    context.delete(conversationModel)
    try context.save()
    return conversationDTO
  }
  
  func fetchConversation(conversationLocalId: UUID) throws -> ConversationDTO? {
    try _fetch(localId: conversationLocalId).map(ConversationDTO.map(from:))
  }
  
  func fetchConversation(conversationBackendId: UUID) throws -> ConversationDTO? {
    try _fetchConversation(conversationBackendId: conversationBackendId).map(ConversationDTO.map(from:))
  }
  
  func fetchAllConversations() throws -> [ConversationDTO] {
    let descriptor = FetchDescriptor<ConversationModel>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
    return try context.fetch(descriptor).map(ConversationDTO.map)
  }
  
  func fetchAllNotSyncConversations() throws -> [ConversationDTO] {
    let descriptor = FetchDescriptor<ConversationModel>(predicate: #Predicate { $0.isSync == false },
                                                        sortBy: [SortDescriptor(\.createdAt, order: .forward)])
    return try context.fetch(descriptor).map(ConversationDTO.map)
  }
  
  // MARK: - Message
  
  @discardableResult
  func syncMessages(conversationBackendId: UUID, messages: [MessageDataBaseInput]) throws -> ConversationDTO {
    do {
      guard let conversation = try _fetchConversation(conversationBackendId: conversationBackendId) else {
        throw Failure.conversationNotFound
      }
      
      guard let minSeq = messages.map(\.seq).min(), let maxSeq = messages.map(\.seq).max() else {
        return ConversationDTO.map(from: conversation)
      }
      
      if conversation.seq + 1 < minSeq {
        for massage in (try? _fetchAllMessages(conversationLocalId: conversation.localId)) ?? [] where massage.seq < minSeq {
          context.delete(massage)
        }
      }
      
      for message in messages {
        do { try insertMessageIfNotExist(conversation: conversation, message: message) }
        catch { continue }
      }
      
      conversation.seq = maxSeq
      conversation.isSync = true
      try context.save()
      return ConversationDTO.map(from: conversation)
    } catch {
      context.rollback()
      throw error
    }
  }
  
  @discardableResult
  func insertMessageIfNotExist(conversationBackendId: UUID, message: MessageDataBaseInput) throws -> MessageDTO {
    guard let conversation = try _fetchConversation(conversationBackendId: conversationBackendId) else {
      throw Failure.conversationNotFound
    }
    return try insertMessageIfNotExist(conversation: conversation, message: message)
  }
  
  @discardableResult
  private func insertMessageIfNotExist(conversation: ConversationModel, message: MessageDataBaseInput) throws -> MessageDTO {
    if let message = try _fetchMessage(messageBackendId: message.backendId) {
      return MessageDTO.map(from: message)
    } else {
      let newMessage = MessageModel(text: message.text,
                                    backendId: message.backendId,
                                    sentAt: message.sentAt,
                                    seq: message.seq,
                                    isCurrentUser: message.isCurrentUser,
                                    conversation: conversation)
      
      context.insert(newMessage)
      try context.save()
      return MessageDTO.map(from: newMessage)
    }
  }
  
  func fetchAllMessages(conversationLocalId: UUID) throws -> [MessageDTO] {
    try _fetchAllMessages(conversationLocalId: conversationLocalId).map(MessageDTO.map)
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
  func _fetch<T: LocalIdentifiableModel & PersistentModel>(localId id: UUID ) throws -> T? {
    let descriptor = FetchDescriptor<T>(predicate: #Predicate { $0.localId == id } )
    return try context.fetch(descriptor).first
  }
  
  func _fetchUser(userBackendId: UUID) throws -> UserModel? {
    let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate { $0.backendId == userBackendId })
    return try context.fetch(descriptor).first
  }
  
  func _fetchConversation(conversationBackendId: UUID) throws -> ConversationModel? {
    let descriptor = FetchDescriptor<ConversationModel>(predicate: #Predicate { $0.backendId == conversationBackendId })
    return try context.fetch(descriptor).first
  }
  
  func _fetchMessage(messageBackendId: UUID) throws -> MessageModel? {
    let descriptor = FetchDescriptor<MessageModel>( predicate: #Predicate { $0.backendId == messageBackendId })
    return try context.fetch(descriptor).first
  }
  
  func _fetchAllMessages(conversationLocalId: UUID) throws -> [MessageModel] {
    let descriptor = FetchDescriptor<MessageModel>(predicate: #Predicate { $0.conversation.localId == conversationLocalId },
                                                   sortBy: [SortDescriptor(\.sentAt, order: .forward)])
    return try context.fetch(descriptor)
  }
}

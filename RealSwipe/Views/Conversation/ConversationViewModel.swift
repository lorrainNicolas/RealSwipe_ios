//
//  ConversationViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation

@MainActor
final class ConversationViewModel: ObservableObject {
  
  class ViewModel: ObservableObject, Identifiable {
    let conversationId: UUID
    let name: String
    
    init(conversationId: UUID, name: String) {
      self.conversationId = conversationId
      self.name = name
    }
  }
 
  @Published var conversations = [ViewModel]()
  private let userSession: UserSession
  private let api: APIClient
  
  init(userSession: UserSession, api: APIClient) {
    self.userSession = userSession
    self.api = api
    refreash()
  }
}

private extension ConversationViewModel {
  func refreash() {
    Task {
      do {
        let value = try await api.sendRequest(to: GetConversationEndpoint(token: userSession.token))
        conversations = value.map {
          .init(conversationId: $0.id, name: $0.profile.firstName)
        }
        print(value)
      }
    }
  }
}

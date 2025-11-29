//
//  TabContentFlow.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation
import Combine

@MainActor
class TabContentFlow: ObservableObject {
  
  @Published var navigationPath: [Screen] = []
  private var bag: Set<AnyCancellable> = []
  init() {
    
    NotificationCenter.default
      .publisher(for: .syncMessageDidDeleteConversation)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] value in
        guard let object = value.object as? ConversationDTO else { return }
        if let path = self?.navigationPath.last,
           case .chatView(let chatViewScreenModel) = path,
           chatViewScreenModel.conversationLocalId == object.localId {
          self?.navigationPath = []
        }
            
      }.store(in: &bag)
  }
  
  enum Screen: Hashable {
    case chatView(ChatViewScreenModel)
    
    var id: UUID {
      switch self {
      case .chatView(let value):
        return value.id
      }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
  }

  func pusChatView(screenModel: ChatViewScreenModel) {
    navigationPath.append(.chatView(screenModel))
  }
}

extension TabContentFlow {
  
  struct ChatViewScreenModel: Identifiable {
    let id = UUID()
    let conversationLocalId: UUID
    let user: String
  }
}

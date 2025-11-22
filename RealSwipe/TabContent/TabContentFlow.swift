//
//  TabContentFlow.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation
import Combine

class TabContentFlow: ObservableObject {
  
  @Published var navigationPath: [Screen] = []
  
  enum Screen: Hashable {
    case message(conversationId: UUID, user: String)
  }

  func pushMessage(conversationId: UUID, conversationBackendId: UUID, user: String) {
    navigationPath.append(.message(conversationId: conversationId,
                                   user: user))
  }

}

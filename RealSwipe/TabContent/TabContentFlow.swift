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
    case message(conversationId: UUID)
  }

  func pushMessage(conversationId: UUID) {
    navigationPath.append(.message(conversationId: conversationId))
  }

}

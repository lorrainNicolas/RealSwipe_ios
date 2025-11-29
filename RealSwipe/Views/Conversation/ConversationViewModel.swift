//
//  ConversationViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 28/11/2025.
//

import UIKit
import ImageCaching
import Combine

@MainActor
class ConversationViewModel: ObservableObject, @MainActor Identifiable {
  
  var id: UUID { conversationLocalId }
  let conversationLocalId: UUID
  let name: String
  let message: String = "coucou"
  
  @Published var profileImage: UIImage?
  
  init(conversationLocalId: UUID,
       profileImageUrl: URL?,
       name: String) {
    self.conversationLocalId = conversationLocalId
    self.name = name
    Task {
      if let profileImageUrl {
        profileImage = try? await ImageLoader.shared.load(from: profileImageUrl)
      }
    }
  }
}

//
//  TabBarIdentifer.swift
//  RealSwipe
//
//  Created by Utilisateur on 30/01/2023.
//

import Foundation
import SwiftUI

enum TabBarIdentifer: Tabbable, CaseIterable {
    case swipe
    case message
    case settings
    
    var title: String {
        switch self {
        case .swipe: return "Swipe"
        case .message: return "message"
        case .settings: return "profil"
        }
    }
    
    var image: Image {
        switch self {
        case .swipe: return Image(systemName:"flame")
        case .message: return Image(systemName:"message")
        case .settings: return Image(systemName:"person")
        }
    }
  
    var imageFill: Image {
      switch self {
      case .swipe: return Image(systemName:"flame.fill")
      case .message: return Image(systemName:"message.fill")
      case .settings: return Image(systemName:"person.fill")
      }
  }
    
    var id: Self { self }
}

//
//  TabBarIdentifer.swift
//  RealSwipe
//
//  Created by Utilisateur on 30/01/2023.
//

import Foundation
import UIKit

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
    
    var image: UIImage? {
        switch self {
        case .swipe: return UIImage(systemName:"heart")
        case .message: return UIImage(systemName:"message")
        case .settings: return UIImage(systemName:"person")
        }
    }
  
    var imageFill: UIImage? {
      switch self {
      case .swipe: return UIImage(systemName:"heart.fill")
      case .message: return UIImage(systemName:"message.fill")
      case .settings: return UIImage(systemName:"person.fill")
      }
  }
    
    var id: Self { self }
}

//
//  SettingsAboutMeViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 29/11/2025.
//

import Foundation

struct SettingsAboutMeViewModel: Identifiable {
  let id = UUID()
  
  enum Info: Hashable {
    case age(Int)
    case sexe(String)
    
    var key: String {
      switch self {
      case .age: return "Age"
      case .sexe: return "Sexe"
      }
    }
    
    var value: String {
      switch self {
      case .age(let value): return "\(value)"
      case .sexe(let value): return value
      }
    }
  }
  
  let info: Info
}

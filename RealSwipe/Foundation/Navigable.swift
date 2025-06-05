//
//  Navigable.swift
//  RealSwipe
//
//  Created by Utilisateur on 12/03/2023.
//

import Foundation

protocol Navigable: Identifiable, Hashable {}

extension Navigable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

//
//  CardViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 05/02/2023.
//

import Foundation
import SwiftUI

@MainActor
final class CardViewModel: CardViewModelProtocol, ObservableObject {
  enum Status {
    case `default`
    case isLiking
    case isUnliking
  }
  
  @Published private(set) var status: Status = .default
  @Published private(set) var background: Color
  
  init(background: Color) {
    self.background = background
  }
}

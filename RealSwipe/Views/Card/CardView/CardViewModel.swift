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

  let profileViewModel =  ProfileViewModel()
  
  init() {
  }
}

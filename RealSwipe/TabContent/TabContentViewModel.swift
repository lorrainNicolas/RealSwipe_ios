//
//  TabContentViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation
import Combine

class TabContentViewModel: ObservableObject {
  private var bag = Set<AnyCancellable>()
  
  @Published var id = TabBarIdentifer.swipe
  let userSession: UserSession
  
  init(userSession: UserSession) {
    self.userSession = userSession
  }
}

//
//  ProfilViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation

@MainActor
class ProfilViewModel: ObservableObject {
  @Published var name: String
  
  init(userSession: UserSession) {
    name = userSession.user.firstName
  }
}

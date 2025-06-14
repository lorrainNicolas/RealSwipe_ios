//
//  SettingsViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation

@MainActor
class SettingsViewModel: ObservableObject {
  
  @Published var showAge: Bool = false
  @Published var showDistance: Bool = false
  @Published var description: String = ""
  
  let name: String
  let age: Int?
  
  init(userSession: UserSession) {
    name = userSession.user.firstName
    age = userSession.user.birthday.age
  }
}

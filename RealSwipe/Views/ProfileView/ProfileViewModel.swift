//
//  ProfileViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 20/11/2025.
//

import Combine
import UIKit
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
  
  @Published private(set) var image: Image?
  
  let name: String
  init() {
    name = Self.randomFirstName()
  }
  
  func task() async {
    let value = try? await URLSession.shared.data(from: URL(string: "https://thispersondoesnotexist.com/")!)
    guard let image = value.flatMap({ UIImage(data: $0.0) }) else { return }
    self.image = Image(uiImage: image)
  }
  
  static func randomFirstName() -> String {
      let names = [
          "Emma", "Léo", "Chloé", "Noah", "Lina",
          "Gabriel", "Mila", "Lucas", "Jade", "Hugo"
      ]
      return names.randomElement() ?? "Inconnu"
  }
}

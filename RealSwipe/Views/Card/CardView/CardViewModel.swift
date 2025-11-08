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
  @Published private(set) var image: Image?
  let name: String
  
  init(background: Color) {
    self.background = background
    self.name = Self.randomFirstName()
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

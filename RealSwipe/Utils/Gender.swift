//
//  Gender.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation

enum Gender: Int, Codable {
  case male = 1
  case woman

  var value: String {
    switch self {
    case .male: "Homme"
    case .woman: "Femme"
    }
  }
}

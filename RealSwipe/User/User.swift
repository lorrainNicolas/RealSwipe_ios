//
//  User.swift
//  RealSwipe
//
//  Created by Utilisateur on 20/05/2025.
//

import Foundation
import Combine
import SwiftUI

struct User: Codable {
  let userId: UUID
  let firstName: String
  let birthday: Date
}

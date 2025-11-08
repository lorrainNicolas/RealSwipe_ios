//
//  Tabbable.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/02/2023.
//

import Foundation
import SwiftUI

protocol Tabbable: Identifiable, Hashable {
  var title: String { get }
  var image: Image { get }
  var imageFill: Image { get }
}

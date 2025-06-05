//
//  Tabbable.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/02/2023.
//

import Foundation
import UIKit

protocol Tabbable: Identifiable, Hashable {
  var title: String { get }
  var image: UIImage? { get }
}

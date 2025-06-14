//
//  Date+RealSwipe.swift
//  RealSwipe
//
//  Created by Utilisateur on 08/06/2025.
//

import Foundation 

extension Date {
  var age: Int? {
    Calendar.current.dateComponents([.year], from: self, to: Date()).year
  }
}

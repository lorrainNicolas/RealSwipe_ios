//
//  LinearGradients.swift
//  RealSwipe
//
//  Created by Utilisateur on 30/01/2023.
//

import Foundation
import UIKit
import SwiftUI

enum LinearGradients {
  static let componentBackground = LinearGradient(colors: [Color(Colors.componentBackground.withAlphaComponent(0.7)),
                                                           Color(Colors.componentBackground)],
                                                  startPoint: UnitPoint(x: 0.7, y: 0.7),
                                                  endPoint: .bottomTrailing)
    
  static let selectedTool = LinearGradient(colors: [Color(UIColor(red: 231.0/255.0, green: 67.0/255.0, blue: 99.0/250.0, alpha: 1)),
                                                    Color(UIColor(red: 239.0/255.0, green: 126.0/255.0, blue: 97.0/250.0, alpha: 1))],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
  
  static let shape = LinearGradient(colors: [Color(UIColor(red: 234.0/255.0, green: 91.0/255.0, blue: 98.0/250.0, alpha: 1)),
                                             Color(UIColor(red: 241.0/255.0, green: 156.0/255.0, blue: 97.0/250.0, alpha: 1))],
                                    startPoint: .top,
                                    endPoint: .bottom)
  
  static let selectedBorder = LinearGradient(colors: [Color(UIColor.white), Color(UIColor.white.withAlphaComponent(0.7)),
                                                      Color(UIColor.white)],
                                             startPoint: .topLeading,
                                             endPoint: .bottomTrailing)
}


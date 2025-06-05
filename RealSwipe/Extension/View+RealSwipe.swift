//
//  View+RealSwipe.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/02/2023.
//

import Foundation
import SwiftUI

extension View {
  public func addBorder<S: ShapeStyle>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View  {
    let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
    return clipShape(roundedRect).overlay(roundedRect.strokeBorder(content, lineWidth: width))
  }
}

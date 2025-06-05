//
//  LoadingViewModifier.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/06/2023.
//

import Foundation
import SwiftUI
import Combine

struct LoadingViewModifier: ViewModifier {
  let isLoading: Bool
  let title: String
  
  func body(content: Content) -> some View {
    ZStack {
      content
      if isLoading {
        ZStack {
          VisualEffectView(effect: UIBlurEffect(style: .light))
          VStack {
            ProgressView()
            Text(title)
          }.transition(.opacity)
           .animation(.default, value: isLoading)
        }.ignoresSafeArea()
      }
    }.navigationBarBackButtonHidden(isLoading)
  }
}

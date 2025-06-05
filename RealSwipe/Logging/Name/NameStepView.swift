//
//  GenderStepView.swift
//  RealSwipe
//
//  Created by Utilisateur on 12/03/2023.
//

import Foundation
import SwiftUI

struct NameStepView: View {
  @FocusState private var textfielIsFocused: Bool
  @ObservedObject var viewModel: NameStepViewModel
  
  var body: some View {
    StepView(title: viewModel.title) {
      VStack(alignment: .leading, spacing: 20) {
        CustomTextField("Prénom", isSecured: false)
          .onTapButton {
            viewModel.onTapButton($0)
            return true
          }
          .frame(maxWidth: .infinity)
          .focused($textfielIsFocused)
      }
    }.ignoresSafeArea(.keyboard)
      .onAppear {
        textfielIsFocused = true
    }
  }
}

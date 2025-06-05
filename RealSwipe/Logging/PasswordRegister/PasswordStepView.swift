//
//  PasswordStepView.swift
//  RealSwipe
//
//  Created by Utilisateur on 27/02/2023.
//

import Foundation
import SwiftUI

@MainActor
protocol PasswordViewModelProtocol: ObservableObject{
  var title: String { get }
  var subtitle: String? { get }
  var isLoading: Bool { get }
  func onTapButton(_ password: String)
}

struct PasswordStepView<ViewModel: PasswordViewModelProtocol>: View {
  
  @FocusState private var passwordFocused: Bool
  @ObservedObject var viewModel: ViewModel

  var body: some View {
    StepView(title: viewModel.title) {
      VStack(alignment: .leading, spacing: 20) {
        CustomTextField("Password", isSecured: true)
          .onTapButton {
            viewModel.onTapButton($0)
            return true
          }
          .frame(maxWidth: .infinity)
          .focused($passwordFocused)
        if let subtitle = viewModel.subtitle {
          Text(subtitle).foregroundColor(.gray)
        }
      }
    }.ignoresSafeArea(.keyboard)
      .onAppear {
      passwordFocused = true
    }.modifier(LoadingViewModifier(isLoading: viewModel.isLoading, title: "Logging"))
  }
}

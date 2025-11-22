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
  var errorMessage: String? { get }
  func didValid(_ password: String)
}

struct PasswordStepView<ViewModel: PasswordViewModelProtocol>: View {
  
  @FocusState private var passwordFocused: Bool
  @ObservedObject var viewModel: ViewModel

  var body: some View {
    StepView(title: viewModel.title) {
      VStack(alignment: .leading, spacing: 20) {
        CustomTextField("Password", isSecured: true)
          .onTapButton {
            viewModel.didValid($0)
            return true
          }
          .frame(maxWidth: .infinity)
          .focused($passwordFocused)
          .padding(.bottom, 20)
          .frame(maxWidth: .infinity)

        if let subtitle = viewModel.subtitle {
          Text(subtitle).foregroundColor(.gray)
        }
        
        Text(viewModel.errorMessage ?? " ")
          .foregroundColor(.red)
        
        
      }
    }.ignoresSafeArea(.keyboard)
      .onAppear {
      passwordFocused = true
    }.modifier(LoadingViewModifier(isLoading: viewModel.isLoading, title: "Logging"))
  }
}

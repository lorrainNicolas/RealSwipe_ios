//
//  PasswordStepScreen.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import SwiftUI
import Combine

@MainActor
protocol PasswordStepScreenViewModel: PasswordViewModelProtocol {
  var logginFlowPublish: AnyPublisher<LogginFlow.Screen, Never> { get }
}

struct PasswordStepScreen<ViewMode: PasswordStepScreenViewModel>: View {
  
  @StateObject var viewModel: ViewMode
  @EnvironmentObject var logginFlow: LogginFlow
  
  var body: some View {
    PasswordStepView(viewModel: viewModel)
    
      .onReceive(viewModel.logginFlowPublish) {
        logginFlow.navigationPath.append($0)
      }
  }
}

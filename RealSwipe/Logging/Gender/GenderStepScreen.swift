//
//  GenderStepScreen.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import SwiftUI

struct GenderStepScreen: View {
  
  @StateObject var viewModel: GenderStepViewModel
  @EnvironmentObject var logginFlow: LogginFlow
  
  var body: some View {
    GenderStepView(viewModel: viewModel)
      .onChange(of: viewModel.isLoading) {_, newValue in
        logginFlow.isLoading = newValue
      }
  }
}

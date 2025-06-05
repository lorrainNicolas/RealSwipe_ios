//
//  NameStepScreen.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import SwiftUI

struct NameStepScreen: View {
  
  @StateObject var viewModel: NameStepViewModel
  @EnvironmentObject var logginFlow: LogginFlow
  
  var body: some View {
    NameStepView(viewModel: viewModel)
      .onReceive(viewModel.logginFlowPublish) {
        logginFlow.navigationPath.append($0)
      }
  }
}

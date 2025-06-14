//
//  BirthdayStepScreen.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import SwiftUI

struct BirthdayStepScreen: View {
  
  @StateObject var viewModel: BirthdayStepViewModel
  @EnvironmentObject var logginFlow: LogginFlow
  
  var body: some View {
    BirthdayStepView(viewModel: viewModel)
      .onReceive(viewModel.logginFlowPublish) {
        logginFlow.navigationPath.append($0)
      }
  }
}

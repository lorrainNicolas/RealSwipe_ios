//
//  LogginScreen.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import Foundation
import SwiftUI

struct LogginScreen: View {
  
  @StateObject var viewModel: LogginViewModel
  @EnvironmentObject var logginFlow: LogginFlow
  
  var body: some View {
    LogginView(viewModel: viewModel)
    
      .onReceive(viewModel.logginFlowPublish) {
        logginFlow.navigationPath.append($0)
      }
  }
}

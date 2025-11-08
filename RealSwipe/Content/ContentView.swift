//
//  ContentView.swift
//  RealSwipe
//
//  Created by Utilisateur on 30/01/2023.
//

import SwiftUI
import Combine

struct ContentView: View {
  @StateObject var viewModel = ContentViewViewModel()
  var body: some View {
    ZStack {
      if let userSession = viewModel.userSession {
        TabContentView(viewModel: TabContentViewModel(userSession: userSession))
          .environment(\.disconnectAction, viewModel.disconnectAction)
          .id(userSession.id)
      } else {
        LogginFlowScreen(logginFlow: LogginFlow())
      }
  
    }.preferredColorScheme(.dark)
  }
}


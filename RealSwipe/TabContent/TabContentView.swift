//
//  TabContentView.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/06/2023.
//

import Foundation
import SwiftUI
import ExyteChat

struct TabContentView: View {
  @StateObject var tabContentFlow = TabContentFlow()
  @StateObject var viewModel: TabContentViewModel
  
  var body: some View {
    ZStack {
      NavigationStack(path: $tabContentFlow.navigationPath) {
        TabView(selectedTabItem: $viewModel.id) {
          MatchView(viewModel: MatchViewModel())
            .tabItem(for: TabBarIdentifer.swipe)
            
          ConversationView(viewModel: ConversationViewModel(userSession: viewModel.userSession,
                                                            api: APIClient()))
            .tabItem(for: TabBarIdentifer.message)

          SettingsView(viewModel: SettingsViewModel(userSession: viewModel.userSession))
            .tabItem(for: TabBarIdentifer.settings)
          
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
  
        .navigationDestination(for: TabContentFlow.Screen.self) { screen in
          switch screen {
          case .message:
            ChatView(viewModel: ChatViewModel())
          }
        }
      }
    }.environmentObject(tabContentFlow)
  }
}

struct DisplayOverlayModifier: ViewModifier {
  func body(content: Content) -> some View {
    ZStack {
      content
    }
  }
}

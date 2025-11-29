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
          SwipeView(viewModel: SwipeViewModel())
            .tabItem(for: TabBarIdentifer.swipe)
            
          ConversationListView(viewModel: ConversationListViewModel(userSession: viewModel.userSession,
                                                                    api: APIClient()))
            .tabItem(for: TabBarIdentifer.message)
          
          SettingsView(viewModel: SettingsViewModel(userSession: viewModel.userSession))
            .tabItem(for: TabBarIdentifer.settings)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
  
        .navigationDestination(for: TabContentFlow.Screen.self) { screen in
          switch screen {
          case .chatView(let chatScreenModel):
            ChatView(viewModel: ChatViewModel(userSession: viewModel.userSession,
                                              inputData: .init(conversationLocalId: chatScreenModel.conversationLocalId,
                                                               user: chatScreenModel.user)))
            .id(screen.id)
          }
        }
      }
    }.environmentObject(tabContentFlow)
  }
}

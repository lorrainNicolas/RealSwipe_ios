//
//  ConversationListView.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/02/2023.
//

import Foundation
import SwiftUI


struct ConversationListView: View {
  
  @StateObject var viewModel: ConversationListViewModel
  @EnvironmentObject var tabContentFlow: TabContentFlow
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("Messages")
        .font(.custom("Poppins Bold", size: 34))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
      
      List {
        ForEach(viewModel.conversations) { viewModel in
          
          ConversationView(viewModel: viewModel)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
              tabContentFlow.pusChatView(screenModel: .init(conversationLocalId: viewModel.conversationLocalId,
                                                            user: viewModel.name))
          }.listRowBackground(Colors.contentBackground)
        }
      }.scrollContentBackground(.hidden)
        .refreshable { await viewModel.refreshable() }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 100)
        }
    }
  }
}

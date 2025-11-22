//
//  ChatView.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import SwiftUI
import ExyteChat

@MainActor
struct ChatView: View {
  
  @StateObject private var viewModel: ChatViewModel
  
  @State var showMatchedView: Bool = false
  @State private var showSheet = false
  
  init(viewModel: ChatViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  
  var body: some View {
    ExyteChat.ChatView(messages: viewModel.messages, chatType: .conversation) { [weak viewModel] draft in
      viewModel?.send(draft: draft)
    }.setAvailableInputs([AvailableInputType.text])
      .showMessageMenuOnLongPress(false)
      .enableLoadMore(pageSize: 0) { _ in
        print("tototo")
      }
      .toolbar {
        
        ToolbarItem(placement: .principal) {
          HStack {
            Circle()
              .fill(.white)
              .frame(height: 50)
            
            Text(viewModel.chatTitle)
          }.onTapGesture {
            showMatchedView = true
          }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
          Button.init {
            showSheet = true
          } label: {
            Image(systemName: "ellipsis")
          }
        }
      }
      .fullScreenCover(isPresented: $showMatchedView) {
        MatchDetailView()
      }
      .sheet(isPresented: $showSheet) {
        ChatViewSheet()
      }
  }
}

private struct ChatViewSheet: View {
  var body: some View {
    VStack {
      Button.init(action: {
        
      }) {
        Text("Remove User")
      }
    }
    .padding()
    .presentationDetents([.height(200)])
    .presentationDragIndicator(.visible)
  }
}

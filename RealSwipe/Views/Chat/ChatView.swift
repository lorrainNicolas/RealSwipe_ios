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
        print("LoadMore")
      }
      .toolbar {
        
        ToolbarItem(placement: .principal) {
          HStack {
            ZStack {
              Circle()
                .fill(.white)
                .frame(height: 50)
              
              if let image = viewModel.profileImage {
                Image(uiImage: image)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 50, height: 50)
                  .clipShape(Circle())
              }
            }
            
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
        ChatViewSheet(viewModel: viewModel)
      }
  }
}

private struct ChatViewSheet: View {
  
  @Environment(\.dismiss) private var dismiss
  
  let viewModel: ChatViewModel
  
  var body: some View {
    VStack {
      
      ZStack {
        Text("Prendre une décision")
          .font(.custom("Poppins Bold", size: 16))
          .padding(.top, 8)
        
        HStack {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
              .font(.system(size: 16, weight: .bold))
              .padding()
          }
          .buttonStyle(.plain)
          
          Spacer()
        }
      }
      
      Button {
        dismiss()
        viewModel.delete()
      } label: {
        HStack(spacing: 18) {
          Image(systemName: "heart.slash")
            .foregroundStyle(Colors.componentBackground)
            .frame(width: 14, height: 14)
          
          VStack(alignment: .leading, spacing: 8) {
            Text("annuler le match")
              .font(.custom("Poppins Bold", size: 14))
              .frame(maxWidth: .infinity, alignment: .leading)
            Text("Pas fan finalement ? Supprime ce profil de tes matchs.")
              .multilineTextAlignment(.leading)
              .font(.system(size: 12))
              .frame(maxWidth: .infinity, alignment: .leading)
          }
        }.padding()
      }.buttonStyle(.plain)
    }
    .padding()
    .presentationDetents([.height(200)])
    .presentationDragIndicator(.visible)
  }
}

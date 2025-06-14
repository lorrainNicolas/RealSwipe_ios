//
//  ConversationView.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/02/2023.
//

import Foundation
import SwiftUI


struct ConversationView: View {
  
  @StateObject var viewModel: ConversationViewModel
  @EnvironmentObject var tabContentFlow: TabContentFlow
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("Messages")
        .font(.custom("Poppins Bold", size: 34))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
      
      List {
        ForEach(viewModel.conversations) {
          MessageView(userName: $0.name, message: nil).onTapGesture {
            tabContentFlow.pushMessage()
          }.listRowBackground(Colors.contentBackground)
        }
      }.scrollContentBackground(.hidden)
    }
  }
}

private struct MessageView: View {
  let userName: String
  let message: String?
  
  var body: some View {
    HStack {
      Circle()
        .fill(.white)
        .frame(height: 50)
      
      VStack(alignment: .leading) {
        Text(userName)
          .foregroundStyle(Colors.text)
          .lineLimit(1)
        
        Text(message ?? " ")
          .foregroundStyle(Colors.text)
          .lineLimit(1)
   
      }
    }
  }
}


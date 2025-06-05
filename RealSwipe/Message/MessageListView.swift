//
//  MessageListView.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/02/2023.
//

import Foundation
import SwiftUI


struct MessageListView: View {
  struct Data: Hashable {
    let userName: String
    let message: String
  }
  
  @StateObject var viewModel: MessageListViewModel
  @EnvironmentObject var tabContentFlow: TabContentFlow
  
  var data: [Data] = [Data(userName: "User 1",  message: "hola"),
                      Data(userName: "User 2",  message: "Ca Gazouille ?")]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("Messages")
        .font(.custom("Poppins Bold", size: 34))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
      
      List {
        ForEach(data, id: \.self) {
          UserMessageView(userName: $0.userName, message: $0.message).onTapGesture {
            tabContentFlow.pushMessage()
          }.listRowBackground(Colors.contentBackground)
        }
      }.scrollContentBackground(.hidden)
    }
  }
}

struct UserMessageView: View {
  let userName: String
  let message: String
  
  var body: some View {
    HStack {
      Circle()
        .fill(.white)
        .frame(height: 50)
      
      VStack(alignment: .leading) {
        Text(userName)
          .foregroundStyle(Colors.text)
          .lineLimit(1)
        Text(message)
          .foregroundStyle(Colors.text)
          .lineLimit(1)
      }
    }
  }
}

struct MessageView: View {
    var message: String
    var isSentByUser: Bool

    var body: some View {
        HStack {
            if isSentByUser {
                Spacer()
                Text(message)
                    .foregroundStyle(Colors.text)
                    .padding(10)
                    .cornerRadius(10)
            } else {
                Text(message)
                    .foregroundStyle(Colors.text)
                    .padding(10)
                    .cornerRadius(10)
                Spacer()
            }
        }
        .padding(.horizontal, 10)
    }
}


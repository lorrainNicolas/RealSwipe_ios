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

    
    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
      ExyteChat.ChatView(messages: viewModel.messages, chatType: .conversation) { draft in
            viewModel.send(draft: draft)
        }.setAvailableInputs([AvailableInputType.text])
        .showMessageMenuOnLongPress(false).enableLoadMore(pageSize: 0) { _ in
          print("dkeodkoek")
        }
    }
}

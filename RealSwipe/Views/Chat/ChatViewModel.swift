//
//  ChatViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import Foundation
import ExyteChat

@MainActor
final class ChatViewModel: ObservableObject {
  
  @Published var messages: [Message] = []
  @Published var chatTitle: String = ""
  let webSocketConnection: WebSocketConnection
  let apiClient: APIClientProtocol
  
  init(apiClient: APIClientProtocol = APIClient()) {
    self.apiClient = apiClient
    webSocketConnection = WebSocketConnection(url: URL.init(string: "ws://localhost:8080/ws?token=")!)
    
    Task {
      do {
        for try await message in webSocketConnection.receive() {
          self.refresh()
          print(message)
        }
      } catch {
        print("Error receiving messages:", error)
      }
    }
  }
  
  func refresh() {
//    Task { [weak self] in
//      do {
//        let value = try await self?.apiClient.sendRequest(to: GetMessageEndpoint())
//        self?.messages = value?.first?.messages.map({
//          Message(id: $0.id,
//                  user: .init(id:  UUID().uuidString,
//                              name: "",
//                              avatarURL: nil,
//                              type: .current),
//                  status: .read,
//                  createdAt: Date(),
//                  text: $0.message,
//                  attachments: [],
//                  giphyMediaId: nil,
//                  reactions: [], recording: nil, replyMessage: nil)
//        }) ?? []
//      }}
  }
  
  func send(draft: DraftMessage) {
    
  }
}

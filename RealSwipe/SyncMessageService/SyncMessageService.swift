//
//  SyncMessageService.swift
//  RealSwipe
//
//  Created by Utilisateur on 07/11/2025.
//

import Combine
import Foundation

@MainActor
final class SyncMessageService: Sendable {
  
  private var bag = Set<AnyCancellable>()
  private let webSocketService: WebSocketService
  private let authentificationSession: AuthentificationService
  
  private var userSession: UserSession?
  
  let didReceivedMessage: PassthroughSubject<WebSocketMessageData, Never> = .init()
  
  static let shared = SyncMessageService()
  
  init(webSocketService: WebSocketService = WebSocketService(),
       authentificationSession: AuthentificationService = .shared) {
    self.webSocketService = webSocketService
    self.authentificationSession = authentificationSession
    
    Task {
      for await message in webSocketService.stream {
        switch message {
        case.didReceive(let message):
          guard let data = message.data(using: .utf8) else { return }
          do {
            didReceivedMessage.send(try await decode(data: data))
          } catch {
            print("Erreur de décodage: \(error)")
          }
          
        default: break
        }
      }
    }
  }
  
  static func launch() {
    shared.authentificationSession.userSessionPublisher.sink {[weak shared] in
      shared?.userSession = $0
      if let token = $0?.token {
        shared?.webSocketService.launch(token: token)
      } else {
        shared?.webSocketService.stop()
      }
    }.store(in: &shared.bag)
  }
  
  @concurrent func decode(data: Data) async throws -> WebSocketMessageData {
    return try JSONDecoder().decode(WebSocketMessageData.self, from: data)
  }
}


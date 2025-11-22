//
//  WebSocketService.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import Foundation

actor WebSocketService {
  
  enum WebSocketMessage {
    case didReceive(MessageResponse)
    case didConnected
  }
  
  let stream: AsyncStream<WebSocketMessage>
  private let streamContinuation: AsyncStream<WebSocketMessage>.Continuation
  
  private var didReseivedWebSocketSessionTask: Task<Void, Never>?
  private var token: String
  
  private var webSocketSession: WebSocketSession?
  
  init(token: String) {
    self.token = token
    let makerStream = AsyncStream<WebSocketMessage>.makeStream()
    stream = makerStream.stream
    streamContinuation = makerStream.continuation
  }
  
  deinit {
    didReseivedWebSocketSessionTask?.cancel()
  }
  
  func launch() async {
    let oldWebSocketSession = webSocketSession
    Task.detached { await oldWebSocketSession?.cancel() }
    didReseivedWebSocketSessionTask?.cancel()
    didReseivedWebSocketSessionTask = nil
    
    let webSocketSession = WebSocketSession(from: token)
    self.webSocketSession = webSocketSession
    connect(webSocketSession: webSocketSession)
    await webSocketSession.resume()
  }
  
  private func connect(webSocketSession: WebSocketSession) {
    didReseivedWebSocketSessionTask = Task { [weak self] in
      guard !Task.isCancelled else { return }
      do {
        for try await message in webSocketSession.stream {
          guard !Task.isCancelled else { return }
          switch message {
          case .didConnected: self?.streamContinuation.yield(.didConnected)
          case .didReceive(let messageResponse): self?.streamContinuation.yield(.didReceive(messageResponse))
          }
        }
      } catch {
        
        if let error = error as? WebSocketSession.Failure, error == .cancel {
          return
        }
        
        guard !Task.isCancelled else { return }
        
        try? await Task.sleep(for: .seconds(30))
        
        guard !Task.isCancelled else { return }
        await self?.launch()
      }
    }
  }
}

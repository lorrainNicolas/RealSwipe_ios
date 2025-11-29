//
//  WebSocketSession.swift
//  RealSwipe
//
//  Created by Utilisateur on 18/11/2025.
//

import Foundation

//https://medium.com/@thomsmed/real-time-with-websockets-and-swift-concurrency-8b44a8808d0d

actor WebSocketSession: NSObject, Identifiable, Sendable {
  
  enum WebSocketMessage {
    case didReceive(MessageResponse)
    case didConnected
    case didDeleteConversation(UUID)
    case didCreateConversation
  }
  
  enum State {
    case pending
    case connected
    case disconnected
  }
  
  enum Failure: Error {
    case cancel
    case failure
  }
  
  let stream: AsyncThrowingStream<WebSocketMessage, Error>
  private let streamContinuation: AsyncThrowingStream<WebSocketMessage, Error>.Continuation
  
  private lazy var session: URLSession = {
    return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
  }()
  
  private lazy var urlSessionWebSocketTask: URLSessionWebSocketTask = {
    return session.webSocketTask(with: URL.init(string: "ws://realswipe.onrender.com/ws?token=\(token)")!)
  }()
  
  let token: String
  private var task: Task<(), any Error>?
  private(set) var state: State = .pending
  
  init(from token: String) {
    let makerStream = AsyncThrowingStream<WebSocketMessage, Error>.makeStream()
    stream = makerStream.stream
    streamContinuation = makerStream.continuation
    self.token = token
    super.init()
    
  }
  
  func cancel() {
    guard state != .disconnected else { return }
    finished(error: .cancel)
  }
  
  func resume() {
    guard state != .disconnected else { return }
    let urlSessionWebSocketTask = urlSessionWebSocketTask
    
    enum IncomingMessage {
      case webSocketEventWrapper(WebSocketEventWrapper)
      case unowned
    }
    
    task = Task {
      do {
        for try await incomingMessage in AsyncThrowingStream<IncomingMessage, Error>(unfolding: {
        
          let message: IncomingMessage
          switch try await urlSessionWebSocketTask.receive() {
          
          case let .data(messageData):
            do {
              let webSocketEventWrapper = try JSONDecoder().decode(WebSocketEventWrapper.self, from: messageData)
              message = .webSocketEventWrapper(webSocketEventWrapper)
            } catch { message = .unowned }
            
          case .string:
            message = .unowned
          @unknown default:
            message = .unowned
          }
          return Task.isCancelled ? nil : message
        }) {
          
          guard !Task.isCancelled else { return }
          
          if state == .pending {
            state = .connected
            streamContinuation.yield(.didConnected)
          }
          
          guard case .webSocketEventWrapper(let value) = incomingMessage else { continue }
          switch value {
          case .messageResponse(let messageResponse): streamContinuation.yield(.didReceive(messageResponse))
          case .connectedResponse: break
          case .didDeleteConversation(let id): streamContinuation.yield(.didDeleteConversation(id))
          case .didCreateConversation: streamContinuation.yield(.didCreateConversation)
          }
        }
      } catch {
        finished(error: .failure)
      }
    }
    
    urlSessionWebSocketTask.resume()
  }
  
  private func finished(error: Failure) {
    state = .disconnected
    streamContinuation.finish(throwing: error)
    task?.cancel()
    task = nil
    urlSessionWebSocketTask.cancel()
  }
}

extension WebSocketSession: URLSessionWebSocketDelegate {
  
  nonisolated func urlSession(_ session: URLSession,
                              webSocketTask: URLSessionWebSocketTask,
                              didOpenWithProtocol protocol: String?) {
  }
  
  nonisolated func urlSession(_ session: URLSession,
                              webSocketTask: URLSessionWebSocketTask,
                              didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                              reason: Data?) {
    Task {
      await finished(error: .failure)
    }
  }
}


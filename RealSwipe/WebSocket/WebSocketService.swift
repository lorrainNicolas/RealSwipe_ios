//
//  WebSocketService.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import Foundation
enum WebSocketMessage {
  case didReceive(String)
  case isCancel
  case unowned
}

@MainActor
final class WebSocketSession: NSObject, Identifiable  {
  enum Failure: Error {
    case failure
  }
  
  let stream: AsyncThrowingStream<WebSocketMessage, any Error>
  private let streamContinuation: AsyncThrowingStream<WebSocketMessage, Error>.Continuation
  
  private lazy var session: URLSession = {
    return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
  }()
  
  private lazy var urlSessionWebSocketTask: URLSessionWebSocketTask = {
    return session.webSocketTask(with: URL.init(string: "ws://realswipe.onrender.com/ws?token=\(token)")!)
  }()
  
  private let token: String
  private var task: Task<(), any Error>?
  private(set) var isCancelled: Bool = false {
    didSet {
      streamContinuation.yield(.isCancel)
    }
  }
  
  init(from token: String) {
    let makerStream = AsyncThrowingStream<WebSocketMessage, Error>.makeStream()
    stream = makerStream.stream
    streamContinuation = makerStream.continuation
    self.token = token
    super.init()
  }

  func cancel() {
    isCancelled = true
    
    streamContinuation.finish(throwing: Failure.failure)
    task?.cancel()
    task = nil
    urlSessionWebSocketTask.cancel()
  }
  
  func resume() {
    let urlSessionWebSocketTask = urlSessionWebSocketTask
    task = Task { 
      do {
        for try await message in AsyncThrowingStream<WebSocketMessage, Error>(unfolding: {
        
          let message: WebSocketMessage
          switch try await urlSessionWebSocketTask.receive() {
          
          case let .data(messageData):
            message = WebSocketMessage.didReceive(.init(data: messageData, encoding: .utf8) ?? "")
          case let .string(text):
            message = WebSocketMessage.didReceive(text)
          @unknown default:
            message = .unowned
          }
          
          return Task.isCancelled ? nil : message
        }) {
          streamContinuation.yield(message)
        }
      } catch {
       cancel()
      }
    }
    
    urlSessionWebSocketTask.resume()
  }
}

extension WebSocketSession: URLSessionWebSocketDelegate {
  
  nonisolated func urlSession(_ session: URLSession,
                              webSocketTask: URLSessionWebSocketTask,
                              didOpenWithProtocol protocol: String?) {
  }
  
  nonisolated func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
    Task {
      await cancel()
    }
  }
}

@MainActor
final class WebSocketService {
  
  let stream: AsyncStream<WebSocketMessage>
  private let streamContinuation: AsyncStream<WebSocketMessage>.Continuation
  private var webSocketSession: WebSocketSession?
  private var didReseivedWebSocketSessionTask: Task<Void, Never>?
  
  init() {
    let makerStream = AsyncStream<WebSocketMessage>.makeStream()
    stream = makerStream.stream
    streamContinuation = makerStream.continuation
  }
  
  func launch(token: String) {
    webSocketSession?.cancel()
    didReseivedWebSocketSessionTask?.cancel()
    
    let webSocketSession = WebSocketSession(from: token)
    self.webSocketSession = webSocketSession
    webSocketSession.resume()
    
    didReseivedWebSocketSessionTask = Task {
      let webSocketSession = webSocketSession
      guard !Task.isCancelled else { return }
   
      do {
        for try await message in webSocketSession.stream {
          guard !Task.isCancelled else { return }
          streamContinuation.yield(message)
        }
      } catch {
        print("Error")
      }
    }
  }
  
  func stop() {
    webSocketSession?.cancel()
    webSocketSession = nil
    
    didReseivedWebSocketSessionTask?.cancel()
    didReseivedWebSocketSessionTask = nil
  }
}

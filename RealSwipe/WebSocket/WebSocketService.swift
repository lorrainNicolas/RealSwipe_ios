//
//  WebSocketService.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import Foundation

/// Enumeration of possible errors that might occur while using ``WebSocketConnection``.
public enum WebSocketConnectionError: Error {
  case connectionError
  case transportError
  case encodingError
  case decodingError
  case disconnected
  case closed
}

@MainActor
public final class WebSocketConnection {
  private let webSocketTask: URLSessionWebSocketTask
  private let session = URLSession(configuration: .default)
  
  init(url: URL) {
    self.webSocketTask = session.webSocketTask(with: url)
    webSocketTask.resume()
  }
  
  deinit {
    webSocketTask.cancel(with: .goingAway, reason: nil)
  }
  
  private func receiveSingleMessage() async throws -> String {
    switch try await webSocketTask.receive() {
    case let .data(messageData):
      return String.init(data: messageData, encoding: .utf8) ?? ""
      
      
    case let .string(text):
      return text
      
    @unknown default:
      webSocketTask.cancel(with: .unsupportedData, reason: nil)
      throw WebSocketConnectionError.decodingError
    }
  }
}

// MARK: Public Interface

extension WebSocketConnection {
  //    func send(_ message: Outgoing) async throws {
  //        guard let messageData = try? encoder.encode(message) else {
  //            throw WebSocketConnectionError.encodingError
  //        }
  //
  //        do {
  //            try await webSocketTask.send(.data(messageData))
  //        } catch {
  //            switch webSocketTask.closeCode {
  //                case .invalid:
  //                    throw WebSocketConnectionError.connectionError
  //
  //                case .goingAway:
  //                    throw WebSocketConnectionError.disconnected
  //
  //                case .normalClosure:
  //                    throw WebSocketConnectionError.closed
  //
  //                default:
  //                    throw WebSocketConnectionError.transportError
  //            }
  //        }
  //    }
  
  func receiveOnce() async throws -> String {
    do {
      return try await receiveSingleMessage()
    } catch let error as WebSocketConnectionError {
      throw error
    } catch {
      switch webSocketTask.closeCode {
      case .invalid:
        throw WebSocketConnectionError.connectionError
        
      case .goingAway:
        throw WebSocketConnectionError.disconnected
        
      case .normalClosure:
        throw WebSocketConnectionError.closed
        
      default:
        throw WebSocketConnectionError.transportError
      }
    }
  }
  
  func receive() -> AsyncThrowingStream<String, Error> {
    AsyncThrowingStream { @MainActor [weak self] in
      guard let self else {
        return nil
      }
      
      let message = try await self.receiveOnce()
      return Task.isCancelled ? nil : message
    }
  }
  
  func close() {
    webSocketTask.cancel(with: .normalClosure, reason: nil)
  }
}

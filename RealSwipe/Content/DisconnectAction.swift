//
//  DisconnectAction.swift
//  RealSwipe
//
//  Created by Utilisateur on 21/05/2025.
//

import SwiftUI
@preconcurrency import Combine

struct DisconnectKey: EnvironmentKey {
    static let defaultValue: DisconnectAction = DisconnectAction(disconnectPublisher: nil)
}

extension EnvironmentValues {
    var disconnectAction: DisconnectAction {
        get { self[DisconnectKey.self] }
        set { self[DisconnectKey.self] = newValue }
    }
}

struct DisconnectAction {
  
  private let disconnectPublisher: PassthroughSubject<Void, Never>?
  
  init(disconnectPublisher: PassthroughSubject<Void, Never>?) {
    self.disconnectPublisher = disconnectPublisher
  }
  
  public func callAsFunction() {
    disconnectPublisher?.send(())
  }
}

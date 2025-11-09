//
//  ContentViewViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 14/06/2025.
//

import Foundation
import Combine

@MainActor
class ContentViewViewModel: ObservableObject {
  
  private var bag = Set<AnyCancellable>()
  @Published var userSession: UserSession?
  
  let disconnectAction: DisconnectAction
  let authentificationSession: AuthentificationService
  
  init(authentificationSession: AuthentificationService = .shared) {
    
    self.authentificationSession = authentificationSession
    
    let disconnectPublisher = PassthroughSubject<Void, Never>()
    disconnectAction = DisconnectAction(disconnectPublisher: disconnectPublisher)
    
    authentificationSession.userSessionDataPublisher.sink {[weak self] in
      self?.userSession = $0.usesrSession
    }.store(in: &bag)
    
    disconnectPublisher.sink {[ weak self] in
      self?.authentificationSession.disconnect()
    }.store(in: &bag)
  }
}


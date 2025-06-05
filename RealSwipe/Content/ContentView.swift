//
//  ContentView.swift
//  RealSwipe
//
//  Created by Utilisateur on 30/01/2023.
//

import SwiftUI
import Combine

struct ContentView: View {
  @StateObject var viewModel = ContentViewViewModel()
  
  var body: some View {
    ZStack {
      if let userSession = viewModel.userSession {
        TabContentView(viewModel: TabContentViewModel(userSession: userSession))
          .environment(\.disconnectAction, viewModel.disconnectAction)
          .id(userSession.id)
      } else {
        LogginFlowScreen(logginFlow: LogginFlow())
      }
    }.preferredColorScheme(.dark)
  }
}

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
    
    authentificationSession.userSessionPublisher.sink {[weak self] in
      self?.userSession = $0
    }.store(in: &bag)
    
    disconnectPublisher.sink {[ weak self] in
      self?.authentificationSession.disconnect()
    }.store(in: &bag)
  }
}

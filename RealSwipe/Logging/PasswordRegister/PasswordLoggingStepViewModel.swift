//
//  PasswordLoggingStepViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/06/2023.
//

import Foundation
import Combine

@MainActor
class PasswordLoggingStepViewModel: PasswordStepScreenViewModel, Navigable {
  
  struct RegisterData {
    let email: String
  }

  private let registerData: RegisterData
  private let authentificationService: AuthentificationService
  
  private let _logginFlowPublish = PassthroughSubject<LogginFlow.Screen, Never>()
  var logginFlowPublish: AnyPublisher<LogginFlow.Screen, Never> { _logginFlowPublish.eraseToAnyPublisher() }
  
  var title: String { "Veuillez Entrer votre mot de passe" }
  var subtitle: String? { nil }
  @Published var isLoading: Bool = false
  
  init(registerData: RegisterData,
       authentificationService: AuthentificationService = .shared) {
    self.registerData = registerData
    self.authentificationService = authentificationService
  }
  
  func onTapButton(_ password: String) {
    guard isLoading == false else { return }
    isLoading = true
    let email = registerData.email
    Task { [weak self] in
      do {
        try await self?.authentificationService.loggin(email: email, password: password)

      } catch {}
      try? await Task.sleep(nanoseconds: 300_000_000)
      self?.isLoading = false
    }
  }
}

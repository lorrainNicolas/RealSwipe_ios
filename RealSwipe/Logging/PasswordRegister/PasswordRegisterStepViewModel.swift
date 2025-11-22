//
//  PasswordRegisterStepViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 27/02/2023.
//

import Foundation
import Combine

@MainActor
class PasswordRegisterStepViewModel: PasswordStepScreenViewModel, Navigable {
  
  private let _logginFlowPublish = PassthroughSubject<LogginFlow.Screen, Never>()
  var logginFlowPublish: AnyPublisher<LogginFlow.Screen, Never> { _logginFlowPublish.eraseToAnyPublisher() }
  
  struct RegisterData {
    let email: String
  }
  
  private let registerData: RegisterData
  
  @Published var errorMessage: String?
  
  var title: String { "Veuillez saisir un mot de passe" }
  var subtitle: String? { "8 caractères minimum." }
  var isLoading: Bool { false }
  
  init(registerData: RegisterData) {
    self.registerData = registerData
  }
  
  func didValid(_ password: String) {
    guard password.isValidPassword() else {
      errorMessage = "Invalid Password"
      return
    }
    _logginFlowPublish.send(.name(.init(registerData: .init(email: registerData.email, password: password))))
  }
}

//
//  GenderStepViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 12/03/2023.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class NameStepViewModel: ObservableObject, Navigable {
  
  private let _logginFlowPublish = PassthroughSubject<LogginFlow.Screen, Never>()
  var logginFlowPublish: AnyPublisher<LogginFlow.Screen, Never> { _logginFlowPublish.eraseToAnyPublisher() }
  
  let title: String = "Quel est ton prénom ?"
  
  struct RegisterData {
    let email: String
    let password: String
  }
  
  private let registerData: RegisterData
  
  init(registerData: RegisterData) {
    self.registerData = registerData
  }
  
  func onTapButton(_ name: String) {
    _logginFlowPublish.send(.gender(.init(registerData: .init(email: registerData.email,
                                                              password: registerData.password,
                                                              name: name))))
  }
}


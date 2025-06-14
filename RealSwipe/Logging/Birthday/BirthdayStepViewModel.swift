//
//  BirthdayStepViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 12/03/2023.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class BirthdayStepViewModel: ObservableObject, Navigable {
  
  private let _logginFlowPublish = PassthroughSubject<LogginFlow.Screen, Never>()
  var logginFlowPublish: AnyPublisher<LogginFlow.Screen, Never> { _logginFlowPublish.eraseToAnyPublisher() }
  
  let title: String = "Quel est ton âge ?"
  
  struct RegisterData {
    let email: String
    let password: String
    let name: String
  }
  
  private let registerData: RegisterData
  
  init(registerData: RegisterData) {
    self.registerData = registerData
  }
  
  func onTapButton(_ date: Date) {
    _logginFlowPublish.send(.gender(.init(registerData: .init(email: registerData.email,
                                                              password: registerData.password,
                                                              name: registerData.name,
                                                              date: date.timeIntervalSince1970))))
  }
}


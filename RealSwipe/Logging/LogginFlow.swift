//
//  LogginFlow.swift
//  RealSwipe
//
//  Created by Utilisateur on 27/02/2023.
//

import Foundation
import Combine
 
@MainActor
class LogginFlow: ObservableObject {
  
  
  enum Screen: Hashable, LogginProgressionProtcol {
    case passwordLogging(PasswordLoggingStepViewModel)
    
    case passwordRegister(PasswordRegisterStepViewModel)
    case name(NameStepViewModel)
    case gender(GenderStepViewModel)
    case birthday(BirthdayStepViewModel)
    
    var percent: CGFloat? {
      switch self {
      case .passwordLogging: return nil
      case .passwordRegister: return 0.25
      case .name: return 0.5
      case .birthday: return 0.75
      case .gender: return 1
      }
    }
  }

  @Published var isLoading = false
  @Published var navigationPath: [Screen] = []
  private let authentificationService: AuthentificationService

  init(authentificationService: AuthentificationService = AuthentificationService.shared) {
    self.authentificationService = authentificationService
  }
}

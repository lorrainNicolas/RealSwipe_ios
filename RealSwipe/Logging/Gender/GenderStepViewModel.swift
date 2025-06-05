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
class GenderStepViewModel: ObservableObject, Navigable {
  
  struct RegisterData {
    let email: String
    let password: String
    let name: String
  }
  
  private let registerData: RegisterData
  private let apiClient: APIClientProtocol
  private let authentificationService: AuthentificationService
  
  @Published var isLoading: Bool = false
  @Published var showFailureAlert: Bool = false
  
  init(registerData: RegisterData,
       apiClient: APIClientProtocol = APIClient(),
       authentificationService: AuthentificationService = .shared) {
    self.registerData = registerData
    self.apiClient = apiClient
    self.authentificationService = authentificationService
  }
  
  func didSelectMan() {
    didSelect(.woman)
  }
  
  func didSelectWoman() {
    didSelect(.woman)
  }
}

private extension GenderStepViewModel {
  
  func didSelect(_ sexe: Sexe) {
    guard !isLoading else { return }
    isLoading = true
    
    Task { [weak self, registerData] in
      do {
       
        try await self?.authentificationService.register(firstName: registerData.name,
                                                         genderId: sexe.rawValue,
                                                         email: registerData.email,
                                                         password: registerData.password)
        try? await Task.sleep(nanoseconds: 300_000_000)
        self?.isLoading = false
      } catch {
        self?.showFailureAlert = true
        self?.isLoading = false
      }
    }
  }
}

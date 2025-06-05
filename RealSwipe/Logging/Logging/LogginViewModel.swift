//
//  LogginViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 27/02/2023.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class LogginViewModel: LogginViewModelProtocol {
  
  private let _logginFlowPublish = PassthroughSubject<LogginFlow.Screen, Never>()
  var logginFlowPublish: AnyPublisher<LogginFlow.Screen, Never> { _logginFlowPublish.eraseToAnyPublisher() }
  
  @Published var errorMessage: String?
  @Published var isLoading: Bool = false
  @Published var showFailureAlert: Bool = false
  
  private let apiClient: APIClientProtocol
  
  init(apiClient: APIClientProtocol = APIClient()) {
    self.apiClient = apiClient
  }
 
  
  func canDismisskeyboard(_ email: String) -> Bool {
    email.isValidEmail()
  }
  
  func didValid(_ email: String) {
    guard email.isValidEmail() else {
      errorMessage = "Invalid Email"
      return
    }
    
    isLoading = true
    errorMessage = nil
    
    Task { [weak self] in
      do {
        
        let didExist = try await self?.apiClient.sendRequest(to: UserExistsEndpoint(data: .init(email: email))).didExist ?? false
        try? await Task.sleep(nanoseconds: 300_000_000)
        if didExist {
          self?._logginFlowPublish.send(.passwordLogging(PasswordLoggingStepViewModel(registerData: .init(email: email))))
          self?.isLoading = false
        } else {
          self?._logginFlowPublish.send(.passwordRegister(PasswordRegisterStepViewModel(registerData: .init(email: email))))
          self?.isLoading = false
        }
      } catch {
        self?.isLoading = false
        self?.showFailureAlert = true
      }
    }
  }
}

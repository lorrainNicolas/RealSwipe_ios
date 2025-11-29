//
//  SyncAccountService.swift
//  RealSwipe
//
//  Created by Utilisateur on 29/11/2025.
//

import Foundation

@MainActor
class SyncAccountService: Sendable {
  
  struct UserSession {
    let userId: UUID
    let token: String
  }
  
  private var pendingTasks: [SyncAccountServiceTaskKey: Task<Void, Never>] = [:]

  private var userSession: UserSession?
  static let shared = SyncAccountService()
  
  static func launch() {
    _ = shared
  }
  
  func stop() {
    self.pendingTasks.values.forEach { $0.cancel() }
    self.pendingTasks = [:]
    
  }
  func updateUserSession(_ userSession: UserSession?) {
    self.userSession = userSession
    if let userSession {
      addSyncAccountTask(token: userSession.token)
      print(userSession.token)
    }
  }

  @discardableResult
  func addSyncAccountTask(token: String) -> Task<Void, Never>  {
    addTask(provider: FetchAccountTask(token: token))
  }
  func addTask<T: SyncAccountServiceProviderTask>(provider: T,
                                                  @_implicitSelfCapture onFinished: ((Result<T.Value, Error>) -> ())? = nil ) -> Task<Void, Never> {
    
    if let task = pendingTasks[provider.key] {
      return task
    } else {
      let task = Task {
        defer { pendingTasks.removeValue(forKey: provider.key) }
        do {
          let value = try await provider.perform()
          onFinished?(.success(value))
        } catch {
          onFinished?(.failure(error))
        }
      }
      
      pendingTasks[provider.key] = task
      return task
    }
  }}


protocol SyncAccountServiceProviderTask {
  var key: SyncAccountServiceTaskKey { get }
  associatedtype Value: Sendable
  func perform() async throws -> Value
}

enum SyncAccountServiceTaskKey: Hashable, Sendable {
  case fetchAccountTask(token: String)
}

struct FetchAccountTask: SyncAccountServiceProviderTask {
  
  let token: String
  let api: APIClient = .init()
  
  var key: SyncAccountServiceTaskKey { .fetchAccountTask(token: token) }
  
  func perform() async throws {
    try Task.checkCancellation()
    print("tototot \(token)")
    let outpur =  try await api.sendRequest(to: GetMeEndpoint(token: token))
   
  }
}

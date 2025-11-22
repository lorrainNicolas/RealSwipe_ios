//
//  RealSwipeApp.swift
//  RealSwipe
//
//  Created by Utilisateur on 30/01/2023.
//

import SwiftUI
import Foundation
import CoreData

@main
struct RealSwipeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
   
    SyncMessageLauncher().launch()
    return true
  }
}

@MainActor
class SyncMessageLauncher {
  func launch() {
    
    SyncMessageService.launch()
    
    Task {
      for try await userSessionData in AuthentificationService.shared.userSessionDataPublisher
        .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
        .values {
        
        await SyncMessageService.shared.updateUserSession(userSessionData.usesrSession.map { .init(userId: $0.user.userId, token: $0.token)},
                                                          hasToBeenClean: !userSessionData.didlaunched)
      }
    }
  }
}

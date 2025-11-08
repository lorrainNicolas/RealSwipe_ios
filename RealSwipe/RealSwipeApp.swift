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
    SyncMessageService.launch()
    return true
  }
}

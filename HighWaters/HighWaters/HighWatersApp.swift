//
//  HighWatersApp.swift
//  HighWaters
//
//  Created by Bianca Maciel on 22/07/25.
//

import SwiftUI
import FirebaseCore

@main
struct HighWatersApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MapView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        if FirebaseApp.app() == nil {
            print("🚨 Firebase was not configured")
        } else {
            print("✅ Firebase was configured successfully")
            if let options = FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!) {
                print("📋 ProjectID: \(options.projectID ?? "N/A")")
            }
        }
        
        return true
    }
}

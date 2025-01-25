//
//  ModernWeatherAppApp.swift
//  ModernWeatherApp
//
//  Created by Trevor Bedson on 1/24/25.
//

import SwiftUI
import SwiftData

@main
struct ModernWeatherAppApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

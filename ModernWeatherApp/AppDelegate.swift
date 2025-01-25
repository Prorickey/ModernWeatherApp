//
//  AppDelegate.swift
//  ModernWeatherApp
//
//  Created by Trevor Bedson on 1/24/25.
//

import Foundation
import UIKit
import os

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let locationsHandler = LocationsHandler.shared
        
        // If location updates were previously active, restart them after the background launch.
        if locationsHandler.updatesStarted {
            locationsHandler.startLocationUpdates()
        }
        
        return true
    }
}

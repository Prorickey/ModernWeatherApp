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
    
    let logger = Logger(subsystem: "xyz.prorickey.ModernWeatherApp", category: "AppDelegate")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let locationsHandler = LocationsHandler.shared
        let weatherHandler = WeatherModel.shared
        
        // If location updates were previously active, restart them after the background launch.
        if locationsHandler.updatesStarted {
            self.logger.info("Restart liveUpdates Session")
            locationsHandler.startLocationUpdates()
        }
        
        weatherHandler.startWeatherUpdates()
        
        return true
    }
}

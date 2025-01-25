//
//  Weather.swift
//  ModernWeatherApp
//
//  Created by Trevor Bedson on 1/24/25.
//

import os
import Foundation
import OpenMeteoSdk
import SwiftUI

struct WeatherData {
    let hourly: Hourly

    struct Hourly {
        let time: [Date]
        let temperature2m: [Float]
    }
}

class WeatherModel: ObservableObject {
    static let shared: WeatherModel = WeatherModel()
    
    @Published var data: WeatherData = WeatherData(hourly: .init(time: [.init()], temperature2m: [0]))
    
    let logger = Logger(subsystem: "com.apple.liveUpdatesSample", category: "DemoView")
    @ObservedObject var locationsHandler = LocationsHandler.shared
    
    init() {
        Task(priority: .high, operation: requestWeather)
    }
    
    func startWeatherUpdates() {
        Task(priority: .high, operation: requestWeather)
    }
    
    final private func requestWeather() async {
        let lat = self.locationsHandler.lastLocation.coordinate.latitude
        let long = self.locationsHandler.lastLocation.coordinate.longitude
        
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(long)&hourly=temperature_2m&format=flatbuffers")!
        
        let responses = try! await WeatherApiResponse.fetch(url: url)
        
        let resp = responses[0]
        let hourly = resp.hourly!
        
        data = WeatherData(hourly: .init(time: hourly.getDateTime(), temperature2m: hourly.variables(at: 0)!.values))
    }
}

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
    let hourly: [Hourly]

    public struct Hourly {
        let time: Int
        let temperature2m: Float
        let cloudCoverage: Float
        let precipitation: Float
    }
}

class WeatherModel: ObservableObject {
    static let shared: WeatherModel = WeatherModel()
    
    @Published var data: WeatherData = WeatherData(hourly: [])
    
    @ObservedObject var locationsHandler = LocationsHandler.shared
    
    var timer: Timer?
    
    init() {
        Task(priority: .high, operation: requestWeather)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            Task(priority: .high, operation: self.requestWeather)
        })
    }
    
    final private func requestWeather() async {
        let lat = self.locationsHandler.lastLocation.coordinate.latitude
        let long = self.locationsHandler.lastLocation.coordinate.longitude
        
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(long)&hourly=temperature_2m,cloud_cover,precipitation&format=flatbuffers")!
        
        let responses = try! await WeatherApiResponse.fetch(url: url)
        
        let resp = responses[0]
        let hourly = resp.hourly!
        
        var weatherHourlyData: [WeatherData.Hourly] = []
        
        for i in 0...24 {
            weatherHourlyData.append(.init(
                time: i,
                temperature2m: hourly.variables(at: 0)!.values[i],
                cloudCoverage: hourly.variables(at: 1)!.values[i],
                precipitation: hourly.variables(at: 2)!.values[i]
            ))
        }
        
        data = WeatherData(hourly: weatherHourlyData)
    }
}

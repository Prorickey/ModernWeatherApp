//
//  LocationHandler.swift
//  ModernWeatherApp
//
//  Created by Trevor Bedson on 1/24/25.
//

import Foundation
import CoreLocation

@MainActor class LocationsHandler: ObservableObject {
    static let shared = LocationsHandler()

    private let manager: CLLocationManager

    @Published var lastUpdate: CLLocationUpdate? = nil
    @Published var lastLocation = CLLocation(latitude: 35.729733, longitude: -81.687194)
    @Published var count = 0
    @Published var isStationary = false
    
    @Published var city = "Morganton"

    @Published
    var updatesStarted: Bool = true
    
    @Published
    var backgroundUpdates: Bool = true
    
    private init() {
        self.manager = CLLocationManager()  // Creating a location manager instance is safe to call here in `MainActor`.
    }
    
    func startLocationUpdates() {
        if manager.authorizationStatus != .authorizedWhenInUse {
            self.manager.requestWhenInUseAuthorization()
        }
        /*Task {
            do {
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    if !self.updatesStarted { break }  // End location updates by breaking out of the loop.
                    self.lastUpdate = update
                    if let loc = update.location {
                        self.lastLocation = loc
                        self.isStationary = update.stationary
                        self.count += 1
                        
                        loc.placemark { placemark, error in
                            guard let placemark = placemark, let city = placemark.locality else { return }
                            self.city = city
                        }
                    }
                }
            } catch {
                print("Could not start location updates")
            }
        }*/
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}

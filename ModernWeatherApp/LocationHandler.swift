//
//  LocationHandler.swift
//  ModernWeatherApp
//
//  Created by Trevor Bedson on 1/24/25.
//

import Foundation
import CoreLocation

@MainActor class LocationsHandler: ObservableObject {
    static let shared = LocationsHandler()  // Create a single, shared instance of the object.

    private let manager: CLLocationManager

    @Published var lastUpdate: CLLocationUpdate? = nil
    @Published var lastLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    @Published var count = 0
    @Published var isStationary = false
    
    @Published var city = "GoonTown"

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
        print("Starting location updates")
        Task {
            do {
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    if !self.updatesStarted { break }  // End location updates by breaking out of the loop.
                    self.lastUpdate = update
                    if let loc = update.location {
                        print("Update location")
                        print(loc)
                        self.lastLocation = loc
                        print(self.lastLocation)
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
            return
        }
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}

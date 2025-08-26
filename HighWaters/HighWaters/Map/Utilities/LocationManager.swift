//
//  LocationManager.swift
//  HighWaters
//
//  Created by Bianca Maciel on 25/08/25.
//

import CoreLocation


class LocationManager: NSObject, ObservableObject {
    
    private let manager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        manager.startUpdatingLocation()
    }
    
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
}

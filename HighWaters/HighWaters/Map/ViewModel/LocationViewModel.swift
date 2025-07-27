//
//  LocationViewModel.swift
//  HighWaters
//
//  Created by Bianca Maciel on 22/07/25.
//

import MapKit
import SwiftUI
import Foundation
import CoreLocation


final class LocationViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    private var mapView: MKMapView?
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.requestWhenInUseAuthorization()
        
        return manager
    }()
    
    // MARK: - Published Properties
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var annotations: [MKPointAnnotation] = []
    
    // MARK: - Initializor
    override init() {
        super.init()
        setupLocationManager()
        setupMapView()
    }
    
    // MARK: - Setup
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func setupMapView() {
        self.mapView?.showsUserLocation = true
        self.mapView?.delegate = self
    }
    
    // MARK: - Actions
    func addFlood() throws {
        
        guard let location = self.locationManager.location else { return }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        
        annotations.append(annotation)
        
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
        
    }
    
}

// MARK: - MKMapViewDelegate
extension LocationViewModel: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if let mapView = self.mapView  {
            let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
            self.mapView?.setRegion(region, animated: true)
        }
        
        
    }
    
}


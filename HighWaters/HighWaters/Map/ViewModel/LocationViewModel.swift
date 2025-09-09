//
//  LocationViewModel.swift
//  HighWaters
//
//  Created by Bianca Maciel on 25/08/25.
//

import MapKit
import SwiftUI

class LocationViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @Published var annotations: [MKPointAnnotation] = []
    private let locationManager = LocationManager()
    private let repository: FloodRepository
    
    
    // MARK: - Init
    init(repository: FloodRepository) {
        locationManager.startUpdating()
        self.repository = repository
    }
    
    
    // MARK: - Location Functions
    func centerToUser() {
        guard let userLocation = locationManager.currentLocation else { return }
        
        withAnimation {
            region.center = userLocation
            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        }
    }
    
    
    func addAnnotation(at coordinate: CLLocationCoordinate2D, title: String) {
        if !isEqual(coordinate: coordinate) { /// Avoiding duplicity
            let annotation = MKPointAnnotation()
            annotation.title = title
            annotation.coordinate = coordinate
            annotations.append(annotation)
        }
    }
    
    func removeAnnotation(at coordinate: CLLocationCoordinate2D) {
        annotations.removeAll {
            $0.coordinate.latitude == coordinate.latitude &&
            $0.coordinate.longitude == coordinate.longitude
        }
    }
    
    private func isEqual(coordinate: CLLocationCoordinate2D) -> Bool {
        return (annotations.contains {
            $0.coordinate.latitude == coordinate.latitude &&
            $0.coordinate.longitude == coordinate.longitude
        })
    }
    
    // MARK: - Firestore Functions
    func saveFlood() {
        guard let location = locationManager.currentLocation else { return }
        let floodReport = FloodReport(latitude: location.latitude, longitude: location.longitude)
        
        repository.saveNewFlood(floodReport)
    }

}





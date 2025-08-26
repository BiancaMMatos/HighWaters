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
    
    
    // MARK: - Init
    init() {
        locationManager.startUpdating()
    }
    
    
    // MARK: - Functions
    func centerToUser() {
        guard let userLocation = locationManager.currentLocation else { return }
        
        withAnimation {
            region.center = userLocation
            region.span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
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
    
}





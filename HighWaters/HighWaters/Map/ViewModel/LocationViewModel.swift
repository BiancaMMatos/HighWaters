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
     
    @Published var isLoading: Bool = true
    @Published var showError: Bool = false
    @Published var annotations: [MKPointAnnotation] = []
    private let locationManager = LocationManager()
    private let service: FloodServiceProtocol = FloodService()
    
    
    // MARK: - Init
    init() {
        locationManager.startUpdating()
        observeFloods()
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
        service.saveFlood(floodReport)
    }
    
    func observeFloods() {
        isLoading = true
        service.observeFloods { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let floods):
                    self?.annotations.removeAll()
                    floods?.forEach {
                        self?.addAnnotation(at: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude),
                                            title: "Flood")
                    }
                    self?.showError = false
                    
                case .failure(let error):
                    print("🚨 Firebase Error: \(error.localizedDescription)")
                    self?.annotations.removeAll()
                    self?.showError = true
                }
            }
        }
        
    }
    
    
    // MARK: - Deinit
    deinit {
        service.removeFloodListener()
    }
    
}





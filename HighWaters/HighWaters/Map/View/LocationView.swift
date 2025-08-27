//
//  LocationView.swift
//  HighWaters
//
//  Created by Bianca Maciel on 25/08/25.
//

import MapKit
import SwiftUI

struct LocationView: UIViewRepresentable {
    
    // MARK: - Properties
    @Binding var region: MKCoordinateRegion
    var annotations: [MKAnnotation] = []
    
    
    // MARK: - Functions
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let locationView = MKMapView()
        locationView.delegate = context.coordinator
        locationView.showsUserLocation = true /// Shows user location
        
        return locationView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        /// Updating region from map
        uiView.setRegion(region, animated: true)
        
        /// Update annotations
        uiView.removeAnnotations(uiView.annotations) /// Remove all annotations
        uiView.addAnnotations(annotations) /// Add new annotations
    }
    
    class Coordinator: NSObject, MKMapViewDelegate { /// Made to conform with MapKit
        var parent: LocationView
        init(_ parent: LocationView) {
            self.parent = parent
        }
    }
}


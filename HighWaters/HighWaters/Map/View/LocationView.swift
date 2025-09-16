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
    var annotations: [MKAnnotation] = []
    @Binding var region: MKCoordinateRegion
    @StateObject private var viewModel = LocationViewModel()
    
    // MARK: - Functions
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true /// Shows user location
        
        return mapView
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
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { /// It's going to provide a particular view for a particular annotation
            
            if annotation is MKUserLocation { /// Nothing will happen to the current location of the user
                return nil
            }
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "FloodAnnotationView")
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "FloodAnnotationView")
                annotationView?.canShowCallout = true
                annotationView?.image = UIImage(named: "flood-annotation")
                
                /// Configuring delete button
                let deleteButton = UIButton.buttonForRightAccessoryView()
                deleteButton.tag = 1001 /// Unique identifier to the button
                annotationView?.rightCalloutAccessoryView = deleteButton
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
            
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard control.tag == 1001 else { return } /// Verify if it is the 'trash' button
            guard let floodAnnotation = view.annotation as? FloodAnnotation else { return }
            
            parent.viewModel.deleteFlood(floodAnnotation.flood)
            
        }
        
    }
}


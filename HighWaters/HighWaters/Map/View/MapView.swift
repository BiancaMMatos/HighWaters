//
//  MapView.swift
//  HighWaters
//
//  Created by Bianca Maciel on 22/07/25.
//

import MapKit
import SwiftUI
import CoreLocation

struct MapView: View {
    
    @StateObject private var locationViewModel = LocationViewModel()
    
    var body: some View {
        ZStack {
            GeometryReader { reader in
                Map(position: $locationViewModel.cameraPosition, interactionModes: .all) {
                    UserAnnotation()
                    
                    ForEach(locationViewModel.annotations, id: \.self) {
                        Marker("Flooded", coordinate: $0.coordinate)
                    }
                    
                }
                .mapControls {
                    MapUserLocationButton()
                }
                
                
                Button {
                    addFlood()
                    
                } label: {
                    Text("Add flood")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .controlSize(.large)
                .frame(width: 150)
                .padding(.horizontal, (reader.size.width * 0.33))
                .padding(.vertical, (reader.size.height * 0.85))
                
            }
            
            
        }
    }
}

extension MapView {
    
    private func addFlood() {
        do {
            try locationViewModel.addFlood()
        } catch {
            print("Erro ao adicionar inundação")
        }
    }
    
}

#Preview {
    MapView()
}

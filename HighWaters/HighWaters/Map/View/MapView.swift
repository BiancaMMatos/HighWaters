//
//  MapView.swift
//  HighWaters
//
//  Created by Bianca Maciel on 25/08/25.
//

import SwiftUI

struct MapView: View {
    
    @State private var floodCount: Int = 0
    @StateObject private var viewModel = LocationViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LocationView(region: $viewModel.region,
                         annotations: viewModel.annotations
            )
            .ignoresSafeArea(.all)
            
            HStack(alignment: .center) {
                Button(action: {
                    addFloodAnnotation()
                }, label: {
                    Text("Add Flood")
                        .bold()
                        .padding()
                        .background(Color.purple)
                        .foregroundStyle(.white)
                        .clipShape(.buttonBorder)
                })
                .padding(.horizontal, 50)
                .padding(.vertical, 15)
                
                Button(action: {
                    viewModel.centerToUser()
                }, label: {
                    Image(systemName: "location.fill")
                        .padding()
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 3)
                })
                .padding()
            }
            
            
        }
    }
}


extension MapView {
    
    private func addFloodAnnotation() {
        /// Getting where the user is
        let centerOfCoordinate = viewModel.region.center
        
        /// Adding a new annotation
        viewModel.addAnnotation(at: centerOfCoordinate,
                                title: "Flood #\(floodCount + 1)"
        )
        
        floodCount += 1
    }
    
}


#Preview {
    MapView()
}

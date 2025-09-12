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
            if viewModel.isLoading {
                LoadingView()
                    .ignoresSafeArea(.all)
            } else {
                LocationView(region: $viewModel.region,
                             annotations: viewModel.annotations
                )
                .ignoresSafeArea(.all)
            }
            
            HStack(alignment: .center) {
                Button(action: {
                    addFloodAnnotation()
                }, label: {
                    Text("Add Flood")
                        .bold()
                        .padding()
                        .background(Color.defaultBlue)
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
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error fetch floods"),
                message: Text("The flood data could not be loaded. The map will be displayed without markers"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


extension MapView {
    
    private func addFloodAnnotation() {
        
        /// Adding a new annotation
        viewModel.saveFlood()
        
        floodCount += 1
    }
    
}


#Preview {
    MapView()
}

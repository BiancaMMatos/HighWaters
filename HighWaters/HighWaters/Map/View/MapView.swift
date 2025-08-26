//
//  MapView.swift
//  HighWaters
//
//  Created by Bianca Maciel on 25/08/25.
//

import SwiftUI

struct MapView: View {
    
    @StateObject private var viewModel = LocationViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LocationView(region: $viewModel.region,
                         annotations: viewModel.annotations
            )
            .ignoresSafeArea(.all)
            
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

#Preview {
    MapView()
}

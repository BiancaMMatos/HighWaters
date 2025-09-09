//
//  LoadingView.swift
//  HighWaters
//
//  Created by Bianca Maciel on 09/09/25.
//

import SwiftUI

struct LoadingView: View {
    var imageName: String = "loading_icon"
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .shadow(radius: 8)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
        }
    }
}


#Preview {
    LoadingView()
}

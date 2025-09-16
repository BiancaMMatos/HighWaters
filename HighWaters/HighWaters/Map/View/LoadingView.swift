//
//  LoadingView.swift
//  HighWaters
//
//  Created by Bianca Maciel on 09/09/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var progress: CGFloat = 0.0
    @State private var isRotating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.defaultBlue, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .onAppear {
            startLoading()
        }
    }
    
    private func startLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            withAnimation(.linear(duration: 0.05)) {
                if progress < 1.0 {
                    progress += 0.01
                } else {
                    timer.invalidate()
                }
            }
        }
    }
}


#Preview {
    LoadingView()
}

//
//  HomeView.swift
//  FaceFit AR
//
//  Created by Anish Hazra on 06/03/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                
                Spacer()
                
                Text("Welcome to FaceFit AR!")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary.opacity(0.8))
                
                NavigationLink(destination: CameraView()) {
                    ZStack {
                        
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.orange,
                                        Color.red.opacity(0.8)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 260, height: 260)
                            .shadow(color: .orange.opacity(0.4), radius: 20, x: 0, y: 10)
                        
                        VStack(spacing: 10) {
                            
                            Image(systemName: "faceid")
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                            
                            Text("FaceFit AR")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                }
                
                Text("Tap to Start Scanning")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(.systemGray6)
            )
        }
    }
}

#Preview {
    HomeView()
}

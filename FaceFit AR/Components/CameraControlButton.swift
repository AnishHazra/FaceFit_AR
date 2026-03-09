//
//  CaptureButton.swift
//  FaceFit AR
//
//  Created by Anish Hazra on 09/03/26.
//

import SwiftUI

// MARK: Camera Control Button
struct CameraControlButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 55, height: 55)
                .background(Color.black.opacity(0.35))
                .clipShape(Circle())
        }
    }
}

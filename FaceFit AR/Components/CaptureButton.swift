//
//  CaptureButton.swift
//  FaceFit AR
//
//  Created by Anish Hazra on 09/03/26.
//

import SwiftUI

// MARK: Capture Button
struct CaptureButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .stroke(Color.white, lineWidth: 3)
                    .frame(width: 74, height: 74)
                Circle()
                    .fill(Color.white)
                    .frame(width: 62, height: 62)
            }
        }
    }
}

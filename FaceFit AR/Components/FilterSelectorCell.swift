//
//  InputField.swift
//  FaceFit AR
//
//  Created by Anish Hazra on 09/03/26.
//

import SwiftUI

// MARK: Filter Selector Cell
struct FilterSelectorCell: View {
    let filter: FilterType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color(red: 0.95, green: 0.38, blue: 0.17) : Color.white.opacity(0.25))
                        .frame(width: 58, height: 70)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: isSelected ? 2.5 : 0)
                        )

                    if filter == .none {
                        Image(systemName: "circle.slash")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                    } else {
                        Text(filter.overlayEmoji.prefix(2).map { String($0) }.joined())
                            .font(.system(size: 26))
                    }
                }

                Text(filter.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
        }
        .scaleEffect(isSelected ? 1.0 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

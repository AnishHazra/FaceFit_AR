//
//  InputField.swift
//  FaceFit AR
//
//  Created by Anish Hazra on 09/03/26.
//

import SwiftUI

// MARK: Input Field
struct InputField: View {
    let placeholder: String
    let icon: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .sentences

    let brandOrange = Color(red: 0.95, green: 0.38, blue: 0.17)

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(brandOrange)
                .frame(width: 20)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(autocapitalization)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }
}

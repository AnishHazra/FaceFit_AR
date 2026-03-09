//
//  PasswordField.swift
//  FaceFit AR
//
//  Created by Anish Hazra on 09/03/26.
//

import SwiftUI

// MARK: Password Field
struct PasswordField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var show: Bool

    let brandOrange = Color(red: 0.95, green: 0.38, blue: 0.17)

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundColor(brandOrange)
                .frame(width: 20)
            Group {
                if show {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            Button {
                show.toggle()
            } label: {
                Image(systemName: show ?  "eye.fill" : "eye.slash.fill")
                    .foregroundColor(.secondary)
                    .font(.system(size: 15))
            }
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

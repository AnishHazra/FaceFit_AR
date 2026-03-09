import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false

    // Brand color
    let brandOrange = Color(red: 0.95, green: 0.38, blue: 0.17)

    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: - Logo Area
                    VStack(spacing: 12) {
                        Spacer().frame(height: 60)

                        ZStack {
                            Circle()
                                .fill(brandOrange.opacity(0.12))
                                .frame(width: 100, height: 100)
                            Image(systemName: "face.smiling.inverse")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 52, height: 52)
                                .foregroundColor(brandOrange)
                        }

                        Text("FaceFit AR")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)

                        Text(authViewModel.isSignUpMode ? "Create your account" : "Sign in to continue")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 40)

                    // MARK: - Form
                    VStack(spacing: 16) {

                        // Name field (sign up only)
                        if authViewModel.isSignUpMode {
                            InputField(
                                placeholder: "Full Name",
                                icon: "person.fill",
                                text: $authViewModel.name
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        // Email
                        InputField(
                            placeholder: "Email Address",
                            icon: "envelope.fill",
                            text: $authViewModel.email,
                            keyboardType: .emailAddress,
                            autocapitalization: .never
                        )

                        // Password
                        PasswordField(
                            placeholder: "Password",
                            text: $authViewModel.password,
                            show: $showPassword
                        )

                        // Confirm Password (sign up only)
                        if authViewModel.isSignUpMode {
                            PasswordField(
                                placeholder: "Confirm Password",
                                text: $authViewModel.confirmPassword,
                                show: $showConfirmPassword
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 28)
                    .animation(.spring(response: 0.35), value: authViewModel.isSignUpMode)

                    // MARK: - Error Message
                    if authViewModel.showError {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(authViewModel.errorMessage)
                                .font(.caption)
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, 28)
                        .padding(.top, 12)
                        .transition(.opacity)
                    }

                    // MARK: - Test Hint
                    if !authViewModel.isSignUpMode {
                        VStack(spacing: 2) {
                            Text("Test account:")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("test@facefit.com  •  Test@1234")
                                .font(.caption2)
                                .foregroundColor(brandOrange)
                                .fontWeight(.medium)
                        }
                        .padding(.top, 10)
                    }

                    // MARK: - Buttons
                    VStack(spacing: 14) {

                        // Primary action button
                        Button {
                            if authViewModel.isSignUpMode {
                                authViewModel.signUp()
                            } else {
                                authViewModel.login()
                            }
                        } label: {
                            ZStack {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text(authViewModel.isSignUpMode ? "Create Account" : "Login")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 17))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(brandOrange)
                            .cornerRadius(14)
                        }
                        .disabled(authViewModel.isLoading)

                        // Toggle mode button
                        Button {
                            withAnimation { authViewModel.toggleMode() }
                        } label: {
                            Text(authViewModel.isSignUpMode ? "Already have an account? Login" : "Sign Up")
                                .fontWeight(.semibold)
                                .font(.system(size: 17))
                                .foregroundColor(brandOrange)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(brandOrange, lineWidth: 1.5)
                                )
                        }

                        // Forgot password
                        if !authViewModel.isSignUpMode {
                            Button {
                                authViewModel.resetPassword()
                            } label: {
                                Text("Forgot Password?")
                                    .font(.subheadline)
                                    .foregroundColor(brandOrange)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 28)

                    Spacer().frame(height: 40)
                }
            }
        }
    }
}

// MARK: - Reusable Input Field
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

// MARK: - Password Field
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
                Image(systemName: show ? "eye.slash.fill" : "eye.fill")
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

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}

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

                    // MARK: Logo Area
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

                    // MARK: Form
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

                    // MARK: Error Message
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

                    // MARK: Buttons
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

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}

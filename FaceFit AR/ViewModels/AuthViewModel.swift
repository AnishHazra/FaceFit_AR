import Foundation
import Combine
import FirebaseAuth

class AuthViewModel: ObservableObject {

    // MARK: Published Properties
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User? = nil
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var name: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var isSignUpMode: Bool = false

    // MARK: Computed
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    var isPasswordValid: Bool {
        password.count >= 6
    }

    // MARK: Init
    init() {
        // Check if user is already logged in
        if let user = Auth.auth().currentUser {
            // Fetch name from displayName or use a default, as you only have email in the basic setup
            self.setLoggedIn(email: user.email ?? "", name: user.displayName ?? "User")
        }
    }

    // MARK: Login
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            showErrorMessage("Please enter email and password.")
            return
        }
        guard isEmailValid else {
            showErrorMessage("Please enter a valid email address.")
            return
        }

        isLoading = true

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            self.isLoading = false

            if let error = error {
                self.showErrorMessage(error.localizedDescription)
                return
            }

            if let user = authResult?.user {
                self.setLoggedIn(email: user.email ?? "", name: user.displayName ?? "User")
            }
        }
    }

    // MARK: Sign Up
    func signUp() {
        guard !name.isEmpty else {
            showErrorMessage("Please enter your full name.")
            return
        }
        guard isEmailValid else {
            showErrorMessage("Please enter a valid email address.")
            return
        }
        guard isPasswordValid else {
            showErrorMessage("Password must be at least 6 characters.")
            return
        }
        guard password == confirmPassword else {
            showErrorMessage("Passwords do not match.")
            return
        }

        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.isLoading = false
                self.showErrorMessage(error.localizedDescription)
                return
            }

            // Update display name
            let changeRequest = authResult?.user.createProfileChangeRequest()
            changeRequest?.displayName = self.name
            changeRequest?.commitChanges { error in
                self.isLoading = false
                if let error = error {
                    self.showErrorMessage(error.localizedDescription)
                } else if let user = Auth.auth().currentUser {
                    self.setLoggedIn(email: user.email ?? "", name: self.name)
                }
            }
        }
    }

    // MARK: Logout
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            currentUser = nil
            email = ""
            password = ""
            confirmPassword = ""
            name = ""
            errorMessage = ""
            isSignUpMode = false
        } catch let signOutError as NSError {
            showErrorMessage(signOutError.localizedDescription)
        }
    }

    // MARK: Reset Password
    func resetPassword() {
        guard isEmailValid else {
            showErrorMessage("Please enter a valid email.")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.showErrorMessage(error.localizedDescription)
            } else {
                self?.showErrorMessage("Password reset link sent to \(self?.email ?? "")")
            }
        }
    }

    // MARK: Helpers
    private func setLoggedIn(email: String, name: String) {
        currentUser = User(name: name, email: email)
        isLoggedIn = true
        self.email = ""
        self.password = ""
    }

    func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.showError = false
        }
    }

    func toggleMode() {
        isSignUpMode.toggle()
        errorMessage = ""
        showError = false
        email = ""
        password = ""
        confirmPassword = ""
        name = ""
    }
}

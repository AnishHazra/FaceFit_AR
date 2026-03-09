import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                MainTabView()
            } else {
                AuthView()
            }
        }
        .animation(.easeInOut, value: authViewModel.isLoggedIn)
    }
}

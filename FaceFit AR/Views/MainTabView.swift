import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var cameraVM = CameraViewModel()
    @State private var selectedTab: Int = 0

    private let brandOrange = Color(red: 0.95, green: 0.38, blue: 0.17)

    var body: some View {
        TabView(selection: $selectedTab) {

            // Home Tab
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)

            // Profile Tab
            ProfileView()
                .environmentObject(cameraVM)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "person.fill" : "person")
                    Text("Settings")
                }
                .tag(1)
        }
        .accentColor(brandOrange)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}

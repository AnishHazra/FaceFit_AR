import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var cameraVM = CameraViewModel()
    @State private var selectedTab: Int = 0

    private let brandOrange = Color(red: 0.95, green: 0.38, blue: 0.17)

    var body: some View {
        TabView(selection: $selectedTab) {

            // Camera Tab
            CameraView()
                .environmentObject(cameraVM)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "camera.fill" : "camera")
                    Text("Camera")
                }
                .tag(0)

            // Gallery Tab
            GalleryView()
                .environmentObject(cameraVM)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "square.grid.2x2.fill" : "square.grid.2x2")
                    Text("Gallery")
                }
                .tag(1)

            // Profile Tab
            ProfileView()
                .environmentObject(cameraVM)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(brandOrange)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}

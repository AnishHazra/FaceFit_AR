import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var cameraVM: CameraViewModel
    
    @State private var showLogoutAlert: Bool = false
    
    private let brandOrange = Color(red: 0.95, green: 0.38, blue: 0.17)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: Avatar & Name
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(brandOrange.opacity(0.15))
                            .frame(width: 100, height: 100)
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(brandOrange)
                    }
                    .padding(.top, 24)
                    
                    Text(authViewModel.currentUser?.name ?? "User")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(authViewModel.currentUser?.email ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 30)
                
                Spacer()
                
                // MARK: Logout Btn
                Button {
                    showLogoutAlert = true
                } label: {
                    Text("Logout")
                        .fontWeight(.semibold)
                        .foregroundColor(brandOrange)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(brandOrange, lineWidth: 1.5)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Logout", role: .destructive) {
                    authViewModel.logout()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
        .environmentObject(CameraViewModel())
}

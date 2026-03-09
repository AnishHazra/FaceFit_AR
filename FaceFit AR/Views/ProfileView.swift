import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var cameraVM: CameraViewModel
    @StateObject private var profileVM = ProfileViewModel()

    private let brandOrange = Color(red: 0.95, green: 0.38, blue: 0.17)

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: - Avatar & Name
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

                    // MARK: - Stats Row
                    HStack(spacing: 0) {
                        StatCell(value: "\(cameraVM.capturedPhotos.count)", label: "Photos")
                        Divider().frame(height: 40)
                        StatCell(value: "\(cameraVM.filterUsageCounts.values.reduce(0, +))", label: "Filters Used")
                        Divider().frame(height: 40)
                        StatCell(value: cameraVM.mostUsedFilter?.rawValue ?? "—", label: "Fav Filter")
                    }
                    .padding(.vertical, 16)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)

                    // MARK: - Settings Section
                    SectionHeader(title: "Settings")
                    VStack(spacing: 0) {
                        ForEach(profileVM.settingsItems) { item in
                            ProfileRow(item: item)
                        }
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    // MARK: - About Section
                    SectionHeader(title: "About the App")
                    VStack(spacing: 0) {
                        ForEach(profileVM.aboutItems) { item in
                            ProfileRow(item: item)
                        }
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)

                    // MARK: - Logout
                    Button {
                        profileVM.showLogoutAlert = true
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
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Logout", isPresented: $profileVM.showLogoutAlert) {
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

// MARK: - Stat Cell
struct StatCell: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 8)
    }
}

// MARK: - Profile Row
struct ProfileRow: View {
    let item: ProfileViewModel.SettingsItem
    private let brandOrange = Color(red: 0.95, green: 0.38, blue: 0.17)

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(brandOrange)
                    .frame(width: 32, height: 32)
                Image(systemName: item.iconName)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
            }

            Text(item.title)
                .font(.system(size: 16))

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .frame(height: 54)
        .overlay(
            Divider()
                .padding(.leading, 62),
            alignment: .bottom
        )
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
        .environmentObject(CameraViewModel())
}

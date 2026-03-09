import SwiftUI
import ARKit

struct CameraView: View {

    @StateObject private var cameraVM = CameraViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    private let arSupported = ARFaceTrackingConfiguration.isSupported
    private let brandOrange = Color(red: 0.95, green: 0.38, blue: 0.17)

    // Coordinator reference for snapshot
    @State private var coordinator: ARCoordinator? = nil

    var body: some View {
        ZStack {

            // MARK: - Camera Feed (full screen)
            if arSupported {
                ARCameraViewRepresentable(
                    selectedFilter: $cameraVM.selectedFilter,
                    onCapture: { image in
                        cameraVM.photoWasCaptured(image)
                    }
                )
                .ignoresSafeArea()
            } else {
                // Fallback for non-TrueDepth devices (simulator / older iPhones)
                FallbackCameraView(
                    selectedFilter: $cameraVM.selectedFilter,
                    onCapture: { image in
                        cameraVM.photoWasCaptured(image)
                    }
                )
                .ignoresSafeArea()
            }

            // MARK: - Top Controls
            VStack {
                HStack {
                    // Flip camera
                    CameraControlButton(icon: "arrow.triangle.2.circlepath.camera.fill") {
                        cameraVM.toggleCamera()
                    }

                    Spacer()

                    Text("FaceFit AR")
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(radius: 2)

                    Spacer()

                    // Profile icon
                    CameraControlButton(icon: "person.circle.fill") {
                        // Navigate to profile — handled by tab
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)

                Spacer()

                // MARK: - Capture Flash Animation
                if cameraVM.showCaptureAnimation {
                    Color.white
                        .ignoresSafeArea()
                        .opacity(0.6)
                        .transition(.opacity)
                        .animation(.easeOut(duration: 0.3), value: cameraVM.showCaptureAnimation)
                }

                // MARK: - Bottom Controls
                VStack(spacing: 16) {

                    // Filter Selector Carousel
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(FilterType.allCases) { filter in
                                FilterSelectorCell(
                                    filter: filter,
                                    isSelected: cameraVM.selectedFilter == filter
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        cameraVM.selectFilter(filter)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    // Capture Button
                    HStack {
                        Spacer()
                        CaptureButton {
                            // Trigger snapshot via NotificationCenter
                            NotificationCenter.default.post(name: .captureSnapshot, object: nil)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 30)
                }
                .background(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.75)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }

            // MARK: - Not supported label
            if !arSupported {
                VStack {
                    Spacer().frame(height: 120)
                    Text("⚠️ Face AR requires TrueDepth camera.\nRunning in preview mode.")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(NotificationCenter.default.publisher(for: .captureSnapshot)) { _ in
            NotificationCenter.default.post(name: .triggerARCapture, object: nil)
        }
    }
}

// MARK: - Filter Selector Cell
struct FilterSelectorCell: View {
    let filter: FilterType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color(red: 0.95, green: 0.38, blue: 0.17) : Color.white.opacity(0.25))
                        .frame(width: 58, height: 58)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: isSelected ? 2.5 : 0)
                        )

                    if filter == .none {
                        Image(systemName: "circle.slash")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                    } else {
                        Text(filter.overlayEmoji.prefix(2).map { String($0) }.joined())
                            .font(.system(size: 26))
                    }
                }

                Text(filter.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

// MARK: - Capture Button
struct CaptureButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .stroke(Color.white, lineWidth: 3)
                    .frame(width: 74, height: 74)
                Circle()
                    .fill(Color.white)
                    .frame(width: 62, height: 62)
            }
        }
    }
}

// MARK: - Camera Control Button
struct CameraControlButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Color.black.opacity(0.35))
                .clipShape(Circle())
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let captureSnapshot = Notification.Name("captureSnapshot")
    static let triggerARCapture = Notification.Name("triggerARCapture")
}

#Preview {
    CameraView()
        .environmentObject(AuthViewModel())
}

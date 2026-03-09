import SwiftUI
import ARKit

// MARK: Notification Names
extension Notification.Name {
    static let captureSnapshot = Notification.Name("captureSnapshot")
    static let triggerARCapture = Notification.Name("triggerARCapture")
    static let toggleCamera = Notification.Name("toggleCamera")
}

struct CameraView: View {

    @StateObject private var cameraVM = CameraViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    private let arSupported = ARFaceTrackingConfiguration.isSupported
    private let brandOrange = Color(red: 0.95, green: 0.38, blue: 0.17)

    // Coordinator reference for snapshot
    @State private var coordinator: ARCoordinator? = nil

    var body: some View {
        ZStack {
            // MARK: Camera Feed (full screen)
            if arSupported {
                ARCameraViewRepresentable(
                    selectedFilter: $cameraVM.selectedFilter,
                    isFrontCamera: $cameraVM.isFrontCamera,
                    onCapture: { image in
                        cameraVM.photoWasCaptured(image)
                    }
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)
            } else {
                // Fallback for non-TrueDepth devices (simulator / older iPhones)
                FallbackCameraView(
                    selectedFilter: $cameraVM.selectedFilter,
                    isFrontCamera: $cameraVM.isFrontCamera,
                    onCapture: { image in
                        cameraVM.photoWasCaptured(image)
                    }
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }

            // MARK: Top Controls
            VStack {
                HStack {
                    Spacer()

                    Text("FaceFit AR")
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(radius: 2)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)

                Spacer()

                // MARK: Capture Flash Animation
                if cameraVM.showCaptureAnimation {
                    Color.white
                        .ignoresSafeArea()
                        .opacity(0.6)
                        .transition(.opacity)
                        .animation(.easeOut(duration: 0.3), value: cameraVM.showCaptureAnimation)
                }

                // MARK: Bottom Controls
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
                    ZStack {
                        CaptureButton {
                            NotificationCenter.default.post(name: .captureSnapshot, object: nil)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)

                        HStack {
                            Spacer()
                            CameraControlButton(icon: "arrow.triangle.2.circlepath.camera.fill") {
                                cameraVM.toggleCamera()
                                NotificationCenter.default.post(name: .toggleCamera, object: nil)
                            }
                            .padding(.trailing, 28)
                        }
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

            // MARK: Not supported label
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onReceive(NotificationCenter.default.publisher(for: .captureSnapshot)) { _ in
            NotificationCenter.default.post(name: .triggerARCapture, object: nil)
        }
    }
}

#Preview {
    CameraView()
        .environmentObject(AuthViewModel())
}

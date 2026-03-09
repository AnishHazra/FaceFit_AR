import Foundation
import UIKit
import Combine
import AVFoundation

class CameraViewModel: ObservableObject {

    // MARK: Published
    @Published var selectedFilter: FilterType = .none
    @Published var isCaptured: Bool = false
    @Published var isFrontCamera: Bool = true
    @Published var showCaptureAnimation: Bool = false
    @Published var filterUsageCounts: [FilterType: Int] = [:]

    // Callback used by ARViewRepresentable to deliver snapshots
    var captureCallback: ((UIImage) -> Void)?

    // MARK: Select Filter
    func selectFilter(_ filter: FilterType) {
        selectedFilter = filter
        filterUsageCounts[filter, default: 0] += 1
    }

    // MARK: Photo Captured from AR
    func photoWasCaptured(_ image: UIImage) {
        showCaptureAnimation = true

        // Save to Photos Library
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.showCaptureAnimation = false
        }
    }
    
    // MARK: Toggle Camera
    func toggleCamera() {
        isFrontCamera.toggle()
    }

}

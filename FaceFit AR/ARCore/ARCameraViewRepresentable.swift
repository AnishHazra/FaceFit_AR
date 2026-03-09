import SwiftUI
import ARKit
import SceneKit
import AVFoundation

struct ARCameraViewRepresentable: UIViewRepresentable {

    @Binding var selectedFilter: FilterType
    @Binding var isFrontCamera: Bool
    var onCapture: (UIImage) -> Void

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        arView.showsStatistics = false
        arView.automaticallyUpdatesLighting = true

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        context.coordinator.arView = arView
        context.coordinator.onCapture = onCapture

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        context.coordinator.currentFilter = selectedFilter
    }

    func makeCoordinator() -> ARCoordinator {
        ARCoordinator()
    }

    // MARK: Snapshot capture
    func captureSnapshot(_ arView: ARSCNView) {
        let image = arView.snapshot()
        onCapture(image)
    }
}

// MARK: ARCoordinator
class ARCoordinator: NSObject, ARSCNViewDelegate {

    weak var arView: ARSCNView?
    var onCapture: ((UIImage) -> Void)?
    var currentFilter: FilterType = .none {
        didSet {
            updateFilterNode()
        }
    }

    private var filterNode: SCNNode?
    private var isUsingFrontCamera: Bool = true

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleCaptureNotification), name: .triggerARCapture, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleToggleCamera), name: .toggleCamera, object: nil)
    }

    @objc private func handleToggleCamera() {
        guard let arView = arView else { return }
        isUsingFrontCamera.toggle()
        if isUsingFrontCamera && ARFaceTrackingConfiguration.isSupported {
            let config = ARFaceTrackingConfiguration()
            config.isLightEstimationEnabled = true
            arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        } else {
            let config = ARWorldTrackingConfiguration()
            config.isLightEstimationEnabled = true
            arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        }
    }

    @objc private func handleCaptureNotification() {
        captureSnapshot()
    }

    // MARK: Update current filter node when selection changes
    private func updateFilterNode() {
        // Ensure UI/SceneKit updates happen on main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let arView = self.arView else { return }

            // Try to find the face node (first child under the scene root for face anchor)
            // If not found yet (e.g., before first anchor), we just update stored filterNode
            let rootNode = arView.scene.rootNode

            // Remove any existing filter node from hierarchy
            if let existing = self.filterNode {
                existing.removeFromParentNode()
                self.filterNode = nil
            }

            // Build a new node for the current filter
            guard let newNode = self.makeFilterNode(for: self.currentFilter) else { return }

            // Attach to the first child node if present (face anchor node), otherwise to root as fallback
            if let faceNode = rootNode.childNodes.first {
                faceNode.addChildNode(newNode)
            } else {
                rootNode.addChildNode(newNode)
            }

            self.filterNode = newNode
        }
    }

    // MARK: ARSCNViewDelegate — face anchor added
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        let node = SCNNode()
        filterNode = makeFilterNode(for: currentFilter)
        if let fn = filterNode { node.addChildNode(fn) }
        return node
    }

    // MARK: Update face anchor every frame
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // Remove old filter nodes
            node.childNodes.forEach { $0.removeFromParentNode() }
            let newNode = self.makeFilterNode(for: self.currentFilter)
            if let fn = newNode {
                node.addChildNode(fn)
                self.filterNode = fn
            }
        }
    }

    // MARK: Build filter overlay node
    private func makeFilterNode(for filter: FilterType) -> SCNNode? {
        switch filter {
        case .none:
            return nil

        case .roseCrown:
            return makeEmojiNode(emoji: "🌹👑🌹",
                                  position: SCNVector3(0, 0.13, 0.05),
                                  fontSize: 80,
                                  width: 0.25,
                                  height: 0.10)

        case .catEars:
            return makeEmojiNode(emoji: "🐱",
                                  position: SCNVector3(0, 0.12, 0.05),
                                  fontSize: 90,
                                  width: 0.20,
                                  height: 0.12)

        case .sunglasses:
            return makeEmojiNode(emoji: "🕶️",
                                  position: SCNVector3(0, 0.02, 0.09),
                                  fontSize: 100,
                                  width: 0.22,
                                  height: 0.07)

        case .faceMask:
            return makeEmojiNode(emoji: "😷",
                                  position: SCNVector3(0, -0.035, 0.09),
                                  fontSize: 90,
                                  width: 0.18,
                                  height: 0.10)

        case .sparkles:
            return makeEmojiNode(emoji: "✨⭐✨",
                                  position: SCNVector3(0, 0.05, 0.10),
                                  fontSize: 60,
                                  width: 0.28,
                                  height: 0.18)
        }
    }

    // MARK: Generic Emoji → SCNNode helper
    private func makeEmojiNode(emoji: String,
                                position: SCNVector3,
                                fontSize: CGFloat,
                                width: CGFloat,
                                height: CGFloat) -> SCNNode {
        let plane = SCNPlane(width: width, height: height)
        plane.firstMaterial?.isDoubleSided = true
        plane.firstMaterial?.diffuse.contents = emojiImage(text: emoji,
                                                           fontSize: fontSize,
                                                           size: CGSize(width: 256, height: 128))
        plane.firstMaterial?.blendMode = .alpha
        plane.firstMaterial?.writesToDepthBuffer = false

        let node = SCNNode(geometry: plane)
        node.position = position
        return node
    }

    // MARK: Render emoji string to UIImage for texture
    private func emojiImage(text: String, fontSize: CGFloat, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            ctx.cgContext.clear(CGRect(origin: .zero, size: size))
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize)
            ]
            let str = NSAttributedString(string: text, attributes: attrs)
            let textSize = str.size()
            let rect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            str.draw(in: rect)
        }
    }

    // MARK: Capture
    func captureSnapshot() {
        guard let arView = arView else { return }
        let image = arView.snapshot()
        onCapture?(image)
    }
}

// MARK: Fallback Camera (Vision) for non-TrueDepth devices
// Used automatically when ARFaceTracking is not supported
struct FallbackCameraView: UIViewRepresentable {

    @Binding var selectedFilter: FilterType
    @Binding var isFrontCamera: Bool
    var onCapture: (UIImage) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black

        context.coordinator.setupSession(in: view)
        context.coordinator.onCapture = onCapture

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.currentFilter = selectedFilter
    }

    func makeCoordinator() -> FallbackCoordinator {
        FallbackCoordinator()
    }
}

class FallbackCoordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    var currentFilter: FilterType = .none
    var onCapture: ((UIImage) -> Void)?

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var overlayLabel: UILabel?
    private weak var containerView: UIView?
    private var isUsingFrontCamera: Bool = true

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleCaptureNotification), name: .triggerARCapture, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleToggleCamera), name: .toggleCamera, object: nil)
    }

    @objc private func handleToggleCamera() {
        guard let session = captureSession else { return }
        isUsingFrontCamera.toggle()
        let position: AVCaptureDevice.Position = isUsingFrontCamera ? .front : .back
        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let newInput = try? AVCaptureDeviceInput(device: newDevice) else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            session.beginConfiguration()
            session.inputs.forEach { session.removeInput($0) }
            session.addInput(newInput)
            session.commitConfiguration()
        }
    }

    @objc private func handleCaptureNotification() {
        guard let view = containerView else { return }

        // Render the view hierarchy into an image
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }

        onCapture?(image)
    }

    func setupSession(in view: UIView) {
        self.containerView = view
        let session = AVCaptureSession()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                    for: .video,
                                                    position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        session.addInput(input)

        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        preview.frame = view.bounds
        view.layer.addSublayer(preview)
        self.previewLayer = preview

        // Emoji overlay label
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.numberOfLines = 2
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            label.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        self.overlayLabel = label

        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
        self.captureSession = session
    }
}


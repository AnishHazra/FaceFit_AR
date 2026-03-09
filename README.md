# FaceFit AR

FaceFit AR is an interactive iOS Augmented Reality application that lets users apply real-time virtual filters and 3D effects to their faces. Built with modern iOS technologies, it features a seamless SwiftUI interface, robust Firebase authentication, and highly responsive facial tracking using Apple's ARKit.

## ✨ Features

- **Real-Time AR Filters**: Apply fun constraints and filters (Cat Ears, Rose Crown, Sunglasses, etc.) using the TrueDepth camera.
- **Capture & Save**: Snap photos of your AR experience and save them directly to your device's photo library.
- **Secure Authentication**: Email and password-based sign up, login, and password management powered by Firebase Auth.
- **Modern UI**: Fully reactive and declarative user interface built with SwiftUI.

## 🛠 Tech Stack

- **Language**: Swift 5+
- **UI Framework**: SwiftUI
- **AR Engine**: ARKit & SceneKit
- **Backend/Identity**: Firebase Authentication
- **Architecture**: MVVM (Model-View-ViewModel)

## 📋 Prerequisites

- **Xcode 14.0** or later.
- An iOS device running **iOS 15.0+** with a **TrueDepth camera** (iPhone X or newer is required to test AR face tracking; it will not work effectively on the simulator).
- A valid `GoogleService-Info.plist` file from your Firebase console.

## 🚀 Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/FaceFit-AR.git
   cd FaceFit-AR
   ```
2. **Setup Firebase**:
   - Create a new project in the [Firebase Console](https://console.firebase.google.com/).
   - Add an iOS app to the project and enter the app's bundle identifier.
   - Download the `GoogleService-Info.plist` file and drag it into the root of the Xcode project.
   - Enable **Email/Password** authentication in the Firebase Authentication settings.

3. **Install Dependencies**:
   - Open the project in Xcode. Swift Package Manager will automatically resolve the required Firebase dependencies.

4. **Build and Run**:
   - Connect your physical iOS device.
   - Select your device from the run destination menu.
   - Hit **Cmd + R** (or click the Play button) to build and run the app!

## 📄 License

This project is licensed under the MIT License.

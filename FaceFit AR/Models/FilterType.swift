import Foundation
import UIKit

enum FilterType: String, CaseIterable, Identifiable {
    case none       = "None"
    case roseCrown  = "Rose Crown"
    case catEars    = "Cat Ears"
    case sunglasses = "Sunglasses"
    case faceMask   = "Face Mask"
    case sparkles   = "Sparkles"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .none:       return "circle.slash"
        case .roseCrown:  return "🌹"
        case .catEars:    return "🐱"
        case .sunglasses: return "🕶️"
        case .faceMask:   return "😷"
        case .sparkles:   return "✨"
        }
    }

    // System SF symbol fallback for selector UI
    var sfSymbol: String {
        switch self {
        case .none:       return "circle.slash"
        case .roseCrown:  return "camera.filters"
        case .catEars:    return "pawprint.fill"
        case .sunglasses: return "eyeglasses"
        case .faceMask:   return "face.smiling"
        case .sparkles:   return "sparkles"
        }
    }

    var overlayColor: UIColor {
        switch self {
        case .none:       return .clear
        case .roseCrown:  return UIColor(red: 0.9, green: 0.2, blue: 0.3, alpha: 0.85)
        case .catEars:    return UIColor(red: 0.95, green: 0.6, blue: 0.7, alpha: 0.85)
        case .sunglasses: return UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.85)
        case .faceMask:   return UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 0.75)
        case .sparkles:   return UIColor(red: 1.0, green: 0.85, blue: 0.2, alpha: 0.85)
        }
    }

    // Emoji string to draw as overlay (used in ARCore rendering)
    var overlayEmoji: String {
        switch self {
        case .none:       return ""
        case .roseCrown:  return "🌹👑🌹"
        case .catEars:    return "🐱"
        case .sunglasses: return "🕶️"
        case .faceMask:   return "😷"
        case .sparkles:   return "✨⭐✨"
        }
    }
}

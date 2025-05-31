
import SwiftUI

struct Theme {
    static let primaryColor = Color.green

    static let cardBackground = Color.black.opacity(0.2)

    static let backgroundGradient = LinearGradient(
        colors: [.teal, .mint],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let textColor = Color.white

    static let accent = Color.blue
}

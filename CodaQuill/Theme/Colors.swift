import SwiftUI

// MARK: - Theme Colors
/// Main color system ng app
/// Nag-ha-handle ng dark at light mode colors
enum Theme {
    // MARK: - Dark Mode Colors
    /// Mga kulay para sa dark mode theme
    private static let darkBackground = Color(hex: "1F2128")    // Main background color
    private static let darkCardSurface = Color(hex: "292C36")   // Surface color para sa cards
    private static let darkAccentBlue = Color(hex: "7F9CF5")    // Primary accent color
    private static let darkPinkAccent = Color(hex: "F28AB2")    // Secondary accent color
    private static let darkHighlightYellow = Color(hex: "F3E99F") // Para sa code highlighting
    private static let darkStringTeal = Color(hex: "A3E4D7")    // Para sa string values
    private static let darkNumberViolet = Color(hex: "C3A2E8")  // Para sa numeric values
    private static let darkCommentGray = Color(hex: "8A8FA0")   // Para sa comments
    
    // MARK: - Light Mode Colors
    /// Mga kulay para sa light mode theme
    private static let lightBackground = Color(hex: "F5F5F7")    // Main background color
    private static let lightCardSurface = Color(hex: "FFFFFF")   // Surface color para sa cards
    private static let lightAccentBlue = Color(hex: "4B6BDB")    // Primary accent color
    private static let lightPinkAccent = Color(hex: "D35D89")    // Secondary accent color
    private static let lightHighlightYellow = Color(hex: "B5A649") // Para sa code highlighting
    private static let lightStringTeal = Color(hex: "2F9E8C")    // Para sa string values
    private static let lightNumberViolet = Color(hex: "8B61B0")  // Para sa numeric values
    private static let lightCommentGray = Color(hex: "6B6F7D")   // Para sa comments
    
    // MARK: - Dynamic Theme Colors
    /// Mga computed properties na nag-a-adjust base sa current theme
    static var background: Color {
        ThemeManager.shared.isDarkMode ? darkBackground : lightBackground
    }
    
    static var cardSurface: Color {
        ThemeManager.shared.isDarkMode ? darkCardSurface : lightCardSurface
    }
    
    static var accentBlue: Color {
        ThemeManager.shared.isDarkMode ? darkAccentBlue : lightAccentBlue
    }
    
    static var pinkAccent: Color {
        ThemeManager.shared.isDarkMode ? darkPinkAccent : lightPinkAccent
    }
    
    static var highlightYellow: Color {
        ThemeManager.shared.isDarkMode ? darkHighlightYellow : lightHighlightYellow
    }
    
    static var stringTeal: Color {
        ThemeManager.shared.isDarkMode ? darkStringTeal : lightStringTeal
    }
    
    static var numberViolet: Color {
        ThemeManager.shared.isDarkMode ? darkNumberViolet : lightNumberViolet
    }
    
    static var commentGray: Color {
        ThemeManager.shared.isDarkMode ? darkCommentGray : lightCommentGray
    }
    
    static var textPrimary: Color {
        ThemeManager.shared.isDarkMode ? .white : .black
    }
    
    static var textSecondary: Color {
        ThemeManager.shared.isDarkMode ? darkCommentGray : lightCommentGray
    }
}

// MARK: - Color Extension
/// Extension para sa hex color conversion
extension Color {
    /// Convert hex string to SwiftUI Color
    /// - Parameter hex: Hex color code (3, 6, or 8 characters)
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 
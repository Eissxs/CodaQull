import SwiftUI

// MARK: - Font Styles
/// Typography system ng app
/// Nag-provide ng consistent font styles at sizes
enum FontStyle {
    // MARK: - General Text Styles
    /// Mga basic text styles para sa UI elements
    static let title = Font.system(.title, design: .rounded).weight(.semibold)    // Para sa main titles
    static let headline = Font.system(.headline, design: .rounded)                 // Para sa section headers
    static let body = Font.system(.body)                                          // Para sa regular text
    static let caption = Font.system(.caption)                                    // Para sa small text
    
    // MARK: - Code Font Styles
    /// Mga monospaced fonts para sa code display
    static let codeText = Font.custom("Menlo", size: UIFont.systemFontSize)       // Regular code text
    static let codeTextLarge = Font.custom("Menlo", size: UIFont.systemFontSize + 2) // Larger code text
    
    // MARK: - Dynamic Scaling
    /// Para sa accessibility support
    static func scaledTitle(size: CGFloat = 20) -> Font {
        return Font.system(size: size, weight: .semibold, design: .rounded)
    }
} 
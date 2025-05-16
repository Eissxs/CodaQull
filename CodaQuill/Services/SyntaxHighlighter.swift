import Foundation
import UIKit
import SwiftUI

// MARK: - Syntax Highlighter
/// Service para sa code syntax highlighting
/// Nag-ha-handle ng color highlighting para sa different languages
class SyntaxHighlighter {
    // MARK: - Properties
    
    /// Shared instance para sa global access
    static let shared = SyntaxHighlighter()
    
    // MARK: - Language Patterns
    
    /// Patterns para sa Swift syntax highlighting
    private let swiftPatterns: [HighlightPattern] = [
        .init(pattern: "\\b(class|struct|enum|protocol|extension|func|var|let|if|else|guard|switch|case|default|for|while|do|try|catch|throw|throws|rethrows|return|break|continue|import|public|private|internal|fileprivate|static|final|override|mutating|nonmutating|convenience|required|lazy|weak|unowned|inout|some|any|self|super|nil|true|false|associatedtype|typealias|where|async|await)\\b", color: Theme.highlightYellow),
        .init(pattern: "\"[^\"\\\\]*(?:\\\\.[^\"\\\\]*)*\"", color: Theme.stringTeal),
        .init(pattern: "//.*", color: Theme.commentGray),
        .init(pattern: "\\b\\d+\\b", color: Theme.numberViolet)
    ]
    
    /// Patterns para sa Python syntax highlighting
    private let pythonPatterns: [HighlightPattern] = [
        .init(pattern: "\\b(def|class|if|else|elif|for|while|try|except|finally|with|as|import|from|return|raise|break|continue|pass|lambda|None|True|False|and|or|not|is|in|global|nonlocal|assert|async|await|yield)\\b", color: Theme.highlightYellow),
        .init(pattern: "(\"\"\"[^\"]*\"\"\")|(\"[^\"\\\\]*(?:\\\\.[^\"\\\\]*)*\")|('[^'\\\\]*(?:\\\\.[^'\\\\]*)*')", color: Theme.stringTeal),
        .init(pattern: "#.*", color: Theme.commentGray),
        .init(pattern: "\\b\\d+\\b", color: Theme.numberViolet)
    ]
    
    /// Patterns para sa HTML syntax highlighting
    private let htmlPatterns: [HighlightPattern] = [
        .init(pattern: "<[!?]?/?[a-zA-Z][^>]*>", color: Theme.highlightYellow),
        .init(pattern: "\"[^\"]*\"", color: Theme.stringTeal),
        .init(pattern: "<!--.*?-->", color: Theme.commentGray),
        .init(pattern: "\\b\\d+\\b", color: Theme.numberViolet)
    ]
    
    // MARK: - Highlighting Methods
    
    /// Apply syntax highlighting sa code
    /// Supports Swift, Python, at HTML
    func highlightCode(_ code: String, language: String) -> NSAttributedString {
        let patterns: [HighlightPattern]
        switch language.lowercased() {
        case "swift":
            patterns = swiftPatterns
        case "python":
            patterns = pythonPatterns
        case "html":
            patterns = htmlPatterns
        default:
            patterns = swiftPatterns
        }
        
        let attributedString = NSMutableAttributedString(string: code)
        let range = NSRange(location: 0, length: code.utf16.count)
        
        // Set default attributes
        attributedString.addAttribute(.font, value: UIFont(name: "Menlo", size: UIFont.systemFontSize) ?? .monospaced(), range: range)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
        
        // Apply syntax highlighting
        for pattern in patterns {
            do {
                let regex = try NSRegularExpression(pattern: pattern.pattern, options: [])
                let matches = regex.matches(in: code, options: [], range: range)
                
                for match in matches {
                    attributedString.addAttribute(.foregroundColor, value: pattern.color.uiColor, range: match.range)
                }
            } catch {
                print("Regex error: \(error)")
            }
        }
        
        return attributedString
    }
}

// MARK: - Helper Types

/// Pattern para sa syntax highlighting
struct HighlightPattern {
    let pattern: String
    let color: Color
}

// MARK: - Extensions

/// Convert SwiftUI Color to UIColor
extension Color {
    var uiColor: UIColor {
        UIColor(self)
    }
}

/// Helper para sa monospaced fonts
extension UIFont {
    static func monospaced(ofSize size: CGFloat = UIFont.systemFontSize) -> UIFont {
        .monospacedSystemFont(ofSize: size, weight: .regular)
    }
} 
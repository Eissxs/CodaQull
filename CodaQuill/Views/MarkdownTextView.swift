import SwiftUI
import UIKit

// MARK: - Markdown Text View
/// View para sa markdown text display at editing
/// Nag-ha-handle ng markdown rendering at text input
struct MarkdownTextView: View {
    // MARK: - Properties
    
    /// Text content na i-di-display
    let text: String
    /// Flag kung pwedeng i-edit
    var isEditable: Bool = false
    /// Callback kapag may changes sa text
    var onTextChange: ((String) -> Void)?
    
    // MARK: - View Body
    /// Main layout ng markdown view
    var body: some View {
        // MARK: - ⚠️ Experimental Feature
        /// TODO: Markdown handling ay may mga issues:
        /// - Hindi optimal ang rendering performance
        /// - Limited ang markdown support
        /// - Need i-enhance ang editing experience
        if isEditable {
            TextEditor(text: Binding(
                get: { text },
                set: { onTextChange?($0) }
            ))
            .font(FontStyle.body)
            .foregroundColor(.white)
        } else {
            Text(try! AttributedString(markdown: text))
                .font(FontStyle.body)
                .foregroundColor(.white)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
} 
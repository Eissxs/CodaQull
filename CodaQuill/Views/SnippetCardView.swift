import SwiftUI

// MARK: - Snippet Card View
/// Card view para sa individual code snippet
/// Nag-di-display ng snippet preview with interactions
struct SnippetCardView: View {
    // MARK: - Properties
    
    /// Snippet na i-di-display
    let snippet: Snippet
    /// Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    /// State para sa copy feedback
    @State private var showCopyFeedback = false
    /// ID para sa view refresh
    @State private var refreshID = UUID()
    
    // MARK: - View Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Header Section
            /// Title, language badge, at favorite button
            HStack {
                Text(snippet.snippetTitle)
                    .font(FontStyle.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: toggleFavorite) {
                    Image(systemName: snippet.isFavorite ? "star.fill" : "star")
                        .foregroundColor(snippet.isFavorite ? Theme.highlightYellow : Theme.commentGray)
                        .font(.system(size: 18))
                }
                .buttonStyle(.plain)
                .padding(.trailing, 8)
                .id(refreshID)
                
                Text(snippet.snippetLanguage)
                    .font(FontStyle.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.pinkAccent.opacity(0.2))
                    .foregroundColor(Theme.pinkAccent)
                    .clipShape(Capsule())
            }
            
            // MARK: - Code Preview
            /// Preview ng code with copy functionality
            ZStack(alignment: .center) {
                Text(snippet.snippetCode)
                    .font(FontStyle.codeText)
                    .foregroundColor(Theme.stringTeal)
                    .lineLimit(3)
                    .padding(8)
                    .background(Theme.background)
                    .cornerRadius(8)
                
                if showCopyFeedback {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Theme.accentBlue)
                        Text("Copied!")
                            .font(FontStyle.caption)
                            .foregroundColor(Theme.accentBlue)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Theme.cardSurface.opacity(0.95))
                    .cornerRadius(20)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .onTapGesture {
                copyToClipboard()
            }
            .onLongPressGesture {
                copyToClipboard()
            }
            
            // MARK: - Tags Section
            /// Horizontal list ng associated tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(snippet.snippetTags)) { tag in
                        Text(tag.tagName)
                            .font(FontStyle.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Theme.accentBlue.opacity(0.2))
                            .foregroundColor(Theme.accentBlue)
                            .clipShape(Capsule())
                    }
                }
            }
            
            // MARK: - Date Display
            /// Creation date ng snippet
            Text(snippet.formattedDate(snippet.snippetCreatedAt))
                .font(FontStyle.caption)
                .foregroundColor(Theme.commentGray)
        }
        .padding()
        .background(Theme.cardSurface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Helper Functions
    
    /// Toggle favorite status ng snippet
    private func toggleFavorite() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            snippet.isFavorite.toggle()
            
            do {
                try viewContext.save()
                refreshID = UUID()
            } catch {
                print("Error toggling favorite: \(error)")
            }
        }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    /// Copy snippet code to clipboard
    private func copyToClipboard() {
        UIPasteboard.general.string = snippet.snippetCode
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showCopyFeedback = true
        }
        
        // Hide feedback after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut) {
                showCopyFeedback = false
            }
        }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

// MARK: - Preview Provider
/// Preview configuration para sa development
struct SnippetCardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let snippet = Snippet(context: context)
        snippet.title = "Example Snippet"
        snippet.code = "func example() {\n    print(\"Hello, World!\")\n}"
        snippet.language = "swift"
        snippet.createdAt = Date()
        
        return SnippetCardView(snippet: snippet)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Theme.background)
    }
} 
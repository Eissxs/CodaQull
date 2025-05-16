import SwiftUI

// MARK: - Snippet Detail View
/// Main view para sa detailed display ng code snippet
/// Nag-ha-handle ng viewing, editing, at management ng snippet
struct SnippetDetailView: View {
    // MARK: - Properties
    
    /// Snippet na i-di-display
    let snippet: Snippet
    /// State para sa edit mode
    @State private var isEditing = false
    /// State para sa delete confirmation
    @State private var showingDeleteAlert = false
    /// State para sa copy feedback display
    @State private var showCopyFeedback = false
    /// State para sa version history display
    @State private var showingVersionHistory = false
    /// ID para sa view refresh trigger
    @State private var refreshID = UUID()
    /// Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    /// Dismiss action
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - View Body
    /// Main layout ng snippet details
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - Language at Date Section
                /// Header section with language badge at creation date
                HStack {
                    Text(snippet.snippetLanguage.capitalized)
                        .font(FontStyle.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.pinkAccent.opacity(0.2))
                        .foregroundColor(Theme.pinkAccent)
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    Text(snippet.formattedDate(snippet.snippetCreatedAt))
                        .font(FontStyle.caption)
                        .foregroundColor(Theme.commentGray)
                }
                
                // MARK: - Code Section
                /// Main code display with copy functionality
                VStack(alignment: .leading, spacing: 8) {
                    Text("Code")
                        .font(FontStyle.headline)
                        .foregroundColor(Theme.commentGray)
                    
                    // MARK: - ⚠️ Experimental Feature
                    /// TODO: Code display ay may ilang issues:
                    /// - May delay sa syntax highlighting
                    /// - Hindi optimal ang theme adaptation
                    /// - Need i-enhance ang copy feedback animation
                    ZStack(alignment: .center) {
                        CodeTextView(text: snippet.snippetCode, language: snippet.snippetLanguage)
                            .frame(minHeight: 200)
                            .background(Theme.cardSurface)
                            .cornerRadius(12)
                        
                        if showCopyFeedback {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Theme.accentBlue)
                                Text("Copied!")
                                    .font(FontStyle.headline)
                                    .foregroundColor(Theme.accentBlue)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Theme.cardSurface.opacity(0.95))
                            .cornerRadius(20)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .onLongPressGesture {
                        copyToClipboard()
                    }
                    
                    // MARK: - Code Execution Section
                    /// Swift code execution feature
                    if snippet.snippetLanguage == "swift" {
                        CodeExecutionView(code: snippet.snippetCode)
                            .padding(.top, 8)
                    }
                }
                
                // MARK: - Notes Section
                /// Optional notes display
                if !snippet.snippetNotes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(FontStyle.headline)
                            .foregroundColor(Theme.commentGray)
                        
                        MarkdownTextView(text: snippet.snippetNotes)
                            .padding()
                            .background(Theme.cardSurface)
                            .cornerRadius(12)
                    }
                }
                
                // MARK: - Tags Section
                /// Display ng associated tags
                if !snippet.snippetTags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tags")
                            .font(FontStyle.headline)
                            .foregroundColor(Theme.commentGray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(snippet.snippetTags)) { tag in
                                    Text(tag.tagName)
                                        .font(FontStyle.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Theme.accentBlue.opacity(0.2))
                                        .foregroundColor(Theme.accentBlue)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle(snippet.snippetTitle)
        .navigationBarTitleDisplayMode(.large)
        .id(refreshID)
        .onReceive(NotificationCenter.default.publisher(for: .snippetChanged)) { _ in
            refreshID = UUID()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: toggleFavorite) {
                        Image(systemName: snippet.isFavorite ? "star.fill" : "star")
                            .foregroundColor(snippet.isFavorite ? Theme.highlightYellow : Theme.commentGray)
                    }
                    .id(refreshID)
                    
                    Button(action: copyToClipboard) {
                        Image(systemName: "doc.on.doc")
                    }
                    
                    Menu {
                        Button(action: { isEditing = true }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(action: { showingVersionHistory = true }) {
                            Label("Version History", systemImage: "clock.arrow.circlepath")
                        }
                        
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditSnippetView(snippet: snippet)
        }
        .sheet(isPresented: $showingVersionHistory) {
            VersionHistoryView(snippet: snippet)
        }
        .alert("Delete Snippet", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteSnippet()
            }
        } message: {
            Text("Are you sure you want to delete this snippet? This action cannot be undone.")
        }
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
    
    /// Delete current snippet
    private func deleteSnippet() {
        viewContext.delete(snippet)
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error deleting snippet: \(error)")
        }
    }
}

// MARK: - Preview Provider
/// Preview configuration para sa development
struct SnippetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let snippet = Snippet(context: context)
        snippet.title = "Example Snippet"
        snippet.code = "print(\"Hello, World!\")"
        snippet.language = "swift"
        snippet.createdAt = Date()
        
        return NavigationView {
            SnippetDetailView(snippet: snippet)
                .environment(\.managedObjectContext, context)
        }
    }
} 
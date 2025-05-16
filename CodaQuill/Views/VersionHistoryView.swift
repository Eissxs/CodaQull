import SwiftUI

// MARK: - Version History View
/// Main view para sa version history ng snippet
/// Nag-ha-handle ng version display at restoration
struct VersionHistoryView: View {
    // MARK: - Properties
    
    /// Snippet na may version history
    let snippet: Snippet
    /// Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    /// Dismiss action
    @Environment(\.dismiss) private var dismiss
    /// Fetched versions ng snippet
    @FetchRequest private var versions: FetchedResults<SnippetVersion>
    /// ID para sa view refresh
    @State private var refreshID = UUID()
    
    // MARK: - Initialization
    
    /// Setup fetch request para sa versions ng specific snippet
    init(snippet: Snippet) {
        self.snippet = snippet
        _versions = FetchRequest(
            entity: SnippetVersion.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \SnippetVersion.createdAt, ascending: false)],
            predicate: NSPredicate(format: "snippet == %@", snippet),
            animation: .default
        )
    }
    
    // MARK: - View Body
    var body: some View {
        List {
            if versions.isEmpty {
                // MARK: - Empty State
                /// Display kapag walang version history
                VStack(spacing: 12) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 64))
                        .foregroundColor(Theme.commentGray)
                    Text("No Version History")
                        .font(FontStyle.headline)
                        .foregroundColor(Theme.commentGray)
                    Text("Changes to this snippet will appear here")
                        .font(FontStyle.caption)
                        .foregroundColor(Theme.commentGray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .listRowBackground(Theme.background)
                .listRowSeparator(.hidden)
            } else {
                ForEach(versions) { version in
                    VStack(alignment: .leading, spacing: 8) {
                        // Version Title and Date
                        HStack {
                            Text(version.versionTitle)
                                .font(FontStyle.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Text(version.formattedDate(version.versionCreatedAt))
                                .font(FontStyle.caption)
                                .foregroundColor(Theme.commentGray)
                        }
                        
                        // Code Preview
                        Text(version.versionCode)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(Theme.stringTeal)
                            .lineLimit(3)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.cardSurface)
                            .cornerRadius(8)
                            .onLongPressGesture {
                                UIPasteboard.general.string = version.versionCode
                                // Haptic feedback
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                            }
                        
                        // Language Badge
                        Text(version.versionLanguage.capitalized)
                            .font(FontStyle.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Theme.pinkAccent.opacity(0.2))
                            .foregroundColor(Theme.pinkAccent)
                            .clipShape(Capsule())
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Theme.cardSurface)
                    .cornerRadius(12)
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = version.versionCode
                        }) {
                            Label("Copy Code", systemImage: "doc.on.doc")
                        }
                        
                        Button(action: {
                            restoreVersion(version)
                        }) {
                            Label("Restore This Version", systemImage: "clock.arrow.circlepath")
                        }
                    }
                }
                .listRowBackground(Theme.background)
                .listRowSeparator(.hidden)
                .padding(.vertical, 4)
            }
        }
        .listStyle(PlainListStyle())
        .background(Theme.background)
        .navigationTitle("Version History")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Helper Functions
    
    /// Restore snippet to specific version
    /// Creates backup ng current state bago mag-restore
    private func restoreVersion(_ version: SnippetVersion) {
        snippet.title = version.versionTitle
        snippet.code = version.versionCode
        snippet.notes = version.versionNotes
        snippet.language = version.versionLanguage
        snippet.updatedAt = Date()
        
        // Create a new version for the current state before restoring
        createVersion(
            title: snippet.snippetTitle,
            code: snippet.snippetCode,
            notes: snippet.snippetNotes,
            language: snippet.snippetLanguage
        )
        
        do {
            try viewContext.save()
            // Trigger refresh
            refreshID = UUID()
            NotificationCenter.default.post(name: .snippetChanged, object: nil)
        } catch {
            print("Error restoring version: \(error)")
        }
    }
    
    /// Create new version record
    /// Used para sa backup bago mag-restore
    private func createVersion(title: String, code: String, notes: String, language: String) {
        let newVersion = SnippetVersion(context: viewContext)
        newVersion.id = UUID()
        newVersion.title = title
        newVersion.code = code
        newVersion.notes = notes
        newVersion.language = language
        newVersion.createdAt = Date()
        newVersion.snippet = snippet
        
        do {
            try viewContext.save()
        } catch {
            print("Error creating version: \(error)")
        }
    }
} 
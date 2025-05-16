import Foundation
import CoreData

// MARK: - Snippet Model Extension
/// Extension para sa Snippet Core Data model
/// Nag-po-provide ng type-safe access sa properties
extension Snippet {
    // MARK: - Computed Properties
    
    /// Unique identifier ng snippet
    var snippetId: UUID {
        get { id ?? UUID() }
        set { id = newValue }
    }
    
    /// Title ng snippet
    var snippetTitle: String {
        get { title ?? "" }
        set { title = newValue }
    }
    
    /// Source code content
    var snippetCode: String {
        get { code ?? "" }
        set { code = newValue }
    }
    
    /// Programming language
    var snippetLanguage: String {
        get { language ?? "swift" }
        set { language = newValue }
    }
    
    /// Additional notes or documentation
    var snippetNotes: String {
        get { notes ?? "" }
        set { notes = newValue }
    }
    
    /// Creation date
    var snippetCreatedAt: Date {
        get { createdAt ?? Date() }
        set { createdAt = newValue }
    }
    
    /// Last update date
    var snippetUpdatedAt: Date {
        get { updatedAt ?? Date() }
        set { updatedAt = newValue }
    }
    
    /// Associated tags
    var snippetTags: Set<Tag> {
        get { (tags as? Set<Tag>) ?? [] }
        set { tags = newValue as NSSet }
    }
    
    /// Version history
    var snippetVersions: Set<SnippetVersion> {
        get { (versions as? Set<SnippetVersion>) ?? [] }
        set { versions = newValue as NSSet }
    }
    
    // MARK: - Helper Methods
    
    /// Format date para sa display
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
} 
import Foundation
import CoreData

// MARK: - Snippet Version Model Extension
/// Extension para sa SnippetVersion Core Data model
/// Nag-ha-handle ng version history data
extension SnippetVersion {
    // MARK: - Computed Properties
    
    /// Unique identifier ng version
    var versionId: UUID {
        get { id ?? UUID() }
        set { id = newValue }
    }
    
    /// Title ng version
    var versionTitle: String {
        get { title ?? "" }
        set { title = newValue }
    }
    
    /// Code content ng version
    var versionCode: String {
        get { code ?? "" }
        set { code = newValue }
    }
    
    /// Notes content ng version
    var versionNotes: String {
        get { notes ?? "" }
        set { notes = newValue }
    }
    
    /// Programming language ng version
    var versionLanguage: String {
        get { language ?? "swift" }
        set { language = newValue }
    }
    
    /// Creation date ng version
    var versionCreatedAt: Date {
        get { createdAt ?? Date() }
        set { createdAt = newValue }
    }
    
    /// Parent snippet reference
    var parentSnippet: Snippet? {
        get { snippet }
        set { snippet = newValue }
    }
    
    // MARK: - Helper Methods
    
    /// Format date para sa display
    /// Includes both date at time
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
} 
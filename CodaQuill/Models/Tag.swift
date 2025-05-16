import Foundation
import CoreData

// MARK: - Tag Model Extension
/// Extension para sa Tag Core Data model
/// Nag-po-provide ng type-safe access sa properties
extension Tag {
    // MARK: - Computed Properties
    
    /// Unique identifier ng tag
    var tagId: UUID {
        get { id ?? UUID() }
        set { id = newValue }
    }
    
    /// Name ng tag
    var tagName: String {
        get { name ?? "" }
        set { name = newValue }
    }
    
    /// Associated snippets
    var tagSnippets: Set<Snippet> {
        get { (snippets as? Set<Snippet>) ?? [] }
        set { snippets = newValue as NSSet }
    }
} 
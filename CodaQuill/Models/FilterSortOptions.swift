import Foundation

// MARK: - Sort Options
/// Enum para sa available sorting options
/// Nag-de-define ng iba't ibang ways para i-sort ang snippets
enum SortOption: String, CaseIterable {
    case favorites = "Favorites First"
    case dateNewest = "Date (Newest)"
    case dateOldest = "Date (Oldest)"
    case titleAZ = "Title (A-Z)"
    case titleZA = "Title (Z-A)"
}

// MARK: - Filter Sort Options
/// Main class para sa filtering at sorting ng snippets
/// Nag-ha-handle ng user-selected filters at sort preferences
class FilterSortOptions: ObservableObject {
    // MARK: - Properties
    
    /// Selected tags para sa filtering
    @Published var selectedTags: Set<Tag> = []
    /// Selected languages para sa filtering
    @Published var selectedLanguages: Set<String> = []
    /// Current sort option
    @Published var sortOption: SortOption = .dateNewest
    /// Search text para sa filtering
    @Published var searchText: String = ""
    
    // MARK: - Computed Properties
    
    /// Check kung may active filters
    var hasActiveFilters: Bool {
        !selectedTags.isEmpty || !selectedLanguages.isEmpty || !searchText.isEmpty
    }
    
    // MARK: - Methods
    
    /// Clear lahat ng active filters
    func clearFilters() {
        selectedTags.removeAll()
        selectedLanguages.removeAll()
        searchText = ""
    }
    
    /// Generate sort descriptors based sa current options
    var sortDescriptor: [NSSortDescriptor] {
        var descriptors: [NSSortDescriptor] = []
        
        // Always add favorites sort if it's the selected option
        if sortOption == .favorites {
            descriptors.append(NSSortDescriptor(keyPath: \Snippet.isFavorite, ascending: false))
            descriptors.append(NSSortDescriptor(keyPath: \Snippet.createdAt, ascending: false))
        } else {
            switch sortOption {
            case .dateNewest:
                descriptors = [NSSortDescriptor(keyPath: \Snippet.createdAt, ascending: false)]
            case .dateOldest:
                descriptors = [NSSortDescriptor(keyPath: \Snippet.createdAt, ascending: true)]
            case .titleAZ:
                descriptors = [NSSortDescriptor(keyPath: \Snippet.title, ascending: true)]
            case .titleZA:
                descriptors = [NSSortDescriptor(keyPath: \Snippet.title, ascending: false)]
            case .favorites:
                break // Already handled above
            }
        }
        
        return descriptors
    }
    
    /// Generate predicate para sa filtering
    /// Combines tag, language, at search filters
    func predicate(searchText: String) -> NSPredicate? {
        var predicates: [NSPredicate] = []
        
        if !selectedTags.isEmpty {
            let tagPredicates = selectedTags.map { tag in
                NSPredicate(format: "ANY tags == %@", tag)
            }
            predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: tagPredicates))
        }
        
        if !selectedLanguages.isEmpty {
            predicates.append(NSPredicate(format: "language IN %@", selectedLanguages))
        }
        
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@ OR code CONTAINS[cd] %@", 
                                       searchText, searchText))
        }
        
        if predicates.isEmpty {
            return nil
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
} 
import SwiftUI

// MARK: - Filter View
/// Main view para sa filtering at sorting ng snippets
/// Nag-ha-handle ng sort options, language filters, at tag filters
struct FilterView: View {
    // MARK: - Properties
    
    /// Filter options object
    @ObservedObject var filterOptions: FilterSortOptions
    /// Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    /// Fetched tags from Core Data
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)])
    private var tags: FetchedResults<Tag>
    /// Dismiss action
    @Environment(\.dismiss) private var dismiss
    
    /// Supported programming languages
    let languages = ["swift", "python", "html"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Sort Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sort By")
                                .font(FontStyle.headline)
                                .foregroundColor(Theme.commentGray)
                            
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Button(action: {
                                    withAnimation(.spring()) {
                                        filterOptions.sortOption = option
                                    }
                                }) {
                                    HStack {
                                        Text(option.rawValue)
                                            .font(FontStyle.body)
                                            .foregroundColor(.white)
                                        Spacer()
                                        if filterOptions.sortOption == option {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Theme.accentBlue)
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(filterOptions.sortOption == option ? 
                                                  Theme.cardSurface.opacity(0.5) : 
                                                  Color.clear)
                                    )
                                }
                            }
                        }
                        .padding()
                        .background(Theme.cardSurface)
                        .cornerRadius(12)
                        
                        // Language Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Filter by Language")
                                .font(FontStyle.headline)
                                .foregroundColor(Theme.commentGray)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(languages, id: \.self) { language in
                                        FilterChip(
                                            title: language.capitalized,
                                            isSelected: filterOptions.selectedLanguages.contains(language),
                                            action: {
                                                if filterOptions.selectedLanguages.contains(language) {
                                                    filterOptions.selectedLanguages.remove(language)
                                                } else {
                                                    filterOptions.selectedLanguages.insert(language)
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Theme.cardSurface)
                        .cornerRadius(12)
                        
                        // Tags Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Filter by Tags")
                                .font(FontStyle.headline)
                                .foregroundColor(Theme.commentGray)
                            
                            if tags.isEmpty {
                                Text("No tags available")
                                    .font(FontStyle.caption)
                                    .foregroundColor(Theme.commentGray)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(tags) { tag in
                                            FilterChip(
                                                title: tag.tagName,
                                                isSelected: filterOptions.selectedTags.contains(tag),
                                                action: {
                                                    if filterOptions.selectedTags.contains(tag) {
                                                        filterOptions.selectedTags.remove(tag)
                                                    } else {
                                                        filterOptions.selectedTags.insert(tag)
                                                    }
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Theme.cardSurface)
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle("Filter & Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        withAnimation(.spring()) {
                            filterOptions.clearFilters()
                        }
                    }
                    .foregroundColor(Theme.pinkAccent)
                }
            }
        }
    }
}

// MARK: - Filter Chip Component
/// Reusable component para sa filter selection
/// Nag-di-display ng selectable chips with active state
struct FilterChip: View {
    // MARK: - Properties
    
    /// Title ng filter chip
    let title: String
    /// Selected state
    let isSelected: Bool
    /// Action kapag na-tap
    let action: () -> Void
    
    // MARK: - View Body
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(FontStyle.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Theme.accentBlue : Theme.cardSurface)
                .foregroundColor(isSelected ? .white : Theme.commentGray)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Theme.accentBlue : Theme.commentGray, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
} 
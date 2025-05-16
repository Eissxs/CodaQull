import SwiftUI
import CoreData

// MARK: - Snippet List View
/// Main view para sa list ng lahat ng code snippets
/// Nag-ha-handle ng display, filtering, at navigation
struct SnippetListView: View {
    // MARK: - Properties
    
    /// Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    /// Filter at sort options
    @StateObject private var filterOptions = FilterSortOptions()
    /// State para sa add snippet sheet
    @State private var showingAddSnippet = false
    /// State para sa filters sheet
    @State private var showingFilters = false
    /// Current scroll position
    @State private var scrollOffset: CGFloat = 0
    /// ID para sa view refresh
    @State private var refreshID = UUID()
    
    // MARK: - View Body
    /// Main layout ng snippet list
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                // MARK: - Scroll Position Tracking
                /// Track scroll position para sa UI updates
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geometry.frame(in: .named("scroll")).minY
                    )
                }
                .frame(height: 0)
                
                LazyVStack(spacing: 16) {
                    // MARK: - Active Filters Display
                    /// Show current active filters at clear button
                    if filterOptions.hasActiveFilters {
                        HStack {
                            Text("Active Filters")
                                .font(FontStyle.caption)
                                .foregroundColor(Theme.commentGray)
                            
                            Spacer()
                            
                            Button("Clear All") {
                                withAnimation(.spring()) {
                                    filterOptions.clearFilters()
                                }
                            }
                            .font(FontStyle.caption)
                            .foregroundColor(Theme.accentBlue)
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // MARK: - Filtered List
                    /// Display filtered snippets using FilteredSnippetList
                    FilteredSnippetList(filterOptions: filterOptions)
                }
                .padding(.vertical)
            }
            .coordinateSpace(name: "scroll")
            .navigationTitle("Snippets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSnippet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSnippet) {
                AddSnippetView()
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(filterOptions: filterOptions)
            }
        }
        .id(refreshID)
        .onReceive(NotificationCenter.default.publisher(for: .snippetChanged)) { _ in
            refreshID = UUID()
        }
    }
}

// MARK: - Scroll Offset Preference Key
/// Helper para sa scroll position tracking
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Filtered Snippet List
/// Component para sa filtered at sorted snippet display
struct FilteredSnippetList: View {
    // MARK: - Properties
    
    /// Filter options binding
    @ObservedObject var filterOptions: FilterSortOptions
    /// Fetched snippets from Core Data
    @FetchRequest private var snippets: FetchedResults<Snippet>
    /// ID para sa list refresh
    @State private var refreshID = UUID()
    
    // MARK: - Initialization
    
    /// Setup ng fetch request based sa filters
    init(filterOptions: FilterSortOptions) {
        self.filterOptions = filterOptions
        
        let finalPredicate = filterOptions.predicate(searchText: filterOptions.searchText)
        
        _snippets = FetchRequest(
            sortDescriptors: filterOptions.sortDescriptor,
            predicate: finalPredicate,
            animation: .default
        )
    }
    
    // MARK: - View Body
    /// Display filtered snippets or empty state
    var body: some View {
        Group {
            if snippets.isEmpty {
                // MARK: - Empty State
                /// Display kapag walang snippets na match sa filters
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 64))
                        .foregroundColor(Theme.commentGray)
                    Text("No snippets found")
                        .font(FontStyle.headline)
                        .foregroundColor(Theme.commentGray)
                    Text("Try adjusting your filters")
                        .font(FontStyle.caption)
                        .foregroundColor(Theme.commentGray)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .transition(.opacity)
            } else {
                // MARK: - Snippet List
                /// Display list ng filtered snippets
                ForEach(snippets) { snippet in
                    NavigationLink(destination: SnippetDetailView(snippet: snippet)) {
                        SnippetCardView(snippet: snippet)
                    }
                }
                .padding(.horizontal)
            }
        }
        // MARK: - Filter Updates
        /// Refresh list kapag may changes sa filters
        .onReceive(filterOptions.$sortOption) { _ in
            refreshID = UUID()
        }
        .onReceive(filterOptions.$selectedTags) { _ in
            refreshID = UUID()
        }
        .onReceive(filterOptions.$selectedLanguages) { _ in
            refreshID = UUID()
        }
        .onReceive(filterOptions.$searchText) { _ in
            refreshID = UUID()
        }
    }
}

// MARK: - Preview Provider
/// Preview configuration para sa development
struct SnippetListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SnippetListView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
} 
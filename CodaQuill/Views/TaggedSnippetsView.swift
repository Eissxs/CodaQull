import SwiftUI

// MARK: - Tagged Snippets View
/// Main view para sa display ng snippets with specific tag
/// Nag-ha-handle ng filtered snippet list at tag management
struct TaggedSnippetsView: View {
    // MARK: - Properties
    
    /// Tag na ginagamit para sa filtering
    let tag: Tag
    /// Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    /// Fetched snippets with this tag
    @FetchRequest private var snippets: FetchedResults<Snippet>
    /// Current scroll position
    @State private var scrollOffset: CGFloat = 0
    
    // MARK: - Initialization
    
    /// Setup fetch request para sa snippets with specific tag
    init(tag: Tag) {
        self.tag = tag
        _snippets = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Snippet.createdAt, ascending: false)],
            predicate: NSPredicate(format: "ANY tags == %@", tag),
            animation: .default
        )
    }
    
    // MARK: - View Body
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geometry.frame(in: .named("scroll")).minY
                    )
                }
                .frame(height: 0)
                
                LazyVStack(spacing: 16) {
                    // Header Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(snippets.count) snippet\(snippets.count == 1 ? "" : "s")")
                            .font(FontStyle.headline)
                            .foregroundColor(Theme.commentGray)
                        
                        Text(tag.tagName)
                            .font(FontStyle.title)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    if snippets.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 64))
                                .foregroundColor(Theme.commentGray)
                            Text("No snippets with this tag")
                                .font(FontStyle.headline)
                                .foregroundColor(Theme.commentGray)
                            Text("Add this tag to some snippets to see them here")
                                .font(FontStyle.caption)
                                .foregroundColor(Theme.commentGray)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .transition(.opacity)
                    } else {
                        ForEach(snippets) { snippet in
                            NavigationLink(destination: SnippetDetailView(snippet: snippet)) {
                                SnippetCardView(snippet: snippet)
                                    .transition(.asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .opacity
                                    ))
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    withAnimation {
                                        removeTagFromSnippet(snippet)
                                    }
                                } label: {
                                    Label("Remove Tag", systemImage: "tag.slash")
                                }
                                
                                Button(role: .destructive) {
                                    withAnimation {
                                        deleteSnippet(snippet)
                                    }
                                } label: {
                                    Label("Delete Snippet", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .coordinateSpace(name: "scroll")
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Helper Functions
    
    /// Remove tag from specific snippet
    private func removeTagFromSnippet(_ snippet: Snippet) {
        var updatedTags = snippet.snippetTags
        updatedTags.remove(tag)
        snippet.snippetTags = updatedTags
        
        do {
            try viewContext.save()
        } catch {
            print("Error removing tag from snippet: \(error)")
        }
    }
    
    /// Delete snippet from storage
    private func deleteSnippet(_ snippet: Snippet) {
        withAnimation {
            viewContext.delete(snippet)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting snippet: \(error)")
            }
        }
    }
}

// MARK: - Preview Provider
/// Preview configuration para sa development
struct TaggedSnippetsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let tag = Tag(context: context)
        tag.name = "Example Tag"
        
        return NavigationView {
            TaggedSnippetsView(tag: tag)
                .environment(\.managedObjectContext, context)
        }
    }
} 
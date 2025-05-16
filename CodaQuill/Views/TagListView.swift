import SwiftUI
import CoreData

// MARK: - Tag List View
/// Main view para sa management ng tags
/// Nag-ha-handle ng display, creation, at deletion ng tags
struct TagListView: View {
    // MARK: - Properties
    
    /// Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    
    /// Fetched tags from Core Data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    /// State para sa add tag alert
    @State private var showingAddTag = false
    /// New tag name input
    @State private var newTagName = ""
    
    // MARK: - View Body
    /// Main layout ng tag list
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            if tags.isEmpty {
                // MARK: - Empty State
                /// Display kapag walang tags
                VStack(spacing: 12) {
                    Image(systemName: "tag.circle")
                        .font(.system(size: 64))
                        .foregroundColor(Theme.commentGray)
                    Text("No Tags")
                        .font(FontStyle.headline)
                        .foregroundColor(Theme.commentGray)
                    Text("Add tags to organize your snippets")
                        .font(FontStyle.caption)
                        .foregroundColor(Theme.commentGray)
                        .multilineTextAlignment(.center)
                }
            } else {
                // MARK: - Tag List
                /// Scrollable list ng existing tags
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(tags) { tag in
                            TagRowView(tag: tag)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        deleteTag(tag)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Tags")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddTag = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("New Tag", isPresented: $showingAddTag) {
            TextField("Tag name", text: $newTagName)
            Button("Cancel", role: .cancel) {
                newTagName = ""
            }
            Button("Add") {
                addTag()
            }
        } message: {
            Text("Enter a name for the new tag")
        }
    }
    
    // MARK: - Helper Functions
    
    /// Create new tag with given name
    private func addTag() {
        guard !newTagName.isEmpty else { return }
        
        withAnimation {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
            
            do {
                try viewContext.save()
                newTagName = ""
            } catch {
                print("Error saving tag: \(error)")
            }
        }
    }
    
    /// Delete existing tag
    private func deleteTag(_ tag: Tag) {
        withAnimation {
            viewContext.delete(tag)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting tag: \(error)")
            }
        }
    }
}

// MARK: - Tag Row View
/// Individual row para sa tag display
struct TagRowView: View {
    // MARK: - Properties
    
    /// Tag na i-di-display
    let tag: Tag
    /// Fetched snippets na may ganitong tag
    @FetchRequest private var snippets: FetchedResults<Snippet>
    
    // MARK: - Initialization
    
    /// Setup fetch request para sa snippets with this tag
    init(tag: Tag) {
        self.tag = tag
        _snippets = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Snippet.createdAt, ascending: false)],
            predicate: NSPredicate(format: "ANY tags == %@", tag),
            animation: .default
        )
    }
    
    // MARK: - View Body
    /// Layout ng individual tag row
    var body: some View {
        NavigationLink(destination: TaggedSnippetsView(tag: tag)) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(tag.tagName)
                        .font(FontStyle.headline)
                        .foregroundColor(.white)
                    Text("\(snippets.count) snippet\(snippets.count == 1 ? "" : "s")")
                        .font(FontStyle.caption)
                        .foregroundColor(Theme.commentGray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(FontStyle.caption)
                    .foregroundColor(Theme.commentGray)
            }
            .padding()
            .background(Theme.cardSurface)
            .cornerRadius(12)
        }
    }
}

// MARK: - Preview Provider
/// Preview configuration para sa development
struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TagListView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
} 
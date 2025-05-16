import SwiftUI

// MARK: - Add Snippet View
/// Main view para sa creation ng bagong code snippet
/// Nag-ha-handle ng input fields at saving ng new snippet
struct AddSnippetView: View {
    // MARK: - Properties
    
    /// Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    /// Dismiss action
    @Environment(\.dismiss) private var dismiss
    
    /// Input fields para sa new snippet
    @State private var title = ""
    @State private var code = ""
    @State private var language = "swift"
    @State private var notes = ""
    @State private var selectedTags: Set<Tag> = []
    @State private var showingTagSelection = false
    
    /// Fetched tags from Core Data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    /// Supported programming languages
    let languages = ["swift", "python", "html"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    Picker("Language", selection: $language) {
                        ForEach(languages, id: \.self) { lang in
                            Text(lang.capitalized)
                        }
                    }
                }
                
                Section(header: Text("Code")) {
                    TextEditor(text: $code)
                        .frame(minHeight: 100)
                        .font(FontStyle.codeText)
                }
                
                Section(header: Text("Notes (Optional)")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                Section(header: Text("Tags")) {
                    Button(action: { showingTagSelection = true }) {
                        HStack {
                            Text(selectedTags.isEmpty ? "Add Tags" : "\(selectedTags.count) selected")
                                .foregroundColor(selectedTags.isEmpty ? .blue : .primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Theme.commentGray)
                        }
                    }
                    
                    if !selectedTags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(selectedTags)) { tag in
                                    Text(tag.tagName)
                                        .font(FontStyle.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Theme.accentBlue.opacity(0.2))
                                        .foregroundColor(Theme.accentBlue)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Snippet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSnippet()
                    }
                    .disabled(title.isEmpty || code.isEmpty)
                }
            }
            .sheet(isPresented: $showingTagSelection) {
                TagSelectionView(selectedTags: $selectedTags)
            }
        }
    }
    
    /// Save new snippet sa Core Data
    /// Creates initial version at i-save ang snippet with tags
    private func saveSnippet() {
        let snippet = Snippet(context: viewContext)
        snippet.id = UUID()
        snippet.title = title
        snippet.code = code
        snippet.language = language
        snippet.notes = notes
        snippet.createdAt = Date()
        snippet.updatedAt = Date()
        snippet.snippetTags = selectedTags
        
        // Create initial version
        let initialVersion = SnippetVersion(context: viewContext)
        initialVersion.id = UUID()
        initialVersion.title = title
        initialVersion.code = code
        initialVersion.notes = notes
        initialVersion.language = language
        initialVersion.createdAt = Date()
        initialVersion.snippet = snippet
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving snippet: \(error)")
        }
    }
}

// MARK: - Tag Selection View
/// View para sa pag-select at pag-add ng tags
struct TagSelectionView: View {
    // MARK: - Properties
    
    /// Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    /// Dismiss action
    @Environment(\.dismiss) private var dismiss
    /// Selected tags binding
    @Binding var selectedTags: Set<Tag>
    
    /// Fetched tags from Core Data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    /// State para sa add tag dialog
    @State private var showingAddTag = false
    @State private var newTagName = ""
    
    var body: some View {
        NavigationView {
            List {
                if tags.isEmpty {
                    Text("No tags available")
                        .foregroundColor(Theme.commentGray)
                } else {
                    ForEach(tags) { tag in
                        Button(action: {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }) {
                            HStack {
                                Text(tag.tagName)
                                Spacer()
                                if selectedTags.contains(tag) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Theme.accentBlue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Tags")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
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
    }
    
    private func addTag() {
        guard !newTagName.isEmpty else { return }
        
        withAnimation {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
            
            do {
                try viewContext.save()
                selectedTags.insert(tag)
                newTagName = ""
            } catch {
                print("Error saving tag: \(error)")
            }
        }
    }
}

// MARK: - Preview Provider
/// Preview configuration para sa development
struct AddSnippetView_Previews: PreviewProvider {
    static var previews: some View {
        AddSnippetView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
} 
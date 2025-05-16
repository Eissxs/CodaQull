import SwiftUI

// MARK: - Edit Snippet View
/// Main view para sa pag-edit ng existing snippet
/// Nag-ha-handle ng modification at version tracking
struct EditSnippetView: View {
    // MARK: - Properties
    
    /// Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    /// Dismiss action
    @Environment(\.dismiss) private var dismiss
    
    /// Snippet na ie-edit
    let snippet: Snippet
    
    /// Input fields para sa edited values
    @State private var title: String
    @State private var code: String
    @State private var language: String
    @State private var notes: String
    @State private var selectedTags: Set<Tag>
    @State private var showingTagSelection = false
    /// ID para sa view refresh
    @State private var refreshID = UUID()
    
    /// Supported programming languages
    let languages = ["swift", "python", "html"]
    
    // MARK: - Initialization
    
    /// Setup initial values from existing snippet
    init(snippet: Snippet) {
        self.snippet = snippet
        _title = State(initialValue: snippet.snippetTitle)
        _code = State(initialValue: snippet.snippetCode)
        _language = State(initialValue: snippet.snippetLanguage)
        _notes = State(initialValue: snippet.snippetNotes)
        _selectedTags = State(initialValue: snippet.snippetTags)
    }
    
    // MARK: - View Body
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
                        .font(.system(.body, design: .monospaced))
                        .frame(minHeight: 200)
                }
                
                Section(header: Text("Notes")) {
                    MarkdownTextView(
                        text: notes,
                        isEditable: true,
                        onTextChange: { newNotes in
                            notes = newNotes
                        }
                    )
                    .frame(minHeight: 100)
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
            .navigationTitle("Edit Snippet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges(createVersion: true)
                        dismiss()
                    }
                    .disabled(title.isEmpty || code.isEmpty)
                }
            }
            .sheet(isPresented: $showingTagSelection) {
                TagSelectionView(selectedTags: $selectedTags)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /// Save changes at create new version
    /// I-update ang snippet at optional na mag-create ng version record
    private func saveChanges(createVersion: Bool) {
        if createVersion {
            // Create a version of the current state before making changes
            let newVersion = SnippetVersion(context: viewContext)
            newVersion.id = UUID()
            newVersion.title = snippet.snippetTitle
            newVersion.code = snippet.snippetCode
            newVersion.notes = snippet.snippetNotes
            newVersion.language = snippet.snippetLanguage
            newVersion.createdAt = Date()
            newVersion.snippet = snippet
        }
        
        // Update the snippet with new values
        snippet.title = title
        snippet.code = code
        snippet.language = language
        snippet.notes = notes
        snippet.updatedAt = Date()
        snippet.snippetTags = selectedTags
        
        do {
            try viewContext.save()
            // Trigger refresh
            refreshID = UUID()
            NotificationCenter.default.post(name: .snippetChanged, object: nil)
        } catch {
            print("Error saving changes: \(error)")
        }
    }
}

// MARK: - Preview Provider
/// Preview configuration para sa development
struct EditSnippetView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let snippet = Snippet(context: context)
        snippet.title = "Example Snippet"
        snippet.code = "print(\"Hello, World!\")"
        snippet.language = "swift"
        
        return EditSnippetView(snippet: snippet)
            .environment(\.managedObjectContext, context)
    }
} 
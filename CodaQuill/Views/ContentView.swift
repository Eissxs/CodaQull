import SwiftUI
import CoreData

// MARK: - Main Content View
/// Root view ng application na nag-handle ng main navigation
/// Nag-o-organize ng major features sa tab-based layout
struct ContentView: View {
    // MARK: - Properties
    
    /// Core Data context para sa data management
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - View Body
    /// Main layout ng app using TabView
    var body: some View {
        // MARK: - ⚠️ Experimental Feature
        /// TODO: Tab colors at themes ay need pa i-enhance
        /// Current implementation ay may limitations sa color adaptation
        /// Need i-integrate sa global theme system
        TabView {
            // MARK: - Snippets Tab
            /// Main snippets list at management
            NavigationView {
                SnippetListView()
            }
            .tabItem {
                Label("Snippets", systemImage: "doc.text")
            }
            
            // MARK: - Tags Tab
            /// Tag organization at filtering
            NavigationView {
                TagListView()
            }
            .tabItem {
                Label("Tags", systemImage: "tag")
            }
            
            // MARK: - Settings Tab
            /// App configuration at preferences
            /// Note: Dark mode settings dito ay experimental pa
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .accentColor(Theme.accentBlue)
    }
}

// MARK: - Preview Provider
/// Preview configuration para sa development
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
} 
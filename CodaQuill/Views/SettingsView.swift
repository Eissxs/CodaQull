import SwiftUI

// MARK: - Settings View
/// Main settings screen ng application
/// Nag-ha-handle ng user preferences at app information
struct SettingsView: View {
    // MARK: - Properties
    
    // MARK: - ⚠️ Experimental Feature
    /// TODO: Theme manager integration ay hindi pa fully functional
    /// Current implementation may issues sa real-time updates
    /// Need pa i-enhance ang color adaptation at persistence
    @StateObject private var themeManager = ThemeManager.shared
    
    // MARK: - View Body
    /// Main layout ng settings screen
    var body: some View {
        List {
            // MARK: - App Info Section
            /// Header section with app logo at version
            Section {
                VStack(spacing: 20) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("CodaQuill")
                        .font(.system(.title, design: .rounded).bold())
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("v1.2")
                        .font(FontStyle.caption)
                        .foregroundColor(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .listRowBackground(Theme.cardSurface)
            }
            
            // MARK: - Appearance Section
            /// TODO: Dark mode toggle ay may known issues:
            /// - Hindi instant ang color updates
            /// - May UI glitches sa transition
            /// - Need i-fix ang state persistence
            Section(header: Text("Appearance").foregroundColor(Theme.textSecondary)) {
                Toggle(isOn: $themeManager.isDarkMode) {
                    HStack {
                        Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(Theme.accentBlue)
                        Text("Dark Mode")
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                .listRowBackground(Theme.cardSurface)
            }
            
            // MARK: - Notifications Section
            /// Daily reminder settings
            Section(header: Text("Notifications").foregroundColor(Theme.textSecondary)) {
                Button(action: {
                    NotificationManager.shared.requestPermissions()
                }) {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(Theme.accentBlue)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Daily Reminder")
                                .font(FontStyle.headline)
                                .foregroundColor(Theme.textPrimary)
                            Text("Get notified at 10 AM daily")
                                .font(FontStyle.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                }
                .listRowBackground(Theme.cardSurface)
            }
            
            // MARK: - About Section
            /// Developer information at app description
            Section(header: Text("About").foregroundColor(Theme.textSecondary)) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Developer")
                        .font(FontStyle.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text("Eissxs")
                        .font(FontStyle.body)
                        .foregroundColor(Theme.textPrimary)
                }
                .padding(.vertical, 4)
                .listRowBackground(Theme.cardSurface)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Description")
                        .font(FontStyle.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text("A beautiful code snippet manager with version control and execution capabilities.")
                        .font(FontStyle.body)
                        .foregroundColor(Theme.textPrimary)
                }
                .padding(.vertical, 4)
                .listRowBackground(Theme.cardSurface)
            }
            
            // MARK: - Features Section
            /// List ng main features ng app
            Section(header: Text("Features").foregroundColor(Theme.textSecondary)) {
                FeatureRow(icon: "tag", title: "Tags", description: "Organize snippets with custom tags")
                FeatureRow(icon: "clock.arrow.circlepath", title: "Version History", description: "Track changes and restore previous versions")
                FeatureRow(icon: "play.circle", title: "Code Execution", description: "Run Swift code in a sandbox environment")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Settings")
    }
}

// MARK: - Feature Row Component
/// Reusable row para sa feature display
struct FeatureRow: View {
    // MARK: - Properties
    
    /// Icon name para sa feature
    let icon: String
    /// Title ng feature
    let title: String
    /// Short description ng feature
    let description: String
    
    // MARK: - View Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Theme.accentBlue)
                Text(title)
                    .font(FontStyle.headline)
                    .foregroundColor(Theme.textPrimary)
            }
            Text(description)
                .font(FontStyle.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .padding(.vertical, 4)
        .listRowBackground(Theme.cardSurface)
    }
}

// MARK: - Preview Provider
/// Preview configuration para sa development
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
} 
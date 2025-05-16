import SwiftUI

// MARK: - Theme Manager Class
/// Main na controller para sa theme system ng app
/// Nag-ha-handle ng dark at light mode switching
/// Ginagamit ang UserDefaults para i-persist ang user preferences
class ThemeManager: ObservableObject {
    // MARK: - Properties
    
    /// Bool na nag-track kung dark mode ba o hindi
    /// Nag-a-auto save sa UserDefaults kapag nag-change
    /// Nag-no-notify sa observers kapag may changes
    @Published var isDarkMode: Bool {
        didSet {
            // Save sa UserDefaults at mag-notify ng changes
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
            NotificationCenter.default.post(name: .themeChanged, object: nil)
        }
    }
    
    // MARK: - Initialization
    
    /// Setup ng initial theme state
    /// Default is dark mode kung walang saved preference
    /// Nag-lo-load ng existing preference kung meron
    init() {
        // Check kung may existing preference
        if !UserDefaults.standard.contains(key: "isDarkMode") {
            // Set dark mode as default
            UserDefaults.standard.set(true, forKey: "isDarkMode")
        }
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    // MARK: - Singleton Instance
    
    /// Shared instance para sa global access
    /// Ginagamit para consistent ang theme sa buong app
    static let shared = ThemeManager()
}

// MARK: - UserDefaults Extension
/// Extension para sa helper functions ng UserDefaults
/// Nag-a-add ng convenience methods para sa theme management
extension UserDefaults {
    /// Check kung may existing value sa given key
    /// - Parameter key: Key na che-check sa UserDefaults
    /// - Returns: True kung may value, false kung wala
    func contains(key: String) -> Bool {
        return object(forKey: key) != nil
    }
}

// MARK: - Notification Extension
/// Custom notification names para sa theme changes
/// Ginagamit para mag-broadcast ng theme updates sa buong app
extension Notification.Name {
    /// Notification na sine-send kapag nag-change ang theme
    /// Ginagamit ng observers para mag-update ng UI
    static let themeChanged = Notification.Name("themeChanged")
}
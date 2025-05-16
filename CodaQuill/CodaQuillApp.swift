//
//  CodaQuillApp.swift
//  CodaQuill
//
//  Created by Michael Eissen San Antonio on 5/11/25.
//

import SwiftUI
import CoreData

// MARK: - Main App Structure
/// Main entry point ng CodaQuill app
/// Nag-ha-handle ng initialization at root view hierarchy
@main
struct CodaQuillApp: App {
    // MARK: - Properties
    
    /// Shared instance para sa CoreData persistence
    let persistenceController = PersistenceController.shared
    
    /// State para sa splash screen visibility
    @State private var showSplash = true
    
    /// Flag para sa onboarding completion tracking
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    /// State para sa onboarding screen visibility
    @State private var showOnboarding = false

    // MARK: - Body Scene
    /// Main scene configuration ng app
    var body: some Scene {
        WindowGroup {
            ZStack {
                // MARK: - ⚠️ Experimental Feature
                /// TODO: Dark/Light mode switching ay hindi pa fully functional
                /// Current implementation ay naka-force sa dark mode
                /// Need pa i-integrate sa ThemeManager properly
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .preferredColorScheme(.dark) // Default to dark mode
                
                // Splash screen overlay
                if showSplash {
                    SplashScreenView()
                        .transition(.opacity)
                }
                
                // Onboarding overlay
                if showOnboarding {
                    OnboardingView(isOnboardingPresented: $showOnboarding)
                        .transition(.opacity)
                }
            }
            .onAppear {
                // Initial app setup at transitions
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        // Hide splash screen after delay
                        showSplash = false
                        
                        // Check at display onboarding kung first time
                        if !hasCompletedOnboarding {
                            showOnboarding = true
                            hasCompletedOnboarding = true
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Persistence Controller
/// Handler para sa CoreData operations at setup
class PersistenceController {
    /// Shared instance para sa global access
    static let shared = PersistenceController()
    
    /// CoreData container instance
    let container: NSPersistentContainer
    
    /// Initialization ng CoreData stack
    init() {
        container = NSPersistentContainer(name: "CodaQuill")
        
        // Load at setup ng persistent store
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // Configure automatic merging at conflict resolution
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

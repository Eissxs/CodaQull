import SwiftUI

// MARK: - Onboarding Feature Model
/// Model para sa individual feature cards
struct OnboardingFeature: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
}

// MARK: - Onboarding View
/// Main onboarding screen ng app
/// Nag-ha-handle ng first-time user experience
struct OnboardingView: View {
    // MARK: - Properties
    
    /// Binding para sa onboarding visibility
    @Binding var isOnboardingPresented: Bool
    /// Current page index
    @State private var currentPage = 0
    
    /// List ng features na i-di-display
    let features = [
        OnboardingFeature(
            title: "Code Snippets",
            description: "Save and organize your code snippets with syntax highlighting and tags",
            icon: "doc.text.fill",
            color: Theme.accentBlue
        ),
        OnboardingFeature(
            title: "Version History",
            description: "Track changes and restore previous versions of your snippets",
            icon: "clock.arrow.circlepath",
            color: Theme.pinkAccent
        ),
        OnboardingFeature(
            title: "Code Execution",
            description: "Run and test your Swift code directly in the app",
            icon: "play.circle.fill",
            color: Theme.accentBlue
        )
    ]
    
    // MARK: - View Body
    /// Main layout ng onboarding screen
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header Section
                /// App logo at welcome message
                VStack(spacing: 20) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                    
                    Text("Welcome to CodaQuill")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                // MARK: - Feature Pages
                /// Swipeable feature cards
                TabView(selection: $currentPage) {
                    ForEach(features.indices, id: \.self) { index in
                        FeatureCard(feature: features[index])
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // MARK: - Page Indicator
                /// Dots para sa current page indicator
                HStack(spacing: 8) {
                    ForEach(features.indices, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Theme.accentBlue : Theme.cardSurface)
                            .frame(width: 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // MARK: - Get Started Button
                /// Button para tapusin ang onboarding
                Button(action: {
                    withAnimation {
                        isOnboardingPresented = false
                    }
                }) {
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded).bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Theme.accentBlue, Theme.pinkAccent]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Theme.accentBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

// MARK: - Feature Card View
/// Individual card para sa feature display
struct FeatureCard: View {
    // MARK: - Properties
    
    /// Feature details na i-di-display
    let feature: OnboardingFeature
    
    // MARK: - View Body
    /// Layout ng individual feature card
    var body: some View {
        VStack(spacing: 30) {
            // MARK: - Feature Icon
            /// Circular icon display
            ZStack {
                Circle()
                    .fill(feature.color.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 40))
                    .foregroundColor(feature.color)
            }
            
            // MARK: - Feature Text
            /// Title at description ng feature
            VStack(spacing: 12) {
                Text(feature.title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(feature.description)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(Theme.commentGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
} 
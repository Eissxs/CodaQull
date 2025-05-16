import SwiftUI

// MARK: - Splash Screen View
/// Initial loading screen ng app
/// Nag-ha-handle ng launch animations at transitions
struct SplashScreenView: View {
    // MARK: - Animation Properties
    
    /// Scale ng logo
    @State private var logoScale = 0.9
    /// Opacity ng logo
    @State private var logoOpacity = 0.0
    /// Opacity ng text elements
    @State private var textOpacity = 0.0
    /// Vertical offset ng text
    @State private var textOffset: CGFloat = 20
    /// Flag para sa loading bar visibility
    @State private var showLoadingBar = false
    /// Progress value ng loading bar
    @State private var loadingProgress: CGFloat = 0.0
    /// Blur effect sa logo
    @State private var blurRadius: CGFloat = 10
    /// Rotation ng logo
    @State private var logoRotation: CGFloat = -10
    /// Flag para sa ongoing animations
    @State private var isAnimating = false
    
    // MARK: - Ripple Effect Properties
    /// Multiple ripple animation states
    @State private var rippleScales: [CGFloat] = [0.8, 0.8, 0.8, 0.8]
    @State private var rippleOpacities: [Double] = [0.5, 0.4, 0.3, 0.2]
    
    // MARK: - View Body
    /// Main layout ng splash screen
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            // MARK: - Background
            /// Modern gradient background effect
            LinearGradient(
                gradient: Gradient(colors: [
                    Theme.background,
                    Theme.accentBlue.opacity(0.1),
                    Theme.background
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // MARK: - Logo Section
                /// Animated logo with ripple effects
                ZStack {
                    // MARK: - Ripple Effects
                    /// Multiple animated circles para sa ripple effect
                    ForEach(0..<4) { index in
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Theme.accentBlue.opacity(0.3),
                                        Theme.pinkAccent.opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                            .scaleEffect(rippleScales[index])
                            .opacity(rippleOpacities[index])
                            .animation(
                                Animation.easeInOut(duration: 3)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.5),
                                value: rippleScales[index]
                            )
                    }
                    
                    // MARK: - App Logo
                    /// Main app logo with animations
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .scaleEffect(logoScale)
                        .rotationEffect(.degrees(logoRotation))
                        .opacity(logoOpacity)
                        .blur(radius: blurRadius)
                }
                .frame(width: 300, height: 300)
                
                // MARK: - Text Section
                /// App name at tagline
                VStack(spacing: 12) {
                    Text("CodaQuill")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(textOpacity)
                        .offset(y: textOffset)
                    
                    Text("Code Beautifully")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.commentGray)
                        .opacity(textOpacity)
                        .offset(y: textOffset)
                }
                
                // MARK: - Loading Bar
                /// Animated progress indicator
                if showLoadingBar {
                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Theme.cardSurface)
                            .frame(width: 120, height: 2)
                        
                        // Progress indicator
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Theme.accentBlue, Theme.pinkAccent]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 120 * loadingProgress, height: 2)
                            .animation(.easeInOut(duration: 0.6), value: loadingProgress)
                    }
                    .opacity(textOpacity)
                }
            }
        }
        // MARK: - Animation Sequence
        /// Start animations pag-appear ng view
        .onAppear {
            // Start ripple animations
            for index in 0..<4 {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: false).delay(Double(index) * 0.5)) {
                    rippleScales[index] = 1.8
                    rippleOpacities[index] = 0
                }
            }
            
            // Logo animations
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                logoScale = 1
                logoOpacity = 1
                blurRadius = 0
                logoRotation = 0
            }
            
            // Text animations
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                textOpacity = 1
                textOffset = 0
            }
            
            // Loading bar animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showLoadingBar = true
                withAnimation(.easeInOut(duration: 1.5)) {
                    loadingProgress = 1.0
                }
            }
        }
    }
} 
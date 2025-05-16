import SwiftUI

// MARK: - Code Execution View
/// View para sa pag-execute ng Swift code
/// Nag-ha-handle ng code running at result display
struct CodeExecutionView: View {
    // MARK: - Properties
    
    /// Code na i-e-execute
    let code: String
    /// Output ng code execution
    @State private var output: String = ""
    /// Error message kung may error
    @State private var error: String = ""
    /// Flag kung nag-e-execute pa
    @State private var isExecuting = false
    
    // MARK: - View Body
    /// Main layout ng execution view
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Output Section
            /// Display ng successful execution output
            if !output.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Output")
                        .font(FontStyle.headline)
                        .foregroundColor(Theme.commentGray)
                    
                    Text(output)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(Theme.stringTeal)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.cardSurface)
                        .cornerRadius(8)
                }
            }
            
            // MARK: - Error Section
            /// Display ng error messages
            if !error.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Error")
                        .font(FontStyle.headline)
                        .foregroundColor(Theme.commentGray)
                    
                    Text(error)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(Theme.pinkAccent)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.cardSurface)
                        .cornerRadius(8)
                }
            }
            
            // MARK: - ⚠️ Experimental Feature
            /// TODO: Code execution button ay may mga issues:
            /// - May delay sa execution start
            /// - Hindi optimal ang error handling
            /// - Need i-improve ang execution feedback
            Button(action: executeCode) {
                HStack {
                    if isExecuting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text(isExecuting ? "Running..." : "Run Code")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.accentBlue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(isExecuting)
        }
    }
    
    // MARK: - Code Execution
    /// Execute ng Swift code using SwiftExecutor
    private func executeCode() {
        guard !isExecuting else { return }
        guard SwiftExecutor.shared.validateCode(code) else {
            error = "Error: Code contains potentially unsafe operations"
            return
        }
        
        isExecuting = true
        output = ""
        error = ""
        
        Task {
            do {
                let result = try await SwiftExecutor.shared.executeSwiftCode(code)
                await MainActor.run {
                    output = result.output.trimmingCharacters(in: .whitespacesAndNewlines)
                    error = result.error.trimmingCharacters(in: .whitespacesAndNewlines)
                    isExecuting = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    isExecuting = false
                }
            }
        }
    }
} 
import Foundation
import WebKit
import JavaScriptCore

// MARK: - Swift Executor
/// Service para sa pag-execute ng Swift code
/// Nag-co-convert ng Swift code to JavaScript para ma-run
class SwiftExecutor {
    // MARK: - Properties
    
    /// Shared instance para sa global access
    static let shared = SwiftExecutor()
    /// JavaScript context para sa code execution
    private let context = JSContext()
    
    // MARK: - Initialization
    
    /// Private initializer para sa singleton pattern
    private init() {
        setupJavaScriptEnvironment()
    }
    
    // MARK: - Setup
    
    /// Setup ng JavaScript environment
    /// Nag-a-add ng basic Swift-like functions at types
    private func setupJavaScriptEnvironment() {
        // Set up console.log
        let consoleLog: @convention(block) (String) -> Void = { message in
            NotificationCenter.default.post(
                name: Notification.Name("JSLog"),
                object: nil,
                userInfo: ["message": message]
            )
        }
        
        // Add the print function directly to the global scope
        context?.setObject(consoleLog, forKeyedSubscript: "print" as NSString)
        
        // Add basic Swift-like functions and types
        context?.evaluateScript("""
            // String interpolation helper
            function interpolate(strings, ...values) {
                return String.raw({ raw: strings }, ...values);
            }
            
            // String class
            class SwiftString {
                constructor(value) {
                    this.value = String(value);
                }
                
                toString() {
                    return this.value;
                }
            }
            
            // Number types
            class Int {
                constructor(value) {
                    this.value = parseInt(value);
                }
                
                toString() {
                    return String(this.value);
                }
            }
            
            class Double {
                constructor(value) {
                    this.value = parseFloat(value);
                }
                
                toString() {
                    return String(this.value);
                }
            }
            
            // Array class
            class Array {
                constructor() {
                    this.items = [];
                }
                
                append(item) {
                    this.items.push(item);
                }
                
                count() {
                    return this.items.length;
                }
                
                toString() {
                    return this.items.toString();
                }
            }
        """)
    }
    
    // MARK: - Code Execution
    
    /// Execute Swift code sa JavaScript environment
    /// Returns output at error messages
    func executeSwiftCode(_ code: String) async throws -> (output: String, error: String) {
        // Convert Swift syntax to JavaScript
        let jsCode = convertSwiftToJS(code)
        
        var output = ""
        var error = ""
        
        // Set up notification observer for console.log
        let observer = NotificationCenter.default.addObserver(
            forName: Notification.Name("JSLog"),
            object: nil,
            queue: .main
        ) { notification in
            if let message = notification.userInfo?["message"] as? String {
                output += message + "\n"
            }
        }
        
        // Execute code with timeout
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            DispatchQueue.global().async {
                autoreleasepool {
                    if let result = self.context?.evaluateScript(jsCode) {
                        if let exception = self.context?.exception {
                            error = exception.toString() ?? "Unknown error occurred"
                        }
                    }
                    continuation.resume()
                }
            }
        }
        
        // Clean up
        NotificationCenter.default.removeObserver(observer)
        
        return (
            output.trimmingCharacters(in: .whitespacesAndNewlines),
            error.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    // MARK: - Code Conversion
    
    /// Convert Swift syntax to JavaScript
    /// Handles string interpolation at basic syntax differences
    private func convertSwiftToJS(_ swiftCode: String) -> String {
        var jsCode = swiftCode
        
        // Handle string interpolation
        let interpolationPattern = #"\\\((.*?)\)"#
        jsCode = jsCode.replacingOccurrences(
            of: interpolationPattern,
            with: "\\${$1}",
            options: .regularExpression
        )
        
        // Handle Swift string literals
        jsCode = jsCode.replacingOccurrences(
            of: #"print\("(.*?)"\)"#,
            with: "print(`$1`)",
            options: .regularExpression
        )
        
        // Replace Swift syntax with JavaScript equivalents
        jsCode = jsCode.replacingOccurrences(of: "let ", with: "const ")
        jsCode = jsCode.replacingOccurrences(of: "var ", with: "let ")
        jsCode = jsCode.replacingOccurrences(of: "func ", with: "function ")
        jsCode = jsCode.replacingOccurrences(of: "-> Void", with: "")
        jsCode = jsCode.replacingOccurrences(of: "-> String", with: "")
        jsCode = jsCode.replacingOccurrences(of: "-> Int", with: "")
        jsCode = jsCode.replacingOccurrences(of: "-> Double", with: "")
        jsCode = jsCode.replacingOccurrences(of: "-> Bool", with: "")
        
        return jsCode
    }
    
    // MARK: - Code Validation
    
    /// Validate code para sa security
    /// Checks para sa potentially harmful operations
    func validateCode(_ code: String) -> Bool {
        // Basic validation to prevent harmful code
        let blacklist = [
            "require",
            "import",
            "eval(",
            "Function(",
            "setTimeout",
            "setInterval",
            "XMLHttpRequest",
            "fetch(",
            "window.",
            "document.",
            "localStorage",
            "sessionStorage"
        ]
        
        return !blacklist.contains { code.contains($0) }
    }
} 
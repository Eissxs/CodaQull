import SwiftUI
import UIKit

// MARK: - Code Text View
/// Main code editor view na may syntax highlighting at line numbers
/// Nag-ha-handle ng code display at editing functionality
struct CodeTextView: UIViewRepresentable {
    // MARK: - Properties
    
    /// Text content ng code editor
    let text: String
    /// Programming language para sa syntax highlighting
    let language: String
    /// Flag kung pwedeng i-edit ang code
    var isEditable: Bool = false
    /// Callback kapag may changes sa text
    var onTextChange: ((String) -> Void)?
    
    // MARK: - ⚠️ Experimental Feature
    /// TODO: Theme integration ay may mga issues:
    /// - May delay sa color updates
    /// - Hindi consistent ang theme application
    /// - Need i-optimize ang theme change handling
    @StateObject private var themeManager = ThemeManager.shared
    
    // MARK: - UIViewRepresentable Implementation
    
    /// Create initial UIView setup
    func makeUIView(context: Context) -> UIView {
        let containerView = context.coordinator.setupViews()
        
        // Listen for theme changes
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.handleThemeChange),
            name: .themeChanged,
            object: nil
        )
        
        return containerView
    }
    
    /// Update UIView kapag may changes
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.updateContent()
    }
    
    /// Create coordinator para sa UIKit integration
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator Class
    /// Handler ng UIKit interactions at updates
    class Coordinator: NSObject, UITextViewDelegate, UIScrollViewDelegate {
        // MARK: - Properties
        
        /// Reference sa parent view
        var parent: CodeTextView
        /// Main text view para sa code
        weak var textView: UITextView?
        /// View para sa line numbers
        weak var lineNumbersView: LineNumbersView?
        /// Scroll view para sa line numbers
        weak var lineNumbersScrollView: UIScrollView?
        /// Scroll view para sa code
        weak var codeScrollView: UIScrollView?
        /// Container view para sa lahat ng components
        weak var containerView: UIView?
        
        // MARK: - Initialization
        
        init(_ parent: CodeTextView) {
            self.parent = parent
        }
        
        // MARK: - View Setup
        /// Initialize at setup lahat ng UI components
        func setupViews() -> UIView {
            // Container view
            let containerView = UIView()
            containerView.backgroundColor = Theme.background.uiColor
            
            // Line numbers scroll view
            let lineNumbersScrollView = UIScrollView()
            lineNumbersScrollView.backgroundColor = Theme.background.uiColor
            lineNumbersScrollView.showsVerticalScrollIndicator = false
            lineNumbersScrollView.showsHorizontalScrollIndicator = false
            lineNumbersScrollView.isScrollEnabled = false
            lineNumbersScrollView.translatesAutoresizingMaskIntoConstraints = false
            lineNumbersScrollView.isHidden = parent.isEditable
            containerView.addSubview(lineNumbersScrollView)
            
            // Line numbers view
            let lineNumbersView = LineNumbersView()
            lineNumbersView.backgroundColor = Theme.background.uiColor
            lineNumbersView.translatesAutoresizingMaskIntoConstraints = false
            lineNumbersScrollView.addSubview(lineNumbersView)
            
            // Code scroll view
            let codeScrollView = UIScrollView()
            codeScrollView.backgroundColor = Theme.background.uiColor
            codeScrollView.showsVerticalScrollIndicator = true
            codeScrollView.showsHorizontalScrollIndicator = true
            codeScrollView.delegate = self
            codeScrollView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(codeScrollView)
            
            // Text view
            let textView = UITextView()
            textView.backgroundColor = Theme.background.uiColor
            textView.delegate = self
            textView.font = .monospaced(ofSize: UIFont.systemFontSize)
            textView.isEditable = parent.isEditable
            textView.autocapitalizationType = .none
            textView.autocorrectionType = .no
            textView.smartQuotesType = .no
            textView.smartDashesType = .no
            textView.textContainer.lineFragmentPadding = 0
            textView.textContainerInset = UIEdgeInsets(top: 8, left: parent.isEditable ? 8 : 4, bottom: 8, right: 4)
            textView.isScrollEnabled = false
            textView.translatesAutoresizingMaskIntoConstraints = false
            codeScrollView.addSubview(textView)
            
            // Setup constraints
            NSLayoutConstraint.activate([
                // Line numbers scroll view
                lineNumbersScrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                lineNumbersScrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
                lineNumbersScrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                lineNumbersScrollView.widthAnchor.constraint(equalToConstant: 45),
                
                // Line numbers view
                lineNumbersView.leadingAnchor.constraint(equalTo: lineNumbersScrollView.leadingAnchor),
                lineNumbersView.topAnchor.constraint(equalTo: lineNumbersScrollView.topAnchor),
                lineNumbersView.trailingAnchor.constraint(equalTo: lineNumbersScrollView.trailingAnchor),
                lineNumbersView.widthAnchor.constraint(equalTo: lineNumbersScrollView.widthAnchor),
                
                // Code scroll view
                codeScrollView.leadingAnchor.constraint(equalTo: parent.isEditable ? containerView.leadingAnchor : lineNumbersScrollView.trailingAnchor),
                codeScrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
                codeScrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                codeScrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                
                // Text view
                textView.leadingAnchor.constraint(equalTo: codeScrollView.leadingAnchor),
                textView.topAnchor.constraint(equalTo: codeScrollView.topAnchor),
                textView.trailingAnchor.constraint(equalTo: codeScrollView.trailingAnchor),
                textView.widthAnchor.constraint(equalTo: codeScrollView.widthAnchor)
            ])
            
            // Store views
            self.textView = textView
            self.lineNumbersView = lineNumbersView
            self.lineNumbersScrollView = lineNumbersScrollView
            self.codeScrollView = codeScrollView
            self.containerView = containerView
            
            return containerView
        }
        
        // MARK: - Content Updates
        
        // MARK: - ⚠️ Experimental Feature
        /// TODO: Content update system ay may performance issues:
        /// - May lag sa malalaking files
        /// - Hindi optimal ang theme updates
        /// - Need i-improve ang synchronization
        func updateContent() {
            guard let textView = textView,
                  let lineNumbersView = lineNumbersView,
                  let lineNumbersScrollView = lineNumbersScrollView,
                  let codeScrollView = codeScrollView,
                  let containerView = containerView else { return }
            
            // Update theme colors
            containerView.backgroundColor = Theme.background.uiColor
            lineNumbersScrollView.backgroundColor = Theme.background.uiColor
            lineNumbersView.backgroundColor = Theme.background.uiColor
            codeScrollView.backgroundColor = Theme.background.uiColor
            textView.backgroundColor = Theme.background.uiColor
            
            let attributedText = SyntaxHighlighter.shared.highlightCode(parent.text, language: parent.language)
            if textView.attributedText != attributedText {
                textView.attributedText = attributedText
                
                // Calculate line height based on font metrics
                let lineHeight = textView.font?.lineHeight ?? UIFont.systemFontSize
                lineNumbersView.updateLineNumbers(for: parent.text, lineHeight: lineHeight)
                
                // Update content sizes
                DispatchQueue.main.async {
                    let contentHeight = max(textView.contentSize.height, codeScrollView.bounds.height)
                    
                    // Update text view frame and content size
                    textView.frame.size.height = contentHeight
                    codeScrollView.contentSize = CGSize(width: codeScrollView.bounds.width, height: contentHeight)
                    
                    // Update line numbers view and scroll view
                    lineNumbersView.frame.size.height = contentHeight
                    lineNumbersScrollView.contentSize = CGSize(width: lineNumbersScrollView.bounds.width, height: contentHeight)
                }
            }
        }
        
        // MARK: - Theme Handling
        /// Handler para sa theme changes
        @objc func handleThemeChange() {
            updateContent()
        }
        
        // MARK: - Text View Delegate
        
        /// Handler para sa text changes
        func textViewDidChange(_ textView: UITextView) {
            parent.onTextChange?(textView.text)
            
            // Calculate line height based on font metrics
            let lineHeight = textView.font?.lineHeight ?? UIFont.systemFontSize
            lineNumbersView?.updateLineNumbers(for: textView.text, lineHeight: lineHeight)
            
            // Update content sizes
            let contentHeight = max(textView.contentSize.height, codeScrollView?.bounds.height ?? 0)
            
            // Update text view frame and content size
            textView.frame.size.height = contentHeight
            codeScrollView?.contentSize = CGSize(width: codeScrollView?.bounds.width ?? 0, height: contentHeight)
            
            // Update line numbers view and scroll view
            lineNumbersView?.frame.size.height = contentHeight
            lineNumbersScrollView?.contentSize = CGSize(
                width: lineNumbersScrollView?.bounds.width ?? 0,
                height: contentHeight
            )
        }
        
        /// Handler para sa text input
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\t" {
                textView.insertText("    ")
                return false
            }
            return true
        }
        
        // MARK: - Scroll View Delegate
        
        /// Sync scroll position ng code at line numbers
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView == codeScrollView {
                lineNumbersScrollView?.contentOffset.y = scrollView.contentOffset.y
            }
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}

// MARK: - Line Numbers View
/// Custom view para sa line numbers display
class LineNumbersView: UIView {
    // MARK: - Properties
    
    /// Stack view para sa line number labels
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    /// Array ng line number labels
    private var lineLabels: [UILabel] = []
    /// Current number of lines being displayed
    private var currentLineCount = 0
    /// Minimum number of lines to display
    private let minimumLineCount = 200
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    /// Initial setup ng view
    private func setupView() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    // MARK: - ⚠️ Experimental Feature
    /// TODO: Line number system ay may known issues:
    /// - May performance impact sa large files
    /// - Hindi smooth ang resizing
    /// - Need i-optimize ang label creation
    func updateLineNumbers(for text: String, lineHeight: CGFloat) {
        let lines = text.components(separatedBy: .newlines)
        let actualLineCount = max(1, lines.count)
        let targetLineCount = max(minimumLineCount, actualLineCount)
        
        // Only rebuild labels if target line count changed
        if targetLineCount != currentLineCount {
            // Remove existing line number views
            lineLabels.forEach { $0.removeFromSuperview() }
            lineLabels.removeAll()
            
            let format = targetLineCount > 99 ? "%4d" : "%3d"
            
            // Create line number labels
            for i in 1...targetLineCount {
                let label = UILabel()
                label.font = .monospaced(ofSize: UIFont.systemFontSize)
                label.textColor = Theme.commentGray.uiColor
                label.textAlignment = .right
                label.text = String(format: format, i)
                
                // Set explicit height constraint
                label.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true
                
                // Add to stack view and store reference
                stackView.addArrangedSubview(label)
                lineLabels.append(label)
            }
            
            currentLineCount = targetLineCount
        }
        
        // Update line heights if they changed
        lineLabels.forEach { label in
            if label.constraints.first(where: { $0.firstAttribute == .height })?.constant != lineHeight {
                label.constraints.first(where: { $0.firstAttribute == .height })?.constant = lineHeight
            }
        }
    }
}

// MARK: - Preview Provider
/// Preview configuration para sa development
struct CodeTextView_Previews: PreviewProvider {
    static var previews: some View {
        CodeTextView(
            text: """
            func example() {
                print("Hello, World!")
            }
            """,
            language: "swift"
        )
        .frame(height: 200)
        .padding()
        .background(Theme.background)
    }
} 
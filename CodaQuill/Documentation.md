# CodaQuill Documentation
Version 1.2 | Last Updated: 2025

## Table of Contents
1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Architecture](#architecture)
4. [Features](#features)
5. [Technical Implementation](#technical-implementation)
6. [User Interface](#user-interface)
7. [Future Development](#future-development)
8. [API Reference](#api-reference)
9. [Contributing](#contributing)

## Introduction

### Overview
CodaQuill is a modern iOS code snippet manager designed for developers and students. It provides robust code management capabilities with syntax highlighting, version control, and code execution features, all wrapped in an intuitive interface that supports both light and dark themes.

### Key Features
- Multi-language code snippet management
- Real-time syntax highlighting
- Version control system
- Swift code execution environment
- Advanced organization with tags
- Comprehensive search and filter system
- Theme support (dark/light modes)

### Technical Requirements
- iOS 15.0 or later
- Swift 5.5+
- Xcode 13.0+
- Minimum 50MB storage

## Getting Started

### Installation
1. Clone the repository
2. Install dependencies
3. Open CodaQuill.xcodeproj
4. Build and run

### First Steps
1. Create your first snippet
2. Add tags for organization
3. Try code execution
4. Explore version history

## Architecture

### Technology Stack
- **UI Framework**: SwiftUI
- **Data Layer**: Core Data
- **Code Display**: TextKit2 via UITextView
- **Code Execution**: JavaScriptCore
- **Theme System**: Custom implementation with UIKit integration

### Project Structure
```
CodaQuill/
├── Models/
│   ├── Snippet.swift                 # Core Data model
│   ├── SnippetVersion.swift          # Version tracking
│   ├── Tag.swift                     # Tag management
│   └── FilterSortOptions.swift       # Filter/Sort logic
├── Views/
│   ├── ContentView.swift             # Main view
│   ├── SnippetListView.swift         # Snippet listing
│   ├── SnippetCardView.swift         # Snippet preview
│   ├── SnippetDetailView.swift       # Detailed view
│   ├── AddSnippetView.swift          # Creation view
│   ├── EditSnippetView.swift         # Modification view
│   ├── FilterView.swift              # Filter UI
│   ├── TagListView.swift             # Tag management
│   ├── TaggedSnippetsView.swift      # Tag filtering
│   ├── VersionHistoryView.swift      # Version control
│   ├── CodeExecutionView.swift       # Code runner
│   ├── CodeTextView.swift            # Code editor
│   ├── MarkdownTextView.swift        # Note editor
│   ├── OnboardingView.swift          # User onboarding
│   ├── SettingsView.swift            # App settings
│   ├── SplashScreenView.swift        # Launch screen
│   └── Components/                   # Reusable components
├── Services/
│   ├── SyntaxHighlighter.swift       # Code highlighting
│   └── SwiftExecutor.swift           # Code execution
├── Theme/
│   ├── Colors.swift                  # Color definitions
│   ├── FontStyles.swift              # Typography
│   ├── ThemeManager.swift            # Theme handling
│   ├── AppLogo.png                   # App assets
│   └── Assets.xcassets/              # Image assets
├── CodaQuill.xcdatamodeld/          # Data model
└── CodaQuillApp.swift                # App entry point
```

## Features

### Code Management
#### Snippet Creation and Editing
- Rich text editor with syntax highlighting
- Support for Swift, Python, and HTML
- Manual save functionality with version tracking
- Tag-based organization
- Real-time preview

#### Version Control
- Automatic versioning on edits
- Version comparison
- Restore capabilities
- Version metadata tracking
- History browsing

#### Code Execution
- Swift code execution in sandbox
- Real-time output display
- Error handling and reporting
- Security measures:
  - Operation blacklisting
  - Execution timeouts
  - Memory limitations
  - Sandboxed environment

### User Interface

#### Theme System
##### Dark Mode (Default)
- Background: #1F2128
- Card Surface: #292C36
- Accent Blue: #7F9CF5
- Pink Accent: #F28AB2
- Highlight Yellow: #F3E99F
- String Teal: #A3E4D7
- Number Violet: #C3A2E8
- Comment Gray: #8A8FA0

##### Light Mode
- Background: #F5F5F7
- Card Surface: #FFFFFF
- Accent Blue: #4B6BDB
- Pink Accent: #D35D89
- Highlight Yellow: #B5A649
- String Teal: #2F9E8C
- Number Violet: #8B61B0
- Comment Gray: #6B6F7D

#### Typography
- UI: SF Pro (Rounded)
- Code: Menlo
- Dynamic Type Support

### Code Display Features
- Minimum 200 line numbers
- Synchronized scrolling
- Proper text alignment
- Theme-aware colors
- Monospaced font support

### Search and Filter System
- Tag-based filtering
- Language filtering
- Full-text search
- Sort options:
  - Date (newest/oldest)
  - Title (A-Z/Z-A)
  - Favorites first
- Combined filters support

## Technical Implementation

### Syntax Highlighting
The syntax highlighter uses regular expressions for pattern matching with support for:
- Keywords and control flow
- String literals
- Comments
- Numeric values
- Custom language patterns

### Code Execution
Swift code execution is implemented through JavaScript transpilation:
```swift
class SwiftExecutor {
    // Converts Swift syntax to JavaScript
    // Handles string interpolation
    // Manages execution environment
    // Provides safety measures
}
```

### Data Persistence
Core Data implementation with support for:
- Snippets
- Tags
- Versions
- User preferences

## Future Development

### Planned Features

#### Code Enhancement
- Code formatting/prettification
- Multiple language execution
- Code sharing via URL/QR
- Enhanced markdown support
- Code diff viewer

#### Collaboration
- iCloud sync support
- Cross-device sharing
- Public repository
- Collaborative editing
- Snippet discussions

#### IDE Features
- Intelligent auto-completion
- Real-time linting
- Documentation lookup
- Code folding
- Advanced search

#### Organization
- Nested folders
- Smart collections
- GitHub integration
- Batch operations
- Regex search

## API Reference

### Core Services
```swift
// SyntaxHighlighter
func highlightCode(_ code: String, language: String) -> NSAttributedString

// SwiftExecutor
func executeSwiftCode(_ code: String) async throws -> (output: String, error: String)
func validateCode(_ code: String) -> Bool

// ThemeManager
var isDarkMode: Bool { get set }
```

## Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Implement changes
4. Submit pull request

### Code Style
- Follow Swift style guide
- Maintain existing patterns
- Document public APIs
- Include unit tests

### Recent Updates

#### Version 1.2 Changes
1. Empty State Implementation
   - Added consistent empty states across all views
   - Implemented with appropriate icons and messages:
     - Version History: Clock icon
     - Tagged Snippets: Magnifying glass icon
     - Tag List: Tag circle icon
     - Snippet List: Document magnifying glass icon
   - Consistent styling using Theme colors and FontStyle fonts

2. Daily Notifications
   - Implemented NotificationManager service
   - Daily reminders at 10 AM
   - User permission handling
   - Notification settings in SettingsView
   - Configurable through Settings tab

3. Code Editing Improvements
   - Removed auto-save functionality for better control
   - Manual save with version creation
   - Improved text editing and deletion
   - Enhanced code editor performance
   - Proper cleanup of editing resources

4. Real-time Updates
   - Added refresh triggers for views:
     - SnippetDetailView
     - SnippetListView
     - VersionHistoryView
   - Implemented .snippetChanged notification
   - Consolidated notification naming
   - Improved theme change handling

---

© 2025 CodaQuill. All rights reserved.

# CodaQuill API Documentation

## Core Components

### Models

#### Snippet (Core Data Entity)
```swift
extension Snippet {
    var snippetId: UUID
    var snippetTitle: String
    var snippetCode: String
    var snippetLanguage: String
    var snippetNotes: String
    var snippetTags: Set<Tag>
    var snippetCreatedAt: Date
    var snippetUpdatedAt: Date
    var snippetVersions: Set<SnippetVersion>
    var isFavorite: Bool
}
```

#### Tag (Core Data Entity)
```swift
extension Tag {
    var tagId: UUID
    var tagName: String
    var tagSnippets: Set<Snippet>
}
```

#### SnippetVersion (Core Data Entity)
```swift
extension SnippetVersion {
    var versionId: UUID
    var versionTitle: String
    var versionCode: String
    var versionNotes: String
    var versionLanguage: String
    var versionCreatedAt: Date
    var parentSnippet: Snippet?
}
```

### Services

#### NotificationManager
- `scheduleDailyNotification()` - Schedules daily reminder at 10 AM
- `requestPermissions()` - Requests notification permissions
- `cancelAllNotifications()` - Removes all pending notifications

#### ThemeManager
- `isDarkMode: Bool` - Current theme state
- `toggleTheme()` - Switches between light and dark mode
- `applyTheme(_ theme: Theme)` - Applies specific theme

#### SnippetManager
- `createSnippet(_ snippet: Snippet)`
- `updateSnippet(_ snippet: Snippet)`
- `deleteSnippet(_ snippet: Snippet)`
- `getSnippetVersions(_ snippet: Snippet)`

### Views

#### SnippetListView
- `@State private var searchText: String`
- `@State private var selectedTags: Set<Tag>`
- `@State private var sortOrder: SortOrder`
- `@State private var refreshID: UUID`

#### EditSnippetView
- `@State private var title: String`
- `@State private var code: String`
- `@State private var language: String`
- `@State private var notes: String`
- `@State private var selectedTags: Set<Tag>`
- `@State private var refreshID: UUID`

#### VersionHistoryView
- `@FetchRequest private var versions: FetchedResults<SnippetVersion>`
- `@State private var refreshID: UUID`

## Data Flow

1. User creates/edits snippet
2. Changes are saved to Core Data
3. UI is updated via @Published properties
4. Notifications are sent for real-time updates
5. Views refresh using refreshID and .snippetChanged notification

## Theme System

### Available Themes
- Light (Not fully implemented)
- Dark (Default)
- System (Not fully implemented)

### Theme Properties
- Background colors
- Text colors
- Accent colors
- Font styles

### Known Issues
- Theme switching has delays
- UI glitches during transitions
- Currently forced to dark mode
- State persistence needs fixing

## Notification System

### Types
- Daily reminders (10 AM)
- Snippet updates
- Theme changes

### Configuration
- Time settings (Fixed at 10 AM)
- Permission handling
- User preferences

## Error Handling

### Common Errors
- Save failures
- Permission denials
- Invalid input

### Error Recovery
- Automatic retry
- User notification
- State recovery 
# Data Model: Voice Entry Listing

**Feature**: Voice Entry Listing  
**Date**: 2025-11-15  
**Status**: Complete

## Entity: Entry

### Domain Entity (Protocol)

```swift
/// Domain entity representing a voice-recorded entry
protocol Entry {
    var id: UUID { get }
    var transcribedText: String { get }
    var creationDate: Date { get }
    var emailSent: Bool { get }
    var lastEmailSentDate: Date? { get }
    var audioRecordingURL: URL? { get }
}
```

### SwiftData Model

```swift
import SwiftData
import Foundation

/// SwiftData model for Entry entity
@Model
final class EntryModel {
    @Attribute(.unique) var id: UUID
    var transcribedText: String
    var creationDate: Date
    var emailSent: Bool
    var lastEmailSentDate: Date?
    var audioRecordingURL: URL?
    
    init(
        id: UUID = UUID(),
        transcribedText: String,
        creationDate: Date = Date(),
        emailSent: Bool = false,
        lastEmailSentDate: Date? = nil,
        audioRecordingURL: URL? = nil
    ) {
        self.id = id
        self.transcribedText = transcribedText
        self.creationDate = creationDate
        self.emailSent = emailSent
        self.lastEmailSentDate = lastEmailSentDate
        self.audioRecordingURL = audioRecordingURL
    }
}
```

### Attributes

| Attribute | Type | Required | Description | Validation Rules |
|-----------|------|----------|-------------|------------------|
| `id` | UUID | Yes | Unique identifier for the entry | Must be unique, auto-generated |
| `transcribedText` | String | Yes | Text transcribed from voice recording | Cannot be empty, max length: 10,000 characters |
| `creationDate` | Date | Yes | Timestamp when entry was created | Auto-set to current date/time |
| `emailSent` | Bool | Yes | Whether email was successfully sent | Default: false |
| `lastEmailSentDate` | Date? | No | Timestamp of last successful email send | Only set when email is sent successfully |
| `audioRecordingURL` | URL? | No | File system URL to saved audio recording | Optional, for future playback capability |

### Business Rules

1. **Entry Creation**:
   - Entry must have non-empty `transcribedText` before it can be saved
   - `creationDate` is automatically set to current date/time when entry is created
   - `id` is automatically generated as UUID
   - `emailSent` defaults to `false`

2. **Email Status**:
   - `emailSent` is set to `true` when email is successfully sent
   - `lastEmailSentDate` is updated when email is sent successfully
   - If email sending fails, `emailSent` remains `false` and `lastEmailSentDate` is not updated
   - Resending email updates both `emailSent` (if previously false) and `lastEmailSentDate`

3. **Audio Recording**:
   - `audioRecordingURL` is optional - audio may or may not be saved
   - If audio is saved, URL points to file in app's document directory
   - Audio files can be cleaned up if storage becomes an issue (future enhancement)

4. **Data Integrity**:
   - `id` must be unique across all entries
   - `transcribedText` cannot be empty or whitespace-only
   - `creationDate` cannot be in the future

### Queries

**List All Entries (sorted by creation date, newest first)**:
```swift
let descriptor = FetchDescriptor<EntryModel>(
    sortBy: [SortDescriptor(\.creationDate, order: .reverse)]
)
```

**Find Entry by ID**:
```swift
let descriptor = FetchDescriptor<EntryModel>(
    predicate: #Predicate { $0.id == entryId }
)
```

**Find Entries with Email Not Sent**:
```swift
let descriptor = FetchDescriptor<EntryModel>(
    predicate: #Predicate { $0.emailSent == false },
    sortBy: [SortDescriptor(\.creationDate, order: .reverse)]
)
```

### State Transitions

**Entry Lifecycle**:
1. **Created**: Entry created with transcribed text, `emailSent = false`
2. **Email Sent**: `emailSent = true`, `lastEmailSentDate = current date`
3. **Email Resent**: `emailSent = true` (if was false), `lastEmailSentDate = current date`

**Error States**:
- **Transcription Failed**: Entry is not created
- **Email Send Failed**: Entry is created but `emailSent = false`

### Relationships

None - Entry is a standalone entity with no relationships to other entities.

### Indexes

- `id`: Unique index (enforced by `@Attribute(.unique)`)
- `creationDate`: Index for efficient sorting (SwiftData automatically indexes frequently queried attributes)

### Migration Strategy

For future schema changes:
- SwiftData handles lightweight migrations automatically
- For breaking changes, implement custom migration using `ModelConfiguration.migrationPlan`

### Data Validation

**Domain-Level Validation** (in Use Cases):
- `transcribedText` must not be empty or whitespace-only
- `transcribedText` must not exceed 10,000 characters
- `creationDate` must not be in the future

**Model-Level Validation** (in EntryModel):
- `id` uniqueness is enforced by SwiftData
- Type safety enforced by Swift types

### Persistence Configuration

```swift
let configuration = ModelConfiguration(
    schema: Schema([EntryModel.self]),
    isStoredInMemoryOnly: false
)
let modelContainer = try ModelContainer(
    for: EntryModel.self,
    configurations: configuration
)
```

### Repository Interface (Domain Layer)

```swift
/// Repository protocol for Entry persistence operations
protocol EntryRepository {
    func save(_ entry: EntryModel) async throws
    func fetchAll() async throws -> [EntryModel]
    func fetch(by id: UUID) async throws -> EntryModel?
    func delete(_ entry: EntryModel) async throws
    func update(_ entry: EntryModel) async throws
}
```


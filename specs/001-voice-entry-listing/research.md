# Research & Technical Decisions: Voice Entry Listing

**Feature**: Voice Entry Listing  
**Date**: 2025-11-15  
**Status**: Complete

## Technology Choices

### Audio Recording

**Decision**: Use AVFoundation framework's `AVAudioRecorder` for voice recording

**Rationale**: 
- Native Apple framework, no external dependencies
- Provides full control over audio recording settings (format, quality, sample rate)
- Supports background recording with proper session configuration
- Integrates seamlessly with iOS permissions system
- Can save audio files to app's document directory for optional persistence

**Alternatives considered**:
- Third-party audio recording libraries (rejected - violates "use native frameworks" requirement)
- Core Audio (rejected - lower-level, more complex than needed)

### Speech Recognition/Transcription

**Decision**: Use Speech framework's `SFSpeechRecognizer` and `SFSpeechRecognitionTask` for transcription

**Rationale**:
- Native Apple framework, no external dependencies
- Supports on-device and cloud-based recognition
- Handles multiple languages (English and French required)
- Provides real-time transcription capabilities
- Integrates with iOS permissions (speech recognition permission)
- Handles errors gracefully with proper error types

**Alternatives considered**:
- Third-party transcription services (rejected - violates "use native frameworks" requirement)
- Core ML speech models (rejected - more complex setup, Speech framework is sufficient)

### Email Sending

**Decision**: Use MessageUI framework's `MFMailComposeViewController` for email composition and sending

**Rationale**:
- Native Apple framework, no external dependencies
- Provides standard iOS email composition UI
- Handles email account configuration automatically
- User can review email before sending
- Integrates with iOS Mail app
- Supports email attachments if needed in future

**Alternatives considered**:
- SMTP libraries (rejected - violates "use native frameworks" requirement, requires email server configuration)
- Third-party email services (rejected - violates "use native frameworks" requirement)
- URL schemes (mailto:) (rejected - less control, opens external Mail app, not ideal UX)

**Note**: MessageUI requires user interaction to send email. For automatic sending, we'll present the mail composer and programmatically trigger send, or use alternative approach if automatic sending is required without user interaction.

### Data Persistence

**Decision**: Use SwiftData framework with `@Model` macro for Entry entity

**Rationale**:
- Native Apple framework (mandated by constitution)
- Type-safe, declarative data modeling
- Integrates seamlessly with SwiftUI and Swift concurrency
- Automatic persistence and relationship management
- Supports queries, sorting, and filtering
- No external dependencies

**Alternatives considered**:
- Core Data (rejected - SwiftData is the modern replacement, better Swift concurrency support)
- UserDefaults (rejected - not suitable for complex entity storage)
- File-based storage (rejected - SwiftData provides better abstraction and querying)

### Concurrency Model

**Decision**: Use Swift 6.2 structured concurrency with `async`/`await`, `Task`, and `@MainActor`

**Rationale**:
- Mandated by constitution (Swift 6.2 concurrency)
- Modern, safe concurrency model
- Prevents data races with actor isolation
- `@MainActor` ensures UI updates on main thread
- `async`/`await` simplifies asynchronous code
- Better than completion handlers or DispatchQueue

**Patterns**:
- Audio recording: Use `Task` for async recording operations
- Speech recognition: Use `async`/`await` for transcription tasks
- Email sending: Use `@MainActor` for UI operations
- Data operations: Use `async`/`await` with ModelContext

### Architecture Pattern

**Decision**: Clean Architecture with MVVM pattern

**Rationale**:
- Mandated by constitution
- Clear separation of concerns
- Testable layers (Domain independent, Data and Presentation testable in isolation)
- Maintainable and scalable
- Follows dependency inversion principle

**Layer Responsibilities**:
- **Domain**: Entry entity (protocol), use cases (CreateEntry, ListEntries, TranscribeAudio, SendEmail)
- **Data**: SwiftData EntryModel, repository implementation, services (AudioRecording, SpeechTranscription, Email)
- **Presentation**: SwiftUI views, ViewModels (observable state), Coordinator (navigation)

### Navigation

**Decision**: Coordinator pattern for navigation

**Rationale**:
- Mandated by constitution
- Decouples views from navigation logic
- Centralized navigation management
- Easier to test and modify
- Supports complex navigation flows

### Error Handling

**Decision**: Use Swift's `Result` type and custom error enums with `async throws`

**Rationale**:
- Type-safe error handling
- Integrates with Swift 6.2 concurrency (`async throws`)
- Clear error types for different failure scenarios
- Can be easily tested

**Error Types**:
- `RecordingError`: Microphone permission denied, recording failed, audio format error
- `TranscriptionError`: Speech recognition unavailable, transcription failed, network error
- `EmailError`: Email not configured, sending failed, user cancelled
- `DataError`: Save failed, fetch failed, invalid data

### Permissions

**Decision**: Request permissions at runtime with proper error handling

**Rationale**:
- iOS best practice
- Required for microphone and speech recognition
- Must handle denial gracefully
- Provide clear user guidance

**Permissions Required**:
- Microphone (`AVAudioSession` permission)
- Speech Recognition (`SFSpeechRecognizer` authorization)
- No email permission needed (MessageUI handles this)

## Implementation Considerations

### Audio File Storage

**Decision**: Optionally save audio files to app's document directory, store URL in Entry entity

**Rationale**:
- Allows future playback of recordings
- SwiftData can store URL as attribute
- Files can be cleaned up if storage becomes an issue
- Optional - not required for MVP but good for future features

### Email Automation

**Decision**: Use MessageUI with programmatic approach or present mail composer for user to send

**Rationale**:
- MessageUI requires user interaction for security reasons
- Can present mail composer pre-filled and guide user to send
- Alternative: Use URL scheme or background email sending if automatic sending is critical (requires additional research)

**Note**: If fully automatic email sending without user interaction is required, may need to use alternative approach (SMTP library would violate "native frameworks only" requirement - needs clarification).

### Offline Support

**Decision**: Support offline voice recording, require network for transcription and email

**Rationale**:
- Audio recording can work offline (AVFoundation)
- Speech recognition may require network (depending on language and device capabilities)
- Email sending requires network
- Provide clear feedback when network is unavailable

### Localization

**Decision**: Use xcstrings files for English and French

**Rationale**:
- Mandated by constitution
- Modern localization format
- Better tooling support in Xcode
- Type-safe string access

## Open Questions Resolved

1. **Q**: Should we save audio files permanently?
   **A**: Optional for MVP, store URL in Entry entity for future playback capability

2. **Q**: Can email be sent automatically without user interaction?
   **A**: MessageUI requires user interaction. Will present mail composer pre-filled. If fully automatic is required, needs alternative approach (may violate "native frameworks only").

3. **Q**: What happens if transcription fails?
   **A**: Display error message, do not create entry. Allow user to retry recording.

4. **Q**: Should we support multiple languages for transcription?
   **A**: Yes, Speech framework supports multiple languages. Will configure for English and French.

## References

- [AVFoundation Documentation](https://developer.apple.com/documentation/avfoundation)
- [Speech Framework Documentation](https://developer.apple.com/documentation/speech)
- [MessageUI Framework Documentation](https://developer.apple.com/documentation/messageui)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [Swift Concurrency Documentation](https://www.swift.org/documentation/concurrency/)


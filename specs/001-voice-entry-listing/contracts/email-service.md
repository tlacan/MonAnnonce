# Email Service Contract

**Service**: Email Sending  
**Framework**: MessageUI  
**Date**: 2025-11-15

## Protocol Definition

```swift
import MessageUI
import Foundation

/// Service protocol for email operations
protocol EmailService {
    /// Check if email can be sent (device configured for email)
    /// - Returns: True if email can be sent, false otherwise
    func canSendEmail() -> Bool
    
    /// Compose and present email composer
    /// - Parameter recipient: Email address of recipient (hardcoded Gmail address)
    /// - Parameter subject: Email subject line
    /// - Parameter body: Email body text (transcribed text)
    /// - Parameter completion: Completion handler with result
    func composeEmail(
        recipient: String,
        subject: String,
        body: String,
        completion: @escaping (Result<Void, EmailError>) -> Void
    )
    
    /// Send email (programmatic, if possible)
    /// - Parameter recipient: Email address of recipient
    /// - Parameter subject: Email subject line
    /// - Parameter body: Email body text
    /// - Throws: EmailError if sending fails
    func sendEmail(recipient: String, subject: String, body: String) async throws
}
```

## Error Types

```swift
enum EmailError: Error {
    case emailNotConfigured
    case sendingFailed
    case userCancelled
    case invalidRecipient
    case networkError
}
```

## Usage Pattern

1. Check if email can be sent
2. Compose email with recipient, subject, and body
3. Present mail composer or send programmatically
4. Handle errors gracefully

## Implementation Notes

- Uses `MFMailComposeViewController` from MessageUI framework
- Hardcoded Gmail recipient address (to be configured in app settings or constants)
- Email subject: "Voice Entry: [Date]" or similar
- Email body: Transcribed text from entry
- May require user interaction for security (iOS limitation)
- If automatic sending without user interaction is required, alternative approach needed

## Hardcoded Configuration

- **Recipient Email**: To be defined in app configuration (hardcoded Gmail address)
- **Email Subject Format**: "Voice Entry - [Creation Date]"
- **Email Body**: Transcribed text from entry


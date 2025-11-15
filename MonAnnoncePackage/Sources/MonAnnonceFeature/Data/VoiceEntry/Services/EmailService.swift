import Foundation

/// Service protocol for email operations
public protocol EmailService {
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
        completion: @escaping @Sendable (Result<Void, EmailError>) -> Void
    )
    
    /// Send email (programmatic, if possible)
    /// - Parameter recipient: Email address of recipient
    /// - Parameter subject: Email subject line
    /// - Parameter body: Email body text
    /// - Throws: EmailError if sending fails
    func sendEmail(recipient: String, subject: String, body: String) async throws
}


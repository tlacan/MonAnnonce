import Foundation

/// Use case for sending email with entry information
public struct SendEmailUseCase: @unchecked Sendable {
    private let emailService: EmailService
    private let recipientEmail: String
    
    public init(emailService: EmailService, recipientEmail: String) {
        self.emailService = emailService
        self.recipientEmail = recipientEmail
    }
    
    @MainActor
    public func execute(for entry: EntryModel) async throws {
        let subject = "Voice Entry - \(formatDate(entry.creationDate))"
        let body = formatEmailBody(for: entry)
        
        try await emailService.sendEmail(
            recipient: recipientEmail,
            subject: subject,
            body: body
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatEmailBody(for entry: EntryModel) -> String {
        var body = "Transcribed Text:\n\(entry.transcribedText)\n\n"
        
        body += "Structured Data:\n"
        body += "---\n"
        
        if !entry.id.isEmpty {
            body += "ID: \(entry.id)\n"
        }
        if !entry.title.isEmpty {
            body += "Title: \(entry.title)\n"
        }
        if !entry.brand.isEmpty {
            body += "Brand: \(entry.brand)\n"
        }
        if !entry.color.isEmpty {
            body += "Color: \(entry.color)\n"
        }
        if !entry.itemDescription.isEmpty {
            body += "Description: \(entry.itemDescription)\n"
        }
        if entry.isUnisex {
            body += "Is Unisex: Yes\n"
        }
        if entry.measurementLength > 0 {
            body += "Measurement Length: \(entry.measurementLength)\n"
        }
        if entry.measurementWidth > 0 {
            body += "Measurement Width: \(entry.measurementWidth)\n"
        }
        if entry.price > 0 {
            body += "Price: \(entry.price)\n"
        }
        if !entry.size.isEmpty {
            body += "Size: \(entry.size)\n"
        }
        if !entry.status.isEmpty {
            body += "Status: \(entry.status)\n"
        }
        
        body += "---\n"
        body += "Created: \(formatDate(entry.creationDate))\n"
        
        return body
    }
}


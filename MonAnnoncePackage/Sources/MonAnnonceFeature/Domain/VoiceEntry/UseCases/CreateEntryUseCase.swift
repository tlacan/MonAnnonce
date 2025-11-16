import Foundation

/// Use case for creating a new entry with structured fields
public struct CreateEntryUseCase: @unchecked Sendable {
    private let repository: EntryRepository
    private let sendEmailUseCase: SendEmailUseCase?
    
    public init(repository: EntryRepository, sendEmailUseCase: SendEmailUseCase? = nil) {
        self.repository = repository
        self.sendEmailUseCase = sendEmailUseCase
    }
    
    public func execute(
        transcribedText: String,
        audioRecordingURL: URL? = nil,
        structuredData: [String: Any] = [:]
    ) async throws -> EntryModel {
        // Create entry with extracted structured data
        let entry = EntryModel(
            id: structuredData["id"] as? String ?? UUID().uuidString,
            transcribedText: transcribedText,
            audioRecordingURL: audioRecordingURL,
            brand: structuredData["brand"] as? String ?? "",
            color: structuredData["color"] as? String ?? "",
            itemDescription: structuredData["itemDescription"] as? String ?? "",
            isUnisex: structuredData["isUnisex"] as? Bool ?? false,
            measurementLength: structuredData["measurementLength"] as? Double ?? 0.0,
            measurementWidth: structuredData["measurementWidth"] as? Double ?? 0.0,
            price: structuredData["price"] as? Double ?? 0.0,
            size: structuredData["size"] as? String ?? "",
            status: structuredData["status"] as? String ?? "",
            title: structuredData["title"] as? String ?? ""
        )
        
        // Repository operations are handled internally on MainActor
        try await repository.save(entry)
        
        // Send email if use case is provided
        if let sendEmailUseCase = sendEmailUseCase {
            do {
                // Extract entry data before passing to MainActor
                let entryId = entry.id
                let transcribedText = entry.transcribedText
                let creationDate = entry.creationDate
                let brand = entry.brand
                let color = entry.color
                let itemDescription = entry.itemDescription
                let isUnisex = entry.isUnisex
                let measurementLength = entry.measurementLength
                let measurementWidth = entry.measurementWidth
                let price = entry.price
                let size = entry.size
                let status = entry.status
                let title = entry.title
                
                // Create a temporary entry model for email sending
                let tempEntry = EntryModel(
                    id: entryId,
                    transcribedText: transcribedText,
                    creationDate: creationDate,
                    brand: brand,
                    color: color,
                    itemDescription: itemDescription,
                    isUnisex: isUnisex,
                    measurementLength: measurementLength,
                    measurementWidth: measurementWidth,
                    price: price,
                    size: size,
                    status: status,
                    title: title
                )
                
                try await Task { @MainActor in
                    try await sendEmailUseCase.execute(for: tempEntry)
                }.value
                
                // Update entry with email sent status
                // Entry is already on MainActor since it was created there
                entry.emailSent = true
                entry.lastEmailSentDate = Date()
                try await repository.update(entry)
            } catch {
                // Entry is still created, but email status remains false
                // This is expected behavior - entry creation should not fail if email fails
            }
        }
        
        return entry
    }
}


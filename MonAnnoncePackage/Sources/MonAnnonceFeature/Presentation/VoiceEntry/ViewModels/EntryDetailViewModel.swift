import SwiftUI
import Foundation

@MainActor
public final class EntryDetailViewModel: ObservableObject {
    @Published public var isSendingEmail = false
    @Published public var errorMessage: String?
    @Published public var successMessage: String?
    
    nonisolated(unsafe) private let entry: EntryModel
    private let sendEmailUseCase: SendEmailUseCase
    private let repository: EntryRepository
    
    public init(
        entry: EntryModel,
        sendEmailUseCase: SendEmailUseCase,
        repository: EntryRepository
    ) {
        self.entry = entry
        self.sendEmailUseCase = sendEmailUseCase
        self.repository = repository
    }
    
    public var entryModel: EntryModel {
        entry
    }
    
    public func resendEmail() async {
        isSendingEmail = true
        errorMessage = nil
        successMessage = nil
        
        let useCase = sendEmailUseCase
        let repo = repository
        
        do {
            // Extract entry data before passing to async context
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
            
            try await useCase.execute(for: tempEntry)
            
            // Update entry with email sent status
            entry.emailSent = true
            entry.lastEmailSentDate = Date()
            try await repo.update(entry)
            
            successMessage = "Email sent successfully"
        } catch {
            errorMessage = "Failed to send email: \(error.localizedDescription)"
        }
        
        isSendingEmail = false
    }
}


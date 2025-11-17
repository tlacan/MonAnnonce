import SwiftUI
import Foundation

@MainActor
public final class EntryDetailViewModel: ObservableObject {
    @Published public var isSendingEmail = false
    @Published public var errorMessage: String?
    @Published public var successMessage: String?
    @Published public var isEditing = false
    @Published public var isSaving = false
    
    // Editable fields
    @Published public var editedId: String
    @Published public var editedTitle: String
    @Published public var editedBrand: String
    @Published public var editedColor: String
    @Published public var editedDescription: String
    @Published public var editedIsUnisex: Bool
    @Published public var editedMeasurementLength: String
    @Published public var editedMeasurementWidth: String
    @Published public var editedPrice: String
    @Published public var editedSize: String
    @Published public var editedStatus: String
    
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
        
        // Initialize editable fields with current values
        self.editedId = entry.id
        self.editedTitle = entry.title
        self.editedBrand = entry.brand
        self.editedColor = entry.color
        self.editedDescription = entry.itemDescription
        self.editedIsUnisex = entry.isUnisex
        self.editedMeasurementLength = entry.measurementLength > 0 ? String(entry.measurementLength) : ""
        self.editedMeasurementWidth = entry.measurementWidth > 0 ? String(entry.measurementWidth) : ""
        self.editedPrice = entry.price > 0 ? String(entry.price) : ""
        self.editedSize = entry.size
        self.editedStatus = entry.status
    }
    
    public var entryModel: EntryModel {
        entry
    }
    
    public func startEditing() {
        isEditing = true
        errorMessage = nil
        successMessage = nil
    }
    
    public func cancelEditing() {
        // Reset to original values
        editedId = entry.id
        editedTitle = entry.title
        editedBrand = entry.brand
        editedColor = entry.color
        editedDescription = entry.itemDescription
        editedIsUnisex = entry.isUnisex
        editedMeasurementLength = entry.measurementLength > 0 ? String(entry.measurementLength) : ""
        editedMeasurementWidth = entry.measurementWidth > 0 ? String(entry.measurementWidth) : ""
        editedPrice = entry.price > 0 ? String(entry.price) : ""
        editedSize = entry.size
        editedStatus = entry.status
        isEditing = false
    }
    
    public func saveChanges() async {
        isSaving = true
        errorMessage = nil
        successMessage = nil
        
        do {
            // Update entry with edited values
            entry.title = editedTitle
            entry.brand = editedBrand
            entry.color = editedColor
            entry.itemDescription = editedDescription
            entry.isUnisex = editedIsUnisex
            entry.measurementLength = Double(editedMeasurementLength) ?? 0.0
            entry.measurementWidth = Double(editedMeasurementWidth) ?? 0.0
            entry.price = Double(editedPrice) ?? 0.0
            entry.size = editedSize
            entry.status = editedStatus
            
            // Save to repository
            try await repository.update(entry)
            
            isEditing = false
            successMessage = "entry.detail.save.success".localized()
        } catch {
            errorMessage = String(format: "entry.detail.save.error".localized(), error.localizedDescription)
        }
        
        isSaving = false
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
            
            successMessage = "entry.detail.resend.email.success".localized()
        } catch {
            errorMessage = String(format: "entry.detail.resend.email.error".localized(), error.localizedDescription)
        }
        
        isSendingEmail = false
    }
}


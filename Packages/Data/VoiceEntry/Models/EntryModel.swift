import SwiftData
import Foundation

/// SwiftData model for Entry entity with structured fields
@Model
public final class EntryModel {
    @Attribute(.unique) public var id: String
    public var transcribedText: String
    public var creationDate: Date
    public var emailSent: Bool
    public var lastEmailSentDate: Date?
    public var audioRecordingURL: URL?
    
    // Structured fields for classified ad listing
    public var brand: String
    public var color: String
    public var description: String
    public var isUnisex: Bool
    public var measurementLength: Double
    public var measurementWidth: Double
    public var price: Double
    public var size: String
    public var status: String
    public var title: String
    public var images: [URL]
    
    public init(
        id: String = UUID().uuidString,
        transcribedText: String,
        creationDate: Date = Date(),
        emailSent: Bool = false,
        lastEmailSentDate: Date? = nil,
        audioRecordingURL: URL? = nil,
        brand: String = "",
        color: String = "",
        description: String = "",
        isUnisex: Bool = false,
        measurementLength: Double = 0.0,
        measurementWidth: Double = 0.0,
        price: Double = 0.0,
        size: String = "",
        status: String = "",
        title: String = "",
        images: [URL] = []
    ) {
        self.id = id
        self.transcribedText = transcribedText
        self.creationDate = creationDate
        self.emailSent = emailSent
        self.lastEmailSentDate = lastEmailSentDate
        self.audioRecordingURL = audioRecordingURL
        self.brand = brand
        self.color = color
        self.description = description
        self.isUnisex = isUnisex
        self.measurementLength = measurementLength
        self.measurementWidth = measurementWidth
        self.price = price
        self.size = size
        self.status = status
        self.title = title
        self.images = images
    }
}

extension EntryModel: Entry {
    // Entry protocol conformance is already satisfied by the properties
}


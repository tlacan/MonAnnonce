import Foundation

/// Domain entity representing a voice-recorded entry with structured fields
public protocol Entry {
    var id: String { get }
    var transcribedText: String { get }
    var creationDate: Date { get }
    var emailSent: Bool { get }
    var lastEmailSentDate: Date? { get }
    var audioRecordingURL: URL? { get }
    
    // Structured fields for classified ad listing
    var brand: String { get }
    var color: String { get }
    var itemDescription: String { get }  // Renamed from 'description' as it conflicts with SwiftData @Model
    var isUnisex: Bool { get }
    var measurementLength: Double { get }
    var measurementWidth: Double { get }
    var price: Double { get }
    var size: String { get }
    var status: String { get }
    var title: String { get }
    var images: [URL] { get }
}


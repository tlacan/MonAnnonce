import Foundation

/// Service protocol for extracting structured data from text using FoundationModels
public protocol FoundationModelsTextExtractionService: Sendable {
    /// Extract structured fields from transcribed text
    /// - Parameter text: The transcribed text to extract data from
    /// - Returns: Dictionary with extracted structured fields
    /// - Throws: TextExtractionError if extraction fails
    func extractStructuredData(from text: String) async throws -> [String: Any]
}


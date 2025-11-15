import Foundation

/// Use case for extracting structured data from transcribed text
public struct ExtractStructuredDataUseCase: Sendable {
    private let extractionService: FoundationModelsTextExtractionService
    
    public init(extractionService: FoundationModelsTextExtractionService) {
        self.extractionService = extractionService
    }
    
    public func execute(from text: String) async throws -> [String: Any] {
        return try await extractionService.extractStructuredData(from: text)
    }
}


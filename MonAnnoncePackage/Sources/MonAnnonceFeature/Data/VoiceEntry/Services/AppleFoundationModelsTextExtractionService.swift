import Foundation

#if canImport(FoundationModels)
import FoundationModels
#endif

/// Apple FoundationModels implementation for text extraction
/// Uses Foundation Models Framework with @Generable for structured data extraction when available
/// Falls back to pattern-based extraction on older iOS versions
public final class AppleFoundationModelsTextExtractionService: @unchecked Sendable, FoundationModelsTextExtractionService {
    public init() {}
    
    public func extractStructuredData(from text: String) async throws -> [String: Any] {
        // Check if Foundation Models is available (iOS 26.0+)
        if #available(iOS 26.0, macOS 26.0, *) {
            return try await extractWithFoundationModels(from: text)
        } else {
            // Fallback to pattern-based extraction for iOS < 26.0
            return try await fallbackExtraction(from: text)
        }
    }
    
    @available(iOS 26.0, macOS 26.0, *)
    private func extractWithFoundationModels(from text: String) async throws -> [String: Any] {
        #if canImport(FoundationModels)
        // Use Foundation Models Framework to extract structured data
        let session = LanguageModelSession()
        
        // Create a prompt that instructs the model to extract entry information
        let prompt = """
        Extract structured information from the following text about a classified ad listing.
        Extract all available information including: ID, title, brand, color, description, 
        whether it's unisex, measurements (length and width in cm), price (in euros), size, and status.
        The text has been done in French
        
        Text: \(text)
        
        Extract the information and return it in a structured format.
        """
        
        do {
            let response = try await session.respond(
                to: prompt,
                generating: EntryExtractionModel.self
            )
            
            let extracted = response.content
            
            // Convert to dictionary format
            var result: [String: Any] = [:]
            result["id"] = extracted.id
            result["title"] = extracted.title
            result["brand"] = extracted.brand
            result["color"] = extracted.color
            result["itemDescription"] = extracted.itemDescription
            result["isUnisex"] = extracted.isUnisex
            result["measurementLength"] = extracted.measurementLength
            result["measurementWidth"] = extracted.measurementWidth
            result["price"] = extracted.price
            result["size"] = extracted.size
            result["status"] = extracted.status
            
            return result
        } catch {
            // Fallback to pattern-based extraction if Foundation Models fails
            return try await fallbackExtraction(from: text)
        }
        #else
        // FoundationModels not available, use fallback
        return try await fallbackExtraction(from: text)
        #endif
    }
    
    private func fallbackExtraction(from text: String) async throws -> [String: Any] {
        // Fallback pattern-based extraction
        var extracted: [String: Any] = [:]
        
        // Extract ID
        if let idMatch = text.range(of: #"Id:\s*([^\s,]+)"#, options: .regularExpression) {
            let id = String(text[idMatch]).replacingOccurrences(of: "Id:", with: "").trimmingCharacters(in: .whitespaces)
            extracted["id"] = id
        }
        
        // Extract Brand
        if let brandMatch = text.range(of: #"Brand:\s*([^,]+)"#, options: .regularExpression) {
            let brand = String(text[brandMatch]).replacingOccurrences(of: "Brand:", with: "").trimmingCharacters(in: .whitespaces)
            extracted["brand"] = brand
        }
        
        // Extract Color
        if let colorMatch = text.range(of: #"Color:\s*([^,]+)"#, options: .regularExpression) {
            let color = String(text[colorMatch]).replacingOccurrences(of: "Color:", with: "").trimmingCharacters(in: .whitespaces)
            extracted["color"] = color
        }
        
        // Extract Description
        if let descMatch = text.range(of: #"Description:\s*([^,]+)"#, options: .regularExpression) {
            let desc = String(text[descMatch]).replacingOccurrences(of: "Description:", with: "").trimmingCharacters(in: .whitespaces)
            extracted["itemDescription"] = desc
        }
        
        // Extract Is Unisex
        if let unisexMatch = text.range(of: #"Is unisex:\s*(true|false|yes|no)"#, options: [.regularExpression, .caseInsensitive]) {
            let unisexStr = String(text[unisexMatch]).replacingOccurrences(of: "Is unisex:", with: "", options: .caseInsensitive).trimmingCharacters(in: .whitespaces).lowercased()
            extracted["isUnisex"] = unisexStr == "true" || unisexStr == "yes"
        }
        
        // Extract Measurement Length
        if let lengthMatch = text.range(of: #"Measurement length:\s*([0-9.]+)"#, options: .regularExpression) {
            let lengthStr = String(text[lengthMatch]).replacingOccurrences(of: "Measurement length:", with: "", options: .caseInsensitive).trimmingCharacters(in: .whitespaces)
            extracted["measurementLength"] = Double(lengthStr) ?? 0.0
        }
        
        // Extract Measurement Width
        if let widthMatch = text.range(of: #"Measurement width:\s*([0-9.]+)"#, options: .regularExpression) {
            let widthStr = String(text[widthMatch]).replacingOccurrences(of: "Measurement width:", with: "", options: .caseInsensitive).trimmingCharacters(in: .whitespaces)
            extracted["measurementWidth"] = Double(widthStr) ?? 0.0
        }
        
        // Extract Price
        if let priceMatch = text.range(of: #"Price:\s*([0-9.]+)"#, options: .regularExpression) {
            let priceStr = String(text[priceMatch]).replacingOccurrences(of: "Price:", with: "", options: .caseInsensitive).trimmingCharacters(in: .whitespaces)
            extracted["price"] = Double(priceStr) ?? 0.0
        }
        
        // Extract Size
        if let sizeMatch = text.range(of: #"Size:\s*([^,]+)"#, options: .regularExpression) {
            let size = String(text[sizeMatch]).replacingOccurrences(of: "Size:", with: "", options: .caseInsensitive).trimmingCharacters(in: .whitespaces)
            extracted["size"] = size
        }
        
        // Extract Status
        if let statusMatch = text.range(of: #"Status:\s*([^,]+)"#, options: .regularExpression) {
            let status = String(text[statusMatch]).replacingOccurrences(of: "Status:", with: "", options: .caseInsensitive).trimmingCharacters(in: .whitespaces)
            extracted["status"] = status
        }
        
        // Extract Title
        if let titleMatch = text.range(of: #"Title:\s*([^,]+)"#, options: .regularExpression) {
            let title = String(text[titleMatch]).replacingOccurrences(of: "Title:", with: "", options: .caseInsensitive).trimmingCharacters(in: .whitespaces)
            extracted["title"] = title
        }
        
        return extracted
    }
}


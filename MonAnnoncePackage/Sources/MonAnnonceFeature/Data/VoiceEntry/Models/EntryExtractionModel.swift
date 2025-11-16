import FoundationModels
import Foundation

/// Structured data model for extracting entry information from transcribed text
/// Uses Foundation Models Framework with @Generable for type-safe extraction
@available(iOS 26.0, macOS 26.0, *)
@Generable
public struct EntryExtractionModel {
    @Guide(description: "Unique identifier or SKU for the item")
    public var id: String
    
    @Guide(description: "Title or name of the item")
    public var title: String
    
    @Guide(description: "Brand name of the item")
    public var brand: String
    
    @Guide(description: "Color of the item")
    public var color: String
    
    @Guide(description: "Detailed description of the item")
    public var itemDescription: String
    
    @Guide(description: "Whether the item is unisex (true/false)")
    public var isUnisex: Bool
    
    @Guide(description: "Length measurement in centimeters")
    public var measurementLength: Double
    
    @Guide(description: "Width measurement in centimeters")
    public var measurementWidth: Double
    
    @Guide(description: "Price in euros")
    public var price: Double
    
    @Guide(description: "Size of the item (e.g., S, M, L, 42, etc.)")
    public var size: String
    
    @Guide(description: "Condition or status of the item (e.g., new, good, fair, etc.)")
    public var status: String
    
    public init(
        id: String = "",
        title: String = "",
        brand: String = "",
        color: String = "",
        itemDescription: String = "",
        isUnisex: Bool = false,
        measurementLength: Double = 0.0,
        measurementWidth: Double = 0.0,
        price: Double = 0.0,
        size: String = "",
        status: String = ""
    ) {
        self.id = id
        self.title = title
        self.brand = brand
        self.color = color
        self.itemDescription = itemDescription
        self.isUnisex = isUnisex
        self.measurementLength = measurementLength
        self.measurementWidth = measurementWidth
        self.price = price
        self.size = size
        self.status = status
    }
}


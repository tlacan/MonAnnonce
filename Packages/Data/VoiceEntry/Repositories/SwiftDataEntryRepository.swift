import SwiftData
import Foundation

/// SwiftData implementation of EntryRepository
public final class SwiftDataEntryRepository: EntryRepository {
    private let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    public func save(_ entry: EntryModel) async throws {
        modelContext.insert(entry)
        try modelContext.save()
    }
    
    public func fetchAll() async throws -> [EntryModel] {
        let descriptor = FetchDescriptor<EntryModel>(
            sortBy: [SortDescriptor(\.creationDate, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    public func fetch(by id: String) async throws -> EntryModel? {
        let descriptor = FetchDescriptor<EntryModel>(
            predicate: #Predicate { $0.id == id }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    public func delete(_ entry: EntryModel) async throws {
        modelContext.delete(entry)
        try modelContext.save()
    }
    
    public func update(_ entry: EntryModel) async throws {
        try modelContext.save()
    }
}


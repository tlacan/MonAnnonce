import SwiftData
import Foundation

/// SwiftData implementation of EntryRepository
/// ModelContext operations must be performed on the main actor
public final class SwiftDataEntryRepository: @unchecked Sendable, EntryRepository {
    nonisolated(unsafe) private let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    public func save(_ entry: EntryModel) async throws {
        // EntryModel operations must happen on MainActor
        // EntryModel is not Sendable, so we use nonisolated(unsafe) to allow passing it
        nonisolated(unsafe) let entryRef = entry
        await MainActor.run {
            modelContext.insert(entryRef)
        }
        try await Task { @MainActor in
            try modelContext.save()
        }.value
    }
    
    public func fetchAll() async throws -> [EntryModel] {
        let descriptor = FetchDescriptor<EntryModel>(
            sortBy: [SortDescriptor(\.creationDate, order: .reverse)]
        )
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                do {
                    let result = try modelContext.fetch(descriptor)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func fetch(by id: String) async throws -> EntryModel? {
        let descriptor = FetchDescriptor<EntryModel>(
            predicate: #Predicate { $0.id == id }
        )
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                do {
                    let result = try modelContext.fetch(descriptor).first
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func delete(_ entry: EntryModel) async throws {
        // EntryModel operations must happen on MainActor
        // EntryModel is not Sendable, so we use nonisolated(unsafe) to allow passing it
        nonisolated(unsafe) let entryRef = entry
        await MainActor.run {
            modelContext.delete(entryRef)
        }
        try await Task { @MainActor in
            try modelContext.save()
        }.value
    }
    
    public func update(_ entry: EntryModel) async throws {
        try await Task { @MainActor in
            try modelContext.save()
        }.value
    }
}


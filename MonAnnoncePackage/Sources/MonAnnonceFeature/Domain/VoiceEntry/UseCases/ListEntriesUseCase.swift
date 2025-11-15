import Foundation

/// Use case for listing all entries sorted by creation date (newest first)
public struct ListEntriesUseCase: Sendable {
    private let repository: EntryRepository
    
    public init(repository: EntryRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [EntryModel] {
        return try await repository.fetchAll()
    }
}


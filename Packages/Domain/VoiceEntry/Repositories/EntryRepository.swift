import Foundation

/// Repository protocol for Entry persistence operations
public protocol EntryRepository {
    func save(_ entry: EntryModel) async throws
    func fetchAll() async throws -> [EntryModel]
    func fetch(by id: String) async throws -> EntryModel?
    func delete(_ entry: EntryModel) async throws
    func update(_ entry: EntryModel) async throws
}


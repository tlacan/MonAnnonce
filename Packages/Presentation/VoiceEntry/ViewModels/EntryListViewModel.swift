import SwiftUI
import Foundation

@MainActor
public final class EntryListViewModel: ObservableObject {
    @Published public var entries: [EntryModel] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    private let listEntriesUseCase: ListEntriesUseCase
    
    public init(listEntriesUseCase: ListEntriesUseCase) {
        self.listEntriesUseCase = listEntriesUseCase
    }
    
    public func loadEntries() async {
        isLoading = true
        errorMessage = nil
        
        do {
            entries = try await listEntriesUseCase.execute()
        } catch {
            errorMessage = "Failed to load entries: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}


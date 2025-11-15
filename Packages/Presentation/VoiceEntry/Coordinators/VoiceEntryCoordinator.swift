import SwiftUI
import SwiftData

/// Coordinator for Voice Entry feature navigation
public struct VoiceEntryCoordinator: View {
    @Environment(\.modelContext) private var modelContext
    
    public init() {}
    
    public var body: some View {
        EntryListView(viewModel: createViewModel())
    }
    
    private func createViewModel() -> EntryListViewModel {
        let repository = SwiftDataEntryRepository(modelContext: modelContext)
        let useCase = ListEntriesUseCase(repository: repository)
        return EntryListViewModel(listEntriesUseCase: useCase)
    }
}


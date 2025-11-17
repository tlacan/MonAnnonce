import SwiftUI

public struct EntryListView: View {
    @StateObject private var viewModel: EntryListViewModel
    let coordinator: VoiceEntryCoordinator
    
    public init(coordinator: VoiceEntryCoordinator) {
        self.coordinator = coordinator
        // Create view model from coordinator's model context
        let repository = SwiftDataEntryRepository(modelContext: coordinator.modelContext)
        let useCase = ListEntriesUseCase(repository: repository)
        _viewModel = StateObject(wrappedValue: EntryListViewModel(listEntriesUseCase: useCase))
    }
    
    public var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.entries.isEmpty {
                emptyStateView
            } else {
                entriesList
            }
        }
        .navigationTitle("entry.list.title".localized())
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    coordinator.handle(VoiceEntryAction.showRecording)
                } label: {
                    Image(systemName: "mic.fill")
                }
                .accessibilityLabel("entry.record.new".localized())
            }
        }
        .task {
            await viewModel.loadEntries()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("EntryCreated"))) { _ in
            Task {
                await viewModel.loadEntries()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "mic.slash")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("entry.list.empty.state".localized())
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var entriesList: some View {
        List(viewModel.entries) { entry in
            Button {
                coordinator.handle(VoiceEntryAction.showEntryDetail(entry))
            } label: {
                EntryRowView(entry: entry)
            }
            .buttonStyle(.plain)
        }
    }
    
}

struct EntryRowView: View {
    let entry: EntryModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !entry.title.isEmpty {
                Text(entry.title)
                    .font(.headline)
            }
            
            if !entry.transcribedText.isEmpty {
                Text(entry.transcribedText)
                    .font(.body)
                    .lineLimit(3)
            }
            
            HStack {
                Text(entry.creationDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if entry.emailSent {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.green)
                        .accessibilityLabel("entry.detail.email.sent.accessibility".localized())
                } else {
                    Image(systemName: "envelope")
                        .foregroundColor(.secondary)
                        .accessibilityLabel("entry.detail.email.not.sent.accessibility".localized())
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    // Preview requires a coordinator, so we'll create a mock one
    // For preview purposes, we'll use a simplified view
    let repository = MockEntryRepository()
    let useCase = ListEntriesUseCase(repository: repository)
    let viewModel = EntryListViewModel(listEntriesUseCase: useCase)
    Text("preview.not.available".localized())
}

// Mock repository for previews
final class MockEntryRepository: @unchecked Sendable, EntryRepository {
    func save(_ entry: EntryModel) async throws {}
    func fetchAll() async throws -> [EntryModel] {
        return [
            EntryModel(
                transcribedText: "Test entry 1",
                brand: "Test Brand",
                title: "Test Title 1"
            ),
            EntryModel(
                transcribedText: "Test entry 2",
                brand: "Test Brand 2",
                title: "Test Title 2"
            )
        ]
    }
    func fetch(by id: String) async throws -> EntryModel? { nil }
    func delete(_ entry: EntryModel) async throws {}
    func update(_ entry: EntryModel) async throws {}
}


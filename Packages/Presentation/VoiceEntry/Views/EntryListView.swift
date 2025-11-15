import SwiftUI

public struct EntryListView: View {
    @StateObject private var viewModel: EntryListViewModel
    @State private var showingRecordingView = false
    
    public init(viewModel: EntryListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationStack {
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
            .navigationTitle("Entries")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingRecordingView = true
                    } label: {
                        Image(systemName: "mic.fill")
                    }
                    .accessibilityLabel("Record new entry")
                }
            }
            .sheet(isPresented: $showingRecordingView) {
                // RecordingView will be implemented in User Story 2
                Text("Recording View - Coming in User Story 2")
            }
            .task {
                await viewModel.loadEntries()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "mic.slash")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No entries yet. Tap the record button to create your first entry.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var entriesList: some View {
        List(viewModel.entries) { entry in
            EntryRowView(entry: entry)
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
                        .accessibilityLabel("Email sent")
                } else {
                    Image(systemName: "envelope")
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Email not sent")
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let repository = MockEntryRepository()
    let useCase = ListEntriesUseCase(repository: repository)
    let viewModel = EntryListViewModel(listEntriesUseCase: useCase)
    return EntryListView(viewModel: viewModel)
}

// Mock repository for previews
class MockEntryRepository: EntryRepository {
    func save(_ entry: EntryModel) async throws {}
    func fetchAll() async throws -> [EntryModel] {
        return [
            EntryModel(
                transcribedText: "Test entry 1",
                title: "Test Title 1",
                brand: "Test Brand"
            ),
            EntryModel(
                transcribedText: "Test entry 2",
                title: "Test Title 2",
                brand: "Test Brand 2"
            )
        ]
    }
    func fetch(by id: String) async throws -> EntryModel? { nil }
    func delete(_ entry: EntryModel) async throws {}
    func update(_ entry: EntryModel) async throws {}
}


import SwiftUI

public struct EntryListView: View {
    @StateObject private var viewModel: EntryListViewModel
    @Binding var showingRecordingView: Bool
    let recordingViewModel: RecordingViewModel?
    let detailViewModelFactory: ((EntryModel) -> EntryDetailViewModel)?
    
    public init(
        viewModel: EntryListViewModel,
        showingRecordingView: Binding<Bool> = .constant(false),
        recordingViewModel: RecordingViewModel? = nil,
        detailViewModelFactory: ((EntryModel) -> EntryDetailViewModel)? = nil
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _showingRecordingView = showingRecordingView
        self.recordingViewModel = recordingViewModel
        self.detailViewModelFactory = detailViewModelFactory
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
                    showingRecordingView = true
                } label: {
                    Image(systemName: "mic.fill")
                }
                .accessibilityLabel("entry.record.new".localized())
            }
        }
        .sheet(isPresented: $showingRecordingView) {
            if let recordingViewModel = recordingViewModel {
                RecordingView(viewModel: recordingViewModel)
                    .onDisappear {
                        Task {
                            await viewModel.loadEntries()
                        }
                    }
            }
        }
        .navigationDestination(for: EntryModel.self) { entry in
            if let factory = detailViewModelFactory {
                EntryDetailView(viewModel: factory(entry))
            } else {
                // Fallback for previews
                Text("Detail view not configured")
            }
        }
        .task {
            await viewModel.loadEntries()
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
            NavigationLink(value: entry) {
                EntryRowView(entry: entry)
            }
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
    let repository = MockEntryRepository()
    let useCase = ListEntriesUseCase(repository: repository)
    let viewModel = EntryListViewModel(listEntriesUseCase: useCase)
    return EntryListView(
        viewModel: viewModel,
        showingRecordingView: .constant(false),
        recordingViewModel: nil
    )
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


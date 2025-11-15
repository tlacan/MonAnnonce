import SwiftUI
import SwiftData

/// Coordinator for Voice Entry feature navigation
public struct VoiceEntryCoordinator: View {
    @Environment(\.modelContext) private var modelContext
    
    public init() {}
    
    public var body: some View {
        EntryListViewWrapper(modelContext: modelContext)
    }
}

private struct EntryListViewWrapper: View {
    let modelContext: ModelContext
    @StateObject private var viewModel: EntryListViewModel
    @State private var showingRecordingView = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        let repository = SwiftDataEntryRepository(modelContext: modelContext)
        let useCase = ListEntriesUseCase(repository: repository)
        _viewModel = StateObject(wrappedValue: EntryListViewModel(listEntriesUseCase: useCase))
    }
    
    var body: some View {
        EntryListViewWithNavigation(
            viewModel: viewModel,
            showingRecordingView: $showingRecordingView,
            recordingViewModel: createRecordingViewModel(),
            modelContext: modelContext
        )
    }
    
    private func createRecordingViewModel() -> RecordingViewModel {
        let repository = SwiftDataEntryRepository(modelContext: modelContext)
        let audioService = AVFoundationAudioRecordingService()
        let transcriptionService = SpeechFrameworkTranscriptionService()
        let extractionService = AppleFoundationModelsTextExtractionService()
        
        // Setup email service
        let emailService = MessageUIEmailService(recipientEmail: AppConfig.recipientEmail)
        let sendEmailUseCase = SendEmailUseCase(
            emailService: emailService,
            recipientEmail: AppConfig.recipientEmail
        )
        
        let createUseCase = CreateEntryUseCase(
            repository: repository,
            sendEmailUseCase: sendEmailUseCase
        )
        
        return RecordingViewModel(
            audioRecordingService: audioService,
            transcriptionService: transcriptionService,
            extractionService: extractionService,
            createEntryUseCase: createUseCase
        )
    }
}

private struct EntryListViewWithNavigation: View {
    @ObservedObject var viewModel: EntryListViewModel
    @Binding var showingRecordingView: Bool
    let recordingViewModel: RecordingViewModel
    let modelContext: ModelContext
    
    var body: some View {
        NavigationStack {
            EntryListView(
                viewModel: viewModel,
                showingRecordingView: $showingRecordingView,
                recordingViewModel: recordingViewModel
            )
            .navigationDestination(for: EntryModel.self) { entry in
                EntryDetailView(viewModel: createDetailViewModel(for: entry))
            }
        }
    }
    
    private func createDetailViewModel(for entry: EntryModel) -> EntryDetailViewModel {
        let repository = SwiftDataEntryRepository(modelContext: modelContext)
        let emailService = MessageUIEmailService(recipientEmail: AppConfig.recipientEmail)
        let sendEmailUseCase = SendEmailUseCase(
            emailService: emailService,
            recipientEmail: AppConfig.recipientEmail
        )
        
        return EntryDetailViewModel(
            entry: entry,
            sendEmailUseCase: sendEmailUseCase,
            repository: repository
        )
    }
}


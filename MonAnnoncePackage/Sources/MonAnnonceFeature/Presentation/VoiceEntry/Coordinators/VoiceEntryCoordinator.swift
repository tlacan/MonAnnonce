import SwiftUI
import SwiftData
import SwiftUICoordinator

/// Coordinator for Voice Entry feature navigation using SwiftUICoordinator
@MainActor
public final class VoiceEntryCoordinator: Routing {
    public weak var parent: Coordinator?
    public var childCoordinators: [Coordinator] = []
    public let navigationController: UINavigationController
    public let startRoute: VoiceEntryRoute
    
    public let modelContext: ModelContext
    
    public init(
        parent: Coordinator? = nil,
        navigationController: UINavigationController,
        modelContext: ModelContext,
        startRoute: VoiceEntryRoute = .entryList
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.modelContext = modelContext
        self.startRoute = startRoute
    }
    
    public func handle(_ action: CoordinatorAction) {
        switch action {
        case let action as VoiceEntryAction:
            handleVoiceEntryAction(action)
        default:
            parent?.handle(action)
        }
    }
    
    private func handleVoiceEntryAction(_ action: VoiceEntryAction) {
        switch action {
        case let .showEntryDetail(entry):
            show(route: VoiceEntryRoute.entryDetail(entry))
        case .showRecording:
            show(route: VoiceEntryRoute.recording)
        case .dismissRecording:
            dismiss(animated: true)
        case .entryCreated:
            // Refresh the list when an entry is created
            NotificationCenter.default.post(name: NSNotification.Name("EntryCreated"), object: nil)
            dismiss(animated: true)
        case .dismissDetail:
            pop(animated: true)
        }
    }
}

// MARK: - RouterViewFactory

extension VoiceEntryCoordinator: RouterViewFactory {
    @ViewBuilder
    public func view(for route: VoiceEntryRoute) -> some View {
        switch route {
        case .entryList:
            EntryListView(coordinator: self)
        case let .entryDetail(entry):
            EntryDetailView(viewModel: createDetailViewModel(for: entry))
        case .recording:
            RecordingView(viewModel: createRecordingViewModel(), coordinator: self)
        }
    }
    
    // MARK: - View Model Factories
    
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

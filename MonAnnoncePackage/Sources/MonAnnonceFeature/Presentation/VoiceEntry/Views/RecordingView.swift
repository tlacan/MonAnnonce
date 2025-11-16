import SwiftUI

public struct RecordingView: View {
    @StateObject private var viewModel: RecordingViewModel
    let coordinator: VoiceEntryCoordinator?
    @State private var hasRequestedPermissions = false
    
    public init(viewModel: RecordingViewModel, coordinator: VoiceEntryCoordinator? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if !hasRequestedPermissions {
                    permissionsView
                } else if viewModel.isRecording {
                    recordingView
                } else if viewModel.isTranscribing {
                    transcribingView
                } else if viewModel.isExtracting {
                    extractingView
                } else if viewModel.isSaving {
                    savingView
                } else if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                    errorView
                } else {
                    readyView
                }
            }
            .padding()
            .navigationTitle("entry.record.title".localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("entry.record.cancel".localized()) {
                        viewModel.cancelRecording()
                        if let coordinator = coordinator {
                            coordinator.handle(VoiceEntryAction.dismissRecording)
                        }
                    }
                }
            }
            .task {
                if !hasRequestedPermissions {
                    let granted = await viewModel.requestPermissions()
                    hasRequestedPermissions = true
                    if !granted {
                        viewModel.errorMessage = "entry.record.permissions.required".localized()
                    }
                }
            }
            .onChange(of: viewModel.isSaving) { oldValue, newValue in
                // When saving completes, notify coordinator
                if oldValue && !newValue && viewModel.errorMessage == nil {
                    if let coordinator = coordinator {
                        coordinator.handle(VoiceEntryAction.entryCreated)
                    }
                }
            }
        }
    }
    
    private var permissionsView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("entry.record.requesting.permissions".localized())
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var readyView: some View {
        VStack(spacing: 24) {
            Image(systemName: "mic.fill")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            Text("entry.record.ready".localized())
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                Task {
                    await viewModel.startRecording()
                }
            } label: {
                HStack {
                    Image(systemName: "mic.fill")
                    Text("entry.record.start".localized())
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(12)
            }
            .accessibilityLabel("entry.record.start.accessibility".localized())
        }
    }
    
    private var recordingView: some View {
        VStack(spacing: 24) {
            Image(systemName: "mic.fill")
                .font(.system(size: 64))
                .foregroundColor(.red)
                .symbolEffect(.pulse)
            
            Text("entry.record.recording".localized())
                .font(.headline)
            
            Button {
                Task {
                    await viewModel.stopRecording()
                }
            } label: {
                HStack {
                    Image(systemName: "stop.fill")
                    Text("entry.record.stop".localized())
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(12)
            }
            .accessibilityLabel("entry.record.stop.accessibility".localized())
        }
    }
    
    private var transcribingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("entry.record.transcribing".localized())
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var extractingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("entry.record.extracting".localized())
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var savingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("entry.record.saving".localized())
                .font(.body)
                .foregroundColor(.secondary)
        }
        .onAppear {
            // Auto-dismiss after a short delay when saving completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if !viewModel.isSaving && viewModel.errorMessage?.isEmpty ?? true {
                    if let coordinator = coordinator {
                        coordinator.handle(VoiceEntryAction.entryCreated)
                    }
                }
            }
        }
    }
    
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text(viewModel.errorMessage ?? "entry.record.error".localized())
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("entry.record.try.again".localized()) {
                viewModel.errorMessage = nil
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    let audioService = AVFoundationAudioRecordingService()
    let transcriptionService = SpeechFrameworkTranscriptionService()
    let extractionService = AppleFoundationModelsTextExtractionService()
    let repository = MockEntryRepository()
    let createUseCase = CreateEntryUseCase(repository: repository)
    let viewModel = RecordingViewModel(
        audioRecordingService: audioService,
        transcriptionService: transcriptionService,
        extractionService: extractionService,
        createEntryUseCase: createUseCase
    )
    return RecordingView(viewModel: viewModel)
}


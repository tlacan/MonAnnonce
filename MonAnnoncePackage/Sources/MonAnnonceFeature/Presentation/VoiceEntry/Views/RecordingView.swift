import SwiftUI

public struct RecordingView: View {
    @StateObject private var viewModel: RecordingViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var hasRequestedPermissions = false
    
    public init(viewModel: RecordingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
            .navigationTitle("Record Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.cancelRecording()
                        dismiss()
                    }
                }
            }
            .task {
                if !hasRequestedPermissions {
                    let granted = await viewModel.requestPermissions()
                    hasRequestedPermissions = true
                    if !granted {
                        viewModel.errorMessage = "Permissions are required to record voice entries"
                    }
                }
            }
        }
    }
    
    private var permissionsView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Requesting permissions...")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var readyView: some View {
        VStack(spacing: 24) {
            Image(systemName: "mic.fill")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            Text("Tap the record button to start recording")
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
                    Text("Start Recording")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(12)
            }
            .accessibilityLabel("Start recording")
        }
    }
    
    private var recordingView: some View {
        VStack(spacing: 24) {
            Image(systemName: "mic.fill")
                .font(.system(size: 64))
                .foregroundColor(.red)
                .symbolEffect(.pulse)
            
            Text("Recording...")
                .font(.headline)
            
            Button {
                Task {
                    await viewModel.stopRecording()
                }
            } label: {
                HStack {
                    Image(systemName: "stop.fill")
                    Text("Stop Recording")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(12)
            }
            .accessibilityLabel("Stop recording")
        }
    }
    
    private var transcribingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Transcribing audio...")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var extractingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Extracting structured data...")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var savingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Saving entry and sending email...")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .onAppear {
            // Auto-dismiss after a short delay when saving completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if !viewModel.isSaving && viewModel.errorMessage?.isEmpty ?? true {
                    dismiss()
                }
            }
        }
    }
    
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text(viewModel.errorMessage ?? "An error occurred")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
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


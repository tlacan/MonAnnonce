import SwiftUI
import Foundation

@MainActor
public final class RecordingViewModel: ObservableObject {
    @Published public var isRecording = false
    @Published public var isTranscribing = false
    @Published public var isExtracting = false
    @Published public var isSaving = false
    @Published public var errorMessage: String?
    @Published public var transcribedText: String = ""
    @Published public var recordingURL: URL?
    
    private let audioRecordingService: AudioRecordingService
    private let transcriptionService: SpeechTranscriptionService
    private let extractionService: FoundationModelsTextExtractionService
    private let createEntryUseCase: CreateEntryUseCase
    
    public init(
        audioRecordingService: AudioRecordingService,
        transcriptionService: SpeechTranscriptionService,
        extractionService: FoundationModelsTextExtractionService,
        createEntryUseCase: CreateEntryUseCase
    ) {
        self.audioRecordingService = audioRecordingService
        self.transcriptionService = transcriptionService
        self.extractionService = extractionService
        self.createEntryUseCase = createEntryUseCase
    }
    
    public func requestPermissions() async -> Bool {
        let micPermission = await audioRecordingService.requestMicrophonePermission()
        let speechPermission = await transcriptionService.requestSpeechRecognitionPermission()
        return micPermission && speechPermission
    }
    
    public func hasPermissions() -> Bool {
        audioRecordingService.hasMicrophonePermission() && 
        transcriptionService.hasSpeechRecognitionPermission()
    }
    
    public func startRecording() async {
        errorMessage = nil
        
        guard hasPermissions() else {
            errorMessage = "Microphone and speech recognition permissions are required"
            return
        }
        
        do {
            let url = try await audioRecordingService.startRecording()
            recordingURL = url
            isRecording = true
        } catch {
            errorMessage = "Failed to start recording: \(error.localizedDescription)"
        }
    }
    
    public func stopRecording() async {
        guard isRecording else { return }
        
        do {
            let url = try await audioRecordingService.stopRecording()
            recordingURL = url
            isRecording = false
            
            // Start transcription
            await transcribeAndCreateEntry(audioURL: url)
        } catch {
            isRecording = false
            errorMessage = "Failed to stop recording: \(error.localizedDescription)"
        }
    }
    
    public func cancelRecording() {
        audioRecordingService.cancelRecording()
        isRecording = false
        recordingURL = nil
        errorMessage = nil
    }
    
    private func transcribeAndCreateEntry(audioURL: URL) async {
        isTranscribing = true
        errorMessage = nil
        
        do {
            // Transcribe audio
            let text = try await transcriptionService.transcribe(audioURL: audioURL, locale: nil)
            transcribedText = text
            isTranscribing = false
            
            // Extract structured data
            isExtracting = true
            let structuredData = try await extractionService.extractStructuredData(from: text)
            isExtracting = false
            
            // Create entry
            isSaving = true
            _ = try await createEntryUseCase.execute(
                transcribedText: text,
                audioRecordingURL: audioURL,
                structuredData: structuredData
            )
            isSaving = false
            
        } catch {
            isTranscribing = false
            isExtracting = false
            isSaving = false
            errorMessage = "Failed to process recording: \(error.localizedDescription)"
        }
    }
}


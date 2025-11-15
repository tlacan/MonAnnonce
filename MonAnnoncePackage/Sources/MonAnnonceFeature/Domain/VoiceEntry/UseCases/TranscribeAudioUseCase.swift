import Foundation

/// Use case for transcribing audio to text
public struct TranscribeAudioUseCase: Sendable {
    private let transcriptionService: SpeechTranscriptionService
    
    public init(transcriptionService: SpeechTranscriptionService) {
        self.transcriptionService = transcriptionService
    }
    
    public func execute(audioURL: URL, locale: Locale? = nil) async throws -> String {
        return try await transcriptionService.transcribe(audioURL: audioURL, locale: locale)
    }
}


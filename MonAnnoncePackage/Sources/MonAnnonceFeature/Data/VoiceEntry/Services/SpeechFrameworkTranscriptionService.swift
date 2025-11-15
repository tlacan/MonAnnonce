import Speech
import Foundation

/// Speech framework implementation of SpeechTranscriptionService
public final class SpeechFrameworkTranscriptionService: @unchecked Sendable, SpeechTranscriptionService {
    public init() {}
    
    public func requestSpeechRecognitionPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
    
    public func hasSpeechRecognitionPermission() -> Bool {
        SFSpeechRecognizer.authorizationStatus() == .authorized
    }
    
    public func transcribe(audioURL: URL, locale: Locale?) async throws -> String {
        guard hasSpeechRecognitionPermission() else {
            throw TranscriptionError.permissionDenied
        }
        
        let recognizerLocale = locale ?? Locale.current
        guard let recognizer = SFSpeechRecognizer(locale: recognizerLocale) else {
            throw TranscriptionError.languageNotSupported
        }
        
        guard recognizer.isAvailable else {
            throw TranscriptionError.recognitionUnavailable
        }
        
        let request = SFSpeechURLRecognitionRequest(url: audioURL)
        request.shouldReportPartialResults = false
        
        return try await withCheckedThrowingContinuation { continuation in
            let task = recognizer.recognitionTask(with: request) { result, error in
                if let error = error {
                    let nsError = error as NSError
                    if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 216 {
                        // User cancelled
                        continuation.resume(throwing: TranscriptionError.userCancelled)
                    } else {
                        continuation.resume(throwing: TranscriptionError.transcriptionFailed)
                    }
                    return
                }
                
                if let result = result, result.isFinal {
                    continuation.resume(returning: result.bestTranscription.formattedString)
                }
                // Note: If result is not final and no error, the continuation will wait
                // The Speech framework will eventually call this with either a final result or an error
            }
            
            // Store task reference to prevent deallocation
            // The task will be retained by the recognizer until completion
            _ = task
        }
    }
}


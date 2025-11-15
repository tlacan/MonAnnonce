import Speech
import Foundation

/// Service protocol for speech recognition and transcription
public protocol SpeechTranscriptionService: Sendable {
    /// Request speech recognition permission
    /// - Returns: True if permission granted, false otherwise
    func requestSpeechRecognitionPermission() async -> Bool
    
    /// Check if speech recognition permission is granted
    /// - Returns: True if permission granted, false otherwise
    func hasSpeechRecognitionPermission() -> Bool
    
    /// Transcribe audio file to text
    /// - Parameter audioURL: URL to the audio file to transcribe
    /// - Parameter locale: Locale for transcription (default: current locale)
    /// - Returns: Transcribed text
    /// - Throws: TranscriptionError if transcription fails
    func transcribe(audioURL: URL, locale: Locale?) async throws -> String
}


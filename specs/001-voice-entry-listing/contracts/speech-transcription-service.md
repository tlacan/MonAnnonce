# Speech Transcription Service Contract

**Service**: Speech Transcription  
**Framework**: Speech  
**Date**: 2025-11-15

## Protocol Definition

```swift
import Speech
import Foundation

/// Service protocol for speech recognition and transcription
protocol SpeechTranscriptionService {
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
```

## Error Types

```swift
enum TranscriptionError: Error {
    case permissionDenied
    case recognitionUnavailable
    case transcriptionFailed
    case networkError
    case invalidAudioFile
    case languageNotSupported
}
```

## Usage Pattern

1. Check/request speech recognition permission
2. Provide audio file URL
3. Transcribe audio to text
4. Handle errors gracefully

## Implementation Notes

- Uses `SFSpeechRecognizer` and `SFSpeechRecognitionTask` from Speech framework
- Supports on-device and cloud-based recognition
- Supports multiple languages (English and French)
- May require network connection depending on language and device capabilities


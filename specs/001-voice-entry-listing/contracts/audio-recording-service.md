# Audio Recording Service Contract

**Service**: Audio Recording  
**Framework**: AVFoundation  
**Date**: 2025-11-15

## Protocol Definition

```swift
import AVFoundation
import Foundation

/// Service protocol for audio recording operations
protocol AudioRecordingService {
    /// Request microphone permission
    /// - Returns: True if permission granted, false otherwise
    func requestMicrophonePermission() async -> Bool
    
    /// Check if microphone permission is granted
    /// - Returns: True if permission granted, false otherwise
    func hasMicrophonePermission() -> Bool
    
    /// Start recording audio
    /// - Returns: URL to the recorded audio file
    /// - Throws: RecordingError if recording fails
    func startRecording() async throws -> URL
    
    /// Stop recording audio
    /// - Throws: RecordingError if stopping fails
    func stopRecording() async throws
    
    /// Check if currently recording
    /// - Returns: True if recording is in progress
    func isRecording() -> Bool
    
    /// Cancel current recording (discard audio)
    func cancelRecording()
}
```

## Error Types

```swift
enum RecordingError: Error {
    case permissionDenied
    case recordingFailed
    case audioSessionError
    case fileSystemError
    case invalidAudioFormat
}
```

## Usage Pattern

1. Check/request microphone permission
2. Start recording
3. Stop recording (returns audio file URL)
4. Handle errors gracefully

## Implementation Notes

- Uses `AVAudioRecorder` from AVFoundation
- Saves audio files to app's document directory
- Audio format: AAC, sample rate: 44100 Hz, channels: 1 (mono)
- Returns URL to saved audio file for transcription


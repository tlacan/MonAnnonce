import AVFoundation
import Foundation

/// Service protocol for audio recording operations
public protocol AudioRecordingService: Sendable {
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
    /// - Returns: URL to the recorded audio file
    /// - Throws: RecordingError if stopping fails
    func stopRecording() async throws -> URL
    
    /// Check if currently recording
    /// - Returns: True if recording is in progress
    func isRecording() -> Bool
    
    /// Cancel current recording (discard audio)
    func cancelRecording()
}


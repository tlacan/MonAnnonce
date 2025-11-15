import Foundation

/// Error types for Entry operations
public enum EntryError: Error {
    case invalidData
    case saveFailed
    case fetchFailed
    case deleteFailed
    case updateFailed
}

/// Error types for audio recording operations
public enum RecordingError: Error {
    case permissionDenied
    case recordingFailed
    case audioSessionError
    case fileSystemError
    case invalidAudioFormat
}

/// Error types for speech transcription operations
public enum TranscriptionError: Error {
    case permissionDenied
    case recognitionUnavailable
    case transcriptionFailed
    case networkError
    case invalidAudioFile
    case languageNotSupported
}

/// Error types for email operations
public enum EmailError: Error {
    case emailNotConfigured
    case sendingFailed
    case userCancelled
    case invalidRecipient
    case networkError
}

/// Error types for data operations
public enum DataError: Error {
    case saveFailed
    case fetchFailed
    case invalidData
    case notFound
}

/// Error types for image operations
public enum ImageError: Error {
    case permissionDenied
    case pickerFailed
    case saveFailed
    case invalidImage
}

/// Error types for text extraction operations
public enum TextExtractionError: Error {
    case extractionFailed
    case invalidInput
    case networkError
    case unsupportedFormat
}


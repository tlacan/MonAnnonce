import AVFoundation
import Foundation

/// AVFoundation implementation of AudioRecordingService
public final class AVFoundationAudioRecordingService: @unchecked Sendable, AudioRecordingService {
    private var audioRecorder: AVAudioRecorder?
    private var recordingURL: URL?
    private let audioSession: AVAudioSession
    
    public init(audioSession: AVAudioSession = .sharedInstance()) {
        self.audioSession = audioSession
    }
    
    public func requestMicrophonePermission() async -> Bool {
        if #available(iOS 17.0, *) {
            return await AVAudioApplication.requestRecordPermission()
        } else {
            return await withCheckedContinuation { continuation in
                audioSession.requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
        }
    }
    
    public func hasMicrophonePermission() -> Bool {
        if #available(iOS 17.0, *) {
            return AVAudioApplication.shared.recordPermission == .granted
        } else {
            return audioSession.recordPermission == .granted
        }
    }
    
    public func startRecording() async throws -> URL {
        guard hasMicrophonePermission() else {
            throw RecordingError.permissionDenied
        }
        
        // Configure audio session
        try audioSession.setCategory(.playAndRecord, mode: .default)
        try audioSession.setActive(true)
        
        // Create audio file URL
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsPath.appendingPathComponent("recording_\(UUID().uuidString).m4a")
        recordingURL = audioFilename
        
        // Audio settings
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        // Create and start recorder
        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        
        guard let recorder = audioRecorder, recorder.record() else {
            throw RecordingError.recordingFailed
        }
        
        return audioFilename
    }
    
    public func stopRecording() async throws -> URL {
        guard let recorder = audioRecorder else {
            throw RecordingError.recordingFailed
        }
        
        recorder.stop()
        audioRecorder = nil
        
        try audioSession.setActive(false)
        
        guard let url = recordingURL else {
            throw RecordingError.fileSystemError
        }
        
        return url
    }
    
    public func isRecording() -> Bool {
        audioRecorder?.isRecording ?? false
    }
    
    public func cancelRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        
        // Delete the file if it exists
        if let url = recordingURL {
            try? FileManager.default.removeItem(at: url)
        }
        recordingURL = nil
        
        try? audioSession.setActive(false)
    }
}


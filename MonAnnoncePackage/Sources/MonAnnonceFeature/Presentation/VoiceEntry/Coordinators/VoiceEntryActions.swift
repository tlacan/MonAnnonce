import Foundation
import SwiftUICoordinator

/// Actions for Voice Entry coordinator
public enum VoiceEntryAction: CoordinatorAction {
    case showEntryDetail(EntryModel)
    case showRecording
    case dismissRecording
    case entryCreated
    case dismissDetail
    
    public var name: String {
        switch self {
        case .showEntryDetail:
            return "showEntryDetail"
        case .showRecording:
            return "showRecording"
        case .dismissRecording:
            return "dismissRecording"
        case .entryCreated:
            return "entryCreated"
        case .dismissDetail:
            return "dismissDetail"
        }
    }
}


import Foundation
import SwiftUICoordinator

/// Navigation routes for Voice Entry feature
public enum VoiceEntryRoute: StackNavigationRoute {
    case entryList
    case entryDetail(EntryModel)
    case recording
    
    public var action: TransitionAction {
        switch self {
        case .entryList:
            return .push(animated: true)
        case .entryDetail:
            return .push(animated: true)
        case .recording:
            return .present(animated: true)
        }
    }
    
    public var title: String? {
        switch self {
        case .entryList:
            return "entry.list.title".localized()
        case .entryDetail:
            return "entry.detail.title".localized()
        case .recording:
            return "entry.record.title".localized()
        }
    }
    
    public var appearance: RouteAppearance? {
        nil
    }
    
    public var hidesNavigationBar: Bool? {
        nil
    }
    
    public var hidesBackButton: Bool? {
        switch self {
        case .entryList:
            return true
        default:
            return nil
        }
    }
}


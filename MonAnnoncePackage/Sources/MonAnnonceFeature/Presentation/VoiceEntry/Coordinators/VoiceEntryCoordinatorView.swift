import SwiftUI
import SwiftData
import SwiftUICoordinator

/// SwiftUI wrapper for VoiceEntryCoordinator
public struct VoiceEntryCoordinatorView: UIViewControllerRepresentable {
    let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    public func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        let coordinator = VoiceEntryCoordinator(
            navigationController: navigationController,
            modelContext: modelContext,
            startRoute: .entryList
        )
        coordinator.start()
        return navigationController
    }
    
    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No updates needed
    }
}


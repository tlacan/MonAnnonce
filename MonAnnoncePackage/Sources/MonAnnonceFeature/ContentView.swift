import SwiftUI
import SwiftData

public struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    public init() {}
    
    public var body: some View {
        VoiceEntryCoordinatorView(modelContext: modelContext)
    }
}

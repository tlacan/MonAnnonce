import SwiftUI
import SwiftData
import MonAnnonceFeature

@main
struct MonAnnonceApp: App {
    @State private var modelContainer: ModelContainer
    
    init() {
        let schema = Schema([EntryModel.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}

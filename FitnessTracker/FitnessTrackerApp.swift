import SwiftUI
import FirebaseCore

@main
struct FitnessTrackerApp: App {
    @State private var authVM = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authVM)
        }
    }
}

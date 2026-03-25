import SwiftUI
import FirebaseCore

@main
struct FitnessTrackerApp: App {
    @State private var authVM = AuthViewModel()
    @State private var workoutManager = WorkoutManager()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authVM)
                .environment(workoutManager)
        }
    }
}

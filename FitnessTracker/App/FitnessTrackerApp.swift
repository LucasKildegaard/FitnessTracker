//
//  FitnessTrackerApp.swift
//  FitnessTracker
//
//  Created by Lucas Kildegaard on 15/03/2026.
//

import SwiftUI
import FirebaseCore
import CoreText

@main
struct FitnessTrackerApp: App {
    @State var authVM: AuthViewModel

    init() {
        FirebaseApp.configure()
        _authVM = State(initialValue: AuthViewModel())
        registerFonts()
    }

    private func registerFonts() {
        let fontNames = ["Iceland-Regular"]
        for name in fontNames {
            if let url = Bundle.main.url(forResource: name, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.isLoggedIn {
                    ContentView()
                        .environment(authVM)
                } else {
                    LoginView()
                        .environment(authVM)
                }
            }
            .task {
                authVM.startListening()
            }
        }
    }
}

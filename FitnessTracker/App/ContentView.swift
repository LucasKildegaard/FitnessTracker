//
//  ContentView.swift
//  FitnessTracker
//
//  Created by Lucas Kildegaard on 15/03/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthViewModel.self) var authVM

    var body: some View {
        Group {
            if authVM.isLoggedIn {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            authVM.startListening()
        }
    }
}



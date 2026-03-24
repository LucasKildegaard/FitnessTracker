//
//  AuthViewModel.swift
//  FitnessTracker
//
//  Created by Lucas Kildegaard
//

import Foundation
import Observation
import FirebaseAuth

@Observable
class AuthViewModel {
    var isLoggedIn: Bool = false
    var errorMessage: String = ""

    init() {
        // Don't access Auth here - Firebase may not be ready yet.
        // Call startListening() from the view after Firebase is configured.
    }

    func startListening() {
        _ = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = user != nil
            }
        }
    }

    func login(email: String, password: String) async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            self.errorMessage = ""
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func signUp(email: String, password: String) async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            self.errorMessage = ""
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}



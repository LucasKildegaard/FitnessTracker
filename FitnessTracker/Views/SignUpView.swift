//
//  SignUpView.swift
//  FitnessTracker
//
//  Created by Lucas Kildegaard
//

import SwiftUI

struct SignUpView: View {
    @Environment(AuthViewModel.self) var authVM
    @Environment(\.dismiss) var dismiss
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false

    var passwordsMatch: Bool {
        password == confirmPassword && !password.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // ── Title ────────────────────────────────────────────
                Text("Hello! Register\nto get started")
                    .authTitleStyle()

                // ── Form Fields ──────────────────────────────────────
                VStack(spacing: 12) {

                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .authFieldStyle()

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .authFieldStyle()

                    SecureField("Password", text: $password)
                        .authFieldStyle()

                    SecureField("Confirm password", text: $confirmPassword)
                        .authFieldStyle()
                        .background(
                            confirmPassword.isEmpty ? Color.clear :
                                (passwordsMatch ? Color.green.opacity(0.05) : Color.red.opacity(0.05))
                        )
                }

                // ── Validation / Error ───────────────────────────────
                if !confirmPassword.isEmpty && !passwordsMatch {
                    Text("Passwords do not match")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                if !authVM.errorMessage.isEmpty {
                    Text(authVM.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                // ── Register button ──────────────────────────────────
                Button {
                    Task {
                        isLoading = true
                        await authVM.signUp(email: email, password: password)
                        isLoading = false
                    }
                } label: {
                    if isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Register")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!passwordsMatch || isLoading)

                // ── Or Register with ────────────────────────────────────
                OrDividerView()

                // ── Google button ────────────────────────────────────
                GoogleSignInButton()

                Spacer(minLength: 40)

                // ── Login link ───────────────────────────────────────
                HStack {
                    Text("Already have an account? ")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color.black.opacity(0.6))
                    Button("Login now") { dismiss() }
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, 24)
        }
    }
}

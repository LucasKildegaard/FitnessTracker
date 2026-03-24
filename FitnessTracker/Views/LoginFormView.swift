//
//  LoginFormView.swift
//  FitnessTracker
//
//  Created by Lucas Kildegaard
//

import SwiftUI

struct LoginFormView: View {
    @Environment(AuthViewModel.self) var authVM
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var isLoading: Bool = false
    @State private var showSignUp: Bool = false

    var body: some View {
        // No NavigationStack here – we rely on LoginView's NavigationStack
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // ── Title ────────────────────────────────────────
                Text("Welcome back! Glad\nto see you, AGAIN!")
                    .authTitleStyle()

                // ── Form Fields ──────────────────────────────────
                VStack(spacing: 12) {

                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .authFieldStyle()

                    ZStack(alignment: .trailing) {
                        Group {
                            if showPassword {
                                TextField("Enter your password", text: $password)
                            } else {
                                SecureField("Enter your password", text: $password)
                            }
                        }
                        .authFieldStyle()

                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(Color.black.opacity(0.4))
                                .padding(.trailing, 16)
                        }
                    }
                }

                // ── Forgot password ──────────────────────────────
                HStack {
                    Spacer()
                    Button("Forget your password?") {}
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color.black.opacity(0.5))
                }

                // ── Error ────────────────────────────────────────
                if !authVM.errorMessage.isEmpty {
                    Text(authVM.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                // ── Login button ─────────────────────────────────
                Button {
                    Task {
                        isLoading = true
                        await authVM.login(email: email, password: password)
                        isLoading = false
                    }
                } label: {
                    if isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Login")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isLoading)

                // ── Or login with ────────────────────────────────
                OrDividerView()

                // ── Google button ────────────────────────────────
                GoogleSignInButton()

                Spacer(minLength: 40)

                // ── Register link ────────────────────────────────
                HStack {
                    Text("Dont have an account? ")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color.black.opacity(0.6))
                    Button("Register now") { showSignUp = true }
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, 24)
        }
        .navigationDestination(isPresented: $showSignUp) {
            SignUpView()
        }
    }
}

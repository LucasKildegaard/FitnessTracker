//
//  LoginView.swift
//  FitnessTracker
//
//  Created by Lucas Kildegaard
//

import SwiftUI

struct LoginView: View {
    @State private var showLogin: Bool = false
    @State private var showSignUp: Bool = false

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 0) {

                    // ── Hero Image ──────────────────────────────────
                    ZStack(alignment: .center) {
                        Image("HeroImage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height * 0.62)
                            .clipped()

                        Text("Track")
                            .font(.custom("Iceland-Regular", size: 150))
                            .foregroundColor(.white)
                    }
                    .frame(width: geo.size.width, height: geo.size.height * 0.62)

                    // ── Buttons ─────────────────────────────────────
                    VStack(spacing: 12) {
                        Spacer()

                        // Login button
                        Button {
                            showLogin = true
                        } label: {
                            Text("Login")
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(hex: "#353535"))
                                .cornerRadius(5)
                        }
                        .padding(.horizontal, 24)

                        // Register button
                        Button {
                            showSignUp = true
                        } label: {
                            Text("Register")
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 24)

                        Spacer()
                    }
                    .frame(width: geo.size.width, height: geo.size.height * 0.38)
                    .background(Color.white)
                }
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $showLogin) {
                LoginFormView()
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}

// Hex color helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

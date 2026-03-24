//
//  AppStyles.swift
//  FitnessTracker
//
//  Shared design components used across login and signup screens.
//

import SwiftUI

// ── Title ─────────────────────────────────────────────────────────────────────
/// Inter SemiBold, 40px, #000000
struct AuthTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter-SemiBold", size: 40))
            .foregroundColor(.black)
            .lineSpacing(4)
            .padding(.top, 16)
    }
}

extension View {
    func authTitleStyle() -> some View {
        modifier(AuthTitleModifier())
    }
}

// ── Form Field ────────────────────────────────────────────────────────────────
/// bgr: rgba(0,0,0,0.05)  stroke: rgba(0,0,0,0.1)  text: rgba(0,0,0,0.6)
struct AuthFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.black.opacity(0.6))
            .padding(.horizontal, 16)
            .padding(.vertical, 18)
            .background(Color.black.opacity(0.05))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
            )
    }
}

extension View {
    func authFieldStyle() -> some View {
        modifier(AuthFieldModifier())
    }
}

// ── Primary Button ────────────────────────────────────────────────────────────
/// #353535 background, white Inter 16px, corner radius 5
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Inter", size: 16))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color(hex: "#353535").opacity(configuration.isPressed ? 0.8 : 1))
            .cornerRadius(5)
    }
}

// ── Or Divider ────────────────────────────────────────────────────────────────
struct OrDividerView: View {
    var label: String = "Or login with"
    var body: some View {
        HStack {
            Rectangle().frame(height: 1).foregroundColor(Color.black.opacity(0.15))
            Text(label)
                .font(.custom("Inter", size: 14))
                .foregroundColor(Color.black.opacity(0.5))
                .fixedSize()
            Rectangle().frame(height: 1).foregroundColor(Color.black.opacity(0.15))
        }
    }
}

// ── Google Sign-In Button ─────────────────────────────────────────────────────
struct GoogleSignInButton: View {
    var action: () -> Void = {}
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Image("GoogleLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                Spacer()
            }
            .padding(.vertical, 14)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
            )
        }
    }
}

//
//  ProfileView.swift
//  FitnessTracker
//
//  Created by Lucas Kildegaard
//

import SwiftUI

struct ProfileView: View {
    @Environment(AuthViewModel.self) var authVM

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Header
            VStack(spacing: 8) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color(hex: "#353535"))
                
                Text("My Profile")
                    .font(.custom("Inter-ExtraBold", size: 24))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            // Logout button
            Button {
                authVM.logout()
            } label: {
                Text("Log out")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "#353535"))
                    .cornerRadius(5)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

#Preview {
    ProfileView()
        .environment(AuthViewModel())
}

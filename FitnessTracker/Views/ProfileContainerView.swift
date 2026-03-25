//
//  ProfileContainerView.swift
//  FitnessTracker
//

import SwiftUI

struct ProfileContainerView: View {
    @State private var selectedProfileTab: Int = 0 // 0: Progress, 1: Activities
    
    var body: some View {
        VStack(spacing: 0) {
            // Shared Dark Header reusing RoutineHeader
            RoutineHeader(
                mode: .profile,
                onLeadingTap: {},
                onTrailingTap: {}
            )
            
            // Tab Switcher Area (Dark background continues)
            VStack {
                HStack(spacing: 0) {
                    TabButton(title: "Progress", isSelected: selectedProfileTab == 0) {
                        selectedProfileTab = 0
                    }
                    
                    TabButton(title: "Activities", isSelected: selectedProfileTab == 1) {
                        selectedProfileTab = 1
                    }
                }
            }
            .padding(.bottom, 16)
            .background(Color(hex: "#353535"))
            
            // Content Area
            if selectedProfileTab == 0 {
                ProgressView()
            } else {
                ActivitiesView()
            }
            
            Spacer()
        }
        .background(Color.white)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Inter-ExtraBold", size: 16))
                .foregroundColor(.white)
                .opacity(isSelected ? 1.0 : 0.6)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ProfileContainerView()
}

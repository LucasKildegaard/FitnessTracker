//
//  FooterBar.swift
//  FitnessTracker
//

import SwiftUI

struct FooterBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 0) {
            FooterBarItem(
                icon: "DumbellIcon",
                label: "Routine",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }

            FooterBarItem(
                icon: "PersonIcon",
                label: "You",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .background(Color(hex: "#353535"))
        .padding(.bottom, 20)
    }
}

struct FooterBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    private var itemColor: Color {
        isSelected ? Color(hex: "#5F97F6") : .white
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(itemColor)

                Text(label)
                    .font(.custom("Inter", size: 11))
                    .foregroundColor(itemColor)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle()) // Ensures the entire generic area is tappable
        }
        .buttonStyle(PlainButtonStyle())
    }
}

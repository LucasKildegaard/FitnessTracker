//
//  AddExerciseButton.swift
//  FitnessTracker
//

import SwiftUI

struct AddExerciseButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image("VectorIcon")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
                Text("Add excercise")
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(hex: "#353535"))
            .cornerRadius(6)
        }
    }
}

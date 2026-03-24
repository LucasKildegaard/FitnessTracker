//
//  SetRow.swift
//  FitnessTracker
//

import SwiftUI

struct SetRow: View {
    let mode: CardMode
    let setNumber: Int
    @Binding var reps: String
    @Binding var kg: String
    @Binding var isDone: Bool

    var body: some View {
        HStack(spacing: 8) {
            // SET (auto number)
            Text("\(setNumber)")
                .font(.custom("Inter", size: 14))
                .foregroundColor(isDone && mode == .workout ? .white : Color.black.opacity(0.5))
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(isDone && mode == .workout ? Color(hex: "#5F97F6") : Color.white)
                .cornerRadius(6)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.1), lineWidth: 1))

            // REPS input
            TextField("", text: $reps)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.custom("Inter", size: 14))
                .foregroundColor(isDone && mode == .workout ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(isDone && mode == .workout ? Color(hex: "#5F97F6") : Color.white)
                .cornerRadius(6)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.1), lineWidth: 1))
                .disabled(mode == .workout && isDone)

            // KG input
            TextField("", text: $kg)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .font(.custom("Inter", size: 14))
                .foregroundColor(isDone && mode == .workout ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(isDone && mode == .workout ? Color(hex: "#5F97F6") : Color.white)
                .cornerRadius(6)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.1), lineWidth: 1))
                .disabled(mode == .workout && isDone)
                
            if mode == .workout {
                Button {
                    isDone.toggle()
                } label: {
                    ZStack {
                        if isDone {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(isDone ? Color(hex: "#5F97F6") : Color.white)
                    .cornerRadius(6)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.1), lineWidth: 1))
                }
            }
        }
    }
}

//
//  ExerciseCard.swift
//  FitnessTracker
//

import SwiftUI

enum CardMode {
    case editor
    case workout
}

struct ExerciseCard: View {
    let mode: CardMode
    @Binding var exercise: Exercise
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Exercise name + trash
            HStack {
                TextField("Excercies name", text: $exercise.name)
                    .font(.custom("Inter", size: 15))
                    .foregroundColor(Color.black.opacity(mode == .workout ? 0.8 : 0.6))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(6)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.1), lineWidth: 1))
                
                Button(action: onDelete) {
                    Image("DeleteIcon")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.black.opacity(0.3))
                }
            }

            // Column headers – equal widths matching SetRow
            HStack(spacing: 8) {
                Text("SET")
                    .font(.custom("Inter-ExtraBold", size: 13))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                Text("REPS")
                    .font(.custom("Inter-ExtraBold", size: 13))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                Text("KG")
                    .font(.custom("Inter-ExtraBold", size: 13))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                if mode == .workout {
                    Text("Done")
                        .font(.custom("Inter-ExtraBold", size: 13))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
            }

            // Set rows
            ForEach(exercise.sets.indices, id: \.self) { idx in
                SetRow(mode: mode,
                       setNumber: idx + 1,
                       reps: $exercise.sets[idx].reps,
                       kg: $exercise.sets[idx].kg,
                       isDone: $exercise.sets[idx].isDone)
            }

            // Add set button
            AddSetButton {
                exercise.sets.append(ExerciseSet())
            }
        }
    }
}

//
//  StartRoutineView.swift
//  FitnessTracker
//

import SwiftUI
internal import Combine

struct StartRoutineView: View {
    @Environment(\.dismiss) var dismiss
    @State var routine: Routine
    var onFinish: (Routine) -> Void
    
    // Timer state
    @State private var timeElapsed: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            RoutineHeader(
                mode: .workout(title: "Active routine"),
                onLeadingTap: { dismiss() },
                onTrailingTap: {
                    onFinish(routine)
                    dismiss()
                }
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Routine Title Display
                    Text(routine.name)
                        .font(.custom("Inter", size: 22))
                        .foregroundColor(Color.black.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.1), lineWidth: 1))
                    
                    // Timer Display
                    Text(timeString(from: timeElapsed))
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color(hex: "#5F97F6"))
                    
                    Divider()
                        .padding(.bottom, 8)
                    
                    // Exercise List
                    VStack(spacing: 24) {
                        ForEach($routine.exercises) { $exercise in
                            exerciseContainer(for: $exercise, isLast: exercise.id == routine.exercises.last?.id)
                        }
                    }
                }
                .padding(16)
                .padding(.bottom, 40)
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onReceive(timer) { _ in
            timeElapsed += 1
        }
    }
    
    @ViewBuilder
    private func exerciseContainer(for exerciseBinding: Binding<Exercise>, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            ExerciseCard(mode: .workout, exercise: exerciseBinding, onDelete: {
                routine.exercises.removeAll { $0.id == exerciseBinding.wrappedValue.id }
            })
            
            if isLast {
                Spacer().frame(height: 24)
                
                AddExerciseButton {
                    routine.exercises.append(Exercise())
                }
            }
        }
        .padding(14)
        .background(Color.black.opacity(0.05))
        .cornerRadius(6)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.1), lineWidth: 1))
    }
    
    private func timeString(from totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = (totalSeconds % 3600) % 60
        
        if hours > 0 {
            return "\(hours) h \(minutes) min \(seconds) s"
        } else if minutes > 0 {
            return "\(minutes) min \(seconds) s"
        } else {
            return "\(minutes) min \(seconds) s"
        }
    }
}

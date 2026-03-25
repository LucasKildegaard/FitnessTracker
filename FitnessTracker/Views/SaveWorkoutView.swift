//
//  SaveWorkoutView.swift
//  FitnessTracker
//

import SwiftUI

struct SaveWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(WorkoutManager.self) var workoutManager
    let originalRoutine: Routine
    let routine: Routine
    let durationElapsed: Int
    let onSave: (Routine) -> Void
    
    @State private var notes: String = ""
    @State private var showUpdateModal: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                RoutineHeader(
                mode: .saveWorkout,
                onLeadingTap: { dismiss() },
                onTrailingTap: {
                    if routine.hasTemplateChanges(comparedTo: originalRoutine) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showUpdateModal = true
                        }
                    } else {
                        saveSessionAndFinish(with: routine)
                    }
                }
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
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
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Duration Section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Duration")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(Color.black.opacity(0.6))
                            Text(timeString(from: durationElapsed))
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(Color(hex: "#5F97F6"))
                        }
                        
                        Divider()
                        
                        // When Section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("When")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(Color.black.opacity(0.6))
                            Text(currentDateFormatted())
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(Color(hex: "#5F97F6"))
                        }
                    }
                    
                    if #available(iOS 16.0, *) {
                        // Notes Input
                        TextField("How’d it go? Share more about your activity", text: $notes, axis: .vertical)
                            .font(.custom("Inter", size: 15))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .frame(minHeight: 100, alignment: .topLeading)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.1), lineWidth: 1))
                    } else {
                        // Fallback for older iOS
                        ZStack(alignment: .topLeading) {
                            if notes.isEmpty {
                                Text("How’d it go? Share more about your activity")
                                    .font(.custom("Inter", size: 15))
                                    .foregroundColor(Color.black.opacity(0.4))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .zIndex(1)
                                    .allowsHitTesting(false)
                            }
                            
                            TextEditor(text: $notes)
                                .font(.custom("Inter", size: 15))
                                .foregroundColor(.black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(minHeight: 100)
                                .colorMultiply(Color.black.opacity(0.05))
                        }
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.1), lineWidth: 1))
                    }
                    
                    // Add Photo / Video Section
                    Button {} label: {
                        VStack(spacing: 12) {
                            Image("AddPhotoIcon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                            Text("ADD Photo/Video")
                                .font(.custom("Inter", size: 15))
                                .bold()
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.1), lineWidth: 1))
                    }
                }
                .padding(16)
            }
            .background(Color.white)
        }
        
        // Reused Top-Level Modal Architecture
        if showUpdateModal {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) { showUpdateModal = false }
                        }
                    
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 24) {
                            VStack(spacing: 4) {
                                Text("Update \"\(routine.name)\"")
                                    .font(.custom("Inter-ExtraBold", size: 16))
                                    .foregroundColor(.black)
                                
                                Text(changesDescription)
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                            .padding(.top, 8)
                            
                            VStack(spacing: 12) {
                                PrimaryButton(title: "Update") {
                                    withAnimation { showUpdateModal = false }
                                    saveSessionAndFinish(with: routine)
                                }
                                
                                Button {
                                    withAnimation { showUpdateModal = false }
                                    saveSessionAndFinish(with: originalRoutine)
                                } label: {
                                    Text("Keep original")
                                        .font(.custom("Inter-ExtraBold", size: 16))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color.white)
                                        .cornerRadius(6)
                                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black, lineWidth: 1))
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 32)
                        .background(Color.white)
                        .cornerRadius(10, corners: [.topLeft, .topRight])
                    }
                    .ignoresSafeArea(edges: .bottom)
                    .transition(.move(edge: .bottom))
                }
                .zIndex(1)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveSessionAndFinish(with finalRoutine: Routine) {
        let completed = routine.exercises.reduce(0) { total, exercise in
            total + exercise.sets.filter { $0.isDone }.count
        }
        let session = WorkoutSession(
            routineName: routine.name,
            duration: durationElapsed,
            completedSets: completed,
            date: Date(),
            notes: notes.isEmpty ? nil : notes
        )
        workoutManager.save(session)
        onSave(finalRoutine)
    }
    
    private func timeString(from totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours) h \(minutes) m"
        } else {
            return "\(minutes) m"
        }
    }
    
    private func currentDateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "da_DK")
        // "24 marts 2026, 4:24 pm"
        formatter.dateFormat = "d MMMM yyyy, h:mm a"
        return formatter.string(from: Date()).lowercased()
    }
    
    private var changesDescription: String {
        if routine.exercises.count > originalRoutine.exercises.count {
            let diff = routine.exercises.count - originalRoutine.exercises.count
            return "You added \(diff) exercise\(diff == 1 ? "" : "s")"
        } else if routine.exercises.count < originalRoutine.exercises.count {
            let diff = originalRoutine.exercises.count - routine.exercises.count
            return "You removed \(diff) exercise\(diff == 1 ? "" : "s")"
        }
        
        var modifiedExercises: [String] = []
        var lastChangeText = ""
        
        for i in 0..<routine.exercises.count {
            let e1 = originalRoutine.exercises[i]
            let e2 = routine.exercises[i]
            let exName = e2.name.isEmpty ? "exercise" : e2.name
            
            var changed = false
            
            if e1.name != e2.name {
                changed = true
                lastChangeText = "You renamed an exercise to '\(exName)'"
            } else if e2.sets.count > e1.sets.count {
                changed = true
                let diff = e2.sets.count - e1.sets.count
                lastChangeText = "You added \(diff) set\(diff == 1 ? "" : "s") to \(exName)"
            } else if e2.sets.count < e1.sets.count {
                changed = true
                let diff = e1.sets.count - e2.sets.count
                lastChangeText = "You removed \(diff) set\(diff == 1 ? "" : "s") from \(exName)"
            } else {
                for j in 0..<e1.sets.count {
                    let s1 = e1.sets[j]
                    let s2 = e2.sets[j]
                    if s1.kg != s2.kg {
                        changed = true
                        lastChangeText = "You modified weight in \(exName)"
                        break
                    }
                    if s1.reps != s2.reps {
                        changed = true
                        lastChangeText = "You modified reps in \(exName)"
                        break
                    }
                }
            }
            
            if changed {
                modifiedExercises.append(exName)
            }
        }
        
        if modifiedExercises.isEmpty {
            return "You modified this routine"
        } else if modifiedExercises.count == 1 {
            return lastChangeText
        } else {
            return "You modified \(modifiedExercises.count) exercises"
        }
    }
}

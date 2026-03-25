//
//  SaveWorkoutView.swift
//  FitnessTracker
//

import SwiftUI

struct SaveWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    let routine: Routine
    let durationElapsed: Int
    let onSave: (Routine) -> Void
    
    @State private var notes: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            RoutineHeader(
                mode: .saveWorkout,
                onLeadingTap: { dismiss() },
                onTrailingTap: {
                    onSave(routine)
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
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
}

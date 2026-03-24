//
//  RoutineHeader.swift
//  FitnessTracker
//

import SwiftUI

enum RoutineHeaderMode {
    case create
    case edit
    case workout(title: String)
    case saveWorkout
}

struct RoutineHeader: View {
    let mode: RoutineHeaderMode
    var onLeadingTap: () -> Void
    var onTrailingTap: () -> Void
    var trailingDisabled: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            // Leading
            if case .workout = mode {
                Button(action: onLeadingTap) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(hex: "#5F97F6"))
                        .font(.system(size: 18, weight: .semibold))
                }
            } else if case .saveWorkout = mode {
                Text("Resume")
                    .foregroundColor(Color(hex: "#5F97F6"))
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.regular)
                    .onTapGesture(perform: onLeadingTap)
            } else {
                Text("Cancel")
                    .foregroundColor(Color(hex: "#5F97F6"))
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.regular)
                    .onTapGesture(perform: onLeadingTap)
            }
            
            Spacer()
            
            // Title
            Text(titleText)
                .font(.custom("Inter", size: 16))
                .fontWeight(.regular)
                .foregroundColor(.white)
            
            Spacer()
            
            // Trailing
            PrimaryButton(
                title: trailingText,
                backgroundColor: Color(hex: "#5F97F6"),
                foregroundColor: .white,
                isFullWidth: false,
                action: onTrailingTap
            )
            .disabled(trailingDisabled)
            .opacity(trailingDisabled ? 0.5 : 1)
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .background(Color(hex: "#252525").ignoresSafeArea(edges: .top))
    }
    
    private var titleText: String {
        switch mode {
        case .create: return "Create Routine"
        case .edit: return "Edit Routine"
        case .workout(let title): return title
        case .saveWorkout: return "Save Workout"
        }
    }
    
    private var trailingText: String {
        switch mode {
        case .create: return "Save"
        case .edit: return "Update"
        case .workout: return "Finish"
        case .saveWorkout: return "Save"
        }
    }
}

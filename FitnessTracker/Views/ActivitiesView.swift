//
//  ActivitiesView.swift
//  FitnessTracker
//

import SwiftUI

struct ActivitiesView: View {
    @Environment(WorkoutManager.self) var workoutManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(workoutManager.sessions.sorted(by: { $0.date > $1.date })) { activity in
                    ActivityRow(activity: activity)
                    Divider().padding(.horizontal, 16)
                }
            }
        }
        .background(Color.white)
    }
}

struct ActivityRow: View {
    let activity: WorkoutSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.routineName)
                    .font(.custom("Inter-ExtraBold", size: 16))
                    .foregroundColor(.black)
                
                HStack(spacing: 8) {
                    Text(timeString(from: activity.duration))
                    Text("•")
                    Text(dateString(from: activity.date))
                }
                .font(.custom("Inter", size: 14))
                .foregroundColor(Color.black.opacity(0.6))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.black.opacity(0.2))
        }
        .padding(16)
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
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d. MMM"
        return formatter.string(from: date)
    }
}

#Preview {
    ActivitiesView()
}

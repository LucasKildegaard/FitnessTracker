//
//  ProgressView.swift
//  FitnessTracker
//

import SwiftUI

struct WeeklyStat {
    let duration: String
    let routines: String
    let sets: String
    let score: Double
}

struct ProgressView: View {
    @Environment(AuthViewModel.self) var authVM
    @Environment(WorkoutManager.self) var workoutManager
    @State private var selectedWeekIndex: Int = 11
    
    private var stats: [WeeklyStat] {
        let calendar = Calendar.current
        let now = Date()
        // Determine the start of the current week based on locale rules
        guard let currentWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else { return [] }
        
        var result: [WeeklyStat] = []
        for i in 0..<12 {
            let weeksAgo = 11 - i
            guard let weekStart = calendar.date(byAdding: .weekOfYear, value: -weeksAgo, to: currentWeekStart),
                  let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else { continue }
            
            let weekSessions = workoutManager.sessions.filter { $0.date >= weekStart && $0.date < weekEnd }
            let totalDuration = weekSessions.reduce(0) { $0 + $1.duration }
            let totalSets = weekSessions.reduce(0) { $0 + $1.completedSets }
            let routinesCount = weekSessions.count
            
            result.append(WeeklyStat(
                duration: timeString(from: totalDuration),
                routines: "\(routinesCount)",
                sets: "\(totalSets)",
                score: Double(routinesCount)
            ))
        }
        
        // Safety fallback array if date calculus inexplicably fails
        if result.count != 12 {
            return Array(repeating: WeeklyStat(duration: "0 m", routines: "0", sets: "0", score: 0), count: 12)
        }
        
        return result
    }
    
    private func timeString(from totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        if hours > 0 { return "\(hours) h \(minutes) m" }
        return "\(minutes) m"
    }
    
    private func weekTitle(for index: Int) -> String {
        if index == 11 {
            return "This week"
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Find the start of the current week based on locale
        let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        guard let currentWeekStart = calendar.date(from: comps) else { return "Unknown" }
        
        let weeksAgo = 11 - index
        guard let targetWeekStart = calendar.date(byAdding: .weekOfYear, value: -weeksAgo, to: currentWeekStart) else {
            return "Unknown"
        }
        let targetWeekEnd = calendar.date(byAdding: .day, value: 6, to: targetWeekStart) ?? targetWeekStart
        
        let startFormatter = DateFormatter()
        startFormatter.dateFormat = "MMM d"
        let startStr = startFormatter.string(from: targetWeekStart)
        
        let endFormatter = DateFormatter()
        endFormatter.dateFormat = "MMM d, yyyy"
        let endStr = endFormatter.string(from: targetWeekEnd)
        
        return "\(startStr) - \(endStr)"
    }
    
    // Helper to calculate relative Y positions
    private func yPosition(for index: Int, height: CGFloat) -> CGFloat {
        let baselineY = height * 0.9
        let topY = height * 0.1
        let maxScore = stats.map { $0.score }.max() ?? 10.0
        let minScore = 0.0 // Force baseline to 0 for count-based metrics
        let range = maxScore - minScore == 0 ? 1.0 : maxScore - minScore
        
        let normalized = (stats[index].score - minScore) / range
        return baselineY - CGFloat(normalized) * (baselineY - topY)
    }
    
    private func formatRoutineValue(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // This week / Selected week section
                VStack(alignment: .leading, spacing: 16) {
                    Text(weekTitle(for: selectedWeekIndex))
                        .font(.custom("Inter-ExtraBold", size: 18))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 0) {
                        StatItem(label: "Routines", value: stats[selectedWeekIndex].routines)
                        StatItem(label: "Duration", value: stats[selectedWeekIndex].duration)
                        StatItem(label: "Sets", value: stats[selectedWeekIndex].sets)
                    }
                }
                .padding(.horizontal, 16)
                
                // Graph section
                VStack(alignment: .leading, spacing: 16) {
                    Text("past 12 weeks")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color.black.opacity(0.4))
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        // Graph Area
                        ZStack {
                            GeometryReader { geo in
                                let width = geo.size.width
                                let height = geo.size.height
                                let spacing = width / 11
                                let baselineY = height * 0.9
                                let topY = height * 0.1
                                let midY = height * 0.5
                                
                                // 1. Grid Lines (2 dark horizontal lines)
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: topY))
                                    path.addLine(to: CGPoint(x: width, y: topY))
                                }
                                .stroke(Color.black.opacity(0.3), lineWidth: 1)
                                
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: midY))
                                    path.addLine(to: CGPoint(x: width, y: midY))
                                }
                                .stroke(Color.black.opacity(0.3), lineWidth: 1)
                                
                                // 2. Area graph Fill
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: baselineY))
                                    for i in 0..<12 {
                                        let x = CGFloat(i) * spacing
                                        let y = yPosition(for: i, height: height)
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                    path.addLine(to: CGPoint(x: width, y: baselineY))
                                    path.closeSubpath()
                                }
                                .fill(Color(hex: "#5F97F6").opacity(0.3))
                                
                                // 3. Line Chart Stroke
                                Path { path in
                                    for i in 0..<12 {
                                        let x = CGFloat(i) * spacing
                                        let y = yPosition(for: i, height: height)
                                        if i == 0 {
                                            path.move(to: CGPoint(x: x, y: y))
                                        } else {
                                            path.addLine(to: CGPoint(x: x, y: y))
                                        }
                                    }
                                }
                                .stroke(Color(hex: "#5F97F6"), lineWidth: 2)
                                
                                // 4. Horizontal Blue baseline
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: baselineY))
                                    path.addLine(to: CGPoint(x: width, y: baselineY))
                                }
                                .stroke(Color(hex: "#5F97F6"), lineWidth: 2)
                                
                                // 5. Vertical line for selection (using animating Rectangle)
                                let selectedX = CGFloat(selectedWeekIndex) * spacing
                                let selectedY = yPosition(for: selectedWeekIndex, height: height)
                                let lineBottom = baselineY + 10 // drops below baseline per design
                                
                                Rectangle()
                                    .fill(Color(hex: "#5F97F6"))
                                    .frame(width: 2, height: max(0, lineBottom - selectedY))
                                    .position(x: selectedX, y: selectedY + (lineBottom - selectedY) / 2)
                                
                                // 6. Regular Dots
                                ForEach(0..<12) { i in
                                    let x = CGFloat(i) * spacing
                                    let y = yPosition(for: i, height: height)
                                    
                                    Circle()
                                        .stroke(Color(hex: "#5F97F6"), lineWidth: 2)
                                        .background(Circle().fill(.white))
                                        .frame(width: 10, height: 10)
                                        .position(x: x, y: y)
                                }
                                
                                // 7. Selected Dot Overlay
                                Circle()
                                    .fill(Color(hex: "#5F97F6"))
                                    .frame(width: 12, height: 12)
                                    .position(x: selectedX, y: selectedY)
                                
                                // 8. Invisible hit area for easier tapping
                                ForEach(0..<12) { i in
                                    let x = CGFloat(i) * spacing
                                    Rectangle()
                                        .fill(Color.black.opacity(0.001))
                                        .frame(width: max(spacing, 30), height: height)
                                        .position(x: x, y: height / 2)
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                selectedWeekIndex = i
                                            }
                                        }
                                }
                            }
                        }
                        .frame(height: 150)
                        
                        let maxVal = stats.map { $0.score }.max() ?? 10.0
                        
                        // Y-Axis Labels
                        ZStack(alignment: .leading) {
                            // Top
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Routines").foregroundColor(Color.black.opacity(0.6))
                                Text(formatRoutineValue(maxVal)).foregroundColor(Color.black.opacity(0.6))
                            }
                            .font(.custom("Inter", size: 12))
                            .offset(y: (150 * 0.1) - 75)
                            
                            // Mid
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Routines").foregroundColor(Color.black.opacity(0.6))
                                Text(formatRoutineValue(maxVal / 2)).foregroundColor(Color.black.opacity(0.6))
                            }
                            .font(.custom("Inter", size: 12))
                            .offset(y: (150 * 0.5) - 75)
                            
                            // Bottom
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Routines").foregroundColor(Color.black.opacity(0.6))
                                Text("0").foregroundColor(Color.black.opacity(0.6))
                            }
                            .font(.custom("Inter", size: 12))
                            .offset(y: (150 * 0.9) - 75)
                        }
                        .frame(width: 50, height: 150)
                        .padding(.leading, 8)
                    }
                }
                .padding(.horizontal, 16)
                
                // Logout button
                Button {
                    authVM.logout()
                } label: {
                    Text("Log out")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "#353535"))
                        .cornerRadius(5)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
            .padding(.vertical, 24)
        }
        .background(Color.white)
    }
}

struct StatItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.custom("Inter", size: 14))
                .foregroundColor(Color.black.opacity(0.6))
            Text(value)
                .font(.custom("Inter", size: 14))
                .foregroundColor(Color(hex: "#5F97F6"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



#Preview {
    ProgressView()
}

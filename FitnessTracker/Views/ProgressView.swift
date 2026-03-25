//
//  ProgressView.swift
//  FitnessTracker
//

import SwiftUI

struct ProgressView: View {
    @Environment(AuthViewModel.self) var authVM
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // This week section
                VStack(alignment: .leading, spacing: 16) {
                    Text("This week")
                        .font(.custom("Inter-ExtraBold", size: 18))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 0) {
                        StatItem(label: "Duration", value: "8 h 2 m")
                        StatItem(label: "Routines", value: "4")
                        StatItem(label: "Sets", value: "25")
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
                                
                                // Grid Lines (2 dark horizontal lines)
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
                                
                                // Vertical line from the last dot
                                Path { path in
                                    let x = CGFloat(11) * spacing
                                    // Make sure it goes exactly from the top line to the blue baseline
                                    path.move(to: CGPoint(x: x, y: topY))
                                    path.addLine(to: CGPoint(x: x, y: baselineY))
                                }
                                .stroke(Color(hex: "#5F97F6"), lineWidth: 2)
                                
                                // Horizontal Blue baseline
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: baselineY))
                                    path.addLine(to: CGPoint(x: width, y: baselineY))
                                }
                                .stroke(Color(hex: "#5F97F6"), lineWidth: 2)
                                
                                // Dots
                                ForEach(0..<12) { i in
                                    let x = CGFloat(i) * spacing
                                    
                                    if i == 11 {
                                        // Final Highlighted Dot
                                        Circle()
                                            .fill(Color(hex: "#5F97F6"))
                                            .frame(width: 12, height: 12)
                                            .position(x: x, y: baselineY)
                                    } else {
                                        // Regular Dot
                                        Circle()
                                            .stroke(Color(hex: "#5F97F6"), lineWidth: 2)
                                            .background(Circle().fill(.white))
                                            .frame(width: 10, height: 10)
                                            .position(x: x, y: baselineY)
                                    }
                                }
                            }
                        }
                        .frame(height: 150)
                        
                        // Y-Axis Labels
                        ZStack(alignment: .leading) {
                            Text("Time\n0:00").font(.custom("Inter", size: 12)).foregroundColor(Color.black.opacity(0.6))
                                .offset(y: (150 * 0.1) - 75)
                            Text("Time\n0:00").font(.custom("Inter", size: 12)).foregroundColor(Color.black.opacity(0.6))
                                .offset(y: (150 * 0.5) - 75)
                            Text("Time\n0:00").font(.custom("Inter", size: 12)).foregroundColor(Color.black.opacity(0.6))
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

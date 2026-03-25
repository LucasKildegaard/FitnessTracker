//
//  WorkoutSession.swift
//  FitnessTracker
//

import Foundation

struct WorkoutSession: Identifiable, Codable {
    let id: UUID
    let routineName: String
    let duration: Int // in seconds
    let completedSets: Int
    let date: Date
    let notes: String?
    
    init(id: UUID = UUID(), routineName: String, duration: Int, completedSets: Int, date: Date = Date(), notes: String? = nil) {
        self.id = id
        self.routineName = routineName
        self.duration = duration
        self.completedSets = completedSets
        self.date = date
        self.notes = notes
    }
}

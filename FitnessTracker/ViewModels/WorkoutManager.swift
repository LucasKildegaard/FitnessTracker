//
//  WorkoutManager.swift
//  FitnessTracker
//

import SwiftUI

@Observable
class WorkoutManager {
    var sessions: [WorkoutSession] = []
    
    private let saveKey = "SavedWorkoutSessions"
    
    init() {
        loadData()
    }
    
    func save(_ session: WorkoutSession) {
        sessions.append(session)
        saveData()
    }
    
    func delete(_ session: WorkoutSession) {
        sessions.removeAll(where: { $0.id == session.id })
        saveData()
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([WorkoutSession].self, from: data) {
                sessions = decoded
                return
            }
        }
        sessions = []
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}

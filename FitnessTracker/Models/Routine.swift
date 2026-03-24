//
//  Routine.swift
//  FitnessTracker
//

import Foundation

// ── ExerciseSet ───────────────────────────────────────────────────────────────
struct ExerciseSet: Identifiable, Hashable, Codable {
    let id: UUID = UUID()
    var reps: String = ""
    var kg: String = ""
    var isDone: Bool = false
}

// ── Exercise ──────────────────────────────────────────────────────────────────
struct Exercise: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String = ""
    var sets: [ExerciseSet] = [ExerciseSet()]
}

// ── Routine ───────────────────────────────────────────────────────────────────
struct Routine: Identifiable, Hashable {
    let id: UUID
    var name: String
    var exercises: [Exercise]

    /// Short comma-separated preview of exercise names (max 4, then "...")
    var preview: String {
        let names = exercises.map { $0.name }.filter { !$0.isEmpty }
        if names.isEmpty { return "No exercises yet" }
        let shown = names.prefix(4)
        let joined = shown.joined(separator: ", ")
        return names.count > 4 ? "\(joined)..." : joined
    }

    init(id: UUID = UUID(), name: String, exercises: [Exercise] = []) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }
}

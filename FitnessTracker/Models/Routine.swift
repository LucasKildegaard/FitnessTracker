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
    
    /// Compares two routines to see if their templates were modified (ignoring `isDone` status).
    func hasTemplateChanges(comparedTo other: Routine) -> Bool {
        if self.name != other.name { return true }
        if self.exercises.count != other.exercises.count { return true }
        
        for i in 0..<self.exercises.count {
            let e1 = self.exercises[i]
            let e2 = other.exercises[i]
            if e1.name != e2.name { return true }
            if e1.sets.count != e2.sets.count { return true }
            for j in 0..<e1.sets.count {
                let s1 = e1.sets[j]
                let s2 = e2.sets[j]
                if s1.reps != s2.reps || s1.kg != s2.kg { return true }
            }
        }
        return false
    }
}

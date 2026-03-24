//
//  RoutineEditorView.swift
//  FitnessTracker
//

import SwiftUI

enum RoutineEditorMode {
    case create
    case edit
}

struct RoutineEditorView: View {
    @Environment(\.dismiss) var dismiss
    
    let mode: RoutineEditorMode
    let onSave: (Routine) -> Void
    
    @State private var title: String
    @State private var exercises: [Exercise]
    
    private var editingRoutineId: UUID?
    
    init(mode: RoutineEditorMode, routine: Routine? = nil, onSave: @escaping (Routine) -> Void) {
        self.mode = mode
        self.onSave = onSave
        
        if mode == .edit, let r = routine {
            _title = State(initialValue: r.name)
            // State initialized directly with the existing exercises
            _exercises = State(initialValue: r.exercises)
            self.editingRoutineId = r.id
        } else {
            _title = State(initialValue: "")
            _exercises = State(initialValue: [])
            self.editingRoutineId = nil
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Custom Nav bar ──────────────────────────────────────────────────────
            RoutineHeader(
                mode: mode == .create ? .create : .edit,
                onLeadingTap: { dismiss() },
                onTrailingTap: {
                    guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    let routineToSave = Routine(
                        id: editingRoutineId ?? UUID(),
                        name: title,
                        exercises: exercises
                    )
                    onSave(routineToSave)
                    dismiss()
                }
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Routine title field
                    TextField("Routine title", text: $title)
                        .font(.custom("Inter", size: 22))
                        .foregroundColor(Color.black.opacity(0.5))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 18)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.1), lineWidth: 1))

                    if exercises.isEmpty {
                        // ── Empty State: Standalone Button ──────────────────────────
                        AddExerciseButton {
                            exercises.append(Exercise())
                        }
                    } else {
                        // ── State 2: Exercises Added ────────────────────────────────
                        VStack(spacing: 24) { // Spacing between each exercise container
                            ForEach($exercises) { $exercise in
                                let index = exercises.firstIndex(where: { $0.id == exercise.id }) ?? 0
                                exerciseContainer(for: $exercise, index: index)
                            }
                        }
                    }
                }
                .padding(16)
                .padding(.bottom, 40)
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    // ── Extracted Container View for Compiler Performance ──────────────
    @ViewBuilder
    private func exerciseContainer(for exerciseBinding: Binding<Exercise>, index: Int) -> some View {
        VStack(spacing: 0) {
            // The exercise content
            ExerciseCard(mode: .editor, exercise: exerciseBinding, onDelete: {
                exercises.removeAll { $0.id == exerciseBinding.wrappedValue.id }
            })
            
            // Only show the "Add exercise" button in the LAST container
            if index == exercises.count - 1 {
                Spacer().frame(height: 24)
                
                AddExerciseButton {
                    exercises.append(Exercise())
                }
            }
        }
        .padding(14)
        .background(Color.black.opacity(0.05))
        .cornerRadius(6)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.1), lineWidth: 1))
    }
}


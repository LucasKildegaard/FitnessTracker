import SwiftUI

struct HomeView: View {
    @Environment(AuthViewModel.self) var authVM

    @State private var routines: [Routine] = [
        Routine(name: "Push-day", exercises: [
            Exercise(name: "Bench press"),
            Exercise(name: "Incline dumbbell press"),
            Exercise(name: "Shoulder press"),
            Exercise(name: "Tricep pushdown"),
            Exercise(name: "Lateral raises")
        ]),
        Routine(name: "Pull-day", exercises: [
            Exercise(name: "Deadlift"),
            Exercise(name: "Barbell row"),
            Exercise(name: "Pull-ups"),
            Exercise(name: "Face pull"),
            Exercise(name: "Bicep curl")
        ]),
        Routine(name: "Leg-day", exercises: [
            Exercise(name: "Squat"),
            Exercise(name: "Leg press"),
            Exercise(name: "Romanian deadlift"),
            Exercise(name: "Leg curl"),
            Exercise(name: "Calf raises")
        ])
    ]

    @State private var showAddRoutine: Bool = false
    @State private var selectedTab: Int = 0
    @State private var showOptionsForRoutine: Routine? = nil
    @State private var routineToEditFullScreen: Routine? = nil
    @State private var routineToStartFullScreen: Routine? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    if selectedTab == 0 {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                Button { showAddRoutine = true } label: {
                                    HStack(spacing: 10) {
                                        Image("VectorIcon")
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(.black)

                                        Text("Add new routine")
                                            .font(.custom("Inter", size: 16))
                                            .foregroundColor(.black)

                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                    )
                                }

                                HStack(spacing: 6) {
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.black)

                                    Text("Routines")
                                        .font(.custom("Inter-ExtraBold", size: 16))
                                        .foregroundColor(.black)
                                }

                                ForEach(routines) { routine in
                                    RoutineCard(
                                        routine: routine,
                                        onOptionsTapped: { showOptionsForRoutine = routine },
                                        onStartTapped: { routineToStartFullScreen = routine }
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                        }
                        .background(Color.white)
                    } else {
                        ProfileContainerView()
                    }

                    FooterBar(selectedTab: $selectedTab)
                }
                .ignoresSafeArea(edges: .bottom)

                if let routineToEdit = showOptionsForRoutine {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showOptionsForRoutine = nil
                                }
                            }

                        VStack {
                            Spacer()

                            VStack(spacing: 0) {
                                Button {
                                    routineToEditFullScreen = routineToEdit
                                    withAnimation {
                                        showOptionsForRoutine = nil
                                    }
                                } label: {
                                    HStack(alignment: .center) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Edit")
                                                .font(.custom("Inter", size: 16))
                                                .foregroundColor(.black)

                                            Text("Add new exercises or update sets, weight, and reps.")
                                                .font(.custom("Inter", size: 14))
                                                .foregroundColor(Color.black.opacity(0.6))
                                                .multilineTextAlignment(.leading)
                                        }

                                        Spacer()

                                        Image("SettingsIcon")
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(Color.black.opacity(0.6))
                                    }
                                    .padding(.vertical, 16)
                                }

                                Button {
                                    if let index = routines.firstIndex(where: { $0.id == routineToEdit.id }) {
                                        routines.remove(at: index)
                                    }
                                    withAnimation {
                                        showOptionsForRoutine = nil
                                    }
                                } label: {
                                    HStack(alignment: .center) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Delete")
                                                .font(.custom("Inter", size: 16))
                                                .foregroundColor(.black)

                                            Text("This will permanently delete this routine.")
                                                .font(.custom("Inter", size: 14))
                                                .foregroundColor(Color.black.opacity(0.6))
                                                .multilineTextAlignment(.leading)
                                        }

                                        Spacer()

                                        Image("DeleteIcon")
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(Color.black.opacity(0.6))
                                    }
                                    .padding(.vertical, 16)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            .padding(.bottom, 32)
                            .background(Color.white)
                            .cornerRadius(10, corners: [.topLeft, .topRight])
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .ignoresSafeArea(edges: .bottom)
                        .transition(.move(edge: .bottom))
                    }
                    .zIndex(1)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showAddRoutine) {
                RoutineEditorView(mode: .create) { newRoutine in
                    routines.append(newRoutine)
                }
            }
            .navigationDestination(item: $routineToEditFullScreen) { selectedRoutine in
                RoutineEditorView(mode: .edit, routine: selectedRoutine) { updatedRoutine in
                    if let index = routines.firstIndex(where: { $0.id == selectedRoutine.id }) {
                        routines[index] = updatedRoutine
                    }
                }
            }
            .navigationDestination(item: $routineToStartFullScreen) { selectedRoutine in
                StartRoutineView(routine: selectedRoutine) { updatedRoutine in
                    if let index = routines.firstIndex(where: { $0.id == selectedRoutine.id }) {
                        routines[index] = updatedRoutine
                    }
                    routineToStartFullScreen = nil
                }
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct RoutineCard: View {
    let routine: Routine
    var onOptionsTapped: () -> Void
    var onStartTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(routine.name)
                    .font(.custom("Inter-ExtraBold", size: 16))
                    .foregroundColor(.black)

                Spacer()

                Button(action: onOptionsTapped) {
                    Image("MoreIcon")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                }
            }

            Text(routine.preview)
                .font(.custom("Inter", size: 16))
                .foregroundColor(Color.black.opacity(0.6))

            Button(action: onStartTapped) {
                Text("Start routine")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#353535"))
                    .cornerRadius(5)
            }
        }
        .padding(16)
        .background(Color.black.opacity(0.05))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
    }
}

 

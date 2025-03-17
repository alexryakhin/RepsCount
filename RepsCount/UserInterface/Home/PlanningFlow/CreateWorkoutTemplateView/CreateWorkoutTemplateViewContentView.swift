import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core
import Flow

public struct CreateWorkoutTemplateViewContentView: PageView {

    public typealias ViewModel = CreateWorkoutTemplateViewViewModel

    @ObservedObject public var viewModel: ViewModel
    @FocusState private var isNameFocused: Bool
    @FocusState private var isNotesFocused: Bool
    @State private var isMuscleMapVisible: Bool = true

    public init(viewModel: CreateWorkoutTemplateViewViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        List {
            Section {
                MuscleMapView(exercises: viewModel.exercises.map(\.exerciseModel))
                    .onAppear { isMuscleMapVisible = true }
                    .onDisappear { isMuscleMapVisible = false }
            } header: {
                Text("Muscle groups to target")
            }

            Section {
                TextField("Legs day", text: $viewModel.workoutName, axis: .vertical)
                    .focused($isNameFocused)
            } header: {
                HStack {
                    Text("Workout Name")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if isNameFocused {
                        Button("Done") {
                            isNameFocused = false
                        }
                    }
                }
            }

            Section {
                TextField("Something you might need", text: $viewModel.workoutNotes, axis: .vertical)
                    .focused($isNotesFocused)
            } header: {
                HStack {
                    Text("Notes")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if isNotesFocused {
                        Button("Done") {
                            isNotesFocused = false
                        }
                    }
                }
            }

            Section {
                ForEach(viewModel.exercises) { exercise in
                    HStack {
                        Text(exercise.exerciseModel.name)
                            .bold()
                        Divider()
                        TextField("0", text: .constant("0"))
                        Divider()
                        TextField("1", text: .constant("1"))
                    }
                }
                .onDelete { offsets in
                    // TODO: delete
                }
            } header: {
                Text("Selected exercises")
            }

            Section {
                Text("Select exercises")
                    .font(.title2)
                    .bold()
                    .listRowBackground(Color.clear)
            }

            ForEach(ExerciseCategory.allCases, id: \.self) { category in
                exerciseCategorySectionView(for: category)
            }
        }
        .overlay(alignment: .topTrailing) {
            if !isMuscleMapVisible {
                floatingMuscleMapView
            }
        }
        .animation(.default, value: isMuscleMapVisible)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ExerciseEquipmentFilterView(selectedEquipment: $viewModel.selectedEquipment)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                viewModel.handle(.saveTemplate)
            } label: {
                Text(viewModel.isEditing ? "Save Changes" : "Create Template")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .cornerRadius(12)
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .gradientStyle(.bottomButton)
        }
    }

    private func exerciseCategorySectionView(for category: ExerciseCategory) -> some View {
        Section {
            let filteredExercises = category.exercises.filter {
                viewModel.selectedEquipment.contains($0.equipment)
            }
            if filteredExercises.isNotEmpty {
                HFlow {
                    ForEach(filteredExercises, id: \.rawValue) { model in
                        capsuleView(
                            for: model,
                            isSelected: viewModel.exercises.contains(
                                where: { $0.exerciseModel.rawValue == model.rawValue }
                            )
                        )
                    }
                }
            } else {
                Text("No exercises available for this category")
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text(category.name)
        }
    }

    @ViewBuilder
    private func capsuleView(for item: ExerciseModel, isSelected: Bool) -> some View {
        if isSelected {
            Button {
                viewModel.handle(.toggleExerciseSelection(item))
                HapticManager.shared.triggerSelection()
            } label: {
                Text(item.name)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(Capsule())
        } else {
            Button {
                viewModel.handle(.toggleExerciseSelection(item))
                HapticManager.shared.triggerSelection()
            } label: {
                Text(item.name)
            }
            .buttonStyle(.bordered)
            .clipShape(Capsule())
        }
    }

    private var floatingMuscleMapView: some View {
        MuscleMapView(exercises: viewModel.exercises.map(\.exerciseModel))
            .frame(width: 100, height: 100)
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(8)
            .transition(.opacity)
    }
}

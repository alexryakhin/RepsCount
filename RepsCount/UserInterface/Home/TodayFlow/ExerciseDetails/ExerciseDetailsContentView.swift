import SwiftUI
import CoreUserInterface
import Core
import Shared
import struct Services.AnalyticsService

public struct ExerciseDetailsContentView: PageView {

    public typealias ViewModel = ExerciseDetailsViewModel

    @State private var isShowingAlert = false
    @State private var showConfetti = false
    @State private var isEditingDefaultsAlertPresented: Bool = false
    @State private var editingDefaultsAmountInput: String = ""
    @State private var editingDefaultsSetsInput: String = ""
    @FocusState private var isNotesInputFocused: Bool
    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: ExerciseDetailsViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        ScrollView {
            VStack(spacing: 24) {
                setsSection
                totalSection
                mapSection
                notesSection
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .background(
            Color.background.ignoresSafeArea().displayConfetti(isActive: $showConfetti)
        )
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            if viewModel.exercise.defaultSets != 0 || viewModel.isEditable {
                HStack(spacing: 12) {
                    progressGauge
                    addDataButton
                }
                .clippedWithPaddingAndBackground(.ultraThinMaterial)
                .padding(vertical: 12, horizontal: 16)
            }
        }
        .alert(viewModel.exercise.model.metricType.enterValueLocalizedString, isPresented: $isShowingAlert) {
            TextField(viewModel.exercise.model.metricType.amountLocalizedString, text: $viewModel.amountInput)
                .keyboardType(.decimalPad)
            TextField("Weight, \(Text(viewModel.measurementUnit.shortName)) (optional)", text: $viewModel.weightInput)
                .keyboardType(.decimalPad)
            Button("Add") {
                viewModel.handle(.addSet)
                isShowingAlert = false
                AnalyticsService.shared.logEvent(.exerciseDetailsAddSetAlertProceedTapped)
            }
            Button("Cancel", role: .cancel) {
                viewModel.amountInput = ""
                viewModel.weightInput = ""
                isShowingAlert = false
                AnalyticsService.shared.logEvent(.exerciseDetailsAddSetAlertCancelTapped)
            }
        }
        .onChange(of: viewModel.exercise) { newValue in
            if newValue.defaultSets != 0 && newValue.sets.count >= Int(newValue.defaultSets) && !showConfetti {
                showConfetti = true
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: viewModel.exercise.sets)
        .onAppear {
            AnalyticsService.shared.logEvent(.exerciseDetailsScreenOpened)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    if viewModel.isEditable {
                        Button {
                            editingDefaultsAmountInput = viewModel.exercise.defaultAmount != 0 ? viewModel.exercise.defaultAmount.formatted() : ""
                            editingDefaultsSetsInput = viewModel.exercise.defaultSets != 0 ? viewModel.exercise.defaultSets.formatted() : ""
                            isEditingDefaultsAlertPresented = true
                            AnalyticsService.shared.logEvent(.exerciseDetailsEditMenuButtonTapped)
                        } label: {
                            Label("Edit defaults", systemImage: "pencil.and.ellipsis.rectangle")
                        }
                    }
                    Section {
                        Button(role: .destructive) {
                            viewModel.handle(.deleteExercise)
                            AnalyticsService.shared.logEvent(.exerciseDetailsDeleteMenuButtonTapped)
                        } label: {
                            Label("Delete exercise", systemImage: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Edit defaults", isPresented: $isEditingDefaultsAlertPresented) {
            TextField("Sets (optional)", text: $editingDefaultsSetsInput)
                .keyboardType(.numberPad)
            let textFieldTitleKey: LocalizedStringKey = switch viewModel.exercise.model.metricType {
            case .reps: "Reps (optional)"
            case .time: "Time (sec, optional)"
            @unknown default:
                fatalError()
            }
            TextField(textFieldTitleKey, text: $editingDefaultsAmountInput)
                .keyboardType(.numberPad)

            Button("Cancel", role: .cancel) {
                editingDefaultsAmountInput = ""
                editingDefaultsSetsInput = ""
                AnalyticsService.shared.logEvent(.exerciseDetailsEditAlertCancelTapped)
            }
            Button("Apply") {
                viewModel.handle(
                    .updateDefaults(
                        amount: Double(editingDefaultsAmountInput) ?? 0,
                        sets: Double(editingDefaultsSetsInput) ?? 0
                    )
                )
                editingDefaultsAmountInput = ""
                editingDefaultsSetsInput = ""
                AnalyticsService.shared.logEvent(.exerciseDetailsEditAlertApplyTapped)
            }
        }
    }

    @ViewBuilder
    private var setsSection: some View {
        if !viewModel.exercise.sets.isEmpty {
            CustomSectionView(header: "Sets", footer: setSectionFooter) {
                ListWithDivider(Array(viewModel.exercise.sets.enumerated())) { offset, exerciseSet in
                    setCellView(exerciseSet, offset: offset)
                }
                .clippedWithBackground(.surface)
            }
        }
    }

    private var setSectionFooter: LocalizedStringKey? {
        if viewModel.exercise.defaultAmount != 0 {
            let value: String = switch viewModel.exercise.model.metricType {
            case .reps:
                Int(viewModel.exercise.defaultAmount).repsCountLocalized
            case .time:
                viewModel.exercise.defaultAmount.formatted(with: [.minute, .second])
            @unknown default:
                fatalError("Unsupported metric type")
            }
            return "Goal: \(value) in a set"
        } else {
            return nil
        }
    }

    private func setCellView(_ exerciseSet: ExerciseSet, offset: Int) -> some View {
        SwipeToDeleteView {
            ExerciseSetRow(
                exerciseSet: exerciseSet,
                index: offset + 1,
                weight: viewModel.measurementUnit.convertFromKilograms(exerciseSet.weight),
                maxReps: viewModel.exercise.maxReps,
                metricType: viewModel.exercise.model.metricType
            )
            .padding(vertical: 12, horizontal: 16)
        } onDelete: {
            viewModel.handle(.deleteSet(exerciseSet))
            AnalyticsService.shared.logEvent(.exerciseDetailsSetRemoved)
        }
        .id(exerciseSet.id)
    }

    private var totalSection: some View {
        CustomSectionView(header: "Total") {
            FormWithDivider {
                switch viewModel.exercise.model.metricType {
                case .reps:
                    infoCellView("Reps: \(viewModel.totalAmount.formatted())")
                case .time:
                    infoCellView("Combined time: \(viewModel.totalAmount.formatted(with: [.minute, .second]))")
                @unknown default:
                    fatalError()
                }
                infoCellView("Sets: \(viewModel.exercise.sets.count.formatted())")
                if viewModel.exercise.sets.count > 1,
                   let firstSetDate = viewModel.exercise.sets.first?.timestamp,
                   let lastSetDate = viewModel.exercise.sets.last?.timestamp {
                    let distance = firstSetDate.distance(to: lastSetDate)
                    infoCellView("Time: \(distance.formatted(with: [.hour, .minute, .second]))")
                }
            }
            .clippedWithBackground(.surface)
        }
    }

    private func infoCellView(_ text: LocalizedStringKey) -> some View {
        Text(text)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(vertical: 12, horizontal: 16)
    }

    @ViewBuilder
    private var mapSection: some View {
        if let location = viewModel.exercise.location {
            CustomSectionView(header: "Map") {
                MapView(location: .init(latitude: location.latitude, longitude: location.longitude))
                    .overlay(alignment: .bottomLeading) {
                        if let address = location.address {
                            Text(address)
                                .font(.subheadline)
                                .padding(vertical: 8, horizontal: 12)
                                .clippedWithBackground(.thinMaterial)
                                .padding(8)
                                .multilineTextAlignment(.leading)
                        }
                    }
            }
        }
    }

    @ViewBuilder
    private var notesSection: some View {
        CustomSectionView(header: "Notes") {
            TextField(
                "Enter your notes here...",
                text: $viewModel.exercise.notes,
                axis: .vertical
            )
            .focused($isNotesInputFocused)
            .clippedWithPaddingAndBackground(.surface)
        } headerTrailingContent: {
            if isNotesInputFocused {
                Button {
                    isNotesInputFocused = false
                    viewModel.handle(.updateNotes)
                    AnalyticsService.shared.logEvent(.exerciseDetailsNotesEdited)
                } label: {
                    Text("Done")
                }
            }
        }
    }

    @ViewBuilder
    private var progressGauge: some View {
        if viewModel.exercise.defaultSets != 0 {
            Gauge(value: min(Double(viewModel.exercise.sets.count) / viewModel.exercise.defaultSets, 1)) {
                Text("Progress: \(viewModel.exercise.sets.count.setsCountLocalized) out of \(viewModel.exercise.defaultSets.formatted())")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var addDataButton: some View {
        if viewModel.isEditable {
            Button {
                isShowingAlert = true
                AnalyticsService.shared.logEvent(.exerciseDetailsAddSetButtonTapped)
            } label: {
                Image(systemName: "plus")
                    .frame(sideLength: 24)
                    .fontWeight(.semibold)
                    .padding(8)
            }
        }
    }
}

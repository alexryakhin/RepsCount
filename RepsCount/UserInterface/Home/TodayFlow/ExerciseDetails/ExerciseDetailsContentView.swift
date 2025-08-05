import SwiftUI

struct ExerciseDetailsContentView: View {

    struct StatCardView: View {
        let title: String
        let value: String
        let icon: String
        let color: Color

        var body: some View {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }

                VStack(spacing: 4) {
                    Text(value)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)

                    Text(title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.tertiarySystemGroupedBackground))
            )
        }
    }

    @State private var isShowingAlert = false
    @State private var showConfetti = false
    @State private var isEditingDefaultsAlertPresented: Bool = false
    @State private var editingDefaultsAmountInput: String = ""
    @State private var editingDefaultsSetsInput: String = ""
    @FocusState private var isNotesInputFocused: Bool
    @ObservedObject var viewModel: ExerciseDetailsViewModel

    init(viewModel: ExerciseDetailsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                setsSection
                totalSection
                mapSection
                notesSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(
            Color(.systemGroupedBackground).ignoresSafeArea().displayConfetti(isActive: $showConfetti)
        )
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            if viewModel.exercise.defaultSets != 0 || viewModel.isEditable {
                HStack(spacing: 12) {
                    progressGauge
                    addDataButton
                }
                .clippedWithPaddingAndBackgroundMaterial(.ultraThinMaterial)
                .padding(vertical: 12, horizontal: 16)
            }
        }
        .alert(viewModel.exercise.model.metricType.enterValueLocalizedString, isPresented: $isShowingAlert) {
            TextField(viewModel.exercise.model.metricType.amountLocalizedString, text: $viewModel.amountInput)
                .keyboardType(.decimalPad)
            TextField("Weight, \(Text(viewModel.measurementUnit.shortName)) (optional)", text: $viewModel.weightInput)
                .keyboardType(.decimalPad)
                            Button(Loc.Common.add.localized) {
                viewModel.handle(.addSet)
                isShowingAlert = false
                AnalyticsService.shared.logEvent(.exerciseDetailsAddSetAlertProceedTapped)
            }
            Button(Loc.Common.cancel.localized, role: .cancel) {
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
        .additionalState(viewModel.additionalState)
        .withAlertManager()
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
                            Label(Loc.Common.edit.localized, systemImage: "pencil.and.ellipsis.rectangle")
                        }
                    }
                    Section {
                        Button(role: .destructive) {
                            viewModel.handle(.deleteExercise)
                            AnalyticsService.shared.logEvent(.exerciseDetailsDeleteMenuButtonTapped)
                        } label: {
                            Label(Loc.ExerciseDetails.deleteExercise.localized, systemImage: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert(Loc.Common.edit.localized, isPresented: $isEditingDefaultsAlertPresented) {
            TextField(Loc.ExerciseDetails.setsOptional.localized, text: $editingDefaultsSetsInput)
                .keyboardType(.numberPad)
            let textFieldTitleKey: String = switch viewModel.exercise.model.metricType {
            case .reps: Loc.ExerciseDetails.repsOptional
            case .time: Loc.ExerciseDetails.timeOptional
            @unknown default:
                fatalError()
            }
            TextField(textFieldTitleKey.localized, text: $editingDefaultsAmountInput)
                .keyboardType(.numberPad)

            Button(Loc.Common.cancel.localized, role: .cancel) {
                editingDefaultsAmountInput = ""
                editingDefaultsSetsInput = ""
                AnalyticsService.shared.logEvent(.exerciseDetailsEditAlertCancelTapped)
            }
            Button(Loc.Common.apply.localized) {
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
            CustomSectionView(header: Loc.ExerciseDetails.sets.localized, footer: setSectionFooter) {
                ListWithDivider(Array(viewModel.exercise.sets.enumerated())) { offset, exerciseSet in
                    setCellView(exerciseSet, offset: offset)
                }
                .clippedWithBackground()
            }
        }
    }

    private var setSectionFooter: String? {
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
        VStack(spacing: 16) {
            HStack {
                Text("Total")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                switch viewModel.exercise.model.metricType {
                case .reps:
                    StatCardView(
                        title: "Total Reps",
                        value: viewModel.totalAmount.formatted(),
                        icon: "number.circle.fill",
                        color: .blue
                    )
                case .time:
                    StatCardView(
                        title: "Total Time",
                        value: viewModel.totalAmount.formatted(with: [.minute, .second]),
                        icon: "clock.fill",
                        color: .green
                    )
                @unknown default:
                    fatalError()
                }
                
                StatCardView(
                    title: "Sets",
                    value: viewModel.exercise.sets.count.formatted(),
                    icon: "list.bullet.circle.fill",
                    color: .orange
                )
                
                if viewModel.exercise.sets.count > 1,
                   let firstSetDate = viewModel.exercise.sets.first?.timestamp,
                   let lastSetDate = viewModel.exercise.sets.last?.timestamp {
                    let distance = firstSetDate.distance(to: lastSetDate)
                    StatCardView(
                        title: "Duration",
                        value: distance.formatted(with: [.hour, .minute, .second]),
                        icon: "timer",
                        color: .purple
                    )
                }
            }
        }
    }

    private func infoCellView(_ text: String) -> some View {
        Text(text)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(vertical: 12, horizontal: 16)
    }

    @ViewBuilder
    private var mapSection: some View {
        if let location = viewModel.exercise.location {
            VStack(spacing: 16) {
                HStack {
                    Text("Map")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    
                    MapView(location: .init(latitude: location.latitude, longitude: location.longitude))
                        .overlay(alignment: .bottomLeading) {
                            if let address = location.address {
                                Text(address)
                                    .font(.subheadline)
                                    .padding(vertical: 8, horizontal: 12)
                                    .clippedWithBackgroundMaterial(.thinMaterial)
                                    .padding(8)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                }
            }
        }
    }

    @ViewBuilder
    private var notesSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Notes")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isNotesInputFocused {
                    Button {
                        isNotesInputFocused = false
                        viewModel.handle(.updateNotes)
                        AnalyticsService.shared.logEvent(.exerciseDetailsNotesEdited)
                    } label: {
                        Text("Done")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            TextField(
                "Enter your notes here...",
                text: $viewModel.exercise.notes,
                axis: .vertical
            )
            .focused($isNotesInputFocused)
            .font(.subheadline)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
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

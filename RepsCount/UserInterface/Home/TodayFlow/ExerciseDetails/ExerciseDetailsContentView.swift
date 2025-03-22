import SwiftUI
import CoreUserInterface
import Core
import Shared
import struct Services.AnalyticsService

public struct ExerciseDetailsContentView: PageView {

    public typealias ViewModel = ExerciseDetailsViewModel

    @State private var isShowingAlert = false
    @FocusState private var isNotesInputFocused: Bool
    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: ExerciseDetailsViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                setsSection
                totalSection
                mapSection
                notesSection
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .background(Color.background)
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
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: viewModel.exercise.sets)
        .onAppear {
            AnalyticsService.shared.logEvent(.exerciseDetailsScreenOpened)
        }
    }

    @ViewBuilder
    private var setsSection: some View {
        if !viewModel.exercise.sets.isEmpty {
            CustomSectionView(header: "Sets") {
                ListWithDivider(Array(viewModel.exercise.sets.enumerated())) { offset, exerciseSet in
                    setCellView(exerciseSet, offset: offset)
                        .contextMenu {
                            if viewModel.isEditable {
                                Button("Delete", role: .destructive) {
                                    viewModel.handle(.deleteSet(exerciseSet))
                                    AnalyticsService.shared.logEvent(.exerciseDetailsSetRemoved)
                                }
                            }
                        }
                }
                .clippedWithBackground(.surface)
            }
        }
    }

    private func setCellView(_ exerciseSet: ExerciseSet, offset: Int) -> some View {
        HStack {
            let convertedWeight: String = viewModel.measurementUnit.convertFromKilograms(exerciseSet.weight)
            Group {
                switch viewModel.exercise.model.metricType {
                case .weightAndReps:
                    exerciseSet.setRepsText(index: offset + 1, weight: exerciseSet.weight > 0 ? convertedWeight : nil)
                        .fontWeight(.semibold)
                case .time:
                    exerciseSet.setTimeText(index: offset + 1, weight: exerciseSet.weight > 0 ? convertedWeight : nil)
                        .fontWeight(.semibold)
                @unknown default:
                    fatalError()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let maxReps = viewModel.exercise.maxReps {
                Gauge(value: min(exerciseSet.amount / maxReps, 1)) {}
                    .gaugeStyle(.accessoryLinear)
                    .tint(Gradient(colors: [.green, .blue]))
            }

            Text(DateFormatter().convertDateToString(date: exerciseSet.timestamp, format: .timeFull))
                .font(.system(.subheadline, design: .monospaced))
                .foregroundStyle(.secondary)
        }
        .padding(vertical: 12, horizontal: 16)
    }

    private var totalSection: some View {
        CustomSectionView(header: "Total") {
            FormWithDivider {
                switch viewModel.exercise.model.metricType {
                case .weightAndReps:
                    infoCellView("Reps: \(viewModel.totalAmount.formatted())")
                case .time:
                    infoCellView("Combined time: \(viewModel.totalAmount.hoursMinutesAndSeconds!)")
                @unknown default:
                    fatalError()
                }
                infoCellView("Sets: \(viewModel.exercise.sets.count.formatted())")
                if viewModel.exercise.sets.count > 1,
                   let firstSetDate = viewModel.exercise.sets.first?.timestamp,
                   let lastSetDate = viewModel.exercise.sets.last?.timestamp {
                    let distance = firstSetDate.distance(to: lastSetDate)
                    infoCellView("Time: \(distance.hoursMinutesAndSeconds!)")
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
                text: $viewModel.notesInput,
                axis: .vertical
            )
            .focused($isNotesInputFocused)
            .clippedWithPaddingAndBackground(.surface)
        } headerTrailingContent: {
            if isNotesInputFocused {
                Button {
                    UIApplication.shared.endEditing()
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
                Text("Progress: \(viewModel.exercise.sets.count) sets out of \(viewModel.exercise.defaultSets.formatted())")
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

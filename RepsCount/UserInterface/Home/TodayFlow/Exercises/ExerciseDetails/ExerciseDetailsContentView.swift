import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core

public struct ExerciseDetailsContentView: PageView {

    public typealias ViewModel = ExerciseDetailsViewModel

    @State private var isShowingAlert = false
    @FocusState private var isNotesInputFocused: Bool
    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: ExerciseDetailsViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        List {
            setsSection
            totalSection
            mapSection
            notesSection
        }
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            addDataButton
        }
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                VStack {
//                    Text(LocalizedStringKey(viewModel.exercise.name))
//                        .font(.headline)
//                    Text(viewModel.exercise.timestamp.formatted(date: .abbreviated, time: .shortened))
//                        .font(.caption)
//                        .foregroundStyle(.secondary)
//                }
//            }
//        }
        .alert("Enter the amount of reps", isPresented: $isShowingAlert) {
            TextField("Amount", text: $viewModel.amountInput)
                .keyboardType(.decimalPad)
            TextField("Weight, \(Text(viewModel.measurementUnit.shortName)) (optional)", text: $viewModel.weightInput)
                .keyboardType(.decimalPad)
            Button("Add") {
                viewModel.handle(.addSet)
                isShowingAlert = false
            }
            Button("Cancel", role: .cancel) {
                viewModel.amountInput = ""
                viewModel.weightInput = ""
                isShowingAlert = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: viewModel.exercise.sets)
    }

    @ViewBuilder
    private var setsSection: some View {
        if !viewModel.exercise.sets.isEmpty {
            Section("Sets") {
                ForEach(Array(viewModel.exercise.sets.enumerated()), id: \.offset) { offset, exerciseSet in
                    HStack {
                        if exerciseSet.weight > 0 {
                            let converted: String = viewModel.measurementUnit.convertFromKilograms(exerciseSet.weight)
                            Text("#\(offset + 1): \(exerciseSet.amount.formatted()) reps, \(converted)")
                                .fontWeight(.semibold)
                        } else {
                            Text("#\(offset + 1): \(exerciseSet.amount.formatted()) reps")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        Text(exerciseSet.timestamp.formatted(date: .omitted, time: .shortened))
                            .foregroundStyle(.secondary)
                    }
                }
                .if(viewModel.isEditable, transform: { view in
                    view.onDelete { offsets in
                        viewModel.handle(.deleteSet(at: offsets))
                    }
                })
            }
        }
    }

    private var totalSection: some View {
        Section("Total") {
            Text("Reps: \(viewModel.totalAmount.formatted())")
                .fontWeight(.semibold)
            Text("Sets: \(viewModel.exercise.sets.count)")
                .fontWeight(.semibold)
            if viewModel.exercise.sets.count > 1,
               let firstSetDate = viewModel.exercise.sets.first?.timestamp,
               let lastSetDate = viewModel.exercise.sets.last?.timestamp {
                let distance = firstSetDate.distance(to: lastSetDate)
                Text("Time: \(timeFormatter.string(from: distance)!)")
                    .fontWeight(.semibold)
            }
        }
    }

    @ViewBuilder
    private var mapSection: some View {
        if let location = viewModel.exercise.location {
            Section("Map") {
                MapView(location: .init(latitude: location.latitude, longitude: location.longitude))
                if let address = location.address {
                    Text(address)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    @ViewBuilder
    private var notesSection: some View {
        Section {
            TextEditor(text: $viewModel.notesInput)
                .focused($isNotesInputFocused)
                .frame(height: 150)
                .overlay(alignment: .topLeading) {
                    if viewModel.notesInput.isEmpty {
                        Text("Enter your notes here...")
                            .foregroundStyle(.secondary)
                            .allowsHitTesting(false)
                            .padding(.horizontal, 4)
                            .padding(.top, 8)
                    }
                }
        } header: {
            HStack {
                Text("Notes")
                    .frame(maxWidth: .infinity, alignment: .leading)
                if isNotesInputFocused {
                    Button {
                        UIApplication.shared.endEditing()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var addDataButton: some View {
        if viewModel.isEditable {
            Button {
                isShowingAlert = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold, design: .monospaced))
                    .padding(8)
            }
            .buttonStyle(.bordered)
            .padding(24)
        }
    }
}

private let timeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.hour, .minute, .second]
    return formatter
}()

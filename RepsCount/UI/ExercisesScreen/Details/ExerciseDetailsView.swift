//
//  ExerciseDetailsView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI
import MapKit

struct ExerciseDetailsView: View {
    @State private var isShowingAlert = false
    @FocusState private var isNotesInputFocused: Bool

    @ObservedObject private var viewModel: ExerciseDetailsViewModel

    init(viewModel: ExerciseDetailsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            setsSection
            totalSection
            mapSection
            notesSection
        }
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            addDataButton
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey(viewModel.exercise.name ?? ""))
                        .font(.headline)
                    if let date = viewModel.exercise.timestamp {
                        Text(date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .alert("Enter the amount of reps", isPresented: $viewModel.isShowingAlert) {
            TextField("Amount", text: $viewModel.amountInput)
                .keyboardType(.decimalPad)
            TextField("Weight, \(Text(viewModel.measurementUnit.shortName)) (optional)", text: $viewModel.weightInput)
                .keyboardType(.decimalPad)
            Button("Add") {
                viewModel.addItem()
                viewModel.isShowingAlert = false
            }
            Button("Cancel", role: .cancel) {
                viewModel.amountInput = ""
                viewModel.weightInput = ""
                viewModel.isShowingAlert = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: viewModel.exerciseSets)
    }

    @ViewBuilder
    private var setsSection: some View {
        if !viewModel.exerciseSets.isEmpty {
            Section("Sets") {
                ForEach(Array(viewModel.exerciseSets.enumerated()), id: \.offset) { offset, exerciseSet in
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
                        Text((exerciseSet.timestamp ?? .now).formatted(date: .omitted, time: .shortened))
                            .foregroundStyle(.secondary)
                    }
                }
                .if(viewModel.isEditable, transform: { view in
                    view.onDelete(perform: viewModel.deleteItems)
                })
            }
        }
    }

    private var totalSection: some View {
        Section("Total") {
            Text("Reps: \(viewModel.totalAmount.formatted())")
                .fontWeight(.semibold)
            Text("Sets: \(viewModel.exerciseSets.count)")
                .fontWeight(.semibold)
            if viewModel.exerciseSets.count > 1,
               let firstSetDate = viewModel.exerciseSets.first?.timestamp,
               let lastSetDate = viewModel.exerciseSets.last?.timestamp {
                let distance = firstSetDate.distance(to: lastSetDate)
                Text("Time: \(timeFormatter.string(from: distance)!)")
                    .fontWeight(.semibold)
            }
        }
    }

    @ViewBuilder
    private var mapSection: some View {
        let latitude = viewModel.exercise.latitude
        let longitude = viewModel.exercise.longitude
        if latitude != 0,
           longitude != 0 {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: location, span: span)
            Section("Map") {
                Map(coordinateRegion: .constant(region), showsUserLocation: false, annotationItems: [MapMarker(coordinate: location, tint: .red)]) { $0 }
                    .frame(height: 200)
                    .allowsHitTesting(false)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if let address = viewModel.exercise.address {
                    Text(address)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    @ViewBuilder
    private var notesSection: some View {
        Section("Notes") {
            TextEditor(text: $viewModel.notesInput)
                .focused($isNotesInputFocused)
                .padding(.bottom, -16)
                .overlay(alignment: .leading) {
                    if viewModel.notesInput.isEmpty {
                        Text("Start typing")
                            .foregroundStyle(.secondary)
                            .allowsHitTesting(false)
                            .padding(.horizontal, 4)
                    }
                }
            if isNotesInputFocused {
                Button("Save") {
                    viewModel.exercise.notes = viewModel.notesInput
                    isNotesInputFocused = false
                    viewModel.save()
                }
            }
        }
        .onAppear {
            viewModel.notesInput = viewModel.exercise.notes ?? ""
        }
    }

    @ViewBuilder
    private var addDataButton: some View {
        if viewModel.isEditable {
            Button {
                viewModel.isShowingAlert = true
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(16)
                    .background(in: Circle())
                    .overlay {
                        Circle().strokeBorder()
                    }
            }
            .padding(30)
        }
    }
}

private let timeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.hour, .minute, .second]
    return formatter
}()

extension MapMarker: Identifiable {
    public var id: String {
        UUID().uuidString
    }
}

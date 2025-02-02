//
//  PlanWorkoutScreenViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/2/25.
//

import SwiftUI
import Foundation
import CoreData

final class PlanWorkoutScreenViewModel: ObservableObject {

    @Published var savedSuccessfully: Bool?

    @Published var eventNameText: String = ""
    @Published var eventNameError: String?

    @Published var notesText: String = ""

    @Published var dateSelection: Date?
    @Published var dateSelectionError: String?

    @Published var recurrenceRule: Calendar.RecurrenceRule?

    @Published var selectedExerciseModels: Set<ExerciseModel> = []
    @Published var selectedExerciseModelsError: String?

    private let calendarEventStorage: CalendarEventStorageInterface

    init(calendarEventStorage: CalendarEventStorageInterface) {
        self.calendarEventStorage = calendarEventStorage
    }

    func saveEvent() {
        guard eventNameText.isEmpty == false else {
            eventNameError = "Name is required"
            return
        }
        guard let dateSelection else {
            dateSelectionError = "Date is required"
            return
        }
        guard selectedExerciseModels.isEmpty == false else {
            selectedExerciseModelsError = "At least one exercise is required"
            return
        }
        do {
            try calendarEventStorage.addEvent(
                title: eventNameText,
                date: dateSelection,
                notes: notesText,
                exercises: selectedExerciseModels
            )
            savedSuccessfully = true
        } catch {
            savedSuccessfully = false
        }
    }
}

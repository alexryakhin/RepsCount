//
//  AnalyticsEvent.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/25/25.
//

import Foundation
import Shared

public enum AnalyticsEvent: String {
    case appOpened

    // MARK: - Today screen
    case todayScreenOpened
    case todayScreenAddWorkoutFromTemplatesButtonTapped
    case todayScreenAddNewWorkoutButtonTapped
    case todayScreenStartPlannedWorkoutTapped
    case todayScreenAddWorkoutFromTemplatesMenuButtonTapped
    case todayScreenStartWorkoutFromTemplate
    case todayScreenAddNewWorkoutButtonMenuTapped
    case todayScreenShowAllWorkoutsMenuButtonTapped
    case todayScreenShowAllExercisesMenuButtonTapped
    case todayScreenWorkoutSelected
    case todayScreenWorkoutRemoveButtonTapped
    case todayScreenWorkoutRemoveCancelButtonTapped
    case todayScreenWorkoutRemoved

    // MARK: - Workout details screen
    case workoutDetailsScreenOpened
    case workoutDetailsAddExerciseButtonTapped
    case workoutDetailsAddExerciseMenuButtonTapped
    case workoutDetailsMarkAsCompleteMenuButtonTapped
    case workoutDetailsRenameMenuButtonTapped
    case workoutDetailsDeleteMenuButtonTapped
    case workoutDetailsExerciseSelected
    case workoutDetailsExerciseRemoveButtonTapped
    case workoutDetailsExerciseRemoveCancelButtonTapped
    case workoutDetailsExerciseRemoved
    case workoutDetailsRenameWorkoutCancelTapped
    case workoutDetailsRenameWorkoutActionTapped
    case workoutDetailsMarkAsCompleteCancelTapped
    case workoutDetailsMarkAsCompleteProceedTapped
    case workoutDetailsDeleteWorkoutCancelTapped
    case workoutDetailsDeleteWorkoutActionTapped

    // MARK: - Exercise details screen
    case exerciseDetailsScreenOpened
    case exerciseDetailsAddSetButtonTapped
    case exerciseDetailsSetRemoved
    case exerciseDetailsNotesEdited
    case exerciseDetailsAddSetAlertCancelTapped
    case exerciseDetailsAddSetAlertProceedTapped

    // MARK: - All workouts screen
    case allWorkoutsScreenOpened
    case allWorkoutsScreenDateSelected
    case allWorkoutsScreenWorkoutSelected
    case allWorkoutsScreenWorkoutRemoveButtonTapped
    case allWorkoutsScreenWorkoutRemoved

    // MARK: - All exercises screen
    case allExercisesScreenOpened
    case allExercisesScreenDateSelected
    case allExercisesScreenExerciseSelected
    case allExercisesScreenExerciseRemoveButtonTapped
    case allExercisesScreenExerciseRemoved

    // MARK: - Planning screen
    case planningScreenOpened
    case planningScreenAddTemplateButtonTapped
    case planningScreenAddTemplateMenuButtonTapped
    case planningScreenCalendarTapped
    case planningScreenTemplateSelected
    case planningScreenTemplateRemoved

    // MARK: - Calendar screen
    case calendarScreenOpened
    case calendarScreenDateSelected
    case calendarScreenScheduleWorkoutTapped
    case calendarScreenScheduleWorkoutMenuButtonTapped
    case calendarScreenEventRemoveButtonTapped
    case calendarScreenEventRemoved
    case calendarScreenEventAndFutureEventsRemoved

    // MARK: - Schedule event screen
    case scheduleEventScreenOpened
    case scheduleEventScreenDateSelected
    case scheduleEventScreenDurationSelected
    case scheduleEventScreenTemplateSelected
    case scheduleEventScreenRecurrenceTurnedOn
    case scheduleEventScreenRecurrenceTurnedOff
    case scheduleEventScreenRepeatFrequencySelected
    case scheduleEventScreenIntervalChanged
    case scheduleEventScreenOccurrencesChanged
    case scheduleEventScreenAddToSystemCalendarTurnedOn
    case scheduleEventScreenAddToSystemCalendarTurnedOff
    case scheduleEventScreenSelectSystemCalendarTapped
    case scheduleEventScreenSaveButtonTapped

    // MARK: - Workout template details screen
    case workoutTemplateDetailsScreenOpened
    case workoutTemplateDetailsScreenAddExerciseButtonTapped
    case workoutTemplateDetailsScreenAddExerciseMenuButtonTapped
    case workoutTemplateDetailsScreenNameChanged
    case workoutTemplateDetailsScreenNotesChanged
    case workoutTemplateDetailsScreenExerciseAdded
    case workoutTemplateDetailsScreenExerciseRemoveButtonTapped
    case workoutTemplateDetailsScreenExerciseEditButtonTapped
    case workoutTemplateDetailsScreenCancelEditButtonTapped
    case workoutTemplateDetailsScreenApplyEditButtonTapped
    case workoutTemplateDetailsScreenSaveButtonTapped

    // MARK: - Add exercise screen
    case addExerciseScreenOpened
    case addExerciseScreenEquipmentChanged
    case addExerciseScreenExerciseTap
    case addExerciseScreenExerciseTapFromSearch

    // MARK: - Settings screen
    case settingsScreenOpened
    case settingsScreenMeasurementUnitChanged
    case settingsScreenSaveLocationTurnedOn
    case settingsScreenSaveLocationTurnedOff
    case settingsScreenAboutAppButtonTapped

    // MARK: - About app screen
    case aboutAppScreenOpened
    case buyMeACoffeeTapped
    case twitterButtonTapped
    case instagramButtonTapped

    var parameters: [String: Any]? {
        switch self {
        case .appOpened:
            ["version": GlobalConstant.currentFullAppVersion]
        default:
            nil
        }
    }
}

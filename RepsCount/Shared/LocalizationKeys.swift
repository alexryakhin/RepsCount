//
//  LocalizationKeys.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation

enum Loc {

    // MARK: - Common
    
    enum Common {
        static let ok = "OK"
        static let cancel = "Cancel"
        static let delete = "Delete"
        static let edit = "Edit"
        static let apply = "Apply"
        static let done = "Done"
        static let add = "Add"
        static let remove = "Remove"
        static let save = "Save"
        static let rename = "Rename"
        static let proceed = "Proceed"
        static let continue_ = "Continue"
    }
    
    // MARK: - Navigation
    
    enum Navigation {
        static let today = "Today"
        static let planning = "Planning"
        static let settings = "Settings"
        static let calendar = "Calendar"
        static let allWorkouts = "All Workouts"
        static let allExercises = "All Exercises"
        static let aboutApp = "About app"
        static let workoutDetails = "Workout Details"
        static let exerciseDetails = "Exercise Details"
    }
    
    // MARK: - Today Flow
    
    enum Today {
        static let currentWorkouts = "Current workouts"
        static let plannedWorkouts = "Planned workouts"
        static let noWorkoutPlanned = "No Workout Planned"
        static let noWorkoutPlannedDescription = "You haven't planned any workouts for today."
        static let addWorkoutFromTemplates = "Add Workout from Templates"
        static let startNewWorkout = "Start a new workout"
        static let addOpenWorkout = "Add open workout"
        static let addWorkoutFromTemplate = "Add a workout from template"
        static let showAllWorkouts = "Show all workouts"
        static let showAllExercises = "Show all exercises"
        static let deleteWorkout = "Delete workout"
        static let deleteWorkoutMessage = "Are you sure you want to delete this workout?"
        static let noWorkouts = "No Workouts"
        static let noWorkoutsDescription = "You don't have any workouts planned for today"
    }
    
    // MARK: - Planning Flow
    
    enum Planning {
        static let myWorkoutTemplates = "My workout templates"
        static let noTemplates = "No Templates"
        static let noTemplatesDescription = "You haven't created any workout templates yet"
        static let createNewWorkoutTemplate = "Create New Workout Template"
        static let scheduleWorkouts = "Schedule workouts"
        static let scheduleWorkoutsDescription = "Manage your workout schedule here: Create repetition for events, set reminders, and more."
        static let createTemplate = "Create Template"
        static let editWorkoutTemplate = "Edit workout template"
        static let workoutName = "Workout Name"
        static let muscleGroupsToTarget = "Muscle groups to target"
        static let selectedExercises = "Selected exercises"
        static let addExercises = "Add exercises"
    }
    
    // MARK: - Workout Details
    
    enum WorkoutDetails {
        static let exercises = "Exercises"
        static let noExercisesYet = "No exercises yet"
        static let noExercisesDescription = "Select 'Add exercise' from the menu in the top right corner"
        static let addExercise = "Add exercise"
        static let targetMuscles = "Target muscles"
        static let info = "Info"
        static let notes = "Notes"
        static let markAsComplete = "Mark as complete"
        static let markAsCompleteMessage = "Are you sure you want to complete this workout? You won't be able to make any changes afterwards"
        static let deleteWorkout = "Delete workout"
        static let deleteWorkoutMessage = "Are you sure you want to delete this workout?"
        static let deleteExercise = "Delete exercise"
        static let deleteExerciseMessage = "Are you sure you want to delete this exercise?"
        static let renameWorkout = "Rename workout"
        static let enterName = "Enter name"
    }
    
    // MARK: - Exercise Details
    
    enum ExerciseDetails {
        static let sets = "Sets"
        static let total = "Total"
        static let map = "Map"
        static let notes = "Notes"
        static let enterNotes = "Enter your notes here..."
        static let goalInSet = "Goal: %@ in a set"
        static let progressOutOf = "Progress: %@ out of %@"
        static let reps = "Reps: %@"
        static let setsCount = "Sets: %@"
        static let time = "Time: %@"
        static let combinedTime = "Combined time: %@"
        static let deleteExercise = "Delete exercise"
        static let deleteExerciseMessage = "Are you sure you want to delete this exercise?"
        static let edit = "Edit"
        static let setsOptional = "Sets (optional)"
        static let repsOptional = "Reps (optional)"
        static let timeOptional = "Time (sec, optional)"
    }
    
    // MARK: - Settings
    
    enum Settings {
        static let measurementUnit = "Measurement unit"
        static let saveLocation = "Save location"
        static let changeLanguage = "Change language"
        static let contactMe = "Contact me"
        static let support = "Support"
        static let rateApp = "Rate the app"
        static let buyMeCoffee = "Buy Me a Coffee"
        static let goToSettings = "Go to settings"
        static let appVersion = "App version:"
        static let changeLanguageMessage = "To change the language of the app, go to the Settings app on your device."
    }
    
    // MARK: - About App
    
    enum AboutApp {
        static let welcomeMessage = "Welcome to RepsCount, your companion for tracking and improving your workout performance!\nI created this app because I myself needed something simple yet powerful to track my progress, and it's pretty hard to do it just in Notes App.\nIf you like the app, please leave a review"
        static let contactMessage = "Have questions, suggestions, or feedback? I'd love to hear from you. Reach out to get support on Instagram or Twitter!"
        static let twitter = "X (Twitter)"
        static let instagram = "Instagram"
    }
    
    // MARK: - Calendar
    
    enum Calendar {
        static let selectDate = "Select date"
        static let plannedWorkouts = "Planned workouts"
        static let noWorkoutsScheduled = "No Workouts Scheduled"
        static let scheduleWorkout = "Schedule a Workout"
        static let calendarOnDevice = "Calendar on device"
        static let addToSystemCalendar = "Add to system calendar"
        static let selectCalendar = "Select calendar"
        static let selectedCalendar = "Selected calendar"
        static let recurrence = "Recurrence"
        static let repeatWorkout = "Repeat Workout"
        static let repeatFrequency = "Repeat Frequency"
        static let daily = "Daily"
        static let weekly = "Weekly"
        static let monthly = "Monthly"
        static let interval = "Interval: %@"
        static let occurrences = "Occurrences: %@"
        static let duration = "Duration"
        static let startDate = "Start date"
        static let selectTemplate = "Select template"
        static let workout = "Workout"
        static let scheduleWorkoutButton = "Schedule Workout"
    }
    
    // MARK: - Alerts
    
    enum Alerts {
        static let error = "Error"
        static let emptyName = "Empty name"
        static let emptyNameMessage = "Name of the workout template cannot be empty"
        static let emptyExercises = "Empty exercises"
        static let emptyExercisesMessage = "You should add at least one exercise"
        static let deleteEvent = "Delete Event"
        static let deleteEventMessage = "Are you sure you want to delete this event?"
        static let deleteAllFutureEvents = "Delete All Future Events"
        static let deleteThisEventOnly = "Delete This Event Only"
    }
    
    // MARK: - Workout Templates
    
    enum WorkoutTemplates {
        static let newWorkoutTemplate = "New workout template"
        static let createTemplates = "Create templates"
        static let haveReadyWorkouts = "Have ready-to-go workouts for any day"
        static let editDefaults = "Edit"
        static let defaults = "Defaults"
        static let somethingYouMightNeed = "Something you might need"
    }
    
    // MARK: - Lists
    
    enum Lists {
        static let noWorkoutsYet = "No workouts yet"
        static let noWorkoutsYetDescription = "Go back and start a workout"
        static let noExercisesYet = "No exercises yet"
        static let noExercisesYetDescription = "Go back and start a workout"
        static let noWorkoutsForDate = "No workouts for this date!"
        static let noExercisesForDate = "No exercises for this date!"
    }
    
    // MARK: - Exercise Input
    
    enum ExerciseInput {
        static let enterAmountOfReps = "Enter the amount of reps"
        static let enterTime = "Enter time"
        static let weightOptional = "Weight, %@ (optional)"
        static let amount = "Amount"
        static let timeSeconds = "Time (seconds)"
        static let timeSec = "Time (sec): %@"
    }
    
    // MARK: - Time
    
    enum Time {
        static let time = "Time"
        static let fifteenMinutes = "15 minutes"
        static let thirtyMinutes = "30 minutes"
        static let oneHour = "1 hour"
        static let oneHourThirtyMinutes = "1 hour 30 minutes"
        static let twoHours = "2 hours"
    }
    
    // MARK: - Units
    
    enum Units {
        static let kilograms = "Kilograms"
        static let pounds = "Pounds"
        static let stones = "Stones"
        static let kg = "kg"
        static let lb = "lb"
        static let st = "st"
    }
    
    // MARK: - Days
    
    enum Days {
        static let monday = "Monday"
        static let tuesday = "Tuesday"
        static let wednesday = "Wednesday"
        static let thursday = "Thursday"
        static let friday = "Friday"
        static let saturday = "Saturday"
        static let sunday = "Sunday"
    }
} 

// MARK: - String Extension for Localization
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

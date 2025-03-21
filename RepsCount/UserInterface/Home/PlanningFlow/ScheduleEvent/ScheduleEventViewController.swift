import UIKit
import SwiftUI
import CoreUserInterface
import Core
import Shared
import EventKitUI

public final class ScheduleEventViewController: PageViewController<ScheduleEventContentView> {

    public enum Event {
        case finish
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private var calendarChooserController: UIViewController?
    private let viewModel: ScheduleEventViewModel

    // MARK: - Initialization

    public init(viewModel: ScheduleEventViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ScheduleEventContentView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        setupBindings()
        navigationItem.title = NSLocalizedString("Schedule Workout", comment: "Schedule Workout")
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .dismiss:
                self?.onEvent?(.finish)
            case .showCalendarChooser:
                self?.showCalendarChooser()
            }
        }
    }

    private func showCalendarChooser() {
        // Initializes a calendar chooser that allows the user to select a single calendar from a list of writable calendars only.
        let calendarChooser = EKCalendarChooser(
            selectionStyle: .single,
            displayStyle: .writableCalendarsOnly,
            entityType: .event,
            eventStore: viewModel.eventStore
        )
        /*
            Set up the selected calendars property. If the user previously selected a calendar from the view controller, update the property with it.
            Otherwise, update selected calendars with an empty set.
        */
        if let calendar = viewModel.calendar {
            let selectedCalendar: Set<EKCalendar> = [calendar]
            calendarChooser.selectedCalendars = selectedCalendar
        } else {
            calendarChooser.selectedCalendars = []
        }
        calendarChooser.delegate = self

        // Configure the chooser to display Done and Cancel buttons.
        calendarChooser.showsDoneButton = true
        calendarChooser.showsCancelButton = true

        let calendarChooserController = UINavigationController(rootViewController: calendarChooser)
        self.calendarChooserController = calendarChooserController
        present(calendarChooserController, animated: true)
    }

}

extension ScheduleEventViewController: EKCalendarChooserDelegate {
    /// The system calls this when the user taps Done in the UI. Save the user's choice.
    public func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
        logInfo("DEBUG50 - calendarChooserDidFinish")
        viewModel.calendar = calendarChooser.selectedCalendars.first
        calendarChooserController?.dismiss(animated: true)
    }

    /// The system calls this when the user taps Cancel in the UI. Dismiss the calendar chooser.
    public func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
        logInfo("DEBUG50 - calendarChooserDidCancel")
        calendarChooserController?.dismiss(animated: true)
    }
}

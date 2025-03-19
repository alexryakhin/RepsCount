import UIKit
import SwiftUI
import CoreUserInterface
import Core

public final class CalendarViewController: PageViewController<CalendarContentView>, NavigationBarVisible {

    public enum Event {
        case scheduleWorkout(configModel: ScheduleEventViewModel.ConfigModel)
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: CalendarViewModel

    // MARK: - Initialization

    public init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(rootView: CalendarContentView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        setupBindings()
        navigationItem.title = "Calendar"
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .scheduleWorkout(let configModel):
                self?.onEvent?(.scheduleWorkout(configModel: configModel))
            case .presentDeleteEventAlert(let event):
                self?.presentDeleteEventAlert(event)
            }
        }
    }

    private func presentDeleteEventAlert(_ event: WorkoutEvent) {
        let alertController = UIAlertController(
            title: "Are you sure you want to delete this event?",
            message: event.type == .recurring ? "This is a repeating event." : nil,
            preferredStyle: .actionSheet
        )
        switch event.type {
        case .recurring:
            let deleteSingleAction = UIAlertAction(title: "Delete This Event Only", style: .destructive) { [weak self] _ in
                self?.viewModel.handle(.handleDeleteEventAlert(event, deleteFutureEvents: false))
            }
            let deleteAllAction = UIAlertAction(title: "Delete All Future Events", style: .destructive) { [weak self] _ in
                self?.viewModel.handle(.handleDeleteEventAlert(event, deleteFutureEvents: true))
            }
            alertController.addAction(deleteSingleAction)
            alertController.addAction(deleteAllAction)
        case .single:
            let deleteSingleAction = UIAlertAction(title: "Delete Event", style: .destructive) { [weak self] _ in
                self?.viewModel.handle(.handleDeleteEventAlert(event, deleteFutureEvents: false))
            }
            alertController.addAction(deleteSingleAction)
        @unknown default:
            fatalError("Unsupported event type")
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}

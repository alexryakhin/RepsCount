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
        navigationItem.title = NSLocalizedString("Calendar", comment: .empty)
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
            title: NSLocalizedString("Are you sure you want to delete this event?", comment: .empty),
            message: event.type == .recurring ? NSLocalizedString("This is a repeating event.", comment: .empty) : nil,
            preferredStyle: .actionSheet
        )
        switch event.type {
        case .recurring:
            let deleteSingleAction = UIAlertAction(title: NSLocalizedString("Delete This Event Only", comment: .empty), style: .destructive) { [weak self] _ in
                self?.viewModel.handle(.handleDeleteEventAlert(event, deleteFutureEvents: false))
            }
            let deleteAllAction = UIAlertAction(title: NSLocalizedString("Delete All Future Events", comment: .empty), style: .destructive) { [weak self] _ in
                self?.viewModel.handle(.handleDeleteEventAlert(event, deleteFutureEvents: true))
            }
            alertController.addAction(deleteSingleAction)
            alertController.addAction(deleteAllAction)
        case .single:
            let deleteSingleAction = UIAlertAction(title: NSLocalizedString("Delete Event", comment: .empty), style: .destructive) { [weak self] _ in
                self?.viewModel.handle(.handleDeleteEventAlert(event, deleteFutureEvents: false))
            }
            alertController.addAction(deleteSingleAction)
        @unknown default:
            fatalError("Unsupported event type")
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: .empty), style: .cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}

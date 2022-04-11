import CoreAnalytics

enum LibraryEvent {
    case homeLoaded // OK
    case displayModeChanged(DisplayMode) // OK
    case goalLoaded(String?) // OK
    case objectiveStatusChanged(String, LearningObjectiveStatus) // OK
    case objectiveLearningToggled(String)
    case createObjectiveTapped
    case objectiveCreated
    case objectiveStartedEditing // OK
    case objectiveCompletedEditing // OK
    case objectiveCanceledEditing // OK
    case objectiveDeleted // OK
    
    enum DisplayMode: String {
        case list, groups
    }
}

extension AnalyticsLogging {
    func log(_ event: LibraryEvent) {
        self.log(event: event)
    }
}

extension LibraryEvent: AnalyticsEvent {
    var name: String {
        switch self {
        case .homeLoaded:
            return "home_opened"
        case .displayModeChanged:
            return "display_mode_changed"
        case .goalLoaded:
            return "category_selected"
        case .objectiveStatusChanged:
            return "objective_status_changed"
        case .createObjectiveTapped:
            return "create_objective_tapped"
        case .objectiveCreated:
            return "objective_created"
        case .objectiveStartedEditing:
            return "objective_started_editing"
        case .objectiveCompletedEditing:
            return "objective_completed_editing"
        case .objectiveCanceledEditing:
            return "objective_canceled"
        case .objectiveDeleted:
            return "objective_deleted"
        case .objectiveLearningToggled:
            return "objective_learning_toggled"
        }
    }
    
    var properties: [AnalyticsProperty]? {
        switch self {
        case .homeLoaded, .createObjectiveTapped,
                .objectiveCreated, .objectiveStartedEditing,
                .objectiveCompletedEditing, .objectiveCanceledEditing,
                .objectiveDeleted:
            return nil
        case let .displayModeChanged(newMode):
            return [
                .init(name: "new_mode", value: newMode.rawValue)
            ]
        case let .goalLoaded(categoryName):
            return [
                .init(name: "category_loaded", value: categoryName)
            ]
        case let .objectiveStatusChanged(objectiveName, newStatus):
            return [
                .init(name: "objective_name", value: objectiveName),
                .init(name: "new_status", value: newStatus),
            ]
        case let .objectiveLearningToggled(objectiveCode):
            return [
                .init(name: "objective_code", value: objectiveCode)
            ]
        }
    }
}

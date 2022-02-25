import CoreInjector

struct ObjectivesRoute: Route {
    static var identifier: String { "library.objectivesRoute" }
    let goal: LearningGoal
}

struct NewObjectiveRoute: Route {
    static var identifier: String { "library.newObjectiveRoute" }
}

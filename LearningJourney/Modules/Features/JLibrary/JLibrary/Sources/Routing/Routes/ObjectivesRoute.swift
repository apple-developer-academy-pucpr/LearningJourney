import CoreInjector
import SwiftUI

struct ObjectivesRoute: Route {
    static var identifier: String { "library.objectivesRoute" }
    let goal: LearningGoal
}

struct NewObjectiveRoute: Route {
    static var identifier: String { "library.newObjectiveRoute" }
    let goal: LearningGoal
    let isPresented: Binding<Bool>
}

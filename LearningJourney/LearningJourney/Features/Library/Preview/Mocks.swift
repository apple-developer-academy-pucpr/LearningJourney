#if DEBUG

import SwiftUI

final class LibraryViewModelMock: LibraryViewModelProtocol {
    var searchQuery: String = ""
    
    let resultToUse: [LearningStrand]
    var strands: LibraryViewModelState<[LearningStrand]> = .loading
    
    init(resultToUse: [LearningStrand]) {
        self.resultToUse = resultToUse
    }
    
    func handleOnAppear() {
        strands = .result(resultToUse)
        objectWillChange.send()
    }
}

final class LibraryCoordinatorMock: LibraryCoordinating {
    func objectivesView(goal: LearningGoal) -> AnyView {
        .init(Text("Dummy"))
    }
    
    func start() -> AnyView {
        .init(Text("Dummy"))
    }
    
    var isPresentingObjectives: Bool = true
}

final class LibraryScenesFactoryMock: LibraryScenesFactoryProtocol {
    func resolveLibraryScene() -> AnyView {
        .init(Text("Dummy"))
    }
    
    func resolveObjectivesListScene(using goal: LearningGoal) -> AnyView {
        .init(Text("Dummy"))
    }
}

final class ObjectivesListViewModelMock: ObjectivesListViewModelProtocol {
    func handleDidLearnToggled(objective: LibraryViewModelState<LearningObjective>) {
        //        let newObjective = LearningObjective(
        //            id: objective.id,
        //            isCore: objective.isCore,
        //            Description: objective.Description,
        //            isLearned: !objective.isLearned)
        //        switch objectives {
        //        case let .result(a):
        //            var objectives = a.map { $0 }
        //            let index = objectives.firstIndex(where: { $0.id == objective.id })!
        //            objectives.remove(at: index)
        //            objectives.insert(.result(newObjective), at: index)
        //            self.objectives = .result(objectives)
        //            objectWillChange.send()
        //        default:
        //            break
        //        }
    }
    
    
    @Published
    var objectives: LibraryViewModelState<[LibraryViewModelState<LearningObjective>]> = .result([
        .result(.fixture()),
        .result(.fixture()),
        .result(.fixture()),
        .result(.fixture()),
        .result(.fixture()),
    ])
    
    var goalName: String = "Dummy"
    
    func handleOnAppear() {
        objectWillChange.send()
    }
}

#endif

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

#endif

#if DEBUG

import SwiftUI

final class LibraryViewModelMock: LibraryViewModelProtocol {
    func handleUserDidChange() {
        
    }
    
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

final class LibraryScenesFactoryMock: LibraryScenesFactoryProtocol {
    func resolveLibraryScene(for feature: LibraryFeature, using route: LibraryRoute?) -> AnyView {
        .init(Text("Dummy"))
    }
    
    func resolveObjectivesListScene(using route: ObjectivesRoute) -> AnyView {
        .init(Text("Dummy"))
    }
}

final class ObjectivesListViewModelMock: ObjectivesListViewModelProtocol {
    func handleDidLearnToggled(objective: LibraryViewModelState<LearningObjective>) {}
    
    
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

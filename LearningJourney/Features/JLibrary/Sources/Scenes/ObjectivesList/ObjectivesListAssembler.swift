import SwiftUI

import CoreNetworking

protocol ObjectivesListAssembling {
    func assemble(learningGoal: LearningGoal) -> AnyView
}

final class ObjectivesListAssembler: ObjectivesListAssembling{
    func assemble(learningGoal: LearningGoal) -> AnyView {
        let parser = LibraryParser()
        
        let service = LibraryRemoteService(
            apiFactory: { ApiRequest(endpoint: $0) })
        let repository = LibraryRepository(
            remoteService: service,
            parser: parser)
        
        let viewModel = ObjectivesListViewModel(
            useCases: .init(
                fetchObjectivesUseCase: FetchObjectivesUseCase(repository: repository),
                toggleLearnUseCase: ToggleLearnUseCase(repository: repository)),
            dependencies: .init(goal: learningGoal))
        let view = ObjectivesListView<ObjectivesListViewModel>(viewModel: viewModel)
        
        return AnyView(view)
    }
}

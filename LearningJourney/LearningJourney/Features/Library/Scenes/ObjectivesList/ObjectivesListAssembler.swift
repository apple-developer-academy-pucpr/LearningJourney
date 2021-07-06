import SwiftUI

protocol ObjectivesListAssembling {
    func assemble(learningGoal: LearningGoal) -> AnyView
}

final class ObjectivesListAssembler: ObjectivesListAssembling {
    
    @Dependency var apiFactory: ApiFactory
    
    func assemble(learningGoal: LearningGoal) -> AnyView {
        let parser = LibraryParser()
        
        let service = LibraryRemoteService(apiFactory: apiFactory)
        let repository = LibraryRepository(
            remoteService: service,
            parser: parser)
        
        let viewModel = ObjectivesListViewModel(
            useCases: .init(
                fetchObjectivesUseCase: FetchObjectivesUseCase(repository: repository),
                toggleLearnUseCase: ToggleLearnUseCase(repository: repository)),
            dependencies: .init(goal: learningGoal))
        let view = ObjectivesListView<ObjectivesListViewModel, LibraryCoordinator>(viewModel: viewModel)
        
        return AnyView(view)
    }
}

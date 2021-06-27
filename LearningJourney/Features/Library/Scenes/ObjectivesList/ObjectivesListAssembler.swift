import SwiftUI

protocol ObjectivesListAssembling {
    func assemble(learningGoal: LearningGoal) -> AnyView
}

final class ObjectivesListAssembler: ObjectivesListAssembling{
    func assemble(learningGoal: LearningGoal) -> AnyView {
        let parser = LibraryParser()
        
        let service = LibraryRemoteService(
            apiFactory: { ApiRequest($0) })
        let repository = LibraryRepository(
            remoteService: service,
            parser: parser)
        
        let viewModel = ObjectivesListViewModel(
            useCases: .init(fetchObjectivesUseCase: FetchObjectivesUseCase(repository: repository)),
            dependencies: .init(goal: learningGoal))
        let view = ObjectivesListView<ObjectivesListViewModel, LibraryCoordinator>(viewModel: viewModel)
        
        return AnyView(view)
    }
}

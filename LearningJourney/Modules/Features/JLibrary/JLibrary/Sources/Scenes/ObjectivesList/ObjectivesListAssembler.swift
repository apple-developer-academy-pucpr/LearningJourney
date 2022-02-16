import SwiftUI

import CoreNetworking

protocol ObjectivesListAssembling {
    func assemble(using feature: LibraryFeature, learningGoal: LearningGoal) -> AnyView
}

final class ObjectivesListAssembler: ObjectivesListAssembling{
    func assemble(using feature: LibraryFeature, learningGoal: LearningGoal) -> AnyView {
        let parser = LibraryParser()
        
        let service = LibraryRemoteService(
            apiFactory: feature.api)
        let repository = LibraryRepository(
            remoteService: service,
            parser: parser)
        let viewModel = ObjectivesListViewModel(
            useCases: .init(fetchObjectivesUseCase: FetchObjectivesUseCase(repository: repository)),
            dependencies: .init(goal: learningGoal))
        
        let view = ObjectivesListView<ObjectivesListViewModel, ObjectiveCard>(viewModel: viewModel) {
            ObjectiveCard(viewModel: ObjectiveCardViewModel(
                useCases: .init(
                    toggleLearnUseCase: ToggleLearnUseCase(repository: repository),
                    toggleEagerToLearnUseCase: ToggleEagerToLearnUseCase(repository: repository)),
                objective: $0))
        }
        
        return AnyView(view)
    }
}

import SwiftUI

import CoreNetworking

protocol CreateObjectiveAssembling {
    func assemble(using feature: LibraryFeature, route: NewObjectiveRoute?) -> AnyView
}

final class CreateObjectiveAssembler: CreateObjectiveAssembling {
    func assemble(using feature: LibraryFeature, route: NewObjectiveRoute?) -> AnyView {
        guard let route = route else { preconditionFailure("Invalid route sent to this assembler") }
        let repository = LibraryRepository(
            remoteService: LibraryRemoteService(apiFactory: feature.api),
            parser: LibraryParser())
        let viewModel = CreateObjectiveViewModel(
            useCases: .init(
            fetchNewObjectiveMetadataUseCase: FetchNewObjectiveMetadataUseCase(
                repository: repository),
            createObjectiveUseCase: CreateNewObjectiveUseCase(repository: repository)
        ),
            goal: route.goal,
            isPresented: route.isPresented)
        
        let view = CreateObjectiveView(viewModel: viewModel)
        return AnyView(view)
    }
}

import SwiftUI

import CoreNetworking

protocol LibraryAssembling {
    func assemble(using feature: LibraryFeature) -> AnyView
}

final class LibraryAssembler: LibraryAssembling {

    func assemble(using feature: LibraryFeature) -> AnyView {
        let parser = LibraryParser()
        
        let service = LibraryRemoteService(
            apiFactory: { ApiRequest(endpoint: $0) })
        let repository = LibraryRepository(
            remoteService: service,
            parser: parser)
        
        let viewModel = LibraryViewModel(
            useCases: .init(
                fetchStrandsUseCase: FetchStrandsUseCase(
                    repository: repository
                )
            )
        )
        let view = LibraryView<LibraryViewModel>(
            viewModel: viewModel,
            routingService: feature.routingService)
        
        return AnyView(view)
    }
}

import SwiftUI

import CoreNetworking

protocol LibraryAssembling {
    func assemble(using feature: LibraryFeature) -> AnyView
}

final class LibraryAssembler: LibraryAssembling {

    func assemble(using feature: LibraryFeature) -> AnyView {
        let parser = LibraryParser()
        
        let service = LibraryRemoteService(
            apiFactory: feature.api)
        let repository = LibraryRepository(
            remoteService: service,
            parser: parser)
        
        let viewModel = LibraryViewModel(
            useCases: .init(
                fetchStrandsUseCase: FetchStrandsUseCase(repository: repository),
                signoutUseCase: SignoutUseCase(
                    cache: feature.tokenCache,
                    notificationCenter: feature.notificationCenter)
            ),
            analyticsLogger: feature.analyticsLogger
        )
        
        let view = LibraryView<LibraryViewModel>(
            viewModel: viewModel,
            routingService: feature.routingService,
            notificationCenter: feature.notificationCenter)
        
        return AnyView(view)
    }
}

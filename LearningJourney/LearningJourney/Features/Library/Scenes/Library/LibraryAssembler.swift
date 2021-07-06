import SwiftUI

protocol LibraryAssembling {
    func assemble() -> AnyView
}

final class LibraryAssembler: LibraryAssembling {

    @Dependency var apiFactory: ApiFactory
    
    func assemble() -> AnyView {
        let parser = LibraryParser()
        let service = LibraryRemoteService(apiFactory: apiFactory)
        
        let repository = LibraryRepository(remoteService: service, parser: parser)
        
        let viewModel = LibraryViewModel(
            useCases: .init(
                fetchStrandsUseCase: FetchStrandsUseCase(
                    repository: repository
                )
        ))
        let view = LibraryView<LibraryViewModel, LibraryCoordinator>(viewModel: viewModel)
        
        return AnyView(view)
    }
}

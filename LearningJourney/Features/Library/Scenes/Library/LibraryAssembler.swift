import SwiftUI

protocol LibraryAssembling {
    func assemble() -> AnyView
}

final class LibraryAssembler: LibraryAssembling {

    func assemble() -> AnyView {
        let parser = LibraryParser()
        
        let service = LibraryRemoteService(
            apiFactory: { ApiRequest($0) })
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
        let view = LibraryView<LibraryViewModel, LibraryCoordinator>(viewModel: viewModel)
        
        return AnyView(view)
    }
}

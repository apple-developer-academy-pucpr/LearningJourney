import SwiftUI

protocol LibraryAssembling {
    func assemble() -> AnyView
}

final class LibraryAssembler<Coordinator>: LibraryAssembling where Coordinator: LibraryCoordinating {
    
    // MARK: - Dependencies
    
    private let coordinator: Coordinator
    
    // MARK: - Initialization
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
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
        let view = LibraryView(coordinator: coordinator, viewModel: viewModel)
        
        return AnyView(view)
    }
}

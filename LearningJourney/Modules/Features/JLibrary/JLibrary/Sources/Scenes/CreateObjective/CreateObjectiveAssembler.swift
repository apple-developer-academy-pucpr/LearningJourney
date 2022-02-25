import SwiftUI

import CoreNetworking

protocol CreateObjectiveAssembling {
    func assemble(using feature: LibraryFeature) -> AnyView
}

final class CreateObjectiveAssembler: CreateObjectiveAssembling {
    func assemble(using feature: LibraryFeature) -> AnyView {
        let viewModel = CreateObjectiveViewModel()
        let view = CreateObjectiveView(viewModel: viewModel)
        viewModel.service = LibraryRemoteService(apiFactory: feature.api)
        return AnyView(view)
    }
}

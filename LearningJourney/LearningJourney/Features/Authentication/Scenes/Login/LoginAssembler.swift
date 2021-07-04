import SwiftUI

protocol LoginAssembling {
    func assemble() -> AnyView
}

final class LoginAssembler: LoginAssembling {
    func assemble() -> AnyView {
        let viewModel = LoginViewModel()
        let view = LoginView(viewModel: viewModel)
        return AnyView(view)
    }
}

import SwiftUI

protocol LoginAssembling {
    func assemble() -> AnyView
}

final class LoginAssembler: LoginAssembling {
    func assemble() -> AnyView {
        let service = AuthenticationService(apiFactory: { ApiRequest($0) })
        let repository = AuthenticationRepository(
            parser: AuthenticationParser(),
            service: service
        )
        let viewModel = LoginViewModel(useCases: .init(
            signInWithAppleUseCase: SignInWithAppleUseCase(repository: repository)
        ))
        let view = LoginView(viewModel: viewModel)
        return AnyView(view)
    }
}

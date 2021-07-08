import SwiftUI

protocol LoginAssembling {
    func assemble() -> LoginView<LoginViewModel>
}

final class LoginAssembler: LoginAssembling {
    func assemble() -> LoginView<LoginViewModel> {
        let service = RemoteAuthenticationService(apiFactory: { ApiRequest($0) })
        let repository = AuthenticationRepository(
            parser: AuthenticationParser(),
            remoteService: service
        )
        let viewModel = LoginViewModel(useCases: .init(
            signInWithAppleUseCase: SignInWithAppleUseCase(repository: repository),
            validateTokenUseCase: ValidateTokenUseCase(tokenProvider: TokenManager.shared)
        ))
        return LoginView(viewModel: viewModel)
    }
}

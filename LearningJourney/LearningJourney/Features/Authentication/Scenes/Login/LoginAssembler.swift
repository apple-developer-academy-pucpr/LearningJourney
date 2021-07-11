import SwiftUI

protocol LoginAssembling {
    func assemble() -> LoginView<LoginViewModel>
}

final class LoginAssembler: LoginAssembling {
    
    @Dependency var apiFactory: ApiFactory
    
    func assemble() -> AnyView {
        let service = RemoteAuthenticationService(apiFactory: apiFactory)
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

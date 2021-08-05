import SwiftUI

import CoreAuthentication

protocol LoginAssembling {
    func assemble(using feature: AuthenticationFeature) -> LoginView<LoginViewModel>
}

final class LoginAssembler: LoginAssembling {
    func assemble(using feature: AuthenticationFeature) -> LoginView<LoginViewModel> {
        let service = RemoteAuthenticationService(apiFactory: feature.apiFactory)
        let repository = AuthenticationRepository(
            parser: AuthenticationParser(),
            remoteService: service
        )
        let viewModel = LoginViewModel(useCases: .init(
            signInWithAppleUseCase: SignInWithAppleUseCase(repository: repository),
            validateTokenUseCase: ValidateTokenUseCase(tokenProvider: TokenManager.shared) // TODO this should be injected!
        ))
        return LoginView(viewModel: viewModel)
    }
}

import SwiftUI

protocol LoginAssembling {
    func assemble() -> AnyView
}

final class LoginAssembler: LoginAssembling {
    func assemble() -> AnyView {
        let service = RemoteAuthenticationService(apiFactory: { ApiRequest($0) })
        let repository = AuthenticationProvider(
            parser: AuthenticationParser(),
            remoteService: service,
            cacheService: CacheAuthenticationService()
        )
        let viewModel = LoginViewModel(useCases: .init(
            signInWithAppleUseCase: SignInWithAppleUseCase(repository: repository)
        ))
        let view = LoginView(viewModel: viewModel)
        return AnyView(view)
    }
}

import SwiftUI

protocol LoginAssembling {
    func assemble() -> AnyView
}

final class LoginAssembler: LoginAssembling {
    
    @Dependency var apiFactory: ApiFactory
    
    func assemble() -> AnyView {
        let service = RemoteAuthenticationService(apiFactory: apiFactory)
        let repository = AuthenticationRepository(
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

#if DEBUG

import AuthenticationServices

final class LoginViewModelMock: LoginViewModeling {
    func handleRequest(request: ASAuthorizationAppleIDRequest) {}
    
    func handleCompletion(result: Result<ASAuthorization, Error>) {}
    
    func handleOnAppear() {}
    
    var isPresented: Bool = true
    
    var viewState: LoginViewState = .result
    
    
}

#endif


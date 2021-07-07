import SwiftUI

protocol LoginSheetPresentationViewModeling: ObservableObject {
    var isPresented: Bool { get set }
    func handleOnAppear()
}

final class LoginSheetPresentationViewModel: LoginSheetPresentationViewModeling {
    
    // MARK: - ViewModeling
    
    @Published var isPresented: Bool = false
    
    private let tokenProvider: TokenProviding
    
    init(tokenProvider: TokenProviding = TokenManager.shared) {
        self.tokenProvider = tokenProvider
    }
    
    func handleOnAppear() {
        switch tokenProvider.token {
        case .success:
            isPresented = false
        case .failure:
            isPresented = true
        }
    }
}

struct LoginSheetPresentationModifier<ViewModel>: ViewModifier where ViewModel: LoginSheetPresentationViewModeling {
    
    @StateObject var viewModel: ViewModel
    
    let loginAssembler: LoginAssembling
    
    func body(content: Content) -> some View {
        content
        .onAppear(perform: viewModel.handleOnAppear)
        .fullScreenCover(isPresented: $viewModel.isPresented) {
            loginAssembler.assemble()
        }
    }
}

public extension View {
    func authenticationSheet() -> some View {
        modifier(LoginSheetPresentationModifier(
                    viewModel: LoginSheetPresentationViewModel(),
                    loginAssembler: LoginAssembler()))
    }
}

import SwiftUI
import AuthenticationServices

struct LoginView<ViewModel>: View where ViewModel: LoginViewModeling {
    
    // MARK: - Dependencies
    
    @ObservedObject var viewModel: ViewModel
    
    @Environment (\.colorScheme)
    var colorScheme
    
    // MARK: - View
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                Text("Loading")
            case .error:
                Text("Error")
            case .result:
                contentView
            }
        }
    }
    
    // fazer a tela aqui
    
    private var contentView: some View {
        VStack{
            Image("loginScreenBanner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()

            VStack (alignment: .leading){
                Text("Your journey starts here")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                VStack (alignment: .leading){
                    FeatureRow(icon: "checkmark.circle", title: "Progress tracking", description: "See what you've already learned.")
                    FeatureRow(icon: "target", title: "Goal mapping", description: "Understand what you still need to work on.")
                }
                
                Spacer()
                SignInWithAppleButton(
                    .continue,
                    onRequest: viewModel.handleRequest,
                    onCompletion: viewModel.handleCompletion
                )
                .frame(height: 50)
                .cornerRadius(10)
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black )
               
            }
            .padding(30)
        }
        
        
       
    }
}

struct LoginPresentationModifier<ViewModel>: ViewModifier where ViewModel: LoginViewModeling {
    
    // MARK: - Dependencies
    
    @ObservedObject
    var viewModel: ViewModel
    
    let loginView: AnyView
    
    // MARK: - ViewModifier
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: viewModel.handleOnAppear)
            .fullScreenCover(isPresented: $viewModel.isPresented) {
                loginView
            }
    }
}

public extension View {
    func authenticationSheet() -> some View {
        let view = LoginAssembler().assemble()
        return modifier(LoginPresentationModifier(
                        viewModel: view.viewModel,
                        loginView: AnyView(view)))
    }
}

#if DEBUG
struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModelMock())
            .preferredColorScheme(.dark)
    }
}
#endif

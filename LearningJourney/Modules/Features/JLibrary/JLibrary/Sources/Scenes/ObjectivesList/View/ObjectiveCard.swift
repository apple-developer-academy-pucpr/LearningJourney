import SwiftUI
import UI

struct ObjectiveCard<ViewModel>: View where ViewModel: ObjectiveCardViewModelProtocol {
    
    @ObservedObject
    var viewModel: ViewModel
    
    var body: some View {
        GroupBox {
            Text(viewModel.objectiveDescription)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        } label: {
            HStack(alignment: .top) {
                VStack (alignment: .leading) {
                    Text(viewModel.objectiveCode)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                    Text(viewModel.objectiveType)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(Color("SecondaryText"))
                }
                Spacer()
                Button {
                    viewModel.handleLearnStatusToggled()
                } label: {
                    switch viewModel.buttonState {
                    case .loading, .empty:
                        LoadingView()
                    case .error:
                        LoadingView() // TODO
                    case let .result(state):
                        Label(state.name, systemImage: state.imageName)
                            .labelStyle(ObjectiveStatusLabelStyle())
                            .buttonStyle(state.learningStatusButtonStyle)
                        
                    }
                }
            }
        }.groupBoxStyle(ObjectiveGroupBoxStyle(isBookmarked: viewModel.isBookmarked))
            .onTapGesture {
                viewModel.handleWantToLearnToggled()
            }
    }
}

#if DEBUG

struct ObjectiveCard_Previews: PreviewProvider {
    static var previews: some View {
        Text("Demo")
    }
}

#endif

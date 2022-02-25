import SwiftUI
import UI

struct ObjectiveCard<ViewModel>: View where ViewModel: ObjectiveCardViewModelProtocol {
    
    @ObservedObject
    var viewModel: ViewModel
    
    var body: some View {
        GroupBox {
            VStack {
                Text(viewModel.objectiveDescription)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                if viewModel.canShowEditingBar {
                    EditObjectiveView(didDelete: {}, didFinishEditing: {}, didCancelEditing: {})
                }
            }
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
                button
            }
        }.groupBoxStyle(ObjectiveGroupBoxStyle(isBookmarked: viewModel.isBookmarked))
            .onTapGesture {
                viewModel.handleWantToLearnToggled()
            }
    }
    
    @ViewBuilder
    private var button: some View {
        Group {
            switch viewModel.buttonState {
            case .loading, .empty:
                LoadingView(style: .medium)
            case .error:
                LoadingView() // TODO
            case let .result(state):
                Button {
                    viewModel.handleLearnStatusToggled()
                } label: {
                    Label(state.name, systemImage: state.imageName)
                        .labelStyle(ObjectiveStatusLabelStyle())
                }
                .buttonStyle(state.learningStatusButtonStyle)
            }
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

import SwiftUI
import UI

struct ObjectiveCard<ViewModel>: View where ViewModel: ObjectiveCardViewModelProtocol {
    
    @ObservedObject
    var viewModel: ViewModel
    
    @FocusState
    var isEditingDescription: Bool
    
    var body: some View {
        if viewModel.isDeleted {
            Rectangle().frame(width: 0, height: 0)
        } else {
            contentView
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        GroupBox {
            VStack {
                descriptionView
                editingBar
            }
        } label: {
            HStack(alignment: .top) {
                VStack (alignment: .leading) {
                    Text(viewModel.objectiveCode)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                    Text(viewModel.objectiveType)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(UI.Assets.Colors.secondaryText.swiftUIColor)
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
    private var editingBar: some View {
        if viewModel.canShowEditingBar {
            EditObjectiveView(
                didStartEditing: {
                    isEditingDescription = true
                    viewModel.didStartEditing()
                },
                didDelete: {
                    isEditingDescription = false
                    viewModel.didConfirmDeletion()
                }, didFinishEditing: {
                    isEditingDescription = false
                    viewModel.didConfirmEditing()
                }, didCancelEditing: {
                    isEditingDescription = false
                    viewModel.didCancelEditing()
                },
                loadingState: $viewModel.buttonState
            )
        }
    }
    
    @ViewBuilder
    private var descriptionView: some View {
        ZStack {
            TextEditor(text: $viewModel.objectiveDescription)
                .opacity(viewModel.canEditDescription ? 1 : 0)
                .focused($isEditingDescription)
            Text(viewModel.objectiveDescription)
                .opacity(viewModel.canEditDescription ? 0 : 1)
                .fixedSize(horizontal: false, vertical: true)
        }
        .lineLimit(nil)
        .padding()
        .background(.clear)
    }
    
    @ViewBuilder
    private var button: some View {
        Group {
            switch viewModel.buttonState {
            case .loading, .empty:
                LoadingView(style: .medium)
            case .error:
                LoadingView()
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

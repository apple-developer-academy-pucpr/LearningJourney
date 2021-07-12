import SwiftUI
import UI

struct ObjectivesListView<ViewModel, Coordinator>: View where
    ViewModel: ObjectivesListViewModelProtocol, Coordinator: LibraryCoordinating {

    // MARK: - Environment
    
    @EnvironmentObject var coordinator: Coordinator
    
    // MARK: - Dependencies
    
    @ObservedObject var viewModel: ViewModel
    
    // MARK: - View
    
    var body: some View {
        contentView
            .navigationTitle(viewModel.goalName)
            .onAppear(perform: viewModel.handleOnAppear)
    }
    
    private var contentView: some View {
        Group {
            switch viewModel.objectives {
            case .loading:
                Text("Loading")
            case let .error(error):
                errorView(for: error)
            case let .result(objectives):
                resultView(objectives)
            }
        }
        .padding()
    }
    
    private func resultView(_ objectives: [LibraryViewModelState<LearningObjective>]) -> some View {
        ScrollView {
            VStack {
                ForEach(objectives) { objective in
                    ObjectiveCard(
                        objective: objective) {
                        viewModel.handleDidLearnToggled(objective: objective)
                    }
                }
            }
        }
    }
}

#if DEBUG

struct ObjectivesListView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectivesListView<ObjectivesListViewModelMock, LibraryCoordinator>(viewModel: ObjectivesListViewModelMock())
    }
}

#endif

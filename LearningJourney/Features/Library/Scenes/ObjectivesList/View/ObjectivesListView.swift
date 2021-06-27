import SwiftUI

struct ObjectivesListView<ViewModel, Coordinator>: View where
    ViewModel: ObjectivesListViewModelProtocol, Coordinator: LibraryCoordinating {

    // MARK: - Environment
    
    @EnvironmentObject var coordinator: Coordinator
    
    // MARK: - Dependencies
    
    @ObservedObject var viewModel: ViewModel
    
    // MARK: - View
    
    var body: some View {
        Text("Salve")
        .navigationTitle(viewModel.goalName)
        .onAppear(perform: viewModel.handleOnAppear)
    }
}

import SwiftUI

struct ObjectivesListView<ViewModel>: View where ViewModel: ObjectivesListViewModelProtocol {

    // MARK: - Dependencies
    
    @ObservedObject var viewModel: ViewModel
    
    // MARK: - View
    
    var body: some View {
        Group {
            Text("Salve")
        }
        .onAppear(perform: viewModel.handleOnAppear)
        .navigationTitle(viewModel.goalName)
    }
}

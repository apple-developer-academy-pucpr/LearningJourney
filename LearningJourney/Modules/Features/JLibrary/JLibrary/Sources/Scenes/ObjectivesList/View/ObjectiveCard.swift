import SwiftUI
import UI

struct ObjectiveCard: View {
    
    let objective: LibraryViewModelState<LearningObjective>
    let buttonAction: () -> Void
    
    var body: some View {
        resultView
        .padding()
        .background(Color ("CardBackground"))
        .cornerRadius(14)
    }
    
    private var resultView: some View {
        Group {
            switch objective {
            case .loading, .empty:
                LoadingView()
            case .error:
                Text("Error")
            case let .result(objective):
                contentView(learningObjective: objective)
            }
        }
    }
    
    private func contentView(learningObjective objective: LearningObjective) -> some View {
        GroupBox {
            Text(objective.description)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        } label: {
            HStack(alignment: .top) {
                VStack (alignment: .leading) {
                    Text(objective.code)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                    Text(objective.type == .core ? "Core" : "Elective")
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(Color("SecondaryText"))
                }
                Spacer()
                Button(objective.status.rawValue.capitalized) {
                    buttonAction()
                }
                .buttonStyle(LearningStatusButtonStyle(status: objective.status))
            }
        }.groupBoxStyle(PlainGroupBoxStyle())
    }
}

struct PlainGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
    }
}

#if DEBUG

struct ObjectiveCard_Previews: PreviewProvider {
    static var previews: some View {
        ObjectiveCard(
            objective: .result(.fixture()),
            buttonAction: {})
        
            ObjectiveCard(
                objective: .result(.fixture()),
                buttonAction: {})
            .previewDevice("iPad Pro (12.9-inch) (2nd generation)")
    }
}

#endif

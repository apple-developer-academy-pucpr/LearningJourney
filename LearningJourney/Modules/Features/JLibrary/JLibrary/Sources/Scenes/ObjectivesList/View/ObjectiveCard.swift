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
                Button {
                    buttonAction()
                } label: {
                    Label(buttonName(for: objective.status), systemImage: imageName(for: objective.status))
                        .labelStyle(ObjectiveStatusLabelStyle())
                }
                .buttonStyle(LearningStatusButtonStyle(status: objective.status))
            }
        }.groupBoxStyle(PlainGroupBoxStyle())
    }
    
    
    private func imageName(for status: LearningObjectiveStatus) -> String {
        switch status {
        case .untutored:
            return "circle"
        case .learning:
            return "circle.lefthalf.filled"
        case .learned:
            return "circle.fill"
        case .mastered:
            return "diamond.fill"
        }
    }
    
    private func buttonName(for status: LearningObjectiveStatus) -> String {
        switch status {
        case .untutored:
            return "Não sei"
        case .learning:
            return "Aprendendo"
        case .learned:
            return "Aprendi"
        case .mastered:
            return "Sei ensinar"
        }
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

struct ObjectiveStatusLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.icon
                .font(.system(size: 8))
            configuration.title
                .font(.system(size: 14, weight: .regular))
        }
        .frame(width: 136, height: 28)
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

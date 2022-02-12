import SwiftUI
import UI

struct ObjectiveCard: View {
    
    let objective: LibraryViewModelState<LearningObjective>
    let buttonAction: () -> Void
    let tapAction: () -> Void
    
    var body: some View {
        resultView
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
                    .onTapGesture {
                        tapAction()
                    }
                    .padding()
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
                    Label(buttonName(for: objective.status, isBookmarked: objective.isBookmarked),
                          systemImage: imageName(for: objective.status, isBookmarked: objective.isBookmarked))
                        .labelStyle(ObjectiveStatusLabelStyle())
                }
                .buttonStyle(LearningStatusButtonStyle(
                    status: objective.status,
                    isBookmarked: objective.isBookmarked))
            }
        }.groupBoxStyle(ObjectiveGroupBoxStyle(isBookmarked: objective.isBookmarked))
    }
    
    
    private func imageName(for status: LearningObjectiveStatus, isBookmarked: Bool) -> String {
        switch status {
        case .untutored where isBookmarked:
            return "circle"
        case .untutored:
            return ""
        case .learning:
            return "circle.lefthalf.filled"
        case .learned:
            return "circle.fill"
        case .mastered:
            return "diamond.fill"
        }
    }
    
    private func buttonName(for status: LearningObjectiveStatus, isBookmarked: Bool) -> String {
        switch status {
        case .untutored where isBookmarked:
            return "Quero Aprender"
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

struct ObjectiveGroupBoxStyle: GroupBoxStyle {
    let isBookmarked: Bool
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .background(.clear)
            configuration.content
                .background(.clear)
        }
        .padding()
        .background(isBookmarked ? Color(hex: "#F2F2F7") : .clear)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "#F2F2F7"), lineWidth: 2)
        )
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
            buttonAction: {},
            tapAction: {})
        
            ObjectiveCard(
                objective: .result(.fixture()),
                buttonAction: {},
                tapAction: {})
            .previewDevice("iPad Pro (12.9-inch) (2nd generation)")
    }
}

#endif

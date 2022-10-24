import SwiftUI

struct LearningStatusButtonStyle: ButtonStyle, Equatable {
    let status: LearningObjectiveStatus
    let isBookmarked: Bool
    func makeBody(configuration: Configuration) -> some View {
        Group {
            switch status {
            case .untutored where isBookmarked:
                configuration.label
                    .background(.orange)
            case .untutored:
                configuration.label
                    .foregroundColor(.white)
                    .background(Color(hex: "#BBBBCD"))
            case .learning:
                configuration.label
                    .foregroundColor(.white)
                    .background(.blue)
            case .learned:
                configuration.label
                    .foregroundColor(.white)
                    .background(.pink)
            case .mastered:
                configuration.label
                    .foregroundColor(.white)
                    .background(.purple)
            }
        }
        .foregroundColor(.white)
        .cornerRadius(5)
    }
}

struct ObjectiveGroupBoxStyle: GroupBoxStyle {
    let isBookmarked: Bool
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .background(.clear)
                .padding()
            configuration.content
                .background(.clear)
        }
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

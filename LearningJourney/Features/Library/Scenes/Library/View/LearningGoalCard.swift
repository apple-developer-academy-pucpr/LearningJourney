import SwiftUI

struct LearningGoalCard: View {
    
    private enum Layout {
        static let backgroundColor = Color("CardBackground") // TODO swiftgen
    }
    
    let goal: LearningGoal
    
    var body: some View {
        VStack {
            progressChart
            Text(goal.name)
                .fontWeight(.semibold)
                .font(.system(size: 19))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .layoutPriority(1000)
                .padding(.top)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(Layout.backgroundColor)
        .cornerRadius(14)
        .aspectRatio(1, contentMode: .fill)
    }
    
    private var progressChart: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.4)
                .foregroundColor(.white)
            
            Circle()
                .trim(from: 0, to: CGFloat(goal.progress))
                .stroke(style: .init(
                    lineWidth: 8,
                    lineCap: .round,
                    lineJoin: .round
                ))
                .rotation(
                    Angle(radians: 3 * .pi / 2))
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "A259FF"),
                        Color(hex: "09F9BF")]),
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading
                ))
            Group {
                Text("\(Int(goal.progress * 100))")
                    .bold()
                    .font(.system(size: 18)) +
                Text("%")
                    .bold()
                    .font(.system(size: 10))
            }
            .padding(24)
        }
    }
    
    private var formattedProgress: String {
        let percentage = Int(goal.progress * 100)
        return String("\(percentage)%")
    }
}


struct LearningGoalCard_Previews: PreviewProvider {
    static var previews: some View {
        LearningGoalCard(goal: .init(
            name: "Logic and Programming",
            progress: 0.5
        ))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

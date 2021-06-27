import SwiftUI

struct LearningStrandRow: View {
    
    let strand: LearningStrand
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(strand.name)
                .font(.headline)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(strand.goals) { goal in
                        LearningGoalCard(goal: goal)
                    }
                }
            }
        }
    }
}


struct LearningStrandRow_Previews: PreviewProvider {
    static var previews: some View {
        LearningStrandRow(strand: .init(
            name: "Technical",
            goals: [
                .init(
                    name: "App Programming",
                    progress: 0.1),
                
                    .init(
                        name: "App Programming",
                        progress: 0.5),
                
                    .init(
                        name: "App Programming",
                        progress: 0.75),
            ]
        ))
    }
}

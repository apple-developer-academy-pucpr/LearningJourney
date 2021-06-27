import SwiftUI

struct LearningStrandRow<Coordinator>: View where Coordinator: LibraryCoordinating {
    
    @EnvironmentObject var coordinator: Coordinator
    let strand: LearningStrand
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(strand.name)
                .font(.headline)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(strand.goals) { goal in
                        NavigationLink(
                            destination: coordinator.objectivesView(goal: goal)
                        ) {
                            LearningGoalCard(goal: goal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}


struct LearningStrandRow_Previews: PreviewProvider {
    static var previews: some View {
        LearningStrandRow<LibraryCoordinator>(strand: .init(
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

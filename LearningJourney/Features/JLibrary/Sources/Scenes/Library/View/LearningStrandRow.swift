import SwiftUI

import CoreInjector

struct LearningStrandRow: View {
    
    let service: RoutingService
    
    let strand: LearningStrand
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(strand.name)
                .font(.headline)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(strand.goals) { goal in
                        service.link(for: ObjectivesRoute(
                                        
                                        goal: goal)) {
                            LearningGoalCard(goal: goal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

#if DEBUG

struct LearningStrandRow_Previews: PreviewProvider {
    static var previews: some View {
        LearningStrandRow(service: DummyRoutingService(), strand: .init(
            id: 1,
            name: "Technical",
            goals: [
                .init(
                    id: 1,
                    name: "App Programming",
                    progress: 0.1),
                
                    .init(
                        id:1,
                        name: "App Programming",
                        progress: 0.5),
                
                    .init(
                        id:1,
                        name: "App Programming",
                        progress: 0.75),
            ]
        ))
    }
}

#endif

import SwiftUI

import CoreInjector

struct LearningStrandRow: View {
    
    let service: RoutingService
    
    let strand: LearningStrand
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(strand.name)
                .font(.system(size: 19))
                .bold()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(strand.goals) { goal in
                        service.link(for: ObjectivesRoute(goal: goal)) {
                            LearningGoalCard(goal: goal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.trailing)
            }
        }
    }
}

#if DEBUG

struct LearningStrandRow_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView_Previews.contentPreview
        
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

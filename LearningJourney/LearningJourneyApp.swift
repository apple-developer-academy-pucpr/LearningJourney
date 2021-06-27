//
//  LearningJourneyApp.swift
//  LearningJourney
//
//  Created by Bruno Pastre on 23/06/21.
//

import SwiftUI

@main
struct LearningJourneyApp: App {
    let persistenceController = PersistenceController.shared

    let feature = LibraryFeature<LibraryCoordinator>()
    var body: some Scene {
        WindowGroup {
            feature.resolve()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

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

    let feature = AuthenticationFeature<AuthenticationCoordinator>()
    var body: some Scene {
        WindowGroup {
            feature.resolve()
        }
    }
}

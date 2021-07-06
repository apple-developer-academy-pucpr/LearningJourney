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

    let libraryFeature = LibraryFeature<LibraryCoordinator>()
    
    private let appContainer = DefaultDependencyContainer()
    
    
    init() {
        appContainer.register(factory: { ApiFactory() }, for: ApiFactoryProtocol.self)
    }
    
    var body: some Scene {
        WindowGroup {
            libraryFeature.resolve()
                .authenticateIfNeeded()
        }
    }
}

extension View {
    func authenticateIfNeeded() -> some View {
        AuthenticationFeature<AuthenticationCoordinator>()
                .resolve()
    }
}

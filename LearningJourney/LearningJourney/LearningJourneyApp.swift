//
//  LearningJourneyApp.swift
//  LearningJourney
//
//  Created by Bruno Pastre on 23/06/21.
//

import SwiftUI

@main
struct LearningJourneyApp: App {
    
    init() {
        #if DEBUG
        TokenCacheService().clear()
        #endif
    }
    
    let libraryFeature = LibraryFeature<LibraryCoordinator>()
    
    var body: some Scene {
        WindowGroup {
            libraryFeature.resolve()
                .authenticationSheet(assembler: LoginAssembler()) // TODO handle this gracefully
        }
    }
}

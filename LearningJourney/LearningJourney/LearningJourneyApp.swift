//
//  LearningJourneyApp.swift
//  LearningJourney
//
//  Created by Bruno Pastre on 23/06/21.
//

import SwiftUI

import CoreAuthentication
import CoreEnvironment

@main
struct LearningJourneyApp: App {
    
    init() {
        print(DefaultEnvironment.baseUrl)
    }
    
    let libraryFeature = LibraryFeature<LibraryCoordinator>()
    
    var body: some Scene {
        WindowGroup {
            libraryFeature.resolve()
                .authenticationSheet(assembler: LoginAssembler()) // TODO handle this gracefully
        }
    }
}

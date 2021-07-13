import SwiftUI

import CoreAuthentication
import CoreEnvironment
import JAuthentication
import JLibrary

@main
struct LearningJourneyApp: App {
    
    init() {
        print(DefaultEnvironment.baseUrl)
    }
    
    var body: some Scene {
        WindowGroup {
            LibraryFeatureFactory.make()
                .authenticationSheet()
        }
    }
}

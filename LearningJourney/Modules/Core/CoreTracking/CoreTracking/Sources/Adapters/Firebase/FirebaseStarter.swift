import Foundation
import Firebase

public enum FirebaseStarter: AnalyticsStarter {
    public static func start() {
        guard let file = Bundle.module.url(
            forResource: "GoogleService-Info",
            withExtension: "plist"
        ),
              let data = try? Data(contentsOf: file),
              let options = try? PropertyListDecoder().decode(GoogleServiceOptions.self, from: data)
        else { return }
        let config = FirebaseOptions(googleServiceOptions: options)
        FirebaseApp.configure(options: config)
    }
}


private extension FirebaseOptions {
    convenience init(googleServiceOptions: GoogleServiceOptions) {
        self.init(googleAppID: googleServiceOptions.googleAppID,
                  gcmSenderID: googleServiceOptions.gcmSenderID)
        
        self.clientID = googleServiceOptions.clientID
        self.apiKey = googleServiceOptions.apiKey
        self.gcmSenderID = googleServiceOptions.gcmSenderID
        self.bundleID = googleServiceOptions.bundleID
        self.projectID = googleServiceOptions.projectID
        self.storageBucket = googleServiceOptions.storageBucket
        self.googleAppID = googleServiceOptions.googleAppID
    }
}

private struct GoogleServiceOptions: Decodable {
    let clientID: String
    let apiKey: String
    let gcmSenderID: String
    let bundleID: String
    let projectID: String
    let storageBucket: String
    let isAdsEnabled: Bool
    let isAnalyticsEnabled: Bool
    let isAppInviteEnabled: Bool
    let isGcmEnabled: Bool
    let isSignInEnabled: Bool
    let googleAppID: String
    
    private enum CodingKeys: String, CodingKey {
        case clientID = "CLIENT_ID"
        case apiKey = "API_KEY"
        case gcmSenderID = "GCM_SENDER_ID"
        case bundleID = "BUNDLE_ID"
        case projectID = "PROJECT_ID"
        case storageBucket = "STORAGE_BUCKET"
        case isAdsEnabled = "IS_ADS_ENABLED"
        case isAnalyticsEnabled = "IS_ANALYTICS_ENABLED"
        case isAppInviteEnabled = "IS_APPINVITE_ENABLED"
        case isGcmEnabled = "IS_GCM_ENABLED"
        case isSignInEnabled = "IS_SIGNIN_ENABLED"
        case googleAppID = "GOOGLE_APP_ID"
    }
}

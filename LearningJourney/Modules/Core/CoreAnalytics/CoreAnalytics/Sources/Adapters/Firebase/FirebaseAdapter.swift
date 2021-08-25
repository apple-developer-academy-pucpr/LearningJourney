import FirebaseAnalytics
import Firebase

protocol FirebaseLogging {
    static func logEvent(_ name: String, parameters: [String : Any]?)
}

extension Analytics: FirebaseLogging {}

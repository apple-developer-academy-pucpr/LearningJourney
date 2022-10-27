import Foundation

// TODO repeat this pattern for all modules, since all of them will need to access resources at some point
extension Bundle {
    static var module: Bundle {
        let moduleBundleUrl = Bundle.main.bundleURL
            .appendingPathComponent("Frameworks")
            .appendingPathComponent(Environment.resourcesBundleName + ".framework")
        return Bundle(url: moduleBundleUrl) ?? .main
    }
}

private enum Environment {
    static let resourcesBundleName = "CoreTracking"
}

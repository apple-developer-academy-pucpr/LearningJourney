cd "$(git rev-parse --show-toplevel)"
make generate
xcodebuild clean build test -project LearningJourney/App/LearningJourney.xcodeproj -scheme "LearningJourney - Release" -sdk iphonesimulator -destination "platform=iOS Simulator,OS=14.2,name=iPhone 8" CODE_SIGNING_REQUIRED=NO
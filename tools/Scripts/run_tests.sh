cd "$(git rev-parse --show-toplevel)"
make generate
xcodebuild clean build test -project LearningJourney/App/LearningJourney.xcodeproj -scheme "LearningJourney - Debug" -sdk iphonesimulator -destination "platform=iOS Simulator,OS=14.5,name=iPhone 8" CODE_SIGNING_REQUIRED=NO
cd "$(git rev-parse --show-toplevel)"
make clean generate # TODO this sjhould be another CI step
xcodebuild clean build test -workspace LearningJourney/LearningJourney.xcworkspace -scheme "LearningJourney - Debug" -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 8" CODE_SIGNING_REQUIRED=NO
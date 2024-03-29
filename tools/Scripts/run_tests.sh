cd "$(git rev-parse --show-toplevel)"

xcodebuild clean build test \
    -project LearningJourney/App/LearningJourney.xcodeproj \
    -scheme "LearningJourney - Debug" \
    -sdk iphonesimulator \
    -destination "platform=iOS Simulator,name=iPhone SE (3rd generation)" \
    CODE_SIGNING_REQUIRED=NO | xcpretty && exit ${PIPESTATUS[0]}

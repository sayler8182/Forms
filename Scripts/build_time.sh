xcodebuild \
    -workspace "../Forms.xcworkspace" \
    -scheme "Forms-Universal-Framework" \
    -destination generic/platform=iOS \
    -destination "platform=iOS Simulator,name=iPhone 11,OS=latest" \
    SYMROOT=$(PWD)/build/ \
    clean \
    build \
    OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies" | grep .[0-9]ms | grep -v ^0.[0-9]ms | sort -nr > build_result.txt
rm -rf build
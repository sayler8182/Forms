BUILD_DIR="build"
OUTPUT="${BUILD_DIR}/Debug-Universal"
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
rm -rf "${OUTPUT}"
mkdir -p "${OUTPUT}"

# clear cache
~/Library/Developer/Xcode/DerivedData
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}" 
rm -rf "${OUTPUT}"
mkdir -p "${OUTPUT}" 

# build
xcodebuild \
    -quiet \
    -workspace "Forms.xcworkspace" \
    -scheme "Forms-Universal-Framework" \
    -destination generic/platform=iOS \
    -destination "platform=iOS Simulator,name=iPhone 11,OS=latest" \
    SYMROOT=$(PWD)/build/

# define frameworks
frameworks=(
    Forms
    FormsAnalytics 
    FormsAnchor
    FormsAppStoreReview
    FormsCardKit
    FormsDeveloperTools
    FormsHomeShortcuts
    FormsImagePickerKit
    FormsInjector
    FormsLocation
    FormsLogger
    FormsMock
    FormsNetworking
    FormsNotifications
    FormsPermissions
    FormsPagerKit
    FormsSideMenuKit
    FormsSocialKit
    FormsTabBarKit
    FormsToastKit
    FormsTransitions
    FormsUtils
    FormsValidators
) 

# merge architectures
for framework in "${frameworks[@]}"
do 
    cp -R "${BUILD_DIR}/Debug-iphoneos/${framework}.framework" "${OUTPUT}/"
    lipo -create -output "${OUTPUT}/${framework}.framework/${framework}" "${BUILD_DIR}/Debug-iphoneos/${framework}.framework/${framework}" "${BUILD_DIR}/Debug-iphonesimulator/${framework}.framework/${framework}"
    cp -r "${BUILD_DIR}/Debug-iphonesimulator/${framework}.framework/Modules/${framework}.swiftmodule/" "${OUTPUT}/${framework}.framework/Modules/${framework}.swiftmodule"
done

open "${OUTPUT}"

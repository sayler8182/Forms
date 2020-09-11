FRAMEWORK=$1;
BUILD_DIR="build"
OUTPUT="${BUILD_DIR}/Debug-Universal" 

# build
if [ -z "$FRAMEWORK" ]
then
    # clear cache for full build
    rm -rf ~/Library/Developer/Xcode/DerivedData
    rm -rf "${BUILD_DIR}"
    mkdir -p "${BUILD_DIR}" 
    mkdir -p "${BUILD_DIR}/Debug-Universal" 
    rm -rf "${OUTPUT}"
    mkdir -p "${OUTPUT}" 
    xcodebuild \
        -quiet \
        -workspace "Forms.xcworkspace" \
        -scheme "Forms-Universal-Framework" \
        -destination generic/platform=iOS \
        -destination "platform=iOS Simulator,name=iPhone 11,OS=latest" \
        -showBuildTimingSummary \
        SYMROOT=$(PWD)/build/
else
    mkdir -p "${BUILD_DIR}"
    mkdir -p "${BUILD_DIR}/Debug-Universal"
    mkdir -p "${OUTPUT}"
    xcodebuild \
        -quiet \
        -workspace "Forms.xcworkspace" \
        -scheme "$FRAMEWORK" \
        -destination generic/platform=iOS \
        -destination "platform=iOS Simulator,name=iPhone 11,OS=latest" \
        -showBuildTimingSummary \
        SYMROOT=$(PWD)/build/
fi

# define frameworks
frameworks=(
    Forms
    FormsAnalytics 
    FormsAnchor
    FormsAppStoreReview
    FormsCalendarKit
    FormsCardKit
    FormsDatabase
    FormsDatabaseSQLite
    FormsDeveloperTools
    FormsDevice
    FormsHomeShortcuts
    FormsImagePickerKit
    FormsInjector
    FormsLocation
    FormsLogger
    FormsMock
    FormsNetworking
    FormsNetworkingImage
    FormsNotifications
    FormsPermissions
    FormsPagerKit
    FormsSideMenuKit
    FormsSocialKit
    FormsTabBarKit
    FormsToastKit
    FormsTodayExtensionKit
    FormsTransitions
    FormsUpdates
    FormsUtils
    FormsUtilsUI
    FormsValidators
) 

# merge architectures
for framework in "${frameworks[@]}"
do 
    if [ -z "$FRAMEWORK" ] || [ $framework = $FRAMEWORK ]
    then
        cp -R "${BUILD_DIR}/Debug-iphoneos/${framework}.framework" "${OUTPUT}/"
        lipo -create -output "${OUTPUT}/${framework}.framework/${framework}" "${BUILD_DIR}/Debug-iphoneos/${framework}.framework/${framework}" "${BUILD_DIR}/Debug-iphonesimulator/${framework}.framework/${framework}"
        cp -r "${BUILD_DIR}/Debug-iphonesimulator/${framework}.framework/Modules/${framework}.swiftmodule/" "${OUTPUT}/${framework}.framework/Modules/${framework}.swiftmodule"
    fi
done

open "${OUTPUT}"

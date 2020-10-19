FRAMEWORK=$1
BUILD_DIR="."
OUTPUT="${BUILD_DIR}/Debug-Universal" 

rm -rf "${OUTPUT}"
mkdir -p "${OUTPUT}" 

lipo -remove arm64 "${BUILD_DIR}/Debug-iphonesimulator/${FRAMEWORK}.framework/${FRAMEWORK}" -o "${BUILD_DIR}/Debug-iphonesimulator/${FRAMEWORK}.framework/${FRAMEWORK}"
cp -R "${BUILD_DIR}/Debug-iphoneos/${FRAMEWORK}.framework" "${OUTPUT}/"
lipo -create -output "${OUTPUT}/${FRAMEWORK}.framework/${FRAMEWORK}" "${BUILD_DIR}/Debug-iphoneos/${FRAMEWORK}.framework/${FRAMEWORK}" "${BUILD_DIR}/Debug-iphonesimulator/${FRAMEWORK}.framework/${FRAMEWORK}"
cp -r "${BUILD_DIR}/Debug-iphonesimulator/${FRAMEWORK}.framework/Modules/${FRAMEWORK}.swiftmodule/" "${OUTPUT}/${FRAMEWORK}.framework/Modules/${FRAMEWORK}.swiftmodule"

open "${OUTPUT}"

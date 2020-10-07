FRAMEWORK=$1
BUILD_DIR="."
OUTPUT="${BUILD_DIR}/Debug-Universal" 
framework=$FRAMEWORK

rm -rf "${OUTPUT}"
mkdir -p "${OUTPUT}" 

cp -R "${BUILD_DIR}/Debug-iphoneos/${framework}.framework" "${OUTPUT}/"
lipo -create -output "${OUTPUT}/${framework}.framework/${framework}" "${BUILD_DIR}/Debug-iphoneos/${framework}.framework/${framework}" "${BUILD_DIR}/Debug-iphonesimulator/${framework}.framework/${framework}"
cp -r "${BUILD_DIR}/Debug-iphonesimulator/${framework}.framework/Modules/${framework}.swiftmodule/" "${OUTPUT}/${framework}.framework/Modules/${framework}.swiftmodule"
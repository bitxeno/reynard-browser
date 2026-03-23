#!/bin/sh

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ROOT_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
PROJECT_PATH="$ROOT_DIR/browser/Reynard.xcodeproj"
XCCONFIG_PATH="$ROOT_DIR/browser/Configuration/Reynard.xcconfig"

cd "$ROOT_DIR"

"$ROOT_DIR/tools/development/build-gecko.sh"

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

TODAY=$(date +%Y%b%d | tr '[:lower:]' '[:upper:]')
cp "$XCCONFIG_PATH" "$DIST_DIR/Reynard.xcconfig"
sed -i '' "s/CURRENT_BUILD = .*/CURRENT_BUILD = $TODAY/" "$DIST_DIR/Reynard.xcconfig"

xcodebuild clean -scheme "Reynard" -project "$PROJECT_PATH" -sdk appletvos -arch arm64 -configuration Release \
	CODE_SIGNING_ALLOWED=NO \
	CODE_SIGNING_REQUIRED=NO \
	CODE_SIGN_ENTITLEMENTS="" \
	CODE_SIGNING_IDENTITY="" \
	AD_HOC_CODE_SIGNING_ALLOWED=YES

xcodebuild archive -scheme "Reynard" -archivePath "$DIST_DIR/Reynard.xcarchive" -project "$PROJECT_PATH" -sdk appletvos -arch arm64 -configuration Release -xcconfig "$DIST_DIR/Reynard.xcconfig" \
	CODE_SIGNING_ALLOWED=NO \
	CODE_SIGNING_REQUIRED=NO \
	CODE_SIGN_ENTITLEMENTS="" \
	CODE_SIGNING_IDENTITY="" \
	AD_HOC_CODE_SIGNING_ALLOWED=YES

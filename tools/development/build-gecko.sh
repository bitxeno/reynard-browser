#!/bin/sh

set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ROOT_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)"
FIREFOX_DIR="$ROOT_DIR/engine/firefox"

# Build target: default to simulator, pass "device" for iOS device,
# "tvos" for Apple TV device, or "tvos-simulator" for Apple TV simulator.
BUILD_FOR="${1:-simulator}"

case "$BUILD_FOR" in
	device)
		TARGET="aarch64-apple-ios"
		;;
	simulator)
		HOST_ARCH="$(uname -m)"
		if [ "$HOST_ARCH" = "arm64" ]; then
			TARGET="aarch64-apple-ios-sim"
		else
			TARGET="x86_64-apple-ios"
		fi
		;;
	tvos)
		TARGET="aarch64-apple-tvos"
		;;
	tvos-simulator|tvos_simulator|tvos-sim)
		HOST_ARCH="$(uname -m)"
		if [ "$HOST_ARCH" != "arm64" ]; then
			echo "tvOS simulator builds require Apple Silicon on this setup." >&2
			exit 1
		fi
		TARGET="aarch64-apple-tvos-sim"
		;;
	*)
		echo "Usage: $0 [device|simulator|tvos|tvos-simulator]" >&2
		exit 1
		;;
esac

cd "$ROOT_DIR"

if [ ! -d "$FIREFOX_DIR" ]; then
	echo "Missing firefox source at $FIREFOX_DIR"
	echo "Add the submodule, then run tools/development/update-gecko.sh."
	exit 1
fi

rm -f "$FIREFOX_DIR/.mozconfig"

{
	echo "ac_add_options --enable-application=mobile/ios"
	echo "ac_add_options --target=$TARGET"
	echo "ac_add_options --enable-ios-target=14.0"
	echo "ac_add_options --enable-optimize"
	echo "ac_add_options --disable-debug"
	echo "ac_add_options --disable-tests"
} > "$FIREFOX_DIR/.mozconfig"

if ! rustup target list | grep -q "^$TARGET (installed)"; then
	rustup target add "$TARGET"
fi

cd "$FIREFOX_DIR"
./mach build

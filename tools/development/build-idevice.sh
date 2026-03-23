#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

SUBMODULE_PATH="$REPO_ROOT/support/idevice"
FFI_DIR="$SUBMODULE_PATH/ffi"
OUTPUT_LIB="$REPO_ROOT/browser/Reynard/JIT/libidevice_ffi.a"

TARGET_DIR="$SUBMODULE_PATH/target"
DEPLOYMENT_TARGET="14.0"

if [ ! -e "$SUBMODULE_PATH/.git" ]; then
  git -C "$REPO_ROOT" submodule update --init --recursive support/idevice
fi

# Build mode: pass "device" to build iOS device, "simulator" for iOS simulator,
# "tvos" for Apple TV device, or "tvos-simulator" for Apple TV simulator.
BUILD_FOR="${1:-simulator}"
echo "Building for $BUILD_FOR..."
case "$BUILD_FOR" in
  device)
    RUST_TARGET="aarch64-apple-ios"
    DEPLOYMENT_FLAG="-miphoneos-version-min=${DEPLOYMENT_TARGET}"
    DEPLOYMENT_ENV_VAR="IPHONEOS_DEPLOYMENT_TARGET"
    ;;
  simulator)
    # Simulator targets: choose based on host arch for Apple Silicon vs Intel.
    HOST_ARCH="$(uname -m)"
    if [ "$HOST_ARCH" = "arm64" ]; then
      RUST_TARGET="aarch64-apple-ios-sim"
    else
      RUST_TARGET="x86_64-apple-ios"
    fi
    DEPLOYMENT_FLAG="-mios-simulator-version-min=${DEPLOYMENT_TARGET}"
    DEPLOYMENT_ENV_VAR="IPHONEOS_DEPLOYMENT_TARGET"
    ;;
  tvos)
    RUST_TARGET="aarch64-apple-tvos"
    DEPLOYMENT_FLAG="-mtvos-version-min=${DEPLOYMENT_TARGET}"
    DEPLOYMENT_ENV_VAR="TVOS_DEPLOYMENT_TARGET"
    ;;
  tvos-simulator|tvos_simulator|tvos-sim)
    HOST_ARCH="$(uname -m)"
    if [ "$HOST_ARCH" != "arm64" ]; then
      echo "tvOS simulator builds require Apple Silicon on this setup." >&2
      exit 1
    fi
    RUST_TARGET="aarch64-apple-tvos-sim"
    DEPLOYMENT_FLAG="-mtvos-simulator-version-min=${DEPLOYMENT_TARGET}"
    DEPLOYMENT_ENV_VAR="TVOS_DEPLOYMENT_TARGET"
    ;;
  *)
    echo "Usage: $0 [device|simulator|tvos|tvos-simulator]" >&2
    exit 1
    ;;
esac

if ! rustup target list | grep -q "^$RUST_TARGET (installed)"; then
  rustup target add "$RUST_TARGET"
fi

# Export simulator/device deployment target appropriately
export "$DEPLOYMENT_ENV_VAR=$DEPLOYMENT_TARGET"
if [ -n "${RUSTFLAGS:-}" ]; then
  export RUSTFLAGS="${RUSTFLAGS} -C link-arg=${DEPLOYMENT_FLAG}"
else
  export RUSTFLAGS="-C link-arg=${DEPLOYMENT_FLAG}"
fi
export TARGET_DIR

mkdir -p "$(dirname "$OUTPUT_LIB")"
cd "$FFI_DIR"
cargo build --release --target "$RUST_TARGET" --no-default-features --features full,ring
cp "$TARGET_DIR/$RUST_TARGET/release/libidevice_ffi.a" "$OUTPUT_LIB"

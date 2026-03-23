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

# Build mode: pass "device" to build for device, otherwise defaults to simulator
BUILD_FOR="${1:-simulator}"

if [ "$BUILD_FOR" = "device" ]; then
  RUST_TARGET="aarch64-apple-ios"
  DEPLOYMENT_FLAG="-miphoneos-version-min=${DEPLOYMENT_TARGET}"
else
  # Simulator targets: choose based on host arch for Apple Silicon vs Intel
  HOST_ARCH="$(uname -m)"
  if [ "$HOST_ARCH" = "arm64" ]; then
    RUST_TARGET="aarch64-apple-ios-sim"
  else
    RUST_TARGET="x86_64-apple-ios"
  fi
  DEPLOYMENT_FLAG="-mios-simulator-version-min=${DEPLOYMENT_TARGET}"
fi

if ! rustup target list | grep -q "^$RUST_TARGET (installed)"; then
  rustup target add "$RUST_TARGET"
fi

# Export simulator/device deployment target appropriately
export IPHONEOS_DEPLOYMENT_TARGET="$DEPLOYMENT_TARGET"
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

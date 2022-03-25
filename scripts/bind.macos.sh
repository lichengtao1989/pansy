
cd "$( cd "$( dirname "$0"  )" && pwd  )/.."

cbindgen native/src/platforms/non_android.rs -l c > macos/Runner/native.h

touch native/src/bridge_generated.rs
flutter_rust_bridge_codegen \
    --rust-input native/src/api.rs \
    --dart-output lib/bridge_generated.dart \
    --c-output macos/Runner/bridge_generated.h \
    --rust-crate-dir native \
    --llvm-path $LLVM_HOME \
    --class-name Native

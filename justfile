compiledb := "false"
compile_commands := if compiledb == "true" { "compiledb" } else { "" }
api_dir := "src/api/"
build_library := "yes"
debug := "target=template_debug debug_symbols=yes"

build-linux $SCONS_CACHE="build-linux":
  scons {{compile_commands}} -j4 {{debug}} use_llvm=yes gdextension_dir={{api_dir}} build_library={{build_library}} platform=linux

build-android-arm32 $SCONS_CACHE="build-android-arm32":
  scons {{compile_commands}} -j4 {{debug}} use_llvm=yes gdextension_dir={{api_dir}} build_library={{build_library}} platform=android arch=arm32
build-android-arm64 $SCONS_CACHE="build-android-arm64":
  scons {{compile_commands}} -j4 {{debug}} use_llvm=yes gdextension_dir={{api_dir}} build_library={{build_library}} platform=android arch=arm64

build-android-x86_32 $SCONS_CACHE="build-android-x86_32":
  scons {{compile_commands}} -j4 {{debug}} use_llvm=yes gdextension_dir={{api_dir}} build_library={{build_library}} platform=android arch=x86_32
build-android-x86_64 $SCONS_CACHE="build-android-x86_64":
  scons {{compile_commands}} -j4 {{debug}} use_llvm=yes gdextension_dir={{api_dir}} build_library={{build_library}} platform=android arch=x86_64

build-windows-x86_32 $SCONS_CACHE="build-windows-x86_32":
  scons {{compile_commands}} -j4 {{debug}} use_llvm=yes gdextension_dir={{api_dir}} build_library={{build_library}} platform=windows arch=x86_32
build-windows-x86_64 $SCONS_CACHE="build-windows-x86_64":
  scons {{compile_commands}} -j4 {{debug}} use_llvm=yes gdextension_dir={{api_dir}} build_library={{build_library}} platform=windows arch=x86_64

build-android: build-android-arm32 build-android-arm64 build-android-x86_32 build-android-x86_64

build-windows: build-windows-x86_32 build-windows-x86_64

build: build-linux build-android build-windows

remove-empty-folders:
  find . -empty -type d ! -path '*/.git*' ! -path '*/.git*/*' ! -path '*/.godot*' ! -path '*/android' -exec rmdir {} \;

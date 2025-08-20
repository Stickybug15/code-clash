compiledb := "false"
compile_commands := if compiledb == "true" { "compiledb" } else { "" }
api_file := "extension_api.json"

[working-directory: "godot-cpp"]
build-godot-cpp-linux:
  scons {{compile_commands}} -j4 custom_api_file=../{{api_file}} platform=linux arch=arm64

[working-directory: "godot-cpp"]
build-godot-cpp-android:
  scons {{compile_commands}} {{ if compiledb == "true" { "compiledb" } else { "" } }} -j4 custom_api_file=../{{api_file}} platform=android android_api_level=31

build-linux $SCONS_CACHE="build-linux":
  scons {{compile_commands}} -j4 custom_api_file={{api_file}} platform=linux

build-android-arm32 $SCONS_CACHE="build-android-arm32":
  scons {{compile_commands}} -j4 custom_api_file={{api_file}} platform=android arch=arm32
build-android-arm64 $SCONS_CACHE="build-android-arm64":
  scons {{compile_commands}} -j4 custom_api_file={{api_file}} platform=android arch=arm64

build-android-x86_32 $SCONS_CACHE="build-android-x86_32":
  scons {{compile_commands}} -j4 custom_api_file={{api_file}} platform=android arch=x86_32
build-android-x86_64 $SCONS_CACHE="build-android-x86_64":
  scons {{compile_commands}} -j4 custom_api_file={{api_file}} platform=android arch=x86_64

build-android: build-android-arm32 build-android-arm64 build-android-x86_32 build-android-x86_64

build: build-linux build-android

remove-empty-folders:
  find . -empty -type d ! -path '*/.git*' ! -path '*/.git*/*' ! -path '*/.godot*' ! -path '*/android' -exec rmdir {} \;

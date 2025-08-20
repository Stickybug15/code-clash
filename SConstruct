#!/usr/bin/env python
import os
import sys

env = SConscript("godot-cpp/SConstruct")

# For reference:
# - CCFLAGS are compilation flags shared between C and C++
# - CFLAGS are for C-specific compilation flags
# - CXXFLAGS are for C++-specific compilation flags
# - CPPFLAGS are for pre-processor flags
# - CPPDEFINES are for pre-processor defines
# - LINKFLAGS are for linking flags

# tweak this if you want to use different folders, or more folders, to store your source code in.
env.Append(
  CPPPATH=[
    "src/",
    "./src/deps/cpp-tree-sitter/include/",
    "./src/deps/tree-sitter/lib/include/",

    "./src/deps/wren/src/include/",
    "./src/deps/wren/src/optional/",
    "./src/deps/wren/src/vm/",
  ],
)
sources = Glob("src/*.cpp")
sources += Glob("./src/deps/tree-sitter/lib/src/lib.c")
sources += Glob("./src/deps/wren/src/vm/*.c")
sources += Glob("./src/deps/wren/src/optional/*.c")

match env["platform"]:
  case "macos":
    name = "bin/libgodotcpp.{}.{}.framework/libgodotcpp.{}.{}".format(
        env["platform"], env["target"], env["platform"], env["target"])
    library = env.SharedLibrary(name, source=sources)
  case "ios":
    if env["ios_simulator"]:
      name = "bin/libgodotcpp.{}.{}.simulator.a".format(
          env["platform"], env["target"])
      library = env.StaticLibrary(name, source=sources)
    else:
      name = "bin/libgodotcpp.{}.{}.a".format(env["platform"], env["target"])
      library = env.StaticLibrary(name, source=sources)
  case _:
    name = "bin/libgodotcpp{}{}".format(env["suffix"], env["SHLIBSUFFIX"])
    library = env.SharedLibrary(name, source=sources)

Default(library)

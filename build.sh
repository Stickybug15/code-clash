#!/usr/bin/bash
build_library=no
use_llvm=no

if [[ "$1" = "build_library" ]]; then
  build_library=yes
fi

exist() {
  command -v "$1" > /dev/null 2>&1
}

if exist clang++; then
  use_llvm=yes  
fi

check-python() {
  local script="import sys; exit(0 if sys.version_info >= (3, 11, 0) else 1)"
  local bin="$1"
  "$bin" -c "$script"
}

python_version="Python 3.11.0"
if ! check-version "python"; then
  if ! check-version "$PWD/.venv/bin/python"; then
    source ".venv/bin/activate"
  else
    echo "Python version must be '$python_version'!, maybe, run './init.sh' first?"
    exit 1
  fi
fi

if [[ "$OS" = "Windows_NT" ]]; then
  ./just.sh build_library="$build_library" use_llvm="$use_llvm" build-windows-x86_64
else
  source /etc/os-release
  case "$ID" in
    arch|ubuntu)
      ./just.sh build_library="$build_library" use_llvm="$use_llvm" build-linux
      ;;
    *)
      echo "Unknown ID: $ID"
      ;;
  esac
fi

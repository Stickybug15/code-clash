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

source /etc/os-release

python_version="Python 3.11.14"
if [[ "$(python --version)" != "$python_version" ]]; then
  if [[ "$(.venv/bin/python --version)" == "$python_version" ]]; then
    source ".venv/bin/activate"
  else
    echo "Python version must be '$python_version'!, maybe, run './init.sh' first?"
    exit 1
  fi
fi

if [[ "$OS" = "Windows_NT" ]]; then
  ./just.sh build_library="$build_library" use_llvm="$use_llvm" build-windows-x86_64
else
  case "$ID" in
    arch|ubuntu)
      ./just.sh build_library="$build_library" use_llvm="$use_llvm" build-linux
      ;;
    *)
      echo "Unknown ID: $ID"
      ;;
  esac
fi

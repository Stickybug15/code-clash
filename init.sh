#!/bin/bash

set -e

cache_dir="$PWD/.cache"

if [[ -d "$cache_dir" ]]; then
  mkdir -p "$cache_dir"
fi

ask() {
  local prompt="$1"
  local answer

  echo "$prompt"
  echo "Please enter 'y' for yes or 'n' for no."
  read -p "> " answer

  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    return 0
  else
    return 1
  fi
}

to_ansi() {
  printf '\001\e[%sm\002' $1
}

ansi() {
  case "$1" in
    (reset)   to_ansi 0;;
    (black)   to_ansi 30;;
    (red)     to_ansi 31;;
    (green)   to_ansi 32;;
    (yellow)  to_ansi 33;;
    (blue)    to_ansi 34;;
    (magenta) to_ansi 35;;
    (cyan)    to_ansi 36;;
    (white)   to_ansi 37;;
    (orange)  to_ansi 38\;5\;166;;
  esac
}

exist() {
  command -v "$1" > /dev/null 2>&1
}

download() {
  local out=$1
  local url=$2

  printf "%sDownloading:%s %s\n" "$(ansi green)" "$(ansi reset)" "$out"
  printf "  from: %s\n" "$url"

  if ! curl -L -C - -f -o "$out" "$url"; then
    printf "%serror:%s failed to download %s\n" "$(ansi red)" "$(ansi reset)" "$out"
    exit 1
  fi
}

init_addons() {
  return
}

init_justfile() {
  local url="https://github.com/casey/just/releases/download/1.42.4/just-1.42.4-x86_64-pc-windows-msvc.zip"
  local zipfile="$cache_dir/$(basename $url)"
  if [[ ! -f "$zipfile" ]]; then
    download "$zipfile" "$url"
  fi
  unzip -n "$zipfile" 'just.exe' -d "$cache_dir"
}

init_godot() {
  local url="https://github.com/godotengine/godot/releases/download/4.4.1-stable/Godot_v4.4.1-stable_win64.exe.zip"
  local zipfile="$cache_dir/$(basename $url)"
  if [[ ! -f "$zipfile" ]]; then
    download "$zipfile" "$url"
  fi
  unzip -n "$zipfile" -d "$cache_dir"
}

init_submodules() {
  git submodule update --init --recursive
}

init_scons() {
  local url="https://www.python.org/ftp/python/3.13.7/python-3.13.7-amd64.exe"
  local file="$cache_dir/$(basename $url)"
  if [[ ! -f "$file" ]]; then
    download "$file" "$url"
  fi

  make_py_script() {
    local sh_file="$cache_dir/python.sh"
    rm -rf "$sh_file"
    local shebang='#!/bin/bash'
    local python="exec python $@"
    printf '%s\n' "$shebang" >> "$sh_file"
    printf 'exec %s $@\n' "$1" >> "$sh_file"
    chmod +x "$sh_file"
  }

  local python_bin=""
  if exist python; then
    python_bin="python"
    make_py_script "$python_bin"
  elif exist python3; then
    python_bin="python3"
    make_py_script "$python_bin"
  elif exist python313; then
    python_bin="python313"
    make_py_script "$python_bin"
  elif exist '/c/Program Files/Python313/python'; then
    python_bin="/c/Program Files/Python313/python"
    make_py_script "$python_bin"
  fi

  if [[ -z $python_bin ]]; then
    cmd //c "$(cygpath -w $file) /passive /norestart InstallAllUsers=1 Include_pip=1 PrependPath=1"
    make_py_script "/c/Program Files/Python313/python"
  fi

  if ! "$cache_dir/python.sh" -m SCons --version > /dev/null 2>&1; then
    "$cache_dir/python.sh" -m pip install scons
  fi
}

init_compiler() {
  local url="https://github.com/msys2/msys2-installer/releases/download/nightly-x86_64/msys2-x86_64-latest.exe"
  local file="$cache_dir/$(basename $url)"
  if [[ ! -d '/c/msys64' ]]; then
    if [[ ! -f "$file" ]]; then
      download "$file" "$url"
    fi
    "$file" in --confirm-command --accept-messages --root 'C:/msys64'
    powershell -Command 'setx PATH "%PATH%;C:/msys64/mingw64/bin"'
  fi
  local pacman="/c/msys64/usr/bin/pacman"
  "$pacman" -S mingw-w64-x86_64-gcc mingw-w64-i686-gcc --noconfirm --needed

  ./just.sh --set build_library yes build-windows-x86_64
}

open() {
  eval "$1" &>/dev/null & disown;
}

init_addons
init_submodules
if [[ "$OS" = "Windows_NT" ]]; then
  init_justfile
  init_godot
  init_scons
  init_compiler
fi

echo
echo -e "$(ansi green)Initialized Successfully!$(ansi reset)"
if ask "Do you want to open godot?"; then
  open ./godot.sh
fi


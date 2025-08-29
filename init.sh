#!/bin/bash

set -e

cache_dir="$PWD/.cache"

download() {
  local out=$1
  local url=$2
  echo "downloading $out from $url"
  mkdir -p $(dirname $out)
  if ! curl -L -C - -f -o $out $url; then
    echo "error: failed to download $zipfile"
    exit 1
  fi
}

init_addons() {
  local url="https://github.com/limbonaut/limboai/releases/download/v1.4.1/limboai+v1.4.1.gdextension-4.4.zip"
  local addon="$(basename $url)"
  local zipfile="$cache_dir/$addon"
  if [[ ! -d "$PWD/addons/limboai" ]]; then
    if [[ ! -f "$zipfile" ]]; then
      download $zipfile $url
    fi
    unzip -n "$zipfile" 'addons/**/*'
  fi
}

init_justfile() {
  local url="https://github.com/casey/just/releases/download/1.42.4/just-1.42.4-x86_64-pc-windows-msvc.zip"
  local zipfile="$cache_dir/$(basename $url)"
  if [[ ! -f "$zipfile" ]]; then
    download $zipfile $url
  fi
  unzip -n "$zipfile" 'just.exe' -d "$cache_dir"
}

init_godot() {
  local url="https://github.com/godotengine/godot/releases/download/4.4.1-stable/Godot_v4.4.1-stable_win64.exe.zip"
  local zipfile="$cache_dir/$(basename $url)"
  if [[ ! -f "$zipfile" ]]; then
    download $zipfile $url
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
    download $file $url
  fi
  if ! type '/c/Program Files/Python313/python'; then
    cmd //c "$(cygpath -w $file) /passive /norestart InstallAllUsers=1 Include_pip=1 PrependPath=1"
  fi

  '/c/Program Files/Python313/python' -m pip install scons
}

init_addons
init_submodules
if [[ "$OS" = "Windows_NT" ]]; then
  init_justfile
  init_godot
  init_scons
fi

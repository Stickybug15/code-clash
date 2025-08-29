#!/bin/bash

cache_dir="$PWD/.cache"

download() {
  local out=$1
  local url=$2
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
    unzip "$zipfile" 'addons/*'
  fi
}

init_justfile() {
  local url="https://github.com/casey/just/releases/download/1.42.4/just-1.42.4-x86_64-pc-windows-msvc.zip"
  local zipfile="$cache_dir/$(basename $url)"
  if [[ ! -f "$zipfile" ]]; then
    download $zipfile $url
  fi
  unzip "$zipfile" 'just.exe' -d "$cache_dir"
}

init_submodules() {
  git submodule update --init --recursive
}

init_addons
init_submodules
if [[ "$OS" = "Windows_NT" ]]; then
  init_justfile
fi



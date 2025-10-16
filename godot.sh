#!/bin/bash
if [[ "$OS" = "Windows_NT" ]]; then
  "./.cache/Godot_v4.4.1-stable_win64.exe" -e --path "$PWD" $@ > /dev/null 2>&1 & disown
else
  cmd=""
  if command -v godot > /dev/null; then
    cmd=godot
  elif [[ -x ".cache/godot" ]]; then
    cmd=".cache/godot"
  fi

  version="4.4.1.stable.official.49a5bc7b6"
  if [[ "$("$cmd" --version)" != "$version" ]]; then
    echo "'$cmd'" is not a valid godot "'$version'" version.
    exit 1
  fi

  $cmd -e --path $PWD $@ > /dev/null 2>&1 & disown
fi

# vi: ft=bash

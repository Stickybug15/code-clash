#!/bin/bash
if [[ "$OS" = "Windows_NT" ]]; then
  exec "./.cache/Godot_v4.4.1-stable_win64.exe" -e --path $PWD $@
else
  if type godot4; then
    exec godot4 -e --path $PWD $@
  else
    exec godot -e --path $PWD $@
  fi
fi

# vi: ft=bash

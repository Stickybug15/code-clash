#!/bin/bash
if [[ "$OS" = "Windows_NT" ]]; then
  exec ./.cache/just.exe $@
else
  exec just $@
fi

# vi: ft=bash

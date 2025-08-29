#!/bin/bash
if [[ "$OS" = "Windows_NT" ]]; then
  ./.cache/just.exe $@
else
  just $@
fi

# vi: ft=bash

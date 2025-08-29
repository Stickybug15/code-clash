#!/bin/bash
if [[ "$OS" = "Windows_NT" ]]; then
  echo exec '/c/Program Files/Python313/python' -m SCons $@
  exec '/c/Program Files/Python313/python' -m SCons $@
else
  exec scons $@
fi

# vi: ft=bash

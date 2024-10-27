#!/bin/bash

if [ "$1" = "/bin/bash" ]; then
  exec /bin/bash
else
  # Default command.
  umask 000
  exec /usr/bin/solc "$@"
fi
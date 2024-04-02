#!/bin/ash

set -e

ARGS="$1"

case "$ARGS" in
  "sh" | "ash" | "bash" | "/bin/sh" )
    exec "/bin/ash"
    ;;
  "--rotate" )
    rotate_credential.sh
    ;;
  * )
    "$@"
    ;;
esac

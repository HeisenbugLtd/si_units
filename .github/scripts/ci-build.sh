#!/usr/bin/env bash

trap 'echo "ERROR at line ${LINENO} (code: $?)" >&2' ERR
trap 'echo "Interrupted" >&2 ; exit 1' INT

set -o errexit
set -o nounset

# Build test program(s)
gprbuild -j0 -p -P si_units.gpr

# For the record
echo ENVIRONMENT:
env | sort
echo ............................

echo GNAT VERSION:
gnatls -v
echo ............................
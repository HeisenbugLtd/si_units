#!/usr/bin/env bash

trap 'echo "ERROR at line ${LINENO} (code: $?)" >&2' ERR
trap 'echo "Interrupted" >&2 ; exit 1' INT

set -o errexit
set -o nounset

echo "Running tests:"
./test/obj/main_si_units_test
# Test subprogram sets exit status depending on if all tests succeeded or not.

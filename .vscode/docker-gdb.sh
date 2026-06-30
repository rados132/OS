#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$SCRIPT_DIR")"

exec docker run --rm -i \
  -v "${WORKSPACE}:/project" \
  riscv-env \
  bash -c "$*"
#!/bin/bash
###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

TESTED_COMMIT=37f2607

PATCH_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CORUNDUM_DIR=${1:-$PATCH_DIR/../../../corundum}

if ! git -C "$CORUNDUM_DIR" rev-parse --git-dir > /dev/null 2>&1; then
  echo "ERROR: $CORUNDUM_DIR is not a git checkout of Corundum" >&2
  exit 1
fi
CORUNDUM_DIR=$(cd "$CORUNDUM_DIR" && pwd)

if ! git -C "$CORUNDUM_DIR" merge-base --is-ancestor $TESTED_COMMIT HEAD 2> /dev/null; then
  echo "WARNING: $CORUNDUM_DIR is not based on the tested commit $TESTED_COMMIT"
fi

failed=0
for patch in "$PATCH_DIR"/patch_*.patch; do
  name=$(basename "$patch")
  if git -C "$CORUNDUM_DIR" apply --reverse --check "$patch" 2> /dev/null; then
    echo "already applied: $name"
  elif git -C "$CORUNDUM_DIR" apply --check "$patch" 2> /dev/null; then
    git -C "$CORUNDUM_DIR" apply "$patch" && echo "applied: $name" || failed=1
  else
    echo "ERROR: $name does not apply to $CORUNDUM_DIR" >&2
    failed=1
  fi
done

exit $failed

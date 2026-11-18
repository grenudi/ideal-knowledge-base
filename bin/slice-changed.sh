#!/bin/sh
# Did a release change what a source lays into its bases? Ends 0 when a file its `generic` names (read from the
# folder of #! from = DIR/, when it has one) - or the list itself - differs between the two releases, 1 when none
# does, 2 on a wrong call. update-pins leaves a base's pin where it is when the answer is 1.
#   slice-changed.sh SOURCE_DIR OLD_VERSION NEW_VERSION
set -eu
[ $# -eq 3 ] || { echo "usage: slice-changed.sh SOURCE_DIR OLD_VERSION NEW_VERSION" >&2; exit 2; }
src=$1; old=$2; new=$3
git -C "$src" rev-parse -q --verify "v$old^{commit}" >/dev/null || exit 0   # an unknown pin: lay the release
git -C "$src" rev-parse -q --verify "v$new^{commit}" >/dev/null || { echo "slice-changed: no release v$new in $src" >&2; exit 2; }
from=$(git -C "$src" show "v$new:generic" | sed -n 's/^#! from = \(.*\)$/\1/p' | head -1)
list=$(mktemp); trap 'rm -f "$list"' EXIT
git -C "$src" show "v$new:generic" | grep -vE '^[[:space:]]*(#|$)' | sed "s|^|$from|" > "$list"

echo generic >> "$list"
# shellcheck disable=SC2046 # one path per line, none with spaces
git -C "$src" diff --quiet "v$old" "v$new" -- $(cat "$list") && exit 1
exit 0

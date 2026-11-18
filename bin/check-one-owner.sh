#!/bin/sh
# A file has one source: the `generic` lists of the sources given (clones, or folders holding a generic file) name no
# file twice - except a file each source holds a marked part of (AGENTS.md, tables.toml: the lines between that
# source's own marker words, `#! marker = WORD` in its generic, idealkb when none), which sources share part by part.
# Prints each file two lists name, with the folders; ends 1 when there is one, 0 when none.
#   check-one-owner.sh SOURCE_DIR SOURCE_DIR...
set -eu
[ $# -ge 2 ] || { echo "usage: check-one-owner.sh SOURCE_DIR SOURCE_DIR..." >&2; exit 2; }
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
for d in "$@"; do
	[ -f "$d/generic" ] || { echo "check-one-owner: $d has no generic list" >&2; exit 2; }
	mark=$(sed -n 's/^#! marker = \(.*\)$/\1/p' "$d/generic" | head -1); : "${mark:=idealkb}"
	from=$(sed -n 's/^#! from = \(.*\)$/\1/p' "$d/generic" | head -1)
	grep -vE '^[[:space:]]*(#|$)' "$d/generic" | sort -u | while read -r f; do
		if [ -f "$d/$from$f" ] && grep -q "$mark:begin" "$d/$from$f"; then part=$mark; else part=whole; fi
		printf '%s\t%s\t%s\n' "$f" "$part" "$d"
	done
done > "$work/all"
bad=0
for f in $(cut -f1 "$work/all" | sort | uniq -d); do
	# two lists name it: fine only when each holds a marked part and the markers differ
	if awk -F'\t' -v f="$f" '$1 == f { n++; if ($2 == "whole") w = 1; if (seen[$2]++) s = 1 } END { exit !(w || s) }' "$work/all"; then
		printf '%s is listed by: %s\n' "$f" "$(awk -F'\t' -v f="$f" '$1 == f { printf "%s ", $3 }' "$work/all")"; bad=1
	fi
done
exit $bad

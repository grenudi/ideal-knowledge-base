#!/bin/sh
# A fork's carried commits say how far each patch has travelled: a subject starts TAG(item): with TAG one of UPSTREAM,
# BACKPORT, FROMGIT, FROMLIST, OURS and item an upstream item carried in this base (tad q carried). The tag must be the one
# the item's state gives (the tag column of tad q carried); BACKPORT stands for UPSTREAM or FROMGIT where the commit needed
# changes. Prints each commit with no tag, with an item not carried, or with the wrong tag; ends 1 when there is one.
#   check-fork-tags.sh BASE_DIR REPO RANGE        (RANGE as git log takes it: v7.1..HEAD)
set -eu
[ $# -eq 3 ] || { echo "usage: check-fork-tags.sh BASE_DIR REPO RANGE" >&2; exit 2; }
base=$(cd "$1" && pwd); repo=$2; range=$3
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
(cd "$base" && tad q carried --format csv) | awk -F, 'NR > 1 { print $1 "\t" $5 }' > "$work/tags" || { echo "check-fork-tags: tad q carried failed in $base" >&2; exit 2; }
bad=0
git -C "$repo" log --format='%h%x09%s' "$range" | while IFS="$(printf '\t')" read -r h s; do
	case $s in
	UPSTREAM\(*\):* | BACKPORT\(*\):* | FROMGIT\(*\):* | FROMLIST\(*\):* | OURS\(*\):*) ;;
	*) echo "$h: no tag: $s"; continue ;;
	esac
	tag=${s%%(*}; item=${s#*(}; item=${item%%)*}
	want=$(awk -F'\t' -v i="$item" '$1 == i { print $2 }' "$work/tags")
	[ -n "$want" ] || { echo "$h: $tag($item) names an item this base does not carry (tad q carried): $s"; continue; }
	[ "$tag" = "$want" ] && continue
	[ "$tag" = BACKPORT ] && { [ "$want" = UPSTREAM ] || [ "$want" = FROMGIT ]; } && continue
	echo "$h: $tag($item) but the item says $want: $s"
done > "$work/bad"
cat "$work/bad"
[ ! -s "$work/bad" ]

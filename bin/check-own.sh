#!/bin/sh
# Every file a base keeps as its own says why: each entry of `own = [...]` in its pin file has a line in the pin's
# [why] section, "FILE" = "the reason" or "FILE" = "upstream:ID" - the upstream item (data/upstream_items.json) that
# sends the base's change to the source. Prints each own file with no reason, and each reason naming an item the
# base does not hold; ends 1 when there is one, 0 when none, 2 on a wrong call. A kept file without a reason is a
# wish to drift that nobody can read later.
#   check-own.sh BASE [PINFILE...]    (default: idealkb.toml and devicebase.toml, those the base has)
set -eu
[ $# -ge 1 ] || { echo "usage: check-own.sh BASE [PINFILE...]" >&2; exit 2; }
base=$(cd "$1" && pwd); shift
[ $# -gt 0 ] || set -- idealkb.toml devicebase.toml
bad=0
for p in "$@"; do
	[ -f "$base/$p" ] || continue
	for f in $(sed -n 's/^own = \[\(.*\)\]$/\1/p' "$base/$p" | tr -d '" ' | tr ',' ' '); do
		why=$(sed -n '/^\[why\]/,/^\[/p' "$base/$p" | sed -n "s|^\"$f\" *= *\"\(.*\)\"\$|\1|p" | head -1)
		if [ -z "$why" ]; then echo "$p: $f is kept as the base's own and says no why (add it under [why]: \"$f\" = \"the reason\" or \"upstream:ITEM\")"; bad=1; continue; fi
		case $why in
		upstream:*)
			id=${why#upstream:}
			found=$(jq -r --arg id "$id" 'select(.id == $id) | .id' "$base/data/upstream_items.json" 2>/dev/null || true)
			if [ -z "$found" ]; then echo "$p: $f names upstream item $id, which this base does not hold (tad q upstream)"; bad=1; fi ;;
		esac
	done
done
exit $bad

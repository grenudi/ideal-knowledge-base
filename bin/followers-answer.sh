#!/bin/sh
# Asks every follower whether it can take this checkout as it stands, before it is released: each base in
# consumers is cloned from its main into a scratch folder, this checkout's generic files are laid over it
# by bin/follow.sh (the base's own files kept as its own), and the generic queries are asked of its
# data. A column a follower does not declare then stops this change, not that follower's weekly pin.
# It writes only in a scratch folder of its own, removed when it ends.
#   followers-answer.sh now [OWNER/REPO...]    (default: the bases listed in ./consumers)
# Ends 0 when every follower answers, 1 when one does not, 2 on a wrong call.
set -eu
[ "${1:-}" = now ] || { echo "usage: followers-answer.sh now [OWNER/REPO...]" >&2; exit 2; }
shift
here=$(cd "$(dirname "$0")/.." && pwd)
repos="$*"; [ -n "$repos" ] || repos=$(grep -vE '^[[:space:]]*(#|$)' "$here/consumers")
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
# this checkout, committed as it stands, under a release name of its own: follow.sh lays a release
git clone -q "$here" "$work/kb"
(cd "$here" && git ls-files -co --exclude-standard -z | xargs -0 tar -cf -) | tar -xf - -C "$work/kb"
git -C "$work/kb" add -A
git -C "$work/kb" -c user.name=check -c user.email=check@localhost commit -qm "as it stands" --allow-empty
git -C "$work/kb" tag v0.0.0-check
failed=0
for r in $repos; do
	base="$work/$(echo "$r" | tr / -)"
	git clone -q --depth 1 "https://github.com/$r" "$base" || { echo "$r: could not be cloned"; failed=1; continue; }
	rc=0; "$work/kb/bin/follow.sh" "$base" 0.0.0-check > "$work/said" || rc=$?
	case $rc in 0 | 3) ;; *) cat "$work/said"; echo "$r: follow.sh refused"; failed=1; continue ;; esac
	answers=1
	for q in "about" "next" "find --text a" "row --id a" "recent" "upstream" "upstreams" "carried" "decided" "ready" "hardware"; do
		# shellcheck disable=SC2086 # each line is a query and its parameters, split on purpose
		if ! (cd "$base" && tad q $q --format csv >/dev/null 2>"$work/err"); then
			echo "$r: tad q $q does not answer: $(head -c 300 "$work/err")"; answers=0
		fi
	done
	if [ "$answers" = 1 ]; then echo "$r: answers all eleven"; else failed=1; fi
done
exit $failed

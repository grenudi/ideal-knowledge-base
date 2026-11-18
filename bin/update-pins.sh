#!/bin/sh
# Brings every knowledge base that follows ideal-knowledge-base to its latest release: bin/follow.sh lays
# the generic files and moves the pin in idealkb.toml, the five generic queries are asked of the base's
# data, and the change lands through land - so each base's own CI decides. Where the base had changed a
# generic file, the branch is pushed and a pull request opened but not landed: its diff is the signal to
# send that change upstream, or to name the file as the base's own. Run hourly by the lab machine, so a release reaches every base within the hour.
#   update-pins.sh now [OWNER/REPO...]    (default: the bases listed in ./consumers)
set -eu
[ "${1:-}" = now ] || { echo "usage: update-pins.sh now [OWNER/REPO...]" >&2; exit 2; }
shift
here=$(cd "$(dirname "$0")/.." && pwd)
git -C "$here" fetch -q --tags origin
latest=$(gh release list -R grenudi/ideal-knowledge-base --limit 20 --exclude-drafts --json tagName -q '[.[].tagName | select(startswith("v"))] | first' | sed 's/^v//')
[ -n "$latest" ] || { echo "update-pins: no release of ideal-knowledge-base" >&2; exit 1; }
repos="$*"; [ -n "$repos" ] || repos=$(grep -vE '^[[:space:]]*(#|$)' "$here/consumers")
failed=0
# each base is followed in a worktree of its own, never in the clone the sessions working there share: a base
# that refuses a release leaves nothing behind but that worktree, removed after it
scratch=$(mktemp -d); trap 'rm -rf "$scratch"' EXIT
follow_one() {
	dir="$HOME/Projects/$1"
	[ -d "$dir" ] || { echo "$1: not cloned at $dir" >&2; return 1; }
	git -C "$dir" fetch -q origin || { echo "$1: could not fetch" >&2; return 1; }
	pin=$(git -C "$dir" show origin/main:idealkb.toml 2>/dev/null | sed -n 's/^version = "\(.*\)"$/\1/p')
	if [ "$pin" = "$latest" ]; then echo "$1: idealkb $pin, current"; return 0; fi
	wt="$scratch/$(echo "$1" | tr / -)"
	git -C "$dir" worktree add -q -f -B "build/idealkb-$latest" "$wt" origin/main || { echo "$1: no worktree" >&2; return 1; }
	cd "$wt"
	said=$(mktemp); own=0
	rc=0; "$here/bin/follow.sh" "$wt" "$latest" > "$said" || rc=$?
	case $rc in 0) ;; 3) own=1 ;; *) cat "$said" >&2; return 1 ;; esac
	asked=1
	for q in "about" "next" "find --text a" "row --id a" "recent"; do
		# shellcheck disable=SC2086 # each line is a query and its parameters, split on purpose
		tad q $q --format csv >/dev/null 2>&1 || { echo "$1: tad q $q does not answer on this base" >&2; asked=0; }
	done
	[ "$asked" = 1 ] || { echo "$1: idealkb $latest not laid - the base needs what the release asks of its own tables first" >&2; return 1; }
	tad canon >/dev/null && tad render >/dev/null
	git add -A
	git -c user.name="${GIT_NAME:-idealkb update-pins}" -c user.email="${GIT_EMAIL:-agent@creation-guidelines}" \
		commit -qm "build: ideal-knowledge-base $latest" -m "The pin moves from ${pin:-none} to $latest; the generic files as that release has them:" -m "$(cat "$said")"
	if [ "$own" = 1 ]; then
		git push -q -f origin "build/idealkb-$latest"
		gh pr create -R "$1" --head "build/idealkb-$latest" --title "build: ideal-knowledge-base $latest - this base changed a generic file" \
			--body "$(printf 'This base had its own change to a generic file of ideal-knowledge-base. The diff shows it as idealkb has it; nothing was landed.\n\nSend the change upstream (grenudi/ideal-knowledge-base), or name the file in own in idealkb.toml, then land this.\n\n%s\n' "$(sed 's/^/    /' "$said")")" >/dev/null
		echo "$1: idealkb $latest laid, but this base changed a generic file - left as a pull request"
	elif land --no-manual >/dev/null 2>&1; then
		echo "$1: idealkb ${pin:-none} -> $latest, landed"
	else
		echo "$1: idealkb $latest refused by its checks; left on build/idealkb-$latest" >&2; return 1
	fi
	rm -f "$said"
}
for r in $repos; do
	follow_one "$r" || failed=1
	cd "$here"
	git -C "$HOME/Projects/$r" worktree remove --force "$scratch/$(echo "$r" | tr / -)" 2>/dev/null || true
done
exit $failed

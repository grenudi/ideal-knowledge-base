#!/bin/sh
# Brings every base that follows a source to that source's latest release. A source is a repository with a `generic`
# list, releases (tags vX) and a `consumers` list: ideal-knowledge-base itself and each repository named in ./sources.
# The base's pin file (the source's `#! pin =`, idealkb.toml by default) says which release it is at; bin/follow.sh lays
# the files and moves the pin, the five generic queries are asked of the base's data, and the change lands through land -
# so each base's own CI decides. Where the base had changed a followed file, the branch is pushed and a pull request
# opened but not landed: its diff is the signal to send that change upstream, or to name the file as the base's own.
# A file two sources list is refused first (bin/check-one-owner.sh). Run hourly by the lab machine; sources in order,
# ideal-knowledge-base first.
#   update-pins.sh now [OWNER/REPO...]    (default: the consumers of every source; with names: only those bases)
set -eu
[ "${1:-}" = now ] || { echo "usage: update-pins.sh now [OWNER/REPO...]" >&2; exit 2; }
shift
here=$(cd "$(dirname "$0")/.." && pwd)
git -C "$here" fetch -q --tags origin
only="$*"
failed=0
# each base is followed in a worktree of its own, never in the clone the sessions working there share: a base
# that refuses a release leaves nothing behind but that worktree, removed after it
scratch=$(mktemp -d); trap 'rm -rf "$scratch"' EXIT
sources_dirs() { echo "$here"; grep -vE '^[[:space:]]*(#|$)' "$here/sources" 2>/dev/null | while read -r s; do echo "$HOME/Projects/$s"; done; }
latest_of() { # latest release of the source clone in $1: its tag without the v
	repo=$(git -C "$1" remote get-url origin | sed 's/\.git$//; s|.*[:/]\([^:/]*/[^:/]*\)$|\1|')
	gh release list -R "$repo" --limit 20 --exclude-drafts --json tagName -q '[.[].tagName | select(startswith("v"))] | first' | sed 's/^v//'
}
follow_one() { # follow_one SOURCE_DIR SOURCE_NAME LATEST PINNAME BASE
	src=$1; sname=$2; latest=$3; pinname=$4; r=$5
	dir="$HOME/Projects/$r"
	[ -d "$dir" ] || { echo "$r: not cloned at $dir" >&2; return 1; }
	git -C "$dir" fetch -q origin || { echo "$r: could not fetch" >&2; return 1; }
	pin=$(git -C "$dir" show "origin/main:$pinname" 2>/dev/null | sed -n 's/^version = "\(.*\)"$/\1/p')
	if [ "$pin" = "$latest" ]; then echo "$r: $sname $pin, current"; return 0; fi
	wt="$scratch/$(echo "$r" | tr / -)-$sname"
	git -C "$dir" worktree add -q -f -B "build/$sname-$latest" "$wt" origin/main || { echo "$r: no worktree" >&2; return 1; }
	cd "$wt"
	said=$(mktemp); own=0
	rc=0; "$here/bin/follow.sh" --source "$src" "$wt" "$latest" > "$said" || rc=$?
	case $rc in 0) ;; 3) own=1 ;; *) cat "$said" >&2; return 1 ;; esac
	asked=1
	for q in "about" "next" "find --text a" "row --id a" "recent"; do
		# shellcheck disable=SC2086 # each line is a query and its parameters, split on purpose
		tad q $q --format csv >/dev/null 2>&1 || { echo "$r: tad q $q does not answer on this base" >&2; asked=0; }
	done
	[ "$asked" = 1 ] || { echo "$r: $sname $latest not laid - the base needs what the release asks of its own tables first" >&2; return 1; }
	tad canon >/dev/null && tad render >/dev/null
	git add -A
	git -c user.name="${GIT_NAME:-idealkb update-pins}" -c user.email="${GIT_EMAIL:-agent@creation-guidelines}" \
		commit -qm "build: $sname $latest" -m "The pin moves from ${pin:-none} to $latest; the files as that release has them:" -m "$(cat "$said")"
	if [ "$own" = 1 ]; then
		git push -q -f origin "build/$sname-$latest"
		gh pr create -R "$r" --head "build/$sname-$latest" --title "build: $sname $latest - this base changed a followed file" \
			--body "$(printf 'This base had its own change to a file of %s. The diff shows it as the release has it; nothing was landed.\n\nSend the change upstream, or name the file in own in %s, then land this.\n\n%s\n' "$sname" "$pinname" "$(sed 's/^/    /' "$said")")" >/dev/null
		echo "$r: $sname $latest laid, but this base changed a followed file - left as a pull request"
	elif land --no-manual >/dev/null 2>&1; then
		echo "$r: $sname ${pin:-none} -> $latest, landed"
	else
		echo "$r: $sname $latest refused by its checks; left on build/$sname-$latest" >&2; return 1
	fi
	rm -f "$said"
}
# every source at its latest release, extracted, to check that no file has two sources
owners="$scratch/owners"; mkdir -p "$owners"; n=0; list=""
for src in $(sources_dirs); do
	[ -d "$src/.git" ] || [ -f "$src/.git" ] || { echo "update-pins: source $src is not cloned" >&2; failed=1; continue; }
	git -C "$src" fetch -q --tags origin 2>/dev/null || true
	latest=$(latest_of "$src"); [ -n "$latest" ] || continue
	n=$((n + 1)); mkdir -p "$owners/$n"; git -C "$src" archive "v$latest" | tar -x -C "$owners/$n"; list="$list $owners/$n"
done
# shellcheck disable=SC2086
if [ "$n" -ge 2 ] && ! sh "$here/bin/check-one-owner.sh" $list > "$scratch/dup" 2>&1; then
	cat "$scratch/dup" >&2; echo "update-pins: a file has two sources; nothing followed until one gives it up" >&2; exit 1
fi
for src in $(sources_dirs); do
	[ -d "$src" ] || continue
	git -C "$src" fetch -q origin 2>/dev/null || true
	latest=$(latest_of "$src")
	[ -n "$latest" ] || { echo "update-pins: no release of $src" >&2; continue; }
	sname=$(basename "$(git -C "$src" remote get-url origin | sed 's/\.git$//')")
	pinname=$(git -C "$src" show "v$latest:generic" 2>/dev/null | sed -n 's/^#! pin = \(.*\)$/\1/p' | head -1); : "${pinname:=idealkb.toml}"
	repos="$only"; [ -n "$repos" ] || repos=$(git -C "$src" show origin/main:consumers 2>/dev/null | grep -vE '^[[:space:]]*(#|$)' || true)
	for r in $repos; do
		# a base named on the command line is followed for every source it pins
		if [ -n "$only" ] && ! git -C "$HOME/Projects/$r" show "origin/main:$pinname" >/dev/null 2>&1; then continue; fi
		follow_one "$src" "$sname" "$latest" "$pinname" "$r" || failed=1
		cd "$here"
		git -C "$HOME/Projects/$r" worktree remove --force "$scratch/$(echo "$r" | tr / -)-$sname" 2>/dev/null || true
	done
done
exit $failed

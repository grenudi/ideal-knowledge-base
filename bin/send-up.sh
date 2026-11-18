#!/bin/sh
# Sends a base's change to a followed file up to its source: the change from the source's release the base was at
# (OLD) to the base's file, merged three-way onto the source's main - what the source changed since is kept - as a
# branch from-BASENAME-FILE on the source's origin, and a pull request there. For a file the source holds a marked
# part of (its marker lines), only that part is compared and replaced. A conflict, or no change, sends nothing and says so.
# Run by update-pins when follow.sh says the base changed a followed file; it makes the diff the signal to act on.
#   send-up.sh [--no-pr] SOURCE_DIR BASE_DIR BASENAME OLD_VERSION FILE
set -eu
pr=1; [ "${1:-}" = --no-pr ] && { pr=0; shift; }
[ $# -eq 5 ] || { echo "usage: send-up.sh [--no-pr] SOURCE_DIR BASE_DIR BASENAME OLD_VERSION FILE" >&2; exit 2; }
src=$(cd "$1" && pwd); base=$(cd "$2" && pwd); name=$3; old=$4; f=$5
git -C "$src" fetch -q origin 2>/dev/null || true
main=origin/main; git -C "$src" rev-parse -q --verify "$main" >/dev/null || main=main
gen=$(git -C "$src" show "$main:generic")
from=$(printf '%s\n' "$gen" | sed -n 's/^#! from = \(.*\)$/\1/p' | head -1)
mark=$(printf '%s\n' "$gen" | sed -n 's/^#! marker = \(.*\)$/\1/p' | head -1); : "${mark:=idealkb}"
path="$from$f"
work=$(mktemp -d); trap 'git -C "$src" worktree remove --force "$work/wt" 2>/dev/null; rm -rf "$work"' EXIT
git -C "$src" show "v$old:$path" > "$work/old" 2>/dev/null || : > "$work/old"
git -C "$src" show "$main:$path" > "$work/main"
part() { awk -v m="$mark" '$0 ~ (m ":begin") { on = 1 } on { print } $0 ~ (m ":end") { on = 0 }'; }
if grep -q "$mark:begin" "$work/main"; then
	partial=1
	part < "$work/old" > "$work/o"; part < "$work/main" > "$work/m"; part < "$base/$f" > "$work/b"
else
	partial=0; cp "$work/old" "$work/o"; cp "$work/main" "$work/m"; cp "$base/$f" "$work/b"
fi
cmp -s "$work/o" "$work/b" && { echo "$f: nothing to send (the base's file is the release's)"; exit 0; }
cp "$work/m" "$work/merged"
git merge-file -q "$work/merged" "$work/o" "$work/b" || { echo "$f: the source changed the same lines; a person merges it (the base's file: $base/$f)"; exit 1; }
if [ "$partial" = 1 ]; then
	awk -v part="$work/merged" -v m="$mark" '$0 ~ (m ":begin") { while ((getline l < part) > 0) print l; skip = 1; next } $0 ~ (m ":end") { skip = 0; next } !skip' "$work/main" > "$work/out"
else cp "$work/merged" "$work/out"; fi
cmp -s "$work/out" "$work/main" && { echo "$f: nothing to send (the source's main has it)"; exit 0; }
branch="from-$name-$(printf '%s' "$f" | tr '/.' '--')"
git -C "$src" worktree add -q -f -B "$branch" "$work/wt" "$main"
cp "$work/out" "$work/wt/$path"
git -C "$work/wt" add "$path"
git -C "$work/wt" -c user.name="${GIT_NAME:-idealkb send-up}" -c user.email="${GIT_EMAIL:-agent@creation-guidelines}" commit -qm "fix: $f, as the base $name changed it" -m "A change $name keeps in $f against release v$old, merged onto main; sent by ideal-knowledge-base's bin/send-up.sh."
remote_tree=$(git -C "$src" rev-parse "refs/remotes/origin/$branch^{tree}" 2>/dev/null || true)
if [ -n "$remote_tree" ] && [ "$remote_tree" = "$(git -C "$work/wt" rev-parse 'HEAD^{tree}')" ]; then echo "$f: already sent (branch $branch)"; exit 0; fi
git -C "$work/wt" push -q -f origin "$branch"
echo "$f: sent as branch $branch"
if [ "$pr" = 1 ]; then
	repo=$(git -C "$src" remote get-url origin | sed 's/\.git$//; s|.*[:/]\([^:/]*/[^:/]*\)$|\1|')
	if [ -z "$(gh pr list -R "$repo" --head "$branch" --state open --json number -q '.[].number')" ]; then
		gh pr create -R "$repo" --head "$branch" --title "fix: $f, as the base $name changed it" \
			--body "The base $name keeps a change to $f against release v$old. This is that change merged onto main, so the source can take it (or the base can drop it). Sent by ideal-knowledge-base's bin/send-up.sh." > /dev/null
		echo "$f: pull request opened on $repo"
	fi
fi

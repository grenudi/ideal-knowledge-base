#!/bin/sh
# A base's change to a followed file goes up as a branch (and a pull request) on its source: bin/send-up.sh makes the
# change from the source's release the base was at to the base's file, three-way onto the source's main, so what the
# source changed since is kept. Scratch repositories, a bare folder as the source's origin, no pull request (--no-pr).
# Ends 0 when every step says what it should, 1 at the first not.
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
fail() { echo "test-send-up: $*"; exit 1; }
git="git -c user.name=t -c user.email=t@localhost"
git init -q --bare "$work/origin.git"
src="$work/src"; git clone -q "$work/origin.git" "$src" 2>/dev/null; $git -C "$src" checkout -q -b main
mkdir -p "$src/queries"
printf '#! pin = devicebase.toml\n#! marker = template\nqueries/q.sql\nAGENTS.md\n' > "$src/generic"
printf -- '-- q\nline one\nline two\nline three\n' > "$src/queries/q.sql"
printf 'top\n<!-- template:begin -->\npart one\npart two\n<!-- template:end -->\nbottom\n' > "$src/AGENTS.md"
$git -C "$src" add -A; $git -C "$src" commit -qm v1; $git -C "$src" tag v1.0.0; $git -C "$src" push -q origin main --tags
# the source moves on: line three changes
printf -- '-- q\nline one\nline two\nline three, by the source\n' > "$src/queries/q.sql"; $git -C "$src" commit -qam v2; $git -C "$src" push -q origin main
# the base, at v1.0.0, changed line one and the marked part
base="$work/base"; mkdir -p "$base/queries"
printf -- '-- q\nline one, by the base\nline two\nline three\n' > "$base/queries/q.sql"
printf 'top\n<!-- template:begin -->\npart one\npart two, by the base\n<!-- template:end -->\nmine\n' > "$base/AGENTS.md"
sh "$here/bin/send-up.sh" --no-pr "$src" "$base" mybase 1.0.0 queries/q.sql > "$work/said" 2>&1 || fail "sending a whole file failed: $(cat "$work/said")"
sh "$here/bin/send-up.sh" --no-pr "$src" "$base" mybase 1.0.0 AGENTS.md > "$work/said2" 2>&1 || fail "sending a marked part failed: $(cat "$work/said2")"
$git -C "$work/origin.git" branch --list 'from-mybase-*' | grep -q queries || fail "no branch for the whole file: $(git -C "$work/origin.git" branch -a)"
b1=$($git -C "$work/origin.git" branch --list 'from-mybase-*queries*' | tr -d ' *')
tree=$($git -C "$work/origin.git" show "$b1:queries/q.sql")
printf '%s' "$tree" | grep -q "line one, by the base" || fail "the base's change is not on the branch"
printf '%s' "$tree" | grep -q "line three, by the source" || fail "what the source changed since was lost"
b2=$($git -C "$work/origin.git" branch --list 'from-mybase-*AGENTS*' | tr -d ' *')
agents=$($git -C "$work/origin.git" show "$b2:AGENTS.md")
printf '%s' "$agents" | grep -q "part two, by the base" || fail "the marked part's change is not on the branch"
printf '%s' "$agents" | grep -q '^bottom$' || fail "lines outside the marker were taken from the base"
before=$($git -C "$work/origin.git" rev-parse "$b1")
sh "$here/bin/send-up.sh" --no-pr "$src" "$base" mybase 1.0.0 queries/q.sql > /dev/null 2>&1 || fail "the second send failed"
[ "$before" = "$($git -C "$work/origin.git" rev-parse "$b1")" ] || fail "a second send moved the branch"
# a file the base did not change sends nothing
cp "$src/queries/q.sql" "$base/queries/q.sql"; git -C "$src" show v1.0.0:queries/q.sql > "$base/queries/q.sql"
sh "$here/bin/send-up.sh" --no-pr "$src" "$base" other 1.0.0 queries/q.sql 2>&1 | grep -q "nothing to send" || fail "an unchanged file was sent"
echo "test-send-up: a base's change reaches its source as a branch, three-way, once"

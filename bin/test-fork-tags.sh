#!/bin/sh
# How far each patch a fork carries has travelled, read off its commit subjects: UPSTREAM(item): / BACKPORT(item): /
# FROMGIT(item): / FROMLIST(item): / OURS(item): subject - the Android common kernel's tags, with the item named - and
# bin/check-fork-tags.sh BASE REPO RANGE finds the commits whose tag is not the one tad q carried derives from the item's
# state (landed: UPSTREAM; accepted: FROMGIT; sent, under review, changes requested: FROMLIST; the rest: OURS; BACKPORT
# for a landed or accepted item whose commit needed changes), commits with no tag, and tags naming an item not carried.
# Scratch base and repository. Ends 0 when every step says what it should, 1 at the first not.
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
fail() { echo "test-fork-tags: $*"; exit 1; }
b="$work/base"; mkdir -p "$b"; cp -R "$here/tables.toml" "$here/data" "$here/queries" "$here/records" "$b/"
cd "$b"
ik() { ikb "$@" --skip-render >/dev/null; }
ik backlog --id w --title "work"
ik upstream --id kernel --kind code-project --name kernel --address https://example.org --how mail
ik upstream-item --id sent-one --upstream kernel --title a --form patch --from-work w --state sent --carried-in fork/a
ik upstream-item --id taken-one --upstream kernel --title b --form patch --from-work w --state accepted --carried-in fork/b
ik upstream-item --id landed-one --upstream kernel --title c --form patch --from-work w --state landed --carried-in fork/c --applied-upstream v7.1
ik upstream-item --id ours-one --upstream kernel --title d --form patch --from-work w --state held --carried-in fork/d
tad q carried --format csv | grep -q "^sent-one,.*FROMLIST" || fail "a sent item is not FROMLIST: $(tad q carried --format csv)"
tad q carried --format csv | grep -q "^taken-one,.*FROMGIT" || fail "an accepted item is not FROMGIT"
tad q carried --format csv | grep -q "^landed-one,.*UPSTREAM" || fail "a landed item is not UPSTREAM"
tad q carried --format csv | grep -q "^ours-one,.*OURS" || fail "a held item is not OURS"
repo="$work/fork"; git init -q "$repo"; g="git -C $repo -c user.name=t -c user.email=t@localhost"
$g commit -q --allow-empty -m "base"; $g tag base
for s in "FROMLIST(sent-one): a" "FROMGIT(taken-one): b" "UPSTREAM(landed-one): c" "OURS(ours-one): d" "BACKPORT(taken-one): b, changed"; do $g commit -q --allow-empty -m "$s"; done
sh "$here/bin/check-fork-tags.sh" "$b" "$repo" base..HEAD > "$work/said" 2>&1 || fail "right tags were refused: $(cat "$work/said")"
$g commit -q --allow-empty -m "FROMLIST(taken-one): says it is only sent"
$g commit -q --allow-empty -m "an untagged change"
$g commit -q --allow-empty -m "UPSTREAM(nowhere-one): an item not carried"
if sh "$here/bin/check-fork-tags.sh" "$b" "$repo" base..HEAD > "$work/said" 2>&1; then fail "wrong tags passed"; fi
grep -q "FROMLIST(taken-one)" "$work/said" || fail "the wrong tag was not named: $(cat "$work/said")"
grep -q "untagged change" "$work/said" || fail "the untagged commit was not named"
grep -q "nowhere-one" "$work/said" || fail "the unknown item was not named"
echo "test-fork-tags: a fork's commits say how far each patch has travelled, and the item agrees"

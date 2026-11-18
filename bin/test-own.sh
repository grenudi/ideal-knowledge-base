#!/bin/sh
# A file a base keeps as its own has a reason: bin/check-own.sh finds the own entries of a pin file with none, with
# a reason that names an upstream item the base does not hold, or with none stated. The reason sits in the pin file:
#   own = ["tables.toml"]
#   [why]
#   "tables.toml" = "upstream:ID"      (an item of data/upstream_items.json)  or  "the words of the reason"
# Runs on a scratch base. Ends 0 when every step says what it should, 1 at the first not.
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
fail() { echo "test-own: $*"; exit 1; }
b="$work/base"; mkdir -p "$b/data"
printf '{"id":"send-tables","upstream":"x","title":"t","form":"patch","state":"sent","from_work":"w","last_update":"2026-11-18"}\n' > "$b/data/upstream_items.json"
pin() { printf 'source = "x/y"\nversion = "1.0.0"\n%s\n' "$1" > "$b/idealkb.toml"; }
pin 'own = ["tables.toml", "records/backlog.sql"]'
sh "$here/bin/check-own.sh" "$b" > "$work/said" 2>&1 && fail "own files with no reason passed"
grep -q "tables.toml" "$work/said" && grep -q "records/backlog.sql" "$work/said" || fail "the files without reason were not named: $(cat "$work/said")"
pin 'own = ["tables.toml"]
[why]
"tables.toml" = "the device tables are this base'"'"'s"'
sh "$here/bin/check-own.sh" "$b" > "$work/said" 2>&1 || fail "a stated reason was refused: $(cat "$work/said")"
pin 'own = ["tables.toml"]
[why]
"tables.toml" = "upstream:send-tables"'
sh "$here/bin/check-own.sh" "$b" > "$work/said" 2>&1 || fail "a reason naming a held upstream item was refused: $(cat "$work/said")"
pin 'own = ["tables.toml"]
[why]
"tables.toml" = "upstream:nothing-here"'
sh "$here/bin/check-own.sh" "$b" > "$work/said" 2>&1 && fail "a reason naming an upstream item the base lacks passed"
grep -q "nothing-here" "$work/said" || fail "the missing item was not named: $(cat "$work/said")"
pin 'own = []'
sh "$here/bin/check-own.sh" "$b" > /dev/null 2>&1 || fail "a base with no own files was refused"
echo "test-own: an own file has a reason or an upstream item the base holds"

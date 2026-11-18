#!/bin/sh
# A second source, followed by the pin: a source repository that names its pin file and marker in its `generic`
# list is laid into a base by bin/follow.sh as idealkb is - its files whole, the part of AGENTS.md between its
# marker lines, the pin file moved - the base's own files left; and a file two sources both list is found.
# Runs on scratch repositories; needs git. Ends 0 when every step says what it should, 1 at the first not.
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
fail() { echo "test-follow: $*"; exit 1; }
git="git -c user.name=t -c user.email=t@localhost"
src="$work/src"; mkdir -p "$src/queries" "$src/records"
cat > "$src/generic" <<'G'
#! pin = devicebase.toml
#! marker = template
# a second source: what a device base takes from it
queries/phone.sql
records/part.sql
AGENTS.md
G
echo "-- phone v1" > "$src/queries/phone.sql"; echo "-- part v1" > "$src/records/part.sql"
printf 'top\n<!-- template:begin -->\nthe template says v1\n<!-- template:end -->\nbottom\n' > "$src/AGENTS.md"
$git -C "$src" init -q; $git -C "$src" add -A; $git -C "$src" commit -qm v1; $git -C "$src" tag v0.1.0
echo "-- phone v2" > "$src/queries/phone.sql"; printf 'top\n<!-- template:begin -->\nthe template says v2\n<!-- template:end -->\nbottom\n' > "$src/AGENTS.md"
$git -C "$src" commit -qam v2; $git -C "$src" tag v0.2.0
base="$work/base"; mkdir -p "$base/queries" "$base/records"
printf 'own\n<!-- template:begin -->\nthe template says v1\n<!-- template:end -->\nmine\n' > "$base/AGENTS.md"
echo "-- the base's own part" > "$base/records/part.sql"
printf 'source = "x/src"\nversion = "0.1.0"\nown = ["records/part.sql"]\n' > "$base/devicebase.toml"
sh "$here/bin/follow.sh" --source "$src" "$base" 0.2.0 > "$work/said" || fail "follow ended $?: $(cat "$work/said")"
grep -q "phone v2" "$base/queries/phone.sql" || fail "the source's query was not laid"
grep -q "the template says v2" "$base/AGENTS.md" || fail "the marked part was not laid"
grep -q '^own$' "$base/AGENTS.md" && grep -q '^mine$' "$base/AGENTS.md" || fail "the base's own lines of AGENTS.md were not kept"
grep -q "phone v1\|part v2" "$base/records/part.sql" && fail "the base's own file was replaced"
grep -q '^version = "0.2.0"$' "$base/devicebase.toml" || fail "the pin did not move: $(cat "$base/devicebase.toml")"
grep -q '^source = "x/src"$' "$base/devicebase.toml" || fail "the pin lost its source"
[ ! -f "$base/idealkb.toml" ] || fail "a pin file the source did not name was made"
# one owner per file
other="$work/other"; mkdir -p "$other"; printf 'queries/phone.sql\nqueries/else.sql\n' > "$other/generic"
if sh "$here/bin/check-one-owner.sh" "$src" "$other" > "$work/dup" 2>&1; then fail "a file listed by two sources was not found"; fi
grep -q "queries/phone.sql" "$work/dup" || fail "the double owner was not named: $(cat "$work/dup")"
sh "$here/bin/check-one-owner.sh" "$src" "$here" > /dev/null 2>&1 || fail "idealkb and the source share a file: $(sh "$here/bin/check-one-owner.sh" "$src" "$here" 2>&1)"
echo "test-follow: a second source is laid by its own pin and marker; its own files are kept; a double owner is found"
# a source that serves its slice from a folder: files read from there, laid at the base's root
src2="$work/src2"; mkdir -p "$src2/layer/queries" "$src2/layer/bin" "$src2/queries"
printf '#! pin = layer.toml\n#! from = layer/\nqueries/slice.sql\nbin/tool.sh\n' > "$src2/generic"
echo "-- slice v1" > "$src2/layer/queries/slice.sql"; echo "tool v1" > "$src2/layer/bin/tool.sh"
echo "-- the source's own, not in the slice" > "$src2/queries/slice.sql"
$git -C "$src2" init -q; $git -C "$src2" add -A; $git -C "$src2" commit -qm s1; $git -C "$src2" tag v1.0.0
base2="$work/base2"; mkdir -p "$base2"
sh "$here/bin/follow.sh" --source "$src2" "$base2" 1.0.0 > "$work/said2" || fail "following a folder slice ended $?: $(cat "$work/said2")"
grep -q "slice v1" "$base2/queries/slice.sql" || fail "the slice file was not laid at the base's root from the folder"
[ -f "$base2/bin/tool.sh" ] || fail "the second slice file was not laid"
[ ! -d "$base2/layer" ] || fail "the folder itself was laid"
grep -q '^version = "1.0.0"$' "$base2/layer.toml" || fail "the pin of the folder source did not move"
echo "-- slice v2" > "$src2/layer/queries/slice.sql"; $git -C "$src2" commit -qam s2; $git -C "$src2" tag v1.1.0
sh "$here/bin/follow.sh" --source "$src2" "$base2" 1.1.0 > /dev/null || fail "the second release was not followed"
grep -q "slice v2" "$base2/queries/slice.sql" || fail "the second release's slice file was not laid"
# the same files from the slice and from another source are one file for the owner check
third="$work/third"; mkdir -p "$third"; printf 'queries/slice.sql\n' > "$third/generic"
if sh "$here/bin/check-one-owner.sh" "$src2" "$third" > /dev/null 2>&1; then fail "a slice file another source lists was not found"; fi
echo "test-follow: a folder slice is laid at the root by its own pin"
# a release that changed none of the slice's files is no reason to move a pin
echo "unrelated" > "$src2/README"; $git -C "$src2" add -A; $git -C "$src2" commit -qm unrelated; $git -C "$src2" tag v1.2.0
if sh "$here/bin/slice-changed.sh" "$src2" 1.1.0 1.2.0 > /dev/null; then fail "a release that changed no slice file was said to change the slice"; fi
sh "$here/bin/slice-changed.sh" "$src2" 1.0.0 1.1.0 > /dev/null || fail "a release that changed a slice file was said not to"
sh "$here/bin/slice-changed.sh" "$src" 0.1.0 0.2.0 > /dev/null || fail "a changed marked part was said not to change the slice"
echo "test-follow: a release that changed no file of the slice leaves the pin"

#!/bin/sh
# Brings a knowledge base to a release of ideal-knowledge-base: the files named in `generic`, as that
# release has them - the named statements whole, AGENTS.md's and tables.toml's part between the lines
# idealkb:begin and idealkb:end - and the pin in the base's idealkb.toml moved to it. A file the base names
# as its own (own = [...] in idealkb.toml) is left as it is; where this release changed it, that is said.
# A generic file the base changed is replaced too, and said: the change shows in the diff, the signal to
# send it upstream - follow.sh then ends 3, and update-pins.sh leaves it for a person to look at.
#   follow.sh [--source DIR] BASE VERSION     DIR is a clone of the source that holds the tag vVERSION (default: the
#                              clone this script is in, ideal-knowledge-base). A source names, in lines at the top of
#                              its generic, the base file that holds the pin (#! pin = devicebase.toml; default
#                              idealkb.toml) and the word of its marker lines (#! marker = template; default idealkb).
#                              A source may serve its files from a folder of it (#! from = DIR/): they are read there and laid at the
#                              base's root. The pin file also holds source = "OWNER/REPO" (what update-pins reads), version, own.
# Ends 0 when the base had no change of its own to a generic file, 3 when it had, 2 on a wrong call.
set -eu
kb=$(cd "$(dirname "$0")/.." && pwd)
if [ "${1:-}" = --source ]; then [ $# -ge 2 ] || { echo "usage: follow.sh [--source DIR] BASE VERSION" >&2; exit 2; }; kb=$(cd "$2" && pwd); shift 2; fi
[ $# -eq 2 ] || { echo "usage: follow.sh [--source DIR] BASE VERSION" >&2; exit 2; }
base=$(cd "$1" && pwd)
new=$2
git -C "$kb" rev-parse -q --verify "v$new^{commit}" >/dev/null || { echo "follow: no release v$new in $kb" >&2; exit 2; }
at() { git -C "$kb" show "v$1:$2" 2>/dev/null; }
origin=$(git -C "$kb" remote get-url origin 2>/dev/null | sed 's/\.git$//; s|.*[:/]\([^:/]*/[^:/]*\)$|\1|') || origin=""
who=$(basename "${origin:-$kb}")
pinname=$(at "$new" generic | sed -n 's/^#! pin = \(.*\)$/\1/p' | head -1); : "${pinname:=idealkb.toml}"
mark=$(at "$new" generic | sed -n 's/^#! marker = \(.*\)$/\1/p' | head -1); : "${mark:=idealkb}"
from=$(at "$new" generic | sed -n 's/^#! from = \(.*\)$/\1/p' | head -1)
pin="$base/$pinname"
old=""; own=""
if [ -f "$pin" ]; then
	old=$(sed -n 's/^version = "\(.*\)"$/\1/p' "$pin")
	own=$(sed -n 's/^own = \[\(.*\)\]$/\1/p' "$pin" | tr -d '" ' | tr ',' ' ')
fi
part() { awk -v m="$mark" '$0 ~ (m ":begin") { on = 1 } on { print } $0 ~ (m ":end") { on = 0 }'; }
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
drift=0
for f in $(at "$new" generic | grep -vE '^[[:space:]]*(#|$)'); do
	case " $own " in
	*" $f "*)
		if [ -n "$old" ] && [ "$(at "$old" "$from$f")" != "$(at "$new" "$from$f")" ]; then
			echo "$f: the base's own; $who $new changed it - look at whether the base takes it:"
			at "$new" "$from$f" > "$work/new"
			diff -u --label "the base's $f" --label "$who $new's" "$base/$f" "$work/new" | sed 's/^/    /' || true
		else
			echo "$f: the base's own"
		fi
		continue ;;
	esac
	at "$new" "$from$f" > "$work/new"
	mkdir -p "$(dirname "$base/$f")"
	if grep -q "$mark:begin" "$work/new"; then
		part < "$work/new" > "$work/part"
		if [ -f "$base/$f" ] && grep -q "$mark:begin" "$base/$f"; then
			part < "$base/$f" > "$work/had"
			if [ -n "$old" ]; then at "$old" "$from$f" | part > "$work/was"; else cp "$work/part" "$work/was"; fi
			if ! cmp -s "$work/had" "$work/was"; then
				drift=1; echo "$f: the base changed its generic part - replaced; the diff shows the change to send upstream"
			fi
			awk -v part="$work/part" -v m="$mark" '
				$0 ~ (m ":begin") { while ((getline l < part) > 0) print l; skip = 1; next }
				$0 ~ (m ":end") { skip = 0; next }
				!skip' "$base/$f" > "$work/out"
			cmp -s "$work/out" "$base/$f" || { cp "$work/out" "$base/$f"; echo "$f: its generic part is $who $new's"; }
		elif [ -f "$base/$f" ]; then
			{ cat "$base/$f"; echo; cat "$work/part"; } > "$work/out" && cp "$work/out" "$base/$f"
			echo "$f: $who $new's generic part added at its end"
		else
			cp "$work/part" "$base/$f"; echo "$f: made, from $who $new's generic part"
		fi
	else
		if [ -f "$base/$f" ] && ! cmp -s "$base/$f" "$work/new"; then
			if [ -z "$old" ] || [ "$(at "$old" "$from$f")" != "$(cat "$base/$f")" ]; then
				drift=1; echo "$f: the base had its own version - replaced; the diff shows it (send it upstream, or name it own)"
			fi
		fi
		cmp -s "$base/$f" "$work/new" 2>/dev/null || { cp "$work/new" "$base/$f"; echo "$f: $who $new's"; }
	fi
done
if [ -f "$pin" ]; then
	sed -i "s/^version = \".*\"$/version = \"$new\"/" "$pin"
else
	cat > "$pin" <<PIN
# This base follows ${origin:-$who} at the release named here: the files its generic list names, and the part of
# AGENTS.md and tables.toml between its marker lines. The pin job (ideal-knowledge-base bin/update-pins.sh) moves it;
# own names the files this base keeps as its own; source is where the job finds its releases.
source = "${origin:-$who}"
version = "$new"
own = []
PIN
fi
grep -q "^version = \"$new\"$" "$pin" || { echo "follow: the pin did not move" >&2; exit 1; }
echo "$who $new: ${old:-not followed before} -> $new"
exit $((drift * 3))

#!/bin/sh
# Brings a knowledge base to a release of ideal-knowledge-base: the files named in `generic`, as that
# release has them - the named statements whole, AGENTS.md's and tables.toml's part between the lines
# idealkb:begin and idealkb:end - and the pin in the base's idealkb.toml moved to it. A file the base names
# as its own (own = [...] in idealkb.toml) is left as it is; where this release changed it, that is said.
# A generic file the base changed is replaced too, and said: the change shows in the diff, the signal to
# send it upstream - follow.sh then ends 3, and update-pins.sh leaves it for a person to look at.
#   follow.sh BASE VERSION     run from a clone of ideal-knowledge-base that holds the tag vVERSION
# Ends 0 when the base had no change of its own to a generic file, 3 when it had, 2 on a wrong call.
set -eu
[ $# -eq 2 ] || { echo "usage: follow.sh BASE VERSION" >&2; exit 2; }
kb=$(cd "$(dirname "$0")/.." && pwd)
base=$(cd "$1" && pwd)
new=$2
git -C "$kb" rev-parse -q --verify "v$new^{commit}" >/dev/null || { echo "follow: no release v$new in $kb" >&2; exit 2; }
pin="$base/idealkb.toml"
old=""; own=""
if [ -f "$pin" ]; then
	old=$(sed -n 's/^version = "\(.*\)"$/\1/p' "$pin")
	own=$(sed -n 's/^own = \[\(.*\)\]$/\1/p' "$pin" | tr -d '" ' | tr ',' ' ')
fi
at() { git -C "$kb" show "v$1:$2" 2>/dev/null; }
part() { awk '/idealkb:begin/ { on = 1 } on { print } /idealkb:end/ { on = 0 }'; }
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
drift=0
for f in $(at "$new" generic | grep -vE '^[[:space:]]*(#|$)'); do
	case " $own " in
	*" $f "*)
		if [ -n "$old" ] && [ "$(at "$old" "$f")" != "$(at "$new" "$f")" ]; then
			echo "$f: the base's own; idealkb $new changed it - look at whether the base takes it:"
			at "$new" "$f" > "$work/new"
			diff -u --label "the base's $f" --label "idealkb $new's" "$base/$f" "$work/new" | sed 's/^/    /' || true
		else
			echo "$f: the base's own"
		fi
		continue ;;
	esac
	at "$new" "$f" > "$work/new"
	mkdir -p "$(dirname "$base/$f")"
	if grep -q 'idealkb:begin' "$work/new"; then
		part < "$work/new" > "$work/part"
		if [ -f "$base/$f" ] && grep -q 'idealkb:begin' "$base/$f"; then
			part < "$base/$f" > "$work/had"
			if [ -n "$old" ]; then at "$old" "$f" | part > "$work/was"; else cp "$work/part" "$work/was"; fi
			if ! cmp -s "$work/had" "$work/was"; then
				drift=1; echo "$f: the base changed its generic part - replaced; the diff shows the change to send upstream"
			fi
			awk -v part="$work/part" '
				/idealkb:begin/ { while ((getline l < part) > 0) print l; skip = 1; next }
				/idealkb:end/ { skip = 0; next }
				!skip' "$base/$f" > "$work/out"
			cmp -s "$work/out" "$base/$f" || { cp "$work/out" "$base/$f"; echo "$f: its generic part is idealkb $new's"; }
		elif [ -f "$base/$f" ]; then
			{ cat "$base/$f"; echo; cat "$work/part"; } > "$work/out" && cp "$work/out" "$base/$f"
			echo "$f: idealkb $new's generic part added at its end"
		else
			cp "$work/part" "$base/$f"; echo "$f: made, from idealkb $new's generic part"
		fi
	else
		if [ -f "$base/$f" ] && ! cmp -s "$base/$f" "$work/new"; then
			if [ -z "$old" ] || [ "$(at "$old" "$f")" != "$(cat "$base/$f")" ]; then
				drift=1; echo "$f: the base had its own version - replaced; the diff shows it (send it upstream, or name it own)"
			fi
		fi
		cmp -s "$base/$f" "$work/new" 2>/dev/null || { cp "$work/new" "$base/$f"; echo "$f: idealkb $new's"; }
	fi
done
if [ -f "$pin" ]; then
	sed -i "s/^version = \".*\"$/version = \"$new\"/" "$pin"
else
	cat > "$pin" <<PIN
# This knowledge base follows grenudi/ideal-knowledge-base at the release named here: the generic named
# statements, and AGENTS.md's and tables.toml's part between idealkb:begin and idealkb:end. Its weekly pin
# job (idealkb's bin/update-pins.sh) moves it; own names the generic files this base keeps as its own.
version = "$new"
own = []
PIN
fi
grep -q "^version = \"$new\"$" "$pin" || { echo "follow: the pin did not move" >&2; exit 1; }
echo "idealkb $new: ${old:-not followed before} -> $new"
exit $((drift * 3))

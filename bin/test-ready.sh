#!/bin/sh
# What an item may be taken, asked of one query: tad q ready. On a scratch copy of this base: an item that waits
# outside the base is not ready, one blocked by an item not done is not, one blocked only by done items is, one
# blocked by an item the base no longer holds is not, hardware not owned or refuted is not; and each skipped
# item says why. Needs tad and ikb on the path. Ends 0 when every step says what it should, 1 at the first not.
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
cp -R "$here/tables.toml" "$here/data" "$here/queries" "$here/records" "$work/"
cd "$work"
ik() { ikb "$@" --skip-render >/dev/null; }
q() { tad q "$@" --format csv 2>&1; }
has() { out=$(q $1) || { echo "tad q $1 failed: $out"; exit 1; }; printf '%s\n' "$out" | grep -q -- "$2" || { echo "tad q $1 does not show '$2':"; printf '%s\n' "$out"; exit 1; }; }
lacks() { out=$(q $1) || { echo "tad q $1 failed: $out"; exit 1; }; ! printf '%s\n' "$out" | grep -q -- "$2" || { echo "tad q $1 shows '$2' and must not:"; printf '%s\n' "$out"; exit 1; }; }
ik hardware --id cable-ok --kind cable --name "a cable" --status owned
ik hardware --id cable-no --kind cable --name "a cable not here" --status wanted
ik backlog --id done-one --title "already done" --status done
ik backlog --id open-one --title "still open" --status open
ik backlog --id gone-one --title "to be taken away" --status open
ik backlog --id free --title "waits on nothing" --needs phone --rank 2
ik backlog --id outside --title "waits on the author" --waits "the author's word" --needs phone --rank 1
ik backlog --id after-done --title "blocked by a done item" --blocked-by done-one --needs phone --rank 3
ik backlog --id after-open --title "blocked by an open item" --blocked-by open-one --needs phone --rank 4
ik backlog --id after-gone --title "blocked by an item taken away" --blocked-by gone-one --needs phone --rank 5
ik remove backlog --key gone-one
ik backlog --id hw-owned --title "needs an owned cable" --hardware cable-ok --needs phone --rank 6
ik backlog --id hw-wanted --title "needs a cable not here" --hardware cable-no --needs phone --rank 7
ik backlog --id builds --title "a build item" --needs build
has "ready" "^free,.*ready"
has "ready" "^after-done,.*ready"
has "ready" "^hw-owned,.*ready"
has "ready" "^outside,.*skipped,.*waits: the author's word"
has "ready" "^after-open,.*skipped,.*blocked by open-one"
has "ready" "^after-gone,.*skipped,.*gone-one.*not in this base"
has "ready" "^hw-wanted,.*skipped,.*cable-no"
lacks "ready" "^done-one,"
has "ready --for keeper" "^free,"
lacks "ready --for keeper" "^builds,"
has "ready --for builder" "^builds,.*ready"
lacks "ready --for builder" "^free,"
# the keeper's first pick is the best-ranked ready item, not the best-ranked item
first=$(tad q ready --for keeper --show ready --format csv | sed -n 2p | cut -d, -f1)
[ "$first" = free ] || { echo "the keeper's first pick is '$first', not free (outside is rank 1 but waits)"; exit 1; }
printf 'test-ready: a done blocker is clear, an outside wait is not ready, every skipped item says why\n'
# an item that needs a witness is ready only while a person's go is open
ik backlog --id attended --title "the author must see it" --needs phone --witness person --rank 8
has "ready" "^attended,.*skipped,.*needs a witness"
ik backlog-go --id attended --until "$(date -d '+1 hour' -Is)" --outcomes "if the go is open then ready shows it"
has "ready" "^attended,.*ready"
ik backlog-go --id attended --until "$(date -d '-1 hour' -Is)" --outcomes "if the go is open then ready shows it"
has "ready" "^attended,.*skipped,.*needs a witness"
ik backlog-go --id attended --until "$(date -d '+1 hour' -Is)" --outcomes "if the go is open then ready shows it"
ik backlog-go --id attended
has "ready" "^attended,.*skipped,.*needs a witness"
if ikb backlog-go --id free --until "$(date -Is)" --skip-render >/dev/null 2>&1; then echo "backlog-go took an item that needs no witness"; exit 1; fi
# an item closed without doing is neither offered nor counted done; what it blocks stays blocked, saying so
ik backlog --id dropme --title "dropped by the author" --note "dropped: not wanted, the author's word" --status dropped
ik backlog --id after-dropped --title "blocked by a dropped item" --blocked-by dropme --needs phone --rank 9
lacks "ready" "^dropme,"
has "ready" "^after-dropped,.*skipped,.*dropme (dropped)"
if ikb backlog --id dropnote --title "no reason" --status dropped --skip-render >/dev/null 2>&1; then echo "a dropped item took no note"; exit 1; fi
if ikb backlog-go --id attended --until "2099-01-01T00:00:00+00:00" --skip-render >/dev/null 2>&1; then echo "a go opened without outcomes"; exit 1; fi
# an unranked item is a finding and comes first, not last
ik backlog --id norank --title "recorded without a rank" --needs phone
ik backlog --id ranked1 --title "ranked" --needs phone --rank 1
has "ready" "^norank,.*unranked: give it a rank"
# a go may name the image it covers: image_sha256, exactly 64 lowercase hex, read as its own field
SHA=$(printf a%.0s $(seq 64))
ik backlog-go --id attended --until "2099-01-01T00:00:00+00:00" --outcomes "if the go is open then ready shows it" --image-sha256 "$SHA"
row=$(tad q row --id attended --format csv 2>&1 || true)
case "$row" in *"$SHA"*) ;; *) echo "image_sha256 not kept as its own field"; exit 1;; esac
for bad in aaaaaaaaaaaa "$(printf A%.0s $(seq 64))" "$(printf g%.0s $(seq 64))" "${SHA}a"; do
  if ikb backlog-go --id attended --until "2099-01-01T00:00:00+00:00" --outcomes x --image-sha256 "$bad" --skip-render >/dev/null 2>&1; then echo "a go took a bad sha: $bad"; exit 1; fi
done
ik backlog-go --id attended
# a ready item that needs a witness names the person and the go's end
ik backlog-go --id attended --until "2099-01-01T00:00:00+00:00" --outcomes "if the go is open then ready shows it"
has "ready" "^attended,ready,,person,2099-01-01"

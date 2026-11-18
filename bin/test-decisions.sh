#!/bin/sh
# A decision's life, recorded and read back: made, tracked, amended, superseded - on a scratch copy of this
# base, asked through tad q decided and about. Ends 0 when every step says what it should, 1 at the first that
# does not. Needs tad and ikb on the path.
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
cp -R "$here/tables.toml" "$here/data" "$here/queries" "$here/records" "$work/"
cd "$work"
ik() { ikb "$@" --skip-render >/dev/null; }
expect() { # expect "tad q ARGS" TEXT : its csv output has TEXT
	out=$(tad q $1 --format csv 2>&1) || { echo "$1 failed: $out"; exit 1; }
	printf '%s\n' "$out" | grep -qF -- "$2" || { echo "$1 does not show '$2':"; printf '%s\n' "$out"; exit 1; }
}
lacks() { out=$(tad q $1 --format csv 2>&1); ! printf '%s\n' "$out" | grep -q -- "$2" || { echo "$1 shows '$2' and must not:"; printf '%s\n' "$out"; exit 1; }; }
refuse() { if ikb $1 --skip-render >/dev/null 2>&1; then echo "'ikb $1' was accepted and must not be"; exit 1; fi; }
ik backlog --id do-a --title "carry out a" --status open
ik decision --id 2026-01-01-a --date 2026-01-01 --brief "choose a" --decision "a" --why "w" --about do-a --scope "every base" --tracked-by do-a
expect "decided" "2026-01-01-a,2026-01-01,in work,every base"
ik backlog --id do-a --title "carry out a" --status done
expect "decided" "carried out"
ik decision --id 2026-02-01-a-too --date 2026-02-01 --brief "also b" --decision "b" --why "w" --amends 2026-01-01-a --about do-a
expect "decided" "2026-01-01-a,2026-01-01,carried out"
expect "decided" "2026-02-01-a-too,2026-02-01,no item named"
expect "decided" "2026-02-01-a-too"
ik decision --id 2026-03-01-not-a --date 2026-03-01 --brief "instead c" --decision "c" --why "w" --supersedes 2026-01-01-a --about do-a
lacks "decided" "^2026-01-01-a,"
lacks "about --subject do-a" "^decision,2026-01-01-a,"
expect "decided --all true" "superseded by 2026-03-01-not-a"
expect "row --id 2026-01-01-a" "every base"
refuse "decision --id 2026-04-01-x --brief b --decision d --why w --supersedes 2026-99-99-none"
refuse "decision --id 2026-04-01-x --brief b --decision d --why w --amends 2026-04-01-x"
refuse "decision --id 2026-04-01-x --brief b --decision d --why w --tracked-by nothing-here"
printf 'test-decisions: a decision is made, tracked, amended, superseded and read back from the work\n'

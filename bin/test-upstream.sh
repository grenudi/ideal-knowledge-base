#!/bin/sh
# The life of a patch, recorded and read back: a fork, a patch sent upstream and carried in the fork, reviewed,
# accepted, landed, no longer carried - on a scratch copy of this base, asked through tad q carried and upstream.
# Ends 0 when every step says what it should, 1 at the first that does not. Needs tad and ikb on the path.
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
cp -R "$here/tables.toml" "$here/data" "$here/queries" "$here/records" "$work/"
cd "$work"
say() { printf 'test-upstream: %s\n' "$*"; }
ik() { ikb "$@" --skip-render >/dev/null; }
expect() { # expect "tad q ARGS" TEXT : its csv output has TEXT
	out=$(tad q $1 --format csv 2>&1) || { echo "$1 failed: $out"; exit 1; }
	printf '%s\n' "$out" | grep -qF -- "$2" || { echo "$1 does not show '$2':"; printf '%s\n' "$out"; exit 1; }
}
refuse() { # refuse "ikb args" : it must fail
	if ikb $1 --skip-render >/dev/null 2>&1; then echo "'ikb $1' was accepted and must not be"; exit 1; fi
}
ik backlog --id send-it --title "send the fix" --status open
ik upstream --id sxmo --kind code-project --name sxmo --address https://example.org/sxmo --how "send-email"
ik upstream --id sxmo-fork --kind code-project --name "sxmo, our fork" --address https://example.org/fork --how "a branch" --fork-of sxmo
refuse "upstream --id bad --kind code-project --name n --address a --how h --fork-of nowhere"
expect "upstreams" "sxmo-fork,code-project,sxmo"
ik upstream-item --id retry --upstream sxmo --title "suspend retry backoff" --form patch --from-work send-it --carried-in sxmo-fork/retry-backoff
expect "carried" "keep"
ik upstream-state --id retry --state sent --sent-on 2026-11-18 --forwarded https://example.org/msg1
ik upstream-state --id retry --state changes-requested --reviewed-by "A. Maintainer"
ik upstream-state --id retry --state accepted --reviewed-by "B. Reviewer"
expect "upstreaming" "accepted,accepted,FROMGIT"
expect "upstreaming-counts" "sxmo,1,0,0,1,0,0"
expect "upstream" "retry"
expect "row --id retry" "A. Maintainer; B. Reviewer"
ik upstream-state --id retry --state landed --applied-upstream "v2.0, commit:abc123"
expect "carried --fork sxmo-fork" "drop at the next rebase"
ik upstream-state --id retry --state landed --carried-in none
expect "upstreaming --upstream sxmo" "landed,landed,UPSTREAM"
out=$(tad q carried --format csv); [ "$(printf '%s\n' "$out" | wc -l)" -le 1 ] || { echo "a landed item is still carried: $out"; exit 1; }
refuse "upstream-state --id nowhere --state sent"
say "the life of a patch reads back: sent, reviewed, accepted, landed, dropped from the fork"

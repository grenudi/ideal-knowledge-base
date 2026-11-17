# What agents spend on recording into a tad knowledge base (measured 2026-11-17)

Method: the 31 newest Claude Code transcripts (~/.claude/projects/*/*.jsonl, all dated 2026-11-17; the 32nd, this session, left out)
whose tool calls hold `tad r|statements|q|canon|render`. Tool calls and results paired with jq; tokens are the context
size (input + cache read + cache create) of the nearest assistant turn, as read-weight does. Scratch data is in the
session scratchpad (s_*.json, errs.tsv). No repository was written. "Not known yet": time in seconds (not measured), and
how much of each pre-record stretch is the research itself rather than finding out how to record (the look-to-ok figures
below include both).

## Totals
- 240 `tad r` calls in 26 sessions (median call text 1,982 B, mean 2,421 B, max 9,832 B; 161 over 1,500 B, 62 over 3,000 B).
- 41 failed (17%): 33 with a `tad:` error line, 8 with only "Exit code" (shell parse, canon/render following).
- 187 `tad canon`/`tad render` commands, 121 of them in the same command as a `tad r` (r && canon && render); about 74 KB of output in all; 19 errored (mostly the same `tad r` failure, or a git merge conflict on data/*.json).
- 31 retries after a failed `tad r`: on average 8.4 tool calls and about 11,000 tokens of context growth until the next good `tad r`.

## (a) Per recording: calls and tokens from first look to first good `tad r`
Look = first call matching `tad statements|--help|tad help|tad man|AGENTS.md|tad q about|tad q find`.
Calls from first look to first good `tad r` (sessions where it can be measured, 25): median 33, range 0 to 262.
Context growth over that stretch: median about 60,000 tokens, range 0 to 394,000. Short ones (3 to 14 calls, 3k to 23k tokens):
8b8368b4, 88c8c64b, 1418c423, 9e00842f, 119f079f, 2227ab70. Long ones: 220b014f (262 calls, 394k), 7e9b1a15 (170, 168k),
8bfbc490 (77, 137k), aa6dfc1c (108 calls, 126k tokens, one single recording). Most of that is the research or lab work before the record,
not the how-to. The narrower cost - the guidance calls before the first `tad r` - is:
- median 3 calls (0 to 15) and about 9,400 B (0 to 44,725 B) per session: 137db72d 22.9 KB, 242c0334 28 KB, 3aa5400e 44.7 KB (9 calls), a69ad4f7 35.9 KB (13 calls), c715b525 34.8 KB, 7007ce97 28 KB (15 calls, AGENTS.md read 10 times).
- Sessions that skipped it (4a205dfc, 45833ff5, 119f079f) copied an earlier `tad r` form.
- Recording sessions that followed the first good `tad r` kept recording: 4ff433c8 made 48 `tad r` calls, 7e9b1a15 23, 220b014f 21, 3aa5400e 19.

## (b) Failed `tad r`, grouped by cause (41 failures; message prefix counted)
1. Wrong project value (the `linux-phone-oco/` prefix doubled, or a name not in the list): 5 (8b8368b4 x2, 3060e909, 137db72d x2 incl. 88c8c64b's `linux-phone-oco/lens`). The rule list is long and repeated in each error.
2. Brief over 200 characters: 5 (4ff433c8, 7e9b1a15, 137db72d - "the brief is 201 characters; at most 200" three times, 218 once). Counts 1 character over - write, fail, shorten, retry.
3. Missing required parameter: 7 (`research needs --brief`, `backlog-status needs --id`, `--project`, `backlog needs --id`, `session-log needs --project`).
4. Duplicate id / row already there: 4 (`the id 'rust-script' is used more than once, in: sources, sources`; pulpoff-linux-surya, sm7150-mainline-pr60) - the statement does INSERT without delete for sources, so a retry after a half-success collides.
5. Value not allowed: `status 'dropped' is not one of: open, in-progress, done` (8b8368b4); `device_id 'google-walleye' names nothing in devices` (242c0334); material path `research/deep-sleep/2026-11-17/suspend-wake-arm-trace.sh` does not match `^research/[a-z0-9]+(-[a-z0-9]+)*/[0-9]{4}-[0-9]{2}-[0-9]{2}(-[a-z0-9]+)*/$` (137db72d) - a file, not a folder.
6. SQL parse error from an apostrophe or reserved word in text or column: 6 (`syntax error at or near "s"` from "decision's", 7e9b1a15, a69ad4f7; `near "by"` - the column `by` of sources is unquoted in the statement, 8bfbc490 x3; `near "first"` aa6dfc1c).
7. Wrong command shape: `error: --help is not a declared flag` 14 times in 9 sessions (an agent asks `tad r X --help`; tad reports it as a flag error, and the help they want is the statement header, `tad statements`); `'backlog' is not a command` (tad 0.6.0: `tad r backlog`), `no query named about --subject X in ./queries/` x5 (a query written inside a quote), `--table is not a declared flag`, `--shown_in ... is not a declared flag`.
8. Shell parse errors on the command itself (`(eval):1: parse error near ')'`): 5 (4ff433c8 x2, 8bfbc490, 7007ce97) - from a shell function or `s(){...}` in zsh, with an alias in place.
9. canon/render noise: `canon already`, `rendered N backlog, 21 components, ...` (a 1-2 line summary of all tables each time, 130+ items), `all is well: 29 tables, 4405 rows`; `tad: 33 problems - canon writes nothing until they are fixed` (220b014f, after a rebase conflict: `UU data/decisions.json`). Not errors in themselves, but 187 runs.
10. Table/column in a query: `Binder Error: Referenced column "brief" not found`, `Could not ORDER BY column "list_positi..."`, `Table with name cond_all does not exist` (about/find/recent queries during a schema move; 4ff433c8, 3aa5400e). Not a `tad r`, but the look step.

## (c) What they read first, and size
- `tad statements`: 62 calls, median 601 B, mean 1.5 KB, max 7.6 KB.
- AGENTS.md (cat/sed/grep): 109 calls, median 614 B (usually a grep/head), max 25.4 KB (whole file).
- `tad q row`: 49 calls, median 574 B, max 12.4 KB.
- `tad --help`/`tad help`: 13 calls, median 1.7 KB, max 12.1 KB.
- records/*.sql statement files: 89 reads, median 1.0 KB, max 8.7 KB.
- `tad r X --help`: 3 times only (48 to 1,895 B).
Order seen most: AGENTS.md (grep) -> `tad statements` -> a previous record (`tad q row --id`) as the model -> `tad r`. Sessions that read records/*.sql (a69ad4f7, 3aa5400e, c715b525, 242c0334) had the heaviest pre-record read (28 to 45 KB) and also fewer first-call failures.

## (d) Quoting of long --found/--decision text
- 100 of 240 `tad r` calls carry the long text inline in double quotes (`--found "..."`), 46 use a heredoc, 1 uses $(cat). None use single quotes inline (as expected for apostrophes).
- Direct quoting failures: 6 SQL parse errors (apostrophes: `a feature research session's decision` -> `syntax error at or near "s"`, 7e9b1a15 i=3130; same in a69ad4f7), 5 shell parse errors. Agents then re-send the whole text, so a 2 to 3 KB call is paid twice (2.4 KB mean = about 600 tokens of output per retry).
- 4ff433c8 (and 7e9b1a15) built a validator/sed pipeline for the 200-character brief rule after three failures.

## Verbatim error examples (session = file stem in ~/.claude/projects/-home-mll/ unless noted; all ids are 8-char prefixes)
- 8b8368b4: `research, line 37: project 'linux-phone-oco/linux-phone-oco/docs' is not one of: linux-phone-oco/docs, linux-phone-oco/lab-tools, ...`
- 137db72d: `tad: record research: Invalid Input Error: the brief is 218 characters; at most 200` and `material 'research/deep-sleep/2026-11-17/suspend-wake-arm-trace.sh' does not match ^research/[a-z0-9]+(-[a-z0-9]+)*/[0-9]{4}-[0-9]{2}-[0-9]{2}(-[a-z0-9]+)*/$`
- 7e9b1a15: `tad: Parser Error: syntax error at or near "s"  LINE 1: UPDATE backlog SET waits = 'a feature research session's decision: ...`
- 8bfbc490: `tad: record source: Parser Error: syntax error at or near "by"  ... INSERT INTO sources (project, id, title, url, author, year, by, takes)` and `the id 'pulpoff-linux-surya' is used more than once, in: sources, sources`
- 3bca014c: `error: --help is not a declared flag` (14 times in the 9 sessions)
- 220b014f: `tad: 4 problems - canon writes nothing until they are fixed:` (after `UU data/decisions.json` merge conflict)
- 8b8368b4: `backlog, line 128: status 'dropped' is not one of: open, in-progress, done`
(Full paths: /home/mll/.claude/projects/-home-mll/<id>*.jsonl; per-project dirs may differ.)

## Reading
Cost is in: (1) the pre-record read (median 9 KB, up to 45 KB) before the first `tad r`; (2) a long inline text sent 1 to 3 times; (3) a 17% failure rate, five causes make up most of it - project prefix, 200-character brief, a missing parameter, a duplicate source id, an apostrophe in inline SQL text; (4) canon+render run after every record with an output no one uses unless it fails. Not known yet: seconds per step; whether tad 0.7.0's `--help` messaging reduces the 14 `--help` errors (7 of them in 0.6.0/0.7.0 transcripts); what portion of failure-free recordings were copied from an earlier one.

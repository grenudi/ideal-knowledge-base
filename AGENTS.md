# AGENTS.md - ideal-knowledge-base

How a knowledge base is organised so that an agent answers by one query. This base describes itself: its concepts
(the practices of organising knowledge; `tad q about` lists them), the decisions and research behind them, and the work ahead.
Setup once: `./bin/install-tad.sh && tad engine`.

<!-- idealkb:begin - kept by grenudi/ideal-knowledge-base at the release idealkb.toml names: change it there -->
## Finding what is known
Ask a query; never read `data/` or `docs/` to answer - they are the database's files and the pages for people.

| To know | Ask |
|---|---|
| how a subject stands, then all that is known of it | `tad q about --subject S` (`--whole true` for every record in full; `tad q about` lists the subjects, and where a summary is due) |
| the work ahead | `tad q next` (`--about S` for one subject) |
| where something is said | `tad q find --text WORDS` |
| one record whole | `tad q row --id ID` |
| what was recorded lately | `tad q recent` (`--days N`) |
| anything else | `tad statements`: every query and record, with its parameters |

At a task's start ask only about its subject (`about --subject S`, or `next --about S`) and act. Every
answer gives each record by its brief, its one line. Read deeper - `row --id`, `--whole true`, a file past
its first paragraph, another subject, `tad statements` - only when a step needs more. Long answers read best
with `--format csv`.

## Recording
Through the named records, never by hand: `tad r decision` (with what was rejected), `tad r research`,
`tad r source`, `tad r backlog`, `tad r session-log` - each naming what it is about (`--about`), a decision
and a research with its brief (`--brief`, the record in one line; the title is the brief of the rest). Then
`tad canon && tad render`, and land. Where `tad q about` says a summary is due for a subject you recorded
into, renew it: `tad r summary --about S --says ...` - how it stands now, naming the records that carry it.
A thing there are many of with one shape is a row; prose read once in order is a file (README, this entry,
a brief), and a file opens with its own brief: its first paragraph says what it holds. Research is both: its finding a row, its own material - notes, excerpts, measurements - a dated
folder the row names (`--material research/SUBJECT/YYYY-MM-DD/`); redone, a new row `--supersedes` the old.
<!-- idealkb:end -->

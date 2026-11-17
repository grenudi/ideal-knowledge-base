# AGENTS.md - ideal-knowledge-base

How a knowledge base is organised so that an agent answers by one query. This base describes itself: its concepts
(the practices of organising knowledge; `tad q about` lists them), the decisions and research behind them, and the work ahead.
Setup once: `./bin/install-tad.sh && tad engine`.

<!-- idealkb:begin - kept by grenudi/ideal-knowledge-base at the release idealkb.toml names: change it there -->
## Finding what is known
Ask a query; never read `data/` or `docs/` to answer - they are the database's files and the pages for people.

| To know | Ask |
|---|---|
| everything known of a subject | `tad q about --subject S` (`tad q about` lists the subjects) |
| the work ahead | `tad q next` (`--about S` for one subject) |
| where something is said | `tad q find --text WORDS` |
| one record whole | `tad q row --id ID` |
| what was recorded lately | `tad q recent` (`--days N`) |
| anything else | `tad statements`: every query and record, with its parameters |

Long answers read best with `--format csv`.

## Recording
Through the named records, never by hand: `tad r decision` (with what was rejected), `tad r research`,
`tad r source`, `tad r backlog`, `tad r session-log` - each naming what it is about (`--about`). Then
`tad canon && tad render`, and land. A thing there are many of with one shape is a row; prose read once in
order is a file (README, this entry, a brief; an essay too long for a row goes in `research/`, cited by a row).
<!-- idealkb:end -->

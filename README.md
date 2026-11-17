# ideal-knowledge-base

**How a knowledge base is organised so that an agent - or a person - answers a question by one query
instead of reading files.** It is a layer on [tad](https://github.com/creation-guidelines/tad-engine), the
open and transparent database (text files in git, tables declared as data, every row checked, SQL), and a
base follows it by a pinned release, as it pins tad.

What it adds to a bare tad database:

- **A row or a file.** A thing there are many of with one shape - cited, linked, dated, or changing state -
  is a row; prose read once in order is a file. Rendered pages are for people, never what an agent reads.
- **The about link.** Every record names what it is about, checked against the base's subjects.
- **Five questions, one query each.** `tad q about --subject S`, `tad q next`, `tad q find --text WORDS`,
  `tad q row --id ID`, `tad q recent` - and named records to write: `decision`, `research`, `source`,
  `backlog`, `session-log`, each with `--about`.
- **The standing tables.** `backlog`, `session_log`, `decisions` (with what was rejected), `research`, `sources`.
- **One entry.** `AGENTS.md` under 3 KB - what the base is in two lines, a table from question to command,
  and the rule: never read `data/` to answer. `CLAUDE.md` is `@AGENTS.md`.

Why, and what was weighed: ask this base itself - `tad q about` lists its concepts, `tad q about --subject
follow-by-pin` gives everything known of one. Its pages are in [`docs/`](docs/index.md).

## Starting a base

```
tad init .                                   # a bare database: tables.toml, data/, tad pinned, its CI check
/path/to/ideal-knowledge-base/bin/follow.sh . 0.1.0   # this layer, at a release (from a clone holding its tag)
```

Then say in `AGENTS.md`'s first lines what the base is, declare its own subject tables in `tables.toml`, and
say what `about` may name there (`[[rules.references]]`, `field = "decisions.about"`, `to = [...]`).

## Following a release

A base names the release it follows in `idealkb.toml` (`version`, and `own`: the generic files it keeps as
its own). The generic files are listed in [`generic`](generic): the named statements whole, and the part of
`AGENTS.md` and of `tables.toml` between the lines `idealkb:begin` and `idealkb:end` - the rest of those two
files is the base's. Every week the lab machine runs `bin/update-pins.sh now` for each base in
[`consumers`](consumers): it lays the latest release, asks the five queries of the base's data, and lands
through the base's own CI. Where a base had changed a generic file, it opens a pull request and does not
land it: the diff is the signal to send that change here, or to name the file `own`.

## Working on this repository

Records go through the named records (`tad statements`), then `tad canon && tad render`; every change gets
its own branch and lands through its checks. Commits follow Conventional Commits; release-please makes the
releases bases pin.

<!-- Generated from data/ by tad. Do not edit by hand. -->

# Concepts

<a id="file-or-table"></a>
### A row or a file

Summary
: A thing there are many of with one shape - that is cited, linked, dated or changes state - is a row: a decision, research, a source, an item of work, a log entry, a concept, a test, a status, a word. Prose read once in order is a file: README, AGENTS.md, a brief, an essay too long for a row (kept in research/ and cited by a row). Rendered pages are output for people and the face, never what an agent reads to answer. The named statements are the base's interface.

Why
: Rows can be asked, checked and linked; prose in rows is unreadable and rows in prose cannot be found. Measured in linux-phone-oco/docs on 2026-11-17 (kb-navigation-measured): reading pages to answer cost 206 KB where the rows that answered were 9.4 KB.


<a id="about-link"></a>
### The about link

Summary
: Every record table names what it is about in one field, about, checked by a references rule against the base's subjects (its components, features, practices - and its own backlog). A word before a dash names a family: modem names modem-data, modem-calls and modem-sms.

Why
: What made answers expensive was not the size of the entry but the missing link from a record to its subject: free text in four spellings, empty on a third of the decisions (kb-navigation-measured). Wikidata's statement about an item is the same move (kb-organisation-world).


<a id="generic-queries"></a>
### Five questions, one query each

Summary
: Every base answers the same five questions the same way: about SUBJECT (everything known of it), next (the work ahead), find TEXT (ids and first words of every record that says it), row ID (one record whole) and recent (what was recorded lately). tad statements lists everything else. Writing goes through named records - decision, research, backlog, session-log, source - each with --about.

Why
: An agent moving between bases learns one way in. Named statements are reviewable SQL beside the data, run with typed parameters (tad's 2026-11-17-named-statements).


<a id="one-entry"></a>
### One short entry

Summary
: AGENTS.md is the one entry, under 3 KB, and CLAUDE.md is @AGENTS.md: what the base is in two lines, an orientation table from a typical question to the command that answers it, tad statements for everything else, and the rule: never read data/ or docs/ to answer - ask a query. Editing recipes belong in CONTRIBUTING.md.

Why
: linux-phone-oco/docs' AGENTS.md was 7.9 KB, most of it how to edit the data, and was read at every start; only its first section said where knowledge is.


<a id="standing-tables"></a>
### The standing tables

Summary
: Every base keeps backlog, session_log, decisions (with what was rejected), research and sources, each with about. A base adds its own subject tables beside them.

Why
: Nothing may depend on anyone remembering: the work ahead, how it went, what was decided and why, and what was learned are the base's own records, queryable like its content (text-as-data-template's backlog-as-a-table, 2026-09).


<a id="follow-by-pin"></a>
### Followed by a pinned release

Summary
: A base follows ideal-knowledge-base by a release named in its idealkb.toml, as it pins tad in bin/install-tad.sh. The generic files - the named statements, and AGENTS.md's and tables.toml's part between idealkb:begin and idealkb:end - are laid by bin/follow.sh; a weekly job on the lab machine moves the pin and lands through the base's own CI. A file the base keeps as its own is named in own.

Why
: Copies drift: three of four vendored copies of tad's engine had drifted (tad's 2026-09-22-vendored-as-a-subrepo). A pin moved by a job, checked by the base's CI, keeps every base current without a hand.


<a id="send-upstream"></a>
### A base's change is a signal

Summary
: When a base changed a generic file, the weekly job still lays idealkb's version, says so, and does not land: its pull request shows the base's change as a diff - the signal to send it upstream to ideal-knowledge-base, or to name the file as the base's own.

Why
: The commons grows by joining: a better query found in one base should reach every base, and a silent overwrite would lose it.

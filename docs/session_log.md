<!-- Generated from data/ by tad. Do not edit by hand. -->

# Session Log

<a id="2026-11-17-made"></a>
### ideal-knowledge-base made, from linux-phone-oco/docs and text-as-data-template

Entry date
: 2026-11-17

Done
: Started with tad init (tad 0.7.0, made for it the same day: decision 2026-11-17-tad-init in tad-engine). The practices, the five generic queries and the records with --about, the standing tables between idealkb:begin and idealkb:end, the short entry, bin/follow.sh and bin/update-pins.sh. The research it rests on carried from docs, with its 17 sources; the reasons text-as-data-template held for a base - the backlog as a table, extracted from a working repository - carried in as decisions before the template retired. The generic queries were first run against docs' 4k rows: about audio-mic 14 KB, next --about modem 0.2 KB, row 0.8 KB.

Considered
: Generic queries that know a base's project field; a declaration tad includes from another file.

Rejected
: Both fit one base and not another: a base whose records span places keeps its records as its own, and a base whose standing tables are extended keeps tables.toml's part as its own.

About
: follow-by-pin

---


<a id="2026-11-17-summary-and-research-layers"></a>
### Summaries over many records, and research kept aside

Entry date
: 2026-11-17

Done
: Asked by the author. Looked around first (research summary-layer-world and research-aside-world, material in research/summary-layer/2026-11-17/). Added the summaries table and tad r summary; research gains material and supersedes; about leads with the summary and condenses records to ids, says per subject when a summary is due; find, recent and row reach summaries. The entry and README say it. ideal-agent follows idealkb next, and docs takes it with audio-mic's summary.

Considered
: Keeping docs' how-it-stands rows as the summary; a count threshold; a model-written summary on a schedule.

Rejected
: See decisions 2026-11-17-summary-layer and 2026-11-17-research-aside.

About
: summary-layer

---


<a id="2026-11-17-sources-by"></a>
### sources keep who made what they describe

Entry date
: 2026-11-17

Done
: Both followers kept a by on their sources (docs as a field, ideal-agent folded it into takes): the generic sources table and the source record take an optional by. Optional, so a base that follows gains the field with no row changed.

Rejected
: Leaving it to each base (two of two needed it).

About
: standing-tables

---


<a id="2026-11-17-ikb-first-release"></a>
### ikb released (0.1.1) and measured against tad r on the same recording

Entry date
: 2026-11-17

Done
: ikb 0.1.0 failed to attach (the conveyor needs a .deb and an .rpm); 0.1.1 released with binaries, installed by bin/install-ikb.sh with checksums. Measured on one recording (a source, a research with quotes and a material folder, a decision) by two fresh subagents on docs: before (tad r, AGENTS.md + tad statements): 5 tool calls, 1 failed (--about on source), 63.5k tokens, the found text escaped by hand, the dated folder and the decision id chosen by hand. After (ikb, AGENTS.md + IKB.md): 5 tool calls, 0 failed, 65.0k tokens, text from stdin unescaped, --material auto made the folder. Same rows, both canonical. Honest reading: on a lean task the tokens are equal because IKB.md (10.9 KB, now 9.6 KB for docs) is heavier than the filtered tad statements (5.2 KB); what ikb removes is failure, quoting and convention-guessing, not reading. Next: keep the page lean (param lines shortened in 0.1.2), then the upstream notion.

Considered
: Hiding records in the page by name list in idealkb.toml (machine); static clap commands

Rejected
: Adding ikb to docs CI install: a failed download must not block docs landings; verify refreshes IKB.md only when ikb is installed

About
: ikb

---


<a id="2026-11-17-upstream-records-built"></a>
### Upstream records built: upstreams and upstream_items in idealkb 0.8, docs seeded

Entry date
: 2026-11-17

Done
: idealkb 0.8.1 / ikb 0.3.0: tables upstreams and upstream_items, records upstream, upstream-item (from-work checked in SQL, --file auto makes upstream/UPSTREAM/ID/) and upstream-state (refuses an unknown id: a plain UPDATE would have changed nothing silently), queries upstream and upstreams, row/find/recent read them. The gate (followers answer) caught docs lacking the tables: docs declared them first (#217), then followed and was seeded from upstream-queue: six upstreams, eight items, patches and messages copied beside the rows (#221). ikb learned: @- once per call (a second @- silently gave empty text), an empty value counts as not given. Lesson: a second `@-` produced empty required text without an error - guards belong where silent failure is possible.

About
: ikb

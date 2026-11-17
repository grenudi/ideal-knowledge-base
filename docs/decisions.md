<!-- Generated from data/ by tad. Do not edit by hand. -->

# Decisions

<a id="2026-09-22-backlog-as-a-table"></a>
### 2026-09-22-backlog-as-a-table

Date
: 2026-09-22

Decision
: Every base keeps its work ahead as a backlog table (open, in-progress, done), beside its content and rendered like it.

Why
: Carried on 2026-11-17 from text-as-data-template's session_log (backlog-as-a-table), before it retired: everything queryable, versioned and diffable in one place. It grew into the standing tables - backlog, session_log, decisions, research, sources.

Rejected
: A separate issue tracker, or a free-form Markdown TODO file: either splits the record across tools, so it cannot be asked or diffed with the rest.

About
: standing-tables


<a id="2026-11-17-extracted-from-a-working-base"></a>
### 2026-11-17-extracted-from-a-working-base

Date
: 2026-11-17

Decision
: The knowledge-base layer is extracted from a base that already works - linux-phone-oco/docs, one tad database holding every linux-phone record, with the about link and the about query landed and measured - not designed first in the abstract. docs is its first follower.

Why
: text-as-data-template was extracted the same way from the software-engineering canon (its session_log, extract-template-from-working-repo, 2026-09-21; tad's 2026-09-21-extracted-from-a-working-repo): an abstraction is only right once it has met a real case.

Rejected
: Designing the layer first and fitting docs to it afterwards: it would encode assumptions that had not met real content.

About
: follow-by-pin


<a id="2026-11-17-ideal-knowledge-base"></a>
### 2026-11-17-ideal-knowledge-base

Date
: 2026-11-17

Decision
: How to organise a knowledge base is written once, here, as a layer on tad: tad stays the database (tad init starts a bare one); ideal-knowledge-base pins tad's release and adds the rule of file and table, the about link, the generic named queries (about, next, find, row, recent) and records with --about, the standing tables, and one entry under 3 KB. A base follows it by a pinned release. text-as-data-template is split between the two and retired with a pointer. How an agent finds its way in a base is a skill of grenudi/ideal-agent; ideal-project-playbook keeps the process and points here for its standing records.

Why
: The author, 2026-11-17: one general place for how to organise a knowledge base, used by every base, so that agents find what they need instead of reading everything; corrected by him the same day - tad stays a database, the knowledge base is a layer on top - and accepted. The full record, with what was weighed: linux-phone-oco/docs decision 2026-11-17-ideal-knowledge-base.

Rejected
: Renaming text-as-data-template into the knowledge base (folds a database's scaffold into it); putting the layer into tad (tad's concern is the data alone); folding it into ideal-project-playbook (a base is not a software project) or ideal-agent (a base is read by people and the face too); a copied template (copies drift); a spec alone (nothing checks a base follows it); a plugin skill as the vehicle (only Claude agents get it); llms.txt as the entry (it serves outside readers of a site); embeddings (a few thousand rows are answered exactly by a checked link and named queries); a table of questions naming their queries (a second index to keep true); folders per Diataxis kind or PARA bucket (the tables already sort by kind).

About
: generic-queries

Research
: kb-organisation-world


<a id="2026-11-17-follow-by-pin"></a>
### 2026-11-17-follow-by-pin

Date
: 2026-11-17

Decision
: A base follows a release named in its idealkb.toml (version, and own: the generic files it keeps as its own). The generic files are listed in generic: the named statements whole, and AGENTS.md's and tables.toml's part between the lines idealkb:begin and idealkb:end - the rest of those two files is the base's. bin/follow.sh BASE VERSION lays a release; it ends 3 where the base had changed a generic file. bin/update-pins.sh now, run weekly by the lab machine for every base in consumers, moves the pin, runs the five generic queries against the base's data, and lands through the base's CI - or, where the base had its own change, pushes the branch and opens a pull request that is not landed: its diff is the signal to send the change upstream or to name the file own.

Why
: tad's pins are moved the same way (tad's 2026-11-11-pins-moved-by-the-lab): a pull request opened by GitHub's own token starts no CI, and the lab already lands through checks. Marked parts let a base keep its own lines in the same file (the entry's two lines about itself, its own tables) while the generic part stays current. A base's change shown and not landed loses nothing.

Rejected
: A declaration tad includes from another file (a change to tad for one layer, and a base that extends a standing table - docs' backlog has project, needs and proof - could not); vendoring as a git subrepo (the template's way: copies drifted); a GitHub workflow in each base (its pull requests start no CI); overwriting a base's change and landing it when CI passes (the change would be lost, not sent upstream); a Rust tool for the sync now (it copies files and compares them - shell orchestration; a tool when it grows logic); a pin moved with no argument (a script that changes state needs its intent said - practice 8: update-pins.sh now).

About
: follow-by-pin

Research
: kb-organisation-commons


<a id="2026-11-17-the-five-questions"></a>
### 2026-11-17-the-five-questions

Date
: 2026-11-17

Decision
: The generic queries are named for the question they answer, in the words an agent already uses: about (everything known of a subject), next (the work ahead), find (where something is said), row (one record whole) and recent (what was recorded lately). find and recent give ids and first words only; row gives the whole as JSON.

Why
: Measured in docs: the answers are small (2 open items under 0.2 KB, a subject's 18 rows 9.4 KB) when asked by subject; what costs is reading whole rows to find which one. Ids first, then one row whole, keeps every step small.

Rejected
: search (find is the word of grep and of every shell), get or show (they say nothing of what comes back), todo (next says it is ordered), latest or log (recent covers every record table, not the log alone), a single ask command taking a question (a second language beside SQL).

About
: generic-queries


<a id="2026-11-17-summary-layer"></a>
### 2026-11-17-summary-layer

Date
: 2026-11-17

Decision
: A subject's answer leads with its summary: a standing table summaries (about, date, says up to 1500 characters, condenses), one row per subject renewed in place, written by tad r summary, which fills condenses from the records about the subject as they stand. tad q about --subject S returns the summary first, then what was recorded since, the open work and the sources of the research shown, and the condensed records by id on one line (--whole gives them in full; row --id one). tad q about without a subject says, per subject, its records, what they weigh, its summary's date, and summary due - when they weigh over 8 KB with no summary, or over 4 KB were recorded since it. The session that records into a subject renews its summary when due, in the same change; a keeper does it at hand-over.

Why
: The author, 2026-11-17: when one subject gathers many records its answer must not grow without bound; a short how-it-stands sits on top, dated, citing the records it condenses, renewed when they move on. Measured: docs' microphone answer grew from 9.4 KB to 15.9 KB as its records went from 18 to 26. Everyone who keeps living knowledge does this (research summary-layer-world); size is the trigger because a bounded answer is the aim, and 8 KB is roughly two thousand tokens - the answer a fresh session still reads whole.

Rejected
: Rewriting a how-it-stands row as the only copy: it erodes (ACE's context collapse) - the records stay and the summary only condenses. Each summary version kept as a row with supersedes: git keeps the versions, and the records are the history; rows would weigh on find and recent for nothing. A count threshold, as the author offered: what grows without bound is weight, not number - the count is shown beside it. A typed status line each cycle (Cochrane's What's New): what was recorded since is read off the data, never typed (practice 28). A background model on a schedule (Beads): nobody knows a subject better than the session that just recorded into it; it can come later for subjects nobody tends. Condensed records one line each: still about 130 bytes a record, unbounded again; ids alone are a twentieth of it. The author's word how it stands for the table: summary is the plain word with one meaning, and how-it-stands already names docs' itemised hand-over rows, which are records a summary condenses.

About
: summary-layer

Research
: summary-layer-world


<a id="2026-11-17-research-aside"></a>
### 2026-11-17-research-aside

Date
: 2026-11-17

Decision
: A research row is the summary of a research: question, finding condensed, sources, date, about - as it was. It gains material, the dated folder holding its own notes, excerpts and measurements (research/SUBJECT/YYYY-MM-DD/, checked by pattern), and supersedes, the research it is a later version of (checked to exist). Research redone is a new row that supersedes the old: the old stays, reachable by find and row, and leaves about's answer; superseded-by is read off, never typed. The folder is the base's own, never a generic file; nothing loads it but a reader who follows the row.

Why
: The author, 2026-11-17: research must be kept with its sources and links, yet not load every future agent's start. Others keep detail one link away and supersede rather than delete (research research-aside-world). The research table already is the short summary row the author proposed; what it lacked was the link to its material and supersession.

Rejected
: A new table of research summaries beside research: one nature under two names (practice 32). Typing both ends of a supersession, as adr-tools and PEPs do: one end is read off. A folder named by the research id rather than its subject: the subject is what a reader comes from, and the date tells versions apart. Material inside the row: the row is read with every answer about its subject. Scratch kept out of git (ArtCraft's plan/): fine for scratch, but research must keep its sources.

About
: research-aside

Research
: research-aside-world


<a id="2026-11-17-brief-first"></a>
### 2026-11-17-brief-first

Date
: 2026-11-17

Brief
: Every record has a one-line brief and every answer gives briefs; the whole is read only when the task needs it.

Decision
: Decisions and research gain brief, the record in one line of at most 200 characters, required by their named records (a longer one is refused); work, the log and sources have their title as brief. about, find and recent answer with briefs - where an older record has none, the first sentence of what it says - and about --whole true, row --id give the whole. A file opens with its brief, its first paragraph. AGENTS.md's generic part says to read briefs first and deeper only when the task needs it. A follower takes it with the pin; a base that names about.sql its own (linux-phone-oco/docs) carries the change to its own copy.

Why
: The author, 2026-11-17, through ideal-agent: records - tables and files - should all have a brief summary to begin with, read by default; more detail only when the task needs it. Measured here: one subject's about answer 1,965 bytes whole, 273 by briefs.

Rejected
: A brief only per subject (the summary layer condenses a subject, but each record still came whole in every answer). Cutting answers at a fixed width, as find and recent did with 100 characters (a cut is not a brief: it ends mid-word and says less than a sentence). A brief field on every table (work, the log and sources already open with a title that is their brief: a second one would say the same). Briefs filled by a program from the text (the first sentence stands in only for records written before; a brief is written by whoever records, who knows what matters).

About
: brief-first


<a id="2026-11-17-followers-answer-before-release"></a>
### 2026-11-17-followers-answer-before-release

Date
: 2026-11-17

Brief
: A release is tagged only once every follower answers the five queries with main's generic files laid over it

Decision
: The release workflow runs bin/followers-answer.sh now before release-please, on every push to main: each base in consumers is cloned from its main, main's generic files are laid over it by follow.sh with its own files kept, and the five generic queries are asked of its data. While one does not answer, release-please does not run, so no tag is made; a merged release pull request waits, untagged, until the first push after which every follower answers. workflow_dispatch asks it any time.

Why
: Found 2026-11-17: v0.4.0's find and recent read decisions.brief, and linux-phone-oco/docs, which keeps tables.toml as its own, has no brief, so its weekly pin could only fail after the release was out. Proposed by the ideal-agent session, which made 0.4.0. Tried: ideal-agent answers all five; docs does not, for brief. First built as a check on release-please's pull request, it never ran there: a pull request opened with GitHub's own token starts no workflow, and land merged it with no checks.

Rejected
: A check on release-please's pull request (it never runs, for that reason); checking after the release, in the weekly pin (the break is found once followers are already asked to take it); a check on every pull request (a change waiting on a follower would block unrelated work); generic queries that test whether a column exists (SQL that guesses at a base's shape hides what a follower lacks).

About
: follow-by-pin


<a id="2026-11-17-ask-the-task-only"></a>
### 2026-11-17-ask-the-task-only

Date
: 2026-11-17

Brief
: At a task's start an agent asks only about the task's subject and acts; deeper reading only when a step needs it.

Decision
: AGENTS.md's generic part says: at a task's start ask only about its subject (about --subject S, or next --about S) and act; a record whole, a file past its first paragraph, another subject or the list of statements only when a step needs more.

Why
: The author, 2026-11-17: an agent reads only summaries and goes into detail only when its current task needs it. Measured on surya's second keeper (ideal-agent research what-a-started-agent-reads): of 33.5 KB read before its first act, 12.1 KB was tad's help and 9.4 KB one subject whole.

Rejected
: A list of what not to read (an agent reads what it is pointed at; the entry points at the one question to ask first).

About
: brief-first


<a id="2026-11-17-ikb-run-time-from-records"></a>
### 2026-11-17-ikb-run-time-from-records

Date
: 2026-11-17

Brief
: ikb: one pinned binary builds each base's record commands and man page from its records/*.sql at run time; no fork.

Decision
: ikb is one released Rust binary (crate ikb/ in idealkb, command line declared with argenv, tad's statements library pinned) that is run in a base and reads that base's own records/*.sql at run time: every record becomes a subcommand with its header's typed options, and the contract and man page are built from those headers. What it adds over tad r: per-record help and one man page written to IKB.md; long text from a file or stdin (--NAME-file, - for stdin) so no shell quoting; id made from the brief when none is given; `about`, project and brief length checked before the run, with the accepted values named; research --material creates and names research/SUBJECT/YYYY-MM-DD/; canon and render run after every record and say one line; --by from OCOECO_BY. It does not parse SQL itself, hold any table, or re-implement tad: it calls tad. A base extends ikb by adding records/*.sql, never by forking code. Per-record --help and completion of enumerated values belong in tad (backlog on tad); ikb help NAME covers it until then.

Why
: Measured 17% of tad r calls failed, 14 of 41 failures only asked --help, 100 of 240 calls carried long text through shell quoting, and canon/render printed 74 KB. docs already overrides five generic records (--project), so a fixed generic CLI would be wrong for it; reading records/*.sql at run time makes each base's difference automatic and keeps pulls trivial because nothing is copied.

Rejected
: Rhizoid/rhizcut fork of the ikb crate into each base: a fork is for patching code, and bases differ only in records, which are data - a fork would carry a Rust workspace into every knowledge base and make every pull a merge; rhizoid stays the way for a base that really must patch ikb's source. A library plus a thin per-base binary: still a build per base. Plugins: a loading mechanism for what a SQL file already declares. Static subcommands generated at build time: a new record would need a release. An MCP server over the CLI: adds schema and context cost; the man page is the interface, MCP can wrap ikb later. Sequential ids (adr-tools): collide across branches; ids are slugs of the brief. $EDITOR flows: not for agents.

About
: ikb

Research
: ikb-friction-and-world


<a id="2026-11-17-upstream-two-tables"></a>
### 2026-11-17-upstream-two-tables

Date
: 2026-11-17

Brief
: Upstream work is two tables, upstreams and upstream_items, one shape for any upstream and any form; ikb adds them.

Decision
: idealkb gains `upstreams` (where knowledge can flow: kind code-project|list|tracker|wiki|standard|person-team|kb-instance|distro, address, how contributions are made, contacts) and `upstream_items` (each thing headed somewhere: form patch|information|correction|question|finding; state draft, ready, sent, under-review, changes-requested, accepted, landed, held, rejected, superseded, not-needed, withdrawn; from_work linking back to a backlog item, decision or research, checked by the record; domain, tags, about, local_ref, file, sent_on, forwarded, bug, version, supersedes, applied_upstream, waits). Records upstream, upstream-item (--file auto makes upstream/UPSTREAM/ID/ for a patch or a long message) and upstream-state; queries `tad q upstream` (what waits, longest first) and `tad q upstreams`; ikb generates the commands. Another idealkb instance is an upstream of kind kb-instance: a general improvement made in a domain base goes upstream to idealkb the same way.

Why
: One shape serves a project, a list, a wiki, a standard, a person and another knowledge base; the item's form says what it is. The state only moves forward and the person's word that a draft may go is the state ready, so an agent never sets a consent flag. A row holds what is queried; the patch or message stays a file beside it. Measured need: docs' six upstream-* items know only open/in-progress/done, and destinations, contacts and send commands live in a README outside git.

Rejected
: A second tracker next to the backlog (the queue repo grown into one): two sources of truth drift. Only an upstream column on backlog items: a patch sent in several versions has nowhere to go and no state beyond open/done. Item files with front matter indexed into a table (DEP-3 style): an indexer and two truths; the row stays the truth and the file holds what prose cannot. One kind per upstream (git, wiki, standard): the differences are the form and the how-text, not the shape. Mirroring the remote tracker's status or review threads: link the archive instead. A separate state machine for following an upstream (Renovate): another direction, another table when needed.

About
: ikb

Research
: upstream-records-world

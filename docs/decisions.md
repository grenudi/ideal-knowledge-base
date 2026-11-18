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


<a id="2026-11-17-ikb-help-first-completions-asked"></a>
### 2026-11-17-ikb-help-first-completions-asked

Date
: 2026-11-17

Brief
: An agent starts with ikb --help and ikb help RECORD; IKB.md is for people; completions ask ikb as you type.

Decision
: An agent starts with `ikb --help` (every record of the base, one line each) and reads `ikb help RECORD` for the record it needs (about 0.8 KB); IKB.md stays as the page for people to browse. `ikb completions bash|zsh|fish|nushell` prints a small glue script; at completion time the shell asks `ikb complete --cur=WORD WORDS...`, which answers from the base's own records (record names, each record's options not yet given, `auto` after --material/--file, shell names) - so the completions are never out of date and never written by hand. The help, the man page, IKB.md and the completions all come from the same records (the argenv contract of the fixed commands plus the run-time records); only the four glue scripts are text. bin/install-ikb.sh writes the completions for the shells it finds.

Why
: Measured by the second before/after: agents read what the skill sends them to; sending them to the 10-13 KB IKB.md (every record concatenated) made their start as heavy as reading tad statements, whereas `ikb --help` plus one `ikb help RECORD` is about 2-3 KB. The author's intent: ikb explains itself through generated help, a man page and completions.

Rejected
: argenv's own completions generator for the whole script: it writes the record names into the script at generation time, so a script made in one base is wrong in another and stale after a new record (tad avoids this only for positional words through `asked`; ikb's records are subcommands, not positionals). Writing completion words by hand per base. A fifth, base-specific completion file in each base.

About
: ikb

Research
: ikb-friction-and-world


<a id="2026-11-17-no-ikb-md"></a>
### 2026-11-17-no-ikb-md

Date
: 2026-11-17

Brief
: IKB.md is not kept anywhere; ikb page only prints; help, man page and completions are generated on demand.

Decision
: IKB.md is not kept in any base. `ikb page` only prints the one page (for people: `ikb page > page.md`); the `--write` option is gone, docs' verify no longer refreshes it, AGENTS.md points at `ikb --help` and `ikb help RECORD`. The man page, the help, the page and the completions are all generated on demand from the records, never stored.

Why
: Nothing read it that the help does not serve: agents go to ikb help RECORD, people can open the record headers in records/*.sql on GitHub or run ikb page, CI checks nothing about it. A committed copy of every record header drifts with each record and each wording change (five regenerations in a day), adds a 9-13 KB file to the read path wherever a skill points at it, and needs ikb in CI to be kept honest, which the orchestration rightly refuses. The author doubted the file needs to exist; the measurement agrees.

Rejected
: Keep IKB.md as a committed page for people, refreshed by verify: a drifting duplicate of the SQL headers, and only honest when ikb runs in CI. Generate it at publish time into the Pages site: no one asked for it there; ikb page can feed it if someone does. Keep `ikb page --write`: a writer of a file nobody reads. Hand-writing any of it: the man page, help, page and completions come from the records.

About
: ikb

Research
: ikb-page-file-readers


<a id="2026-11-17-commons-and-unit-bases"></a>
### 2026-11-17-commons-and-unit-bases

Date
: 2026-11-17

Brief
: A commons base plus one open base per unit (device); the commons pulls and derives progress, never copies or types it.

Decision
: A commons base and one open base per unit (here: per device). 1. A device base (a repository made from device-template: surya-lab, google-walleye-lab, a third device) holds everything about that device: its queue (backlog with needs and waits), its log of tries, measurements (test_runs, test_results), decisions and research about that device, the sources it used, and its parts: one row per part of the device with a status, the evidence for it (a run id or link) and the date. It follows idealkb (pinned) and runs ikb like any base; its next item is its own `tad q next` (and `phone-queue` for its keeper). 2. docs holds only what helps every device: concepts, the components/features catalogue, the landscape, general decisions and research (dt-any-phone, how knowledge bases work), shared sources, the tests catalogue, the lab tooling (lab-tools), and a registry of devices (id, name, SoC, the address of its base, the template version). Support status and progress for a device are derived, never typed in docs: a feed record pulls each registered base's `parts` table over HTTPS in CI (feeds.yml), validates it against the contract the template declares, and fills support_status and feature_support with the device's own claim, its evidence link and its date; a device that has not declared a part, or whose base is unreachable or stale, shows "not known yet". docs never copies a device's queue, tries or measurements. 3. A third device is made from device-template (the template carries tables.toml, the idealkb pin, ikb, device.toml and tests); adding it to docs is one `ikb device` record with the base's address. 4. Moving today's mixed records: by the `device` field on backlog (docs 260) and by the project of the row - the rows of surya-lab and google-walleye-lab, docs' own device-named backlog/research/decisions/log, test_runs and test_results move to the device base, replayed record by record with their ids; general rows stay. A cross-reference from a device row to a docs concept is written `docs:ID` in text, since the references rule works within one base. 5. Lanes and launchers: a launcher for a device works in that device's repository and asks its base (`tad q next`, `lane-next` there); docs' lane-next stays only for the general queue; the observatory already reads each repository's oco.toml exports for the cross-device picture. 6. This supersedes decision 2026-11-17-one-database for devices only: docs and its lab tools stay one database; devices get theirs.

Why
: What is true of every large open project read: the commons holds schema, rules and process, each unit its own files and its own claim, and the commons derives by pulling - a status typed in both places drifts. Measured here: 40 of docs' own 81 backlog items, 34 of 49 research rows and 14 of 28 decisions name a device; test_results is 1.3 MB of docs' 2.0 MB; the keeper's landings every few minutes conflict whole-file in docs' data; a device is opened by other people as data (surya, walleye are forks of the template), and the author wants docs to hold only general knowledge useful to all devices. The `device` field and lane-next (docs 260) separate the lanes at no cost and stay until the move, but do not lighten docs or its conflicts.

Rejected
: Keeping one database with a device field and lane-next: tells lanes apart, leaves the weight, the keeper's conflicts and one commons holding every device's work - the author's clutter. Per-device status typed in docs and in the device (two copies): drifts. Embedding device repositories in docs as git submodules or subtrees: copies the work, history and drift in. A GitHub template repository with no link back: no way to bring later template changes (the idealkb pin carries the generic part; the rest is a backlog item). Deriving status from CI results only (option C): a phone cannot run in CI, most parts would stay unknown. A push from each device into docs: needs a credential in every device base and a writer in docs' data; pull needs none. Superseding one-database wholesale: its reasons (two tools writing one database, glimpse conflicts) still hold for docs and its tools, which stay one database.

About
: ikb

Research
: commons-and-unit-bases-world


<a id="2026-11-17-ikb-set-and-remove"></a>
### 2026-11-17-ikb-set-and-remove

Date
: 2026-11-17

Brief
: ikb set and ikb remove change or take away one existing row of any declared table, checked; no tad sql by hand.

Decision
: ikb gets two fixed commands: `ikb set TABLE --key K [--key K2] --field NAME=VALUE ...` changes fields of one existing row of any declared table, and `ikb remove TABLE --key K` takes one row away. Both read the base's own tables.toml: a missing or wrong table lists the tables with their keys, a wrong field lists the fields with their allowed values, a key of several fields says how many --key values and in what order, a row that does not exist is refused (adding is its record's job), an enum value outside its list says the list. tad checks every rule before a change is kept (tad::set puts the file back; a removal runs through tad sql, which does the same); canon and render run after. A named record is kept for what is said in several fields at once (backlog-status, backlog-needs, part). The roles session's idea of a hook that refuses `tad sql` writes belongs in ideal-agent's guard, with this as its message.

Why
: Measured by the roles session (ideal-agent research work-struggles, 41 transcripts of 2026-11-17): 56 hand-written tad sql writes past the named records in 13 sessions - backlog status/waits/note 22, decisions 8, sources deleting and updating 9, practices 5, test_results inserts 4, research deletes 2, subjects inserts 2. About 41 of them are one field of one row or one removal in idealkb's standing tables; a record per field and table would be dozens of statements, most unused; one generic checked command is one thing to learn and its errors teach the tables. tad already has the checked set (tad set TABLE --key K --set F=V) but with no help for tables, fields or values and no refusal of an absent row - agents reached for sql instead.

Rejected
: One named record per table and field (backlog-waits, source-remove, decision-about ...): dozens of statements, base-specific, most never used. A generic SQL record taking table, id, field and value: a table or a column cannot be a parameter of a named statement, and the values would not be checked against the declaration. Adding a generic backlog-status to idealkb: docs and the device template already keep their own (with project or without), so it would only create drift in their own lists; ikb set covers its waits. Leaving tad sql allowed with a warning: the agents' route of least resistance stays. Putting the command in tad: tad is released separately; ikb already reads the declaration, and tad::set is what it calls.

About
: ikb

Research
: tad-sql-hand-writes


<a id="2026-11-17-chain-follow-by-slice"></a>
### 2026-11-17-chain-follow-by-slice

Date
: 2026-11-17

Brief
: One pin-and-follow mechanism for the whole chain; improvements go back as PRs recorded as upstream items; rhizoid gets a slice mode.

Decision
: One mechanism, the one idealkb already has, for the whole chain: a source repository names what it gives (`generic`), releases by tag, and each follower pins a release and takes the slice with bin/follow.sh, weekly through update-pins and its own CI, ending 3 when a follower changed a generic file. idealkb is the source for every base (device bases are consumers of idealkb directly, like docs); device-template becomes a second source for the device layer (the parts contract, devices, phone queries, test-run) with its own `generic` list and releases, taken by device bases through the same script; follow.sh and update-pins.sh learn to take the source from the pin file (backlog). Pushing back: a general improvement made in a base or the template is a pull request to the source repository from the base's branch, recorded in the base as an upstream item (ikb upstream-item, form patch, --file auto for the patch or message, state draft, ready on the person's word, sent with the PR address as forwarded, landed when released). First-class upstreams: every device base ships two upstreams rows - idealkb (kind kb-instance) and device-template (kb-instance) - seeded in the template's data/upstreams.json, so the links are visible and queryable (tad q upstreams); docs records idealkb the same way. rhizoid stays the tool for forking whole repositories to patch them (linux-phone-oco/linux of sm7150-mainline/linux, tad-engine, argenv); what it lacks for this chain - a consumption mode for slices - goes on git-rhizoid's own backlog (slice-consumption), with follow.sh as its prototype, rather than worked around.

Why
: The mechanism exists, is in use for two bases, has a drift verdict (exit 3), a gate on release and a weekly job, and is source-agnostic in follow.sh. What flows is a slice laid into a repository with its own data, which none of rhizoid (whole forks; consumption side undesigned; CLI stubbed), subtree (needs a prefix), Copier/cruft (Python, a second state file) or Renovate (bumps numbers) does. Making the links visible as upstreams rows costs two rows and uses what was built today.

Rejected
: Every device base as a rhizcut (a fork) of idealkb or the template: drags the source's crate, data, research and release files into each base, and a base cannot follow two forks. git subtree or submodule: the generic files must sit at the base's root where tad reads them. Copier or cruft: Python, which the practices refuse for new tools, and an answers file beside idealkb.toml. Renovate as the updater: it can bump the version line but the files have to be laid by follow.sh anyway, which update-pins already does with its own CI. A new `ikb follow` that fetches its own standing parts at run time: attractive later (no clone with tags needed) but the weekly job works; kept as backlog. Waiting for rhizoid to be implemented: its consumption side is undesigned and the CLI stubbed; the chain is needed now.

About
: ikb

Research
: chain-follow-world


<a id="2026-11-17-blocked-by-clears-itself"></a>
### 2026-11-17-blocked-by-clears-itself

Date
: 2026-11-17

Brief
: A wait on an item of the same base is named in blocked_by and clears itself when that item is done; waits stays free text for outside things.

Decision
: A wait on another item of the same base is named, not described: backlog gets `blocked_by` (ids of this base's items, comma-separated, pattern-checked; the records refuse an id that is no item) beside `waits`, which stays free text for what is outside the base (the author, a SIM card, hardware) and may no longer be empty (pattern). An item is clear when `waits` is empty and every item in `blocked_by` is done: phone-next and phone-queue read that off the data (the queue shows `blocked_on`, the items still open), so nothing is typed again when the blocking item is done. Records: backlog (--blocked-by) and backlog-blocked (set or take away). Landed 2026-11-17 in device-template and in surya-lab and google-walleye-lab, with the waits that were plainly item ids migrated (3 and 8 rows); the other waits stay as written. docs' own lane-next, phone-next and phone-queue and idealkb's generic backlog are not changed yet (their tables are the bases' own).

Why
: Three times today a phone lane stalled on a stale wait - an empty string read as waiting, and twice an item still waiting on one already done - and each time a coordinator re-entered the row by hand. Practice 28: what an item waits on is read off the data, not typed as a state to keep true. The waits already in the two device bases named items in 3 and 8 rows (exactly an id, or a comma list of ids), so the shape was already in use; prose that merely mentions an id (for example 'walleye-ufs-readonly (not required) / walleye-first-fastboot-boot; a person witnesses...') stays free text because a query cannot read intent from prose.

Rejected
: Reading ids out of the free text of waits: brittle (prose mentions ids without waiting on them). One field that holds either an item id or text, told apart by whether an item of that id exists: an item later created with that id changes what an old row means. A referenced field per wait (tad's references rule): a wait can name several items and the rule checks a single value; the record checks the list instead. A mutually exclusive pair enforced in the declaration: tad has no such rule; the queries read both. Changing the generic backlog of idealkb now: docs and the device bases own their tables, so the generic next query would fail where the column is missing; it follows once every base carries it.

About
: ikb

Research
: stale-waits


<a id="2026-11-17-principles-cited-not-restated"></a>
### 2026-11-17-principles-cited-not-restated

Date
: 2026-11-17

Brief
: A base keeps its principles as a few concept rows with stable ids; guides cite by link, the citation is checked, restating is measured.

Decision
: A base's founding principles are a small numbered set (at most about ten) kept once, as rows of its concepts with a stable id, a one-line statement and a why; where a principle rests on a general practice it cites that practice by number, not by its words. Briefs, guides and other repositories' AGENTS.md cite a principle by a link to its anchor and never restate it. Two checks keep that honest: the citations resolve (a dead id or an uncited principle fails, in the base's verify) and the restating is measured (overlay-check with the principles' text as an extra base). A principle whose meaning changes gets a new id; the old row stays. A decision or work that rests on a principle names it in --about, so tad q about --subject ID lists what rests on it. First used in linux-phone-oco/docs (decision 2026-11-17-principles-are-concepts-cited-by-id).

Why
: Durable charters (Debian's Social Contract and DFSG, the Mozilla Manifesto, Wikipedia's five pillars, Rust's API guidelines) are small, on one page, with short stable ids that are link targets; none enforces cite-not-restate mechanically, so the link is checked and the restating measured. Rows render with anchors and show on the face already, so no new page or table is needed.

Rejected
: A free-standing manifesto file: prose nobody can cite by id, no check, no face. A table of its own for principles: a second kind of concept. Versioned texts: ceremony at this size. Making it a generic idealkb table now: one base uses it; extract when a second does.

About
: ikb

Research
: charter-pattern-world


<a id="2026-11-18-updates-fail-loudly"></a>
### 2026-11-18-updates-fail-loudly

Date
: 2026-11-18

Brief
: An update that matches no row or changes nothing is refused: ikb set, every update-only record, and backlog-needs keeps what is not given.

Decision
: An update that does nothing is refused, not shown as done. ikb: `ikb set` refuses a change the row already has ("nothing changed: backlog (x) already has rank=2"); a record whose statement only updates (UPDATE with no INSERT) is refused when tad printed no `changed:` line, which is when no row matched or nothing differed. Records: backlog-needs keeps what is not given - re-ranking is `--rank` alone and leaves what the item needs alone, `--needs none` takes it off every queue (before, a missing --needs cleared it, so a re-rank silently dropped the item off the phone queue); it and hardware-status refuse a call that gives nothing to change and a --needs outside phone, research, build or none. The existence guards of upstream-state, backlog-blocked, hardware-status, backlog-status stay. Landed in device-template, surya-lab and google-walleye-lab; idealkb's generic records already guard.

Why
: The Top Coordinator reported two backlog items in google-walleye-lab that 'silently failed to re-rank' so a builder kept taking the wrong item; docs had a status write that matched no row and still said recorded. Reproduced on a scratch base: `backlog-needs --id a --rank 2` without --needs set the rank and cleared needs, taking the item off the phone queue; tad prints `changed: TABLE` only when it changed something, so an update that matched nothing printed nothing and ikb said recorded.

Rejected
: Failing every record that changes nothing: an INSERT that replaces a row with itself is idempotent and harmless; only updates promise a change to an existing row. Making `set` print a warning: a message among others is what was missed. A guard in each SQL record only: new records would forget it; ikb checks every update-only record by what tad reports. Clearing needs by omission kept for compatibility: it was the trap.

About
: ikb

Research
: silent-noop-updates


<a id="2026-11-18-carry-is-a-place-not-a-state"></a>
### 2026-11-18-carry-is-a-place-not-a-state

Date
: 2026-11-18

Brief
: A patch carried in a fork names the fork (carried_in); sent/accepted/landed stay the state; fork_of links a fork to its upstream

Decision
: upstream_items gains carried_in (fork id/branch) and reviewed_by; upstreams gains fork_of; tad q carried says keep, drop at the next rebase, or ask why; upstream-state --carried-in none ends the carry; followers-answer asks upstream, upstreams, carried too; bin/test-upstream.sh follows a patch from sent to dropped in CI. The fork keeps no base: its rows live in the base of the lane that works on it, and any base reads the same queries.

Why
: DEP-3 and Yocto keep the patch in the package whatever the upstream says; b4 keeps replies' trailers per patch. Our one state word could not say 'accepted upstream but still ours until a release' (sxmo accepted, thank you). A place beside the state tells it without a thirteenth state.

Rejected
: a state 'carried' (loses sent/accepted); a base inside every fork (forks stay cuttings of their upstream, the research chain-follow-world); one row per version of reviewers (b4's per-message provenance - too heavy until a base needs it); Yocto's one-word Upstream-Status alone (no place, no reviewers).

About
: ikb

Research
: upstreaming-and-carry-world


<a id="2026-11-18-decisions-are-superseded-not-edited"></a>
### 2026-11-18-decisions-are-superseded-not-edited

Date
: 2026-11-18

Brief
: A decision is superseded or amended by a later row, names who it binds and the item carrying it out; where it stands is read off the work (tad q decided)

Decision
: decisions gains supersedes, amends, scope, tracked_by; ikb decision takes them and refuses unknown ids; tad q decided says superseded, carried out, in work or no item named; about leaves superseded decisions; AGENTS.md says so; followers-answer asks decided; bin/test-decisions.sh follows one decision to superseded in CI. No proposal state, no comment period, no typed back-link, no decider field.

Why
: RFC 'Obsoletes/Updates', PEP 'Replaces/Superseded-By', MADR 'superseded by' and Rust's tracking issue agree: an old decision stays and says what replaced it, and what carries it out is a link. Our own practice 28 (states are read off the work) rules out typing Draft/Accepted; practice 12 says a decision with no item named is not known yet, not undone.

Rejected
: a status field with proposed/accepted/deprecated (a state to keep true); a final comment period (sessions message each other and waits already holds a sign-off); typing Superseded-By on the old row (a second link that drifts - the other direction is a query); a links table of all kinds (one table for four fields most records never use); editing decisions in place (loses what was decided then).

About
: ikb

Research
: rfc-systems-world

Scope
: every base that follows idealkb; ideal-agent skills (record-the-work)

Tracked by
: decision-links-everywhere


<a id="2026-11-18-followers-follow-each-release"></a>
### 2026-11-18-followers-follow-each-release

Date
: 2026-11-18

Brief
: update-pins runs hourly over every base that follows, each in its own worktree; consumers lists the device bases too

Decision
: The lab timer runs update-pins hourly (it ends at once for a base already current); consumers names docs, ideal-agent, device-template, surya-lab, google-walleye-lab; each base is followed in a scratch worktree, never the clone sessions share. The unit files are kept in packaging/systemd.

Why
: ideal-agent's roles session: nine releases in two days against a weekly job; three device bases sat at 0.9.1 because consumers was hand-kept. Releases come from GitHub and the job needs the lab's token and land, so the lab polls; a release-workflow trigger would put the lab token in CI.

Rejected
: running update-pins from the release workflow (the lab token and land are on the lab); a path unit (no local file changes on a release); deriving followers from idealkb.toml files or an upstreams row (needs a list of repositories to search first; GitHub code search is rate-limited) - kept as backlog followers-derived.

About
: ikb


<a id="2026-11-18-one-ready-query"></a>
### 2026-11-18-one-ready-query

Date
: 2026-11-18

Brief
: tad q ready --for keeper|builder|research is the one picking query of every base: no outside wait, blockers done, hardware owned; each skipped item says why

Decision
: queries/ready.sql in the generic slice, with backlog needs/proof/rank/hardware and the hardware table made generic so it binds everywhere. A done blocker is clear, an unheld blocker is not (said so), waits is not ready, hardware not owned or refuted is not. --show ready gives the picks. Briefs name it and carry no picking SQL (ideal-agent 0.3.40). bin/test-ready.sh holds it in CI; the release gate asks it of every follower.

Why
: Three picking queries differed and two signs were seen: a raw-SQL builder took an item waiting outside the base, and lane-next ignored blocked_by. Taskwarrior and Beads agree a done blocker clears and a blocked listing says why.

Rejected
: urgency scoring (the author's rank orders the queue); each base keeping its own next/phone-next/lane-next (the sign again); resolving a blocker across bases now (needs a link kind; backlog ready-across-bases); refusing the whole query when a blocker is unheld (one bad row would hide the queue - it is skipped with its why).

About
: ikb

Research
: ready-query-world

Scope
: every base that follows idealkb; ideal-agent skills and briefs (keep-a-shared-resource), orchestration's builder.md

Tracked by
: ready-query-everywhere

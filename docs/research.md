<!-- Generated from data/ by tad. Do not edit by hand. -->

# Research

<a id="kb-organisation-world"></a>
### kb-organisation-world

Date
: 2026-11-17

Question
: How do open practice and agent makers organise a knowledge base so that people and agents reach what they need without reading all of it?

Found
: They agree. (1) One small entry that is always read and routes onward, saying what each target is for: llms.txt, the root AGENTS.md (nearest wins), PhotoCraft's Read/Why orientation table, Johnny.Decimal's index, datapackage.json. (2) What is always loaded is kept small: CLAUDE.md under 200 lines, no more than ten per level, llms.txt's skippable Optional. (3) Detail in stages: Skills' name and line, then body, then linked files; Claude Code loads nested CLAUDE.md only when its subtree is touched; context engineering keeps lightweight identifiers - paths, stored queries - and loads content just in time. (4) Small units with stable addresses: evergreen notes whose titles work like APIs, numbered ADRs, Wikidata's Q and P ids. (5) Facts apart from explanation: Diátaxis' reference against explanation, Wikidata statements and infoboxes beside prose. (6) One decision per record, superseded rather than deleted (Nygard, MADR). (7) Every statement is about an item by its id and cites who says so (Wikidata). (8) Views are generated from the source data (PhotoCraft's scorecard, Mintlify's llms.txt). Tensions: hierarchy against association (fixed buckets vs dense links - a small fixed index with free links beneath answers both); one file against many (concatenation does not save context; loading on demand does). No source measured how much any of it speeds an agent - the measure here is docs' own (kb-navigation-measured). (Carried from linux-phone-oco/docs, where it was made, on 2026-11-17.)

Sources
: diataxis,llms-txt,agents-md,nygard-adr,madr,frictionless-data-package,docs-as-code,evergreen-notes,johnny-decimal,para-forte,wikidata-statements,wikipedia-infobox,anthropic-context-engineering,anthropic-agent-skills,claude-code-memory,photocraft-agents-md,mintlify-llms-txt

About
: file-or-table


<a id="kb-navigation-measured"></a>
### kb-navigation-measured

Date
: 2026-11-17

Question
: How much must an agent read in docs today to answer a typical question, and what would an entry and a link cut it to?

Found
: Measured on main 2026-11-17 (bytes; about 4 per token). What is known of surya's microphone: there is no checked link from a record to what it is about - research, backlog and session_log have no such field, and decisions' about is free text in four spellings (microphone, features:microphone, linux-phone-oco/docs/features:microphone, a milestone id) and empty on 12 of 38. So an agent reads pages - research, decisions, backlog, support_status, feature_support: 206 KB, about 52k tokens - or greps data/ (79 KB of matched rows, noisy). The answer itself is 18 rows, 9.4 KB, about 2.3k tokens: 22 times less, but only reachable today by knowing the ids. What to do next on the modem: the backlog page is 84 KB (21k tokens); tad q backlog prints 327 KB in its box format (37 KB as csv) for all places; the answer is 2 open items, under 0.2 KB - found today only by matching words in titles. How to record a decision: tad statements answers it with every parameter in 3.5 KB (0.9k tokens), and practice 42 says it at session start - this one is already good. The entries: AGENTS.md (7 KB) is how to edit the data (setup, rules, recipes), not where knowledge is; README names 6 of 29 tables; the rendered index lists tables by count. Every session also reads 21 KB at start (practices and inbox). The rendered pages are 1.46 MB in all, 1 MB of them test_results. So the weight is not the entry files but the lack of a subject link: with an about link checked on every record table and a query about SUBJECT, the first two questions are one call of 2-10 KB. (Carried from linux-phone-oco/docs, where it was made, on 2026-11-17.)

Sources
: text-as-data-template

About
: about-link


<a id="kb-organisation-commons"></a>
### kb-organisation-commons

Date
: 2026-11-17

Question
: What in the commons already does part of an ideal knowledge base, and would idealkb be one nature under a second name?

Found
: tad (creation-guidelines/tad-engine) is the engine: tables declared as data after Frictionless Table Schema, checked rows, canonical files, SQL, named queries and records with their header line as their description (tad statements is already an index of every question and record a base keeps). text-as-data-template is the template for a base kept as tad data - the same nature as idealkb - and has drifted: last changed 2026-11-04, still the vendored Python engine on a DuckDB schema that every base left on 2026-11-11 (as the vendored engines had drifted, three of four behind). ideal-project-playbook is how to run a software project - the loop, guards, CI, honesty - whose own docs/ is a tad base; its kit/templates for backlog, development log and idea page are records a base keeps as tables, and its findability test (real questions, the answer within the first three) is the measure a base needs. software-engineering-canon is a base itself (the spike the template came from). ideal-agent (grenudi/ideal-agent, 2026-11-17) is how agents work: practices, skills, hooks, and its own tad base; it keeps only what is general and leaves a project's domain in the project's data. ocoeco's marks (oco.toml exports, holds) and lenses say how a base fits the observatory's picture - its face, not its organisation. linux-phone-oco/docs is one tad base for every linux-phone place (2026-11-17-one-database), with prompts/ (role briefs), research/ (long prose), and rendered docs/ the face reads. Overlap: idealkb would be text-as-data-template under a second name; nothing else holds how knowledge is organised. Gap: no base links a record to what it is about, and no base has an entry that routes questions to queries. (Carried from linux-phone-oco/docs, where it was made, on 2026-11-17.)

Sources
: text-as-data-template

About
: follow-by-pin


<a id="summary-layer-world"></a>
### summary-layer-world

Date
: 2026-11-17

Question
: When one subject gathers many records, how do others keep a short, dated how-it-stands on top - when is it renewed, and by whom?

Found
: They agree on the shape and disagree only on the trigger. A dated summary on top that stands on its own and links what it condenses: Cochrane's abstract and What's New, Wikipedia's lead and Main link, PhotoCraft's ROADMAP, a skill's description. Two speeds: a cheap line every cycle (Cochrane: searched, N pending, conclusions stand) and a rewrite only when conclusions would change, or on a size, age or batch trigger (Wikipedia 8,000 words of prose; Beads 10 closed issues 30 days old; skills 500 lines). Nobody has a numeric threshold for an important change (Cochrane says so). Whoever changes the detail renews the summary (Wikipedia: child first, then the parent's summary; Cochrane's authors); a background model only where nobody is at hand (Beads), and then only if shorter, the original kept. The detail is never thrown away: rewriting one summary as the only copy erodes it (ACE's context collapse). Risk: summaries go stale - Wikipedia's Sync tag; more than half of living reviews never update.

Sources
: cochrane-lsr-guidance,elliott-lsr-2017,wikipedia-summary-style,wikipedia-article-size,wikipedia-lead,beads-compaction,photocraft-agents-md,claude-code-skills,ace-context-collapse,anthropic-context-engineering

About
: summary-layer

Material
: research/summary-layer/2026-11-17/


<a id="research-aside-world"></a>
### research-aside-world

Date
: 2026-11-17

Question
: How do others keep research with its sources but out of everyday reading - dated versions, the latest first, the old superseded but reachable?

Found
: Supersede, never delete: the old version stays, marked, out of the default reading, and points at its replacement - Nygard's ADRs, adr-tools (both directions), MADR's status, PEP 1's Superseded-By and Replaces, RFC Obsoletes. Detail one link away from what is read every day: Wikipedia's Main article, a skill's reference files, ArtCraft's dated raw evidence beside its summary (docs/performance/2026-09-26-*.json); scratch can stay out of the record entirely (ArtCraft's git-ignored plan/). No common practice of a dated research/YYYY-MM-DD/ folder was found - not known yet; ArtCraft's dated evidence files are nearest. In idealkb the research row already is the short summary the proposal asked for (finding, date, sources); what it lacked was a link to its material and a way to be superseded.

Sources
: nygard-adr,adr-tools,madr,pep-1,artcraft,wikipedia-summary-style,claude-code-skills,gastown

About
: research-aside

Material
: research/summary-layer/2026-11-17/


<a id="ikb-friction-and-world"></a>
### ikb-friction-and-world

Date
: 2026-11-17

Brief
: Recording costs 17% failed tad r calls and shell quoting; others declare an entry once and derive flags, help, man.

Question
: What do agents spend on recording into a tad base, what exists, what do others do, and what does ikb add over tad r?

Found
: Measured on 31 transcripts of 2026-11-17: 240 tad r calls, 41 failed (17%), 8.4 tool calls and ~11k tokens per failure. Causes: missing parameter 7, doubled project prefix 5, brief over 200 chars 5, duplicate source id 4, SQL/apostrophe 6, shell parse 5, material path not a folder/status 3, '--help is not a declared flag' 14 (9 sessions). 100 of 240 calls carry 2-10 KB of text in double quotes, 46 in heredocs; 74 KB of canon/render chatter. Before the first good record agents read ~9 KB (statements 0.6 KB, SQL 1 KB). Exists: tad r runs named statements with typed params and defaults from the header comment, tad::statements is a library, tad prints no per-record help; argenv Record is an owned run-time struct, so a contract and man page can be built from headers at run time. World: git notes, adr-tools, log4brains, Taskwarrior UDAs, hugo new: one declaration gives flags, defaults, validation, templates, dated names; agent guidance: few tools, errors that steer.

Sources
: git-notes,adr-tools,log4brains,taskwarrior-udas,hugo-new-content,writing-tools-for-agents

About
: ikb

Material
: research/ikb/2026-11-17/


<a id="upstream-records-world"></a>
### upstream-records-world

Date
: 2026-11-17

Brief
: Upstream work everywhere is two things: where it can go, and what was sent with a forward-only state, linked back to its origin.

Question
: What one general shape records upstream work (any external resource, any form) so that linux-phone-oco/docs can follow it instead of a second tracker?

Found
: DEP-3, the kernel trailers, Debian's BTS and Launchpad converge on an origin, a forwarded-to address, a link to the report and an applied-upstream marker; Patchwork and IETF errata give states (new/under review/accepted/rejected; reported/verified/held/rejected); OSM notes show a light question-or-information form with no patch; Renovate shows that following an upstream is another direction. Here the upstream-queue repo keeps patches and send commands in a README outside git, and docs' six upstream-* backlog items know only open/in-progress/done - nothing says sent, awaiting review, or links an item to its file, branch or PR. Shape taken: upstreams (id, kind, name, address, how, contacts, notes) and upstream_items (upstream, title, form patch|information|correction|question|finding, state draft..landed with side exits, from_work, domain, tags, about, local_ref, file, sent_on, forwarded, bug, version, supersedes, applied_upstream, waits, note, last_update). Not read: Patchwork's real state list, Launchpad/Fedora/Alpine trackers, wikis and standards processes beyond OSM/IETF errata/Wikidata, linked-vault tools.

Sources
: git-notes

About
: ikb

Material
: research/upstream/2026-11-17/


<a id="ikb-page-file-readers"></a>
### ikb-page-file-readers

Date
: 2026-11-17

Brief
: Nothing needs IKB.md: agents use ikb help, people the record headers or ikb page, CI checks nothing; it drifted five times a day.

Question
: Who reads IKB.md, could ikb --help, ikb help RECORD and ikb man serve instead, and how do other tools treat generated docs?

Found
: Readers: two AGENTS.md lines, one skill line and docs' verify; no CI check. Its content is a copy of the records' own headers. Same pattern elsewhere in the commons: tad's man page and completions are built in packaging (tad/generated is gitignored); only tad's rendered docs/*.md, the product people open, are committed and checked. Second remeasure with four agents: equal tokens before and after (about 64k each), 0-1 failures, so the file bought nothing measurable.

About
: ikb

Material
: research/ikb/2026-11-17/


<a id="commons-and-unit-bases-world"></a>
### commons-and-unit-bases-world

Date
: 2026-11-17

Brief
: Open projects keep schema and process in the commons, each unit its own claim; the commons pulls and derives, never types status twice.

Question
: How should linux-phone-oco/docs split general knowledge from per-device work, and how does docs learn each device's progress?

Found
: Linux MAINTAINERS, devicetree bindings vs board dts, the Debian ports wiki, Renovate, GitHub templates and Copier show one shape: the commons holds schema, rules and process; each unit holds its files and its own claim of status in a fixed shape; the commons learns by pulling and derives a summary, with stale or missing units shown as not known. Hand-typed status in two places drifts (Debian's per-port pages), a GitHub template keeps no link back, and CI-derived status fails where hardware cannot run in CI. Here docs holds 2.0 MB (test_results 1.3 MB) and, in its own project, 40 of 81 backlog items, 34 of 49 research rows and 14 of 28 decisions name a device; the keeper's landings conflict whole-file in docs' data. Not read: postmarketOS (redirects), Fedora ARM, nixpkgs/Wikidata/OSM patterns.

About
: ikb

Material
: research/commons-bases/2026-11-17/


<a id="tad-sql-hand-writes"></a>
### tad-sql-hand-writes

Date
: 2026-11-17

Brief
: 56 hand-written tad sql writes in 13 sessions: mostly one field of one row, or a removal, which no named record covers.

Question
: Which generic record or commands stop agents writing tad sql by hand?

Found
: The roles session's count (ideal-agent research work-struggles) of 2026-11-17: backlog status/waits/note 22, decisions 8, sources 9, practices 5, test_results inserts 4, research deletes 2, subjects inserts 2 - 56 in 13 sessions. tad set exists and checks every rule but offers no help on tables, fields or values and adds an absent row. practices and subjects are ideal-agent's own tables, test_results is devlab's test-run record. Not measured here: how many of the 56 were one-offs against a missing record, or why agents did not use tad set.

Sources
: git-notes

About
: ikb


<a id="chain-follow-world"></a>
### chain-follow-world

Date
: 2026-11-17

Brief
: What flows down the chain is a slice of files into a repo with its own data; idealkb's pin and follow.sh fit, rhizoid lacks a slice mode.

Question
: How should idealkb, device-template and the device bases take general updates and send improvements back, and does rhizoid fit?

Found
: Rhizoid (README, design log) is a fork-own-sync tool for whole dependency repositories, not implemented yet (CLI stubbed; its consumption side is an open item). idealkb's follow.sh/update-pins/consumers with the release gate already lays a slice (generic list, own list, drift exit 3) into repositories with their own data; it is source-agnostic. Subtree needs a prefix, Copier and cruft are Python with a second state file, Renovate bumps numbers. linux-phone-oco/linux (a fork of sm7150-mainline/linux) is a true cutting.

Sources
: git-notes

About
: ikb

Material
: research/chain-follow/2026-11-17/


<a id="stale-waits"></a>
### stale-waits

Date
: 2026-11-17

Brief
: Three phone-lane stalls today came from waits typed as text: an empty string and two items still waiting on a done item.

Question
: How should an item's wait be kept so that it clears when what it waits on is done?

Found
: Three stalls on 2026-11-17 (the Top Coordinator): an empty string read as waiting, twice a wait on an already-done item; each re-entered by hand. In the device bases the waits that are plainly item ids: surya-lab 3 rows, google-walleye-lab 8; others are prose mentioning ids or outside things. tad has no rule for a list of references or an either/or pair, so the check is in the records. Also found: the tad library 0.7.0 behind ikb read a reference by the field id, so ikb set refused rows of a table keyed by another field (parts); tad 0.7.1 fixes it and ikb now links 0.7.1. Not measured: how many of docs' own waits would clear.

Sources
: git-notes

About
: ikb


<a id="charter-pattern-world"></a>
### charter-pattern-world

Date
: 2026-11-17

Brief
: A project's principles: five to ten rows with stable ids, cited by link, with the citation checked and the restating measured.

Question
: How should a base keep its founding principles so that guides cite and never restate them?

Found
: Read (2026-11-17, for linux-phone-oco/docs): Debian Social Contract/DFSG, Mozilla Manifesto, Wikipedia five pillars, Rust API guidelines checklist, RFC 7282, PEP 20, the kernel's DCO 1.1, MADR decision drivers - small sets with stable linkable ids; none enforces cite-not-restate. Not read: Arch principles, PEP 1, Nygard's ADR post, the Rust RFC process. Full record in docs: research principles-world.

Sources
: git-notes

About
: ikb


<a id="silent-noop-updates"></a>
### silent-noop-updates

Date
: 2026-11-18

Brief
: A re-rank without --needs cleared needs and an update matching no row said recorded: tad prints changed: only when it changed.

Question
: Why did a re-rank in google-walleye-lab fail silently, and how do updates fail loudly?

Found
: Reproduced 2026-11-18 on a scratch device base: backlog-needs --id a --rank 2 (no --needs) set rank 2 and needs to null, so the item left the phone queue; a second identical call printed nothing and ikb reported recorded; a status write on an absent id was only stopped where a guard existed. tad r prints a 'changed: TABLE' line exactly when it changed a table. Not asked yet: which command the walleye coordinator ran (asked; if it was another command the fix above may not be the whole cause).

Sources
: git-notes

About
: ikb

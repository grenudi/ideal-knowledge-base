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


<a id="rfc-systems-world"></a>
### rfc-systems-world

Date
: 2026-11-18

Brief
: RFC, PEP, Rust RFC, MADR: we lacked superseding a decision, its scope and its carrying work; status is read, not typed

Question
: How do RFCs, PEPs, Rust RFCs, KEPs, ADRs and the kernel's RFC convention compare with ikb's research, decision, concept and backlog records; what to adopt, what to keep different?

Found
: Compared (read this round): IETF RFC style RFC 7322 - 'Obsoletes:' and 'Updates:' header lines, each RFC fixed once published (immutability itself not on the page read). Python PEP 1 - statuses Draft, Active, Accepted, Final, Rejected, Withdrawn, Deferred, Superseded, Provisional; a decider (Steering Council or its PEP-Delegate), a Sponsor, header links Replaces, Superseded-By, Requires, a Resolution link to the pronouncement; a PEP is not substantially modified after Accepted, Final, Rejected or Superseded. Rust RFCs - pre-RFC, PR, shepherd from the subteam, final comment period of ten calendar days opened only when every subteam member signs off, ending in merge, close or postpone; every accepted RFC gets a tracking issue; small changes amend, substantial ones are a new RFC with a note on the old. MADR - status proposed, rejected, accepted, deprecated, 'superseded by ADR-0123'; decision-makers, consulted, informed; considered options with pros and cons; confirmation. Not read this round, from memory and so unchecked: Kubernetes KEP (the page did not answer) - kep.yaml status provisional/implementable/implemented, owning-sig and participating-sigs, graduation criteria per stage; Nygard's 2011 ADR note (status, context, decision, consequences; superseded ADRs stay); the kernel's RFC subject tag, which marks a patch as a request for comment, not for merge.
Map to ikb. Fit: research = the background an RFC/PEP carries, with supersedes; decision = an ADR (decision, why, rejected = considered options, research = context); sources; backlog with blocked_by = Requires; upstream_items = the kernel and DEP-3/Upstream-Status side (research upstreaming-and-carry-world). Lacked: (1) a decision could be replaced by id only - history in git, not in the data, no Superseded-By or Updates; (2) no stated scope - who a decision binds (KEP participating-sigs, MADR informed); (3) no link from a decision to the work that carries it out (Rust tracking issue, KEP implemented) - so nothing said whether a decision was carried out; (4) no way to ask which decisions stand.
Deliberate differences, with why. No proposal state machine: a row is decided; a proposal is research and a backlog item that waits on the author's word (waits), because the sessions decide by the canon and the author's turn is the approval - a Draft/Accepted word typed on a row is a state to keep true (practice 28). Status is read, never typed: superseded (a later row names it), carried out (its item is done), in work, or no item named - the KEP/Rust status read off the work. No final comment period: sessions message each other and work does not wait on a period; where a decision must be heard by others its scope names them, and the sign-off is a waits on an item. No typed back-link (Superseded-By, Obsoleted-by): RFCs and PEPs keep both directions by hand and drift; ours is one link and the other direction is a query. No decider/sponsor field: the record's signature (OCOECO_BY) and the author's recorded turn say it. No BCP/Standards-Track categories: a decision's about and scope place it. Written once, never edited: kept as PEP/RFC do, but through supersedes/amends rows; an id replaced is for fixing a mistake before others read it.
Cross-reference: the carry of a patch (research upstreaming-and-carry-world) and the life of a decision share one idea - the state is read off links and work, the old row stays reachable - and the same Upstream-Status/Backport reading ('accepted upstream, ours until a release') fits 'decided, in work, carried out'.
Reaches every base the way carried did: generic tables.toml, record, query and AGENTS.md line by the pin; bases with their own tables.toml add four fields by hand (nullable) - that gap itself is open (backlog tables-own-drift).

Sources
: rfc7322,pep-1,rust-rfcs,madr-template,dep3,yocto-upstream-status

About
: ikb

Material
: research/ikb/2026-11-18/


<a id="upstreaming-and-carry-world"></a>
### upstreaming-and-carry-world

Date
: 2026-11-18

Brief
: Sent and carried are two facts; DEP-3, Yocto and b4 agree; ours lacked carried_in, reviewers, fork-of

Question
: What does idealkb say about upstreaming, how do others tell a patch's life and carry, and how does a change reach every base?

Found
: Already here: upstreams (kind incl. code-project, kb-instance) and upstream_items (form, 12 states, from_work, local_ref, file, sent_on, forwarded, bug, version, supersedes, applied_upstream, waits), the generic part of tables.toml and AGENTS.md, the queries upstream/upstreams, records upstream/upstream-item/upstream-state; carried to every base by bin/follow.sh from the pin, answered before release by followers-answer.sh. Not here: how a patch kept in a fork until the upstream has it is told (sent and carried are two facts, the item had one state), the fork itself as an upstream that names what it forks, who reviewed (trailers), and a view that says which carried patches to keep or drop. The fork is not a base: linux-phone-oco/linux is a cutting of sm7150-mainline/linux (research chain-follow-world); its work is recorded in the base of the lane that works on it.
Others: DEP-3 (read) - Origin (upstream/backport/vendor/other), Forwarded (no, not-needed, or where), Applied-Upstream (version or commit:ID), Bug, Reviewed-by/Acked-by, Last-Update: facts in a patch header, no state word, and the patch is in the package until the next version carries it. Yocto Upstream-Status (read) - Pending, Submitted [where], Backport [version], Denied, Inappropriate [reason], Inactive-Upstream: one word per carried patch, the patch stays in the recipe whatever the word is; the word Backport means it is already in the next release, drop at the bump. b4 (read trailers page; prep/send tags from memory, not re-read) - trailers (Reviewed-by, Acked-by, Tested-by) collected from replies to any sent version by patch-id, refusals remembered by provenance; each sent revision is a version of one series; thanks sent when applied. Ours maps: our state is the word of Upstream-Status's life (draft..landed, side exits), forwarded/applied_upstream/bug are DEP-3's fields, supersedes is the b4 revision chain; what was missing is carry (the patch is in the fork whatever the state), reviewers, and the fork-of link. Sxmo's 'accepted, thank you' is state accepted; it is carried until a release has it (applied_upstream), then landed and dropped.
Propagation: a change to the generic part (tables.toml between idealkb:begin and idealkb:end, queries, records, AGENTS.md lines named in generic) reaches a base by its pin: release, update-pins opens the pin change, follow.sh lays it, exit 3 on drift; followers-answer.sh asks every base in consumers before release - now also upstream, upstreams and carried, so a base whose data cannot answer stops the change. New fields are optional, so existing rows stay valid. Forks are not followers: a fork carries no base.
Not read: Patchwork's state list again, Gerrit/Phabricator, git-send-email's tracking tools (git-pw), Gentoo/Arch patch-carry conventions.
Seen with the RFC systems comparison, research rfc-systems-world: the same reading (state read off links and work) is applied to decisions.

Sources
: dep3,yocto-upstream-status,b4-trailers

About
: ikb

Material
: research/ikb/2026-11-18/


<a id="ready-query-world"></a>
### ready-query-world

Date
: 2026-11-18

Brief
: Taskwarrior, Beads, make: ready = not blocked by anything not done, with the blocked listed; ours had three slightly different queries

Question
: How do others compute 'ready', what does idealkb already have, and what should one shared picking query be?

Found
: Looked at: Taskwarrior (read, taskwarrior.org virtual tags) - READY = pending, not BLOCKED (depends on an incomplete task), and not scheduled for later; WAITING is a separate hidden state with a wait date; a blocker that is done stops blocking. Beads (README fetched, `bd ready`/`bd blocked` not on that page, from memory so unchecked) - ready lists open issues with no open blocking dependency, and a separate listing says what is blocked. Jira and Linear (Linear's relations page fetched but did not say; from memory, unchecked) - 'blocked by' is a link and a badge, not a gate: nothing refuses work on a blocked issue, and the badge goes when the blocker closes. make (known) - a target is runnable when every prerequisite is up to date; an unknown prerequisite with no rule is an error, not a pass. Taskwarrior's urgency score (coefficients for due, priority, age, blocking) is the part we do not take: ranking here is the author's order, by rank.
Ours before: next (every item not done, with blocked_on shown - lists, does not pick), phone-next and phone-queue (device bases: waits null, blocked_by done, hardware owned - right, but only for needs = phone, in device bases), lane-next (waits only; ignored blocked_by - the walleye sign), docs' next. Raw SQL in briefs (lab-tools builder: took a row waiting outside the base). Three queries shaped the same, each slightly different - one nature, three names.
Taken: one query, ready, in the generic slice. Ready = no outside wait, every blocker done (a done blocker clears itself - Taskwarrior, Beads), hardware owned and not refuted; a blocker the base does not hold is not clear and is said so (make: an unknown prerequisite is an error; the roles proposal's 'refused while unresolved'). Every skipped item gets a why - Beads' blocked listing and Taskwarrior's +BLOCKED, in the same rows. Lanes by needs, in the author's rank. Not taken: urgency scoring; resolving a blocker in another base (the commons) - a blocker in another base is shown as not in this base, so the wait is typed as waits until a cross-base link exists (backlog ready-across-bases).
Prerequisites: the generic backlog gains needs, proof, rank and hardware, and the generic part gains the hardware table (the decision 2026-11-18-hardware-is-one-table-in-every-base already says every base), so the query binds in every base; docs and the device bases already hold them.

Sources
: taskwarrior-tags

About
: ikb

Material
: research/ikb/2026-11-18/


<a id="fork-tags-and-workarounds-world"></a>
### fork-tags-and-workarounds-world

Date
: 2026-11-18

Brief
: Android's commit tags map to the item's state: derive and check, not type; a workaround's place stays in its marker, not a field

Question
: Should upstream_items gain a worked-around-where field, should a fork's commits carry Android-style tags, and which items do today's three workarounds want?

Found
: Android common kernel (read: android.googlesource.com kernel/common README, source.android.com 'Develop kernel code for GKI'): a patch not merged from an upstream branch must have its subject tagged UPSTREAM: (cherry-picked from mainline, unchanged, with the commit named), BACKPORT: (needed changes), FROMGIT: (in a maintainer tree, not yet mainline), FROMLIST: (sent to the list, not yet in any maintainer tree; BACKPORT: FROMLIST: when changed) or ANDROID: (downstream-only). Chromium's kernel tags follow the same words (from memory, not read).
Ours before: upstream_items has state (draft..landed with side exits), carried_in (research upstreaming-and-carry-world) and local_ref (the branch, pull request or commit here it is made in). The tags are the state seen from the commit: sent = FROMLIST, accepted into a maintainer branch = FROMGIT, landed/applied = UPSTREAM, the rest = OURS (Android's ANDROID: is a word for Android; ours is the plain OURS). So the tag is derived from the item, never typed on the item - and the commit subject, which a person reads in git log, carries it with the item id, so the two are checked against each other.
(1) a field on upstream_items for where it is worked around: not taken. The marker WORKAROUND(item-id) in place is the single record of where; a field on the item is a second one that drifts (practice 28). local_ref already names the place a thing is made in; ideal-agent's scripts/workarounds reads markers and the item's state, which is the direction that fails when the item has landed.
(2) tags: taken, derived (tag column of tad q carried) and checked (bin/check-fork-tags.sh). BACKPORT is accepted only where the item is UPSTREAM or FROMGIT (a commit that needed changes); ANDROID is replaced by OURS.
(3) the three workarounds: sxmo's autosuspend loop and rtcwake already have items in docs (sxmo-autosuspend-backoff, sxmo-suspend-stop-by-profile, sxmo-surya-sensors-suspend, with the forks' topics in carried_in); walleye's fw_devlink=permissive stands in for a missing supplier node (the tps61099 boost converter): an item in walleye's base; lpoco-health awake's wake lock is a lab tool by design, not obviously a stand-in for an upstream fault - its fault is for the roles session to name.

Sources
: android-common-kernel-readme,dep3,yocto-upstream-status

About
: ikb

Material
: research/ikb/2026-11-18/


<a id="upstream-items-already-holds-an-upstreaming-view"></a>
### upstream-items-already-holds-an-upstreaming-view

Date
: 2026-11-19

Brief
: upstream_items already holds an upstreaming view; a table is not needed, a query and a git check are

Question
: Does upstream_items hold what a view of what we shipped where, how far, and why needs, or must a table be added? How do Patchwork, Debian's patch tracker and the Android kernel tags show it, and what can be derived from git?

Found
: Held: target (upstream, its kind), form, state (12 values), version and supersedes (series), links (forwarded, bug, applied_upstream), carried_in, reviewed_by, sent_on, last_update, why (note, waits, from_work). Patchwork's states (new, under review, changes requested, accepted, rejected, superseded, mainlined) map onto our state enum; Debian's DEP-3 fields (Forwarded, Bug, Applied-Upstream) are what we already have; the Android common kernel's UPSTREAM/FROMGIT/FROMLIST tags are the carried tag. Missing: only dates of each step (accepted, landed), which git log of the item's file gives; no new table. Derivable from git without typing: a carried patch landed upstream by patch-id (git cherry UPSTREAM FORK, the minus lines), a sent patch's state from Patchwork's REST API by message-id, replies and Reviewed-by trailers from lore (b4, lei). These are checks that propose, like check-fork-tags.sh, not writers. From memory, not re-read: Patchwork, Debian patch tracker, Linaro dashboards, KernelCI (which shows test results, not patches).

About
: follow-by-pin

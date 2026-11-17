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

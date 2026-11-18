<!-- Generated from data/ by tad. Do not edit by hand. -->

# Sources

<a id="anthropic-context-engineering"></a>
### Effective context engineering for AI agents

Url
: https://www.anthropic.com/research/effective-context-engineering-for-ai-agents

Author
: Anthropic

Year
: 2025

Takes
: Context rot and an attention budget: more tokens, worse recall. Three tools for long work - compaction (risks losing what matters later), structured notes outside the window (NOTES.md), sub-agents that return 1-2 thousand token summaries; load knowledge just in time by reference.


<a id="diataxis"></a>
### Diátaxis: a systematic approach to technical documentation

Url
: https://diataxis.fr/

Author
: Daniele Procida

Year
: 2021

Takes
: Four kinds by the reader's need - tutorial, how-to, reference, explanation - never mixed on one page. Reference is neutral and looked up: in a tad base, the tables; how-to is the named records and briefs; explanation is decisions, concepts and the occasional essay.


<a id="llms-txt"></a>
### The /llms.txt file

Url
: https://llmstxt.org/

Author
: Jeremy Howard

Year
: 2024

Takes
: One Markdown file at a fixed path: a title, a one-line summary, then sections of links with a note each, and an Optional section an agent may skip when short of context. A router, not the content.


<a id="agents-md"></a>
### AGENTS.md

Url
: https://agents.md/

Author
: agents.md

Year
: 2025

Takes
: A README for agents; the nearest AGENTS.md to the file being edited wins. The one file every agent already looks for - the place for a base's single entry.


<a id="nygard-adr"></a>
### Documenting Architecture Decisions

Url
: https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions

Author
: Michael Nygard

Year
: 2011

Takes
: One significant decision per record, numbered and never reused; a reversed decision is kept, marked superseded, pointing at what replaced it. docs' decisions table is this, with rejected beside it.


<a id="madr"></a>
### MADR: Markdown Architectural Decision Records 4.0

Url
: https://adr.github.io/madr/

Author
: MADR project

Year
: 2024

Takes
: Adds considered options with pros and cons and a status that says superseded by which. What docs' decisions already keep as decision, why, rejected.


<a id="frictionless-data-package"></a>
### Data Package (Frictionless Data)

Url
: https://specs.frictionlessdata.io/data-package/

Author
: Frictionless Data

Year
: 2017

Takes
: datapackage.json at the top is the descriptor and index of the data's resources, each with a stable name and a schema. tables.toml follows its Table Schema; tad statements is the same kind of index for questions.


<a id="docs-as-code"></a>
### Docs as Code

Url
: https://www.writethedocs.org/guide/docs-as-code/

Author
: Write the Docs

Year
: 2024

Takes
: Documentation in plain text, in git, reviewed and tested like code. What every tad base already is.


<a id="evergreen-notes"></a>
### Evergreen notes

Url
: https://notes.andymatuschak.org/Evergreen_notes

Author
: Andy Matuschak

Year
: 2020

Takes
: Atomic, concept-oriented, densely linked notes whose titles work like APIs; outline notes link many notes. One row is one such note; a checked link is the dense link; a query is the outline note.


<a id="johnny-decimal"></a>
### Johnny.Decimal

Url
: https://johnnydecimal.com/10-19-concepts/11-core/11.01-introduction/

Author
: Johnny Noble

Year
: 2024

Takes
: A fixed small index - no more than ten at each level - kept as a first-class record of every id. A base's entry should be that small.


<a id="para-forte"></a>
### The PARA Method

Url
: https://fortelabs.com/blog/para/

Author
: Tiago Forte

Year
: 2023

Takes
: Organise by actionability: projects, areas, resources, archives. In a base, what is actionable is read off status (open backlog), not filed by folder.


<a id="wikidata-statements"></a>
### Help:Statements (Wikidata)

Url
: https://www.wikidata.org/wiki/Help:Statements

Author
: Wikidata

Year
: 2024

Takes
: Every statement is about an item, by its id, with references saying who says so. The missing piece in docs: records say which place they are of, but not checked which thing they are about.


<a id="wikipedia-infobox"></a>
### Help:Infobox (Wikipedia)

Url
: https://en.wikipedia.org/wiki/Help:Infobox

Author
: Wikipedia

Year
: 2024

Takes
: A fixed-format summary of facts beside the prose that explains them; the facts must stand in the prose with citations too. Tables for facts, prose for reasons.


<a id="anthropic-agent-skills"></a>
### Equipping agents for the real world with Agent Skills

Url
: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills

Author
: Zhang, Lazuka and Murag (Anthropic)

Year
: 2025

Takes
: Three levels: a name and one line always loaded, the body when relevant, linked files only when needed; scripts run without being read. The shape of a base's entry: AGENTS.md, tad statements, a query's rows, one row.


<a id="claude-code-memory"></a>
### Manage Claude's memory (Claude Code)

Url
: https://code.claude.com/docs/en/memory

Author
: Anthropic

Year
: 2026

Takes
: CLAUDE.md up the tree loads at start, nested ones when their subtree is touched; under 200 lines; imports organise but do not save context; procedures go into skills. CLAUDE.md is @AGENTS.md, one source.


<a id="photocraft-agents-md"></a>
### PhotoCraft AGENTS.md

Url
: https://raw.githubusercontent.com/storytold/photocraft/main/AGENTS.md

Author
: storytold

Year
: 2026

Takes
: Root AGENTS.md: who it is, then an Orientation table (Read / Why) of about 14 docs pages, the workspace map, golden rules, how to pick work, and where each thing is tracked and which pages are generated from which data. ArtCraft (storytold/artcraft) routes by nested AGENTS.md and .claude/rules instead.


<a id="mintlify-llms-txt"></a>
### Simplifying docs for AI with /llms.txt

Url
: https://www.mintlify.com/blog/simplifying-docs-with-llms-txt

Author
: Tiffany Chen (Mintlify)

Year
: 2024

Takes
: llms.txt as the slim index and llms-full.txt as the whole site in one file, both generated. For a base's published site, generated from the data - not the agent's entry.


<a id="text-as-data-template"></a>
### text-as-data-template

Url
: https://github.com/creation-guidelines/text-as-data-template

Author
: creation-guidelines

Year
: 2026

Takes
: The commons' template for a knowledge base kept as data; last changed 2026-11-04 and still describing the vendored Python engine on a DuckDB schema (bin/adopt-engine.sh, .tad/), which every base left for tad on 2026-11-11.


<a id="cochrane-lsr-guidance"></a>
### Guidance for the production and publication of Cochrane living systematic reviews, v1.0

Url
: https://community.cochrane.org/sites/default/files/uploads/inline-files/Transform/201912_LSR_Revised_Guidance.pdf

Author
: Cochrane

Year
: 2019

Takes
: Searched monthly, republished only when new evidence would change the conclusions or on a schedule; between versions a What's New line: searched, N pending, conclusions stand. No numeric threshold for an important change exists.


<a id="elliott-lsr-2017"></a>
### Living systematic review: 1. Introduction - the why, what, when, and how

Url
: https://pubmed.ncbi.nlm.nih.gov/28912002/

Author
: Elliott, Synnot, Turner et al.

Year
: 2017

Takes
: A review continually updated as new evidence becomes available, where new evidence could change decisions.


<a id="wikipedia-summary-style"></a>
### Wikipedia:Summary style

Url
: https://en.wikipedia.org/wiki/Wikipedia:Summary_style

Author
: Wikipedia editors

Takes
: A long section spun off into its own article leaves a summary with a Main link; new material goes to the child first, then is summarised in the parent; Sync marks a summary fallen behind.


<a id="wikipedia-article-size"></a>
### Wikipedia:Article size

Url
: https://en.wikipedia.org/wiki/Wikipedia:Article_size

Author
: Wikipedia editors

Takes
: Size thresholds for dividing: over 8,000 words of prose may, over 9,000 probably, over 15,000 almost certainly; under 6,000 length alone does not justify it.


<a id="wikipedia-lead"></a>
### Manual of Style: Lead section

Url
: https://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style/Lead_section

Author
: Wikipedia editors

Takes
: The lead summarises the most important contents and stands on its own; 250-400 words in featured articles; citations may stay in the body.


<a id="pep-1"></a>
### PEP 1 - PEP Purpose and Guidelines

Url
: https://peps.python.org/pep-0001/

Author
: Python

Takes
: Superseded-By with a matching Replaces; a resolved PEP is a historical document, not a living specification.


<a id="beads-compaction"></a>
### Beads

Url
: https://github.com/steveyegge/beads

Author
: Steve Yegge

Takes
: Closed issues summarised 30 days after closing by a small model, kept only if shorter, the original snapshotted and restorable; run when 10 or more are eligible.


<a id="gastown"></a>
### Gas Town

Url
: https://github.com/gastownhall/gastown

Author
: Steve Yegge

Takes
: Work state in git-backed hooks and the Beads ledger; gt seance questions an earlier session's logs rather than a stored summary.


<a id="artcraft"></a>
### ArtCraft

Url
: https://github.com/storytold/artcraft

Author
: Storyteller

Takes
: CLAUDE.md is @AGENTS.md; a shared rules block pinned by commit and checksum; plan/ a git-ignored notebook; dated raw evidence beside a summary (docs/performance/2026-09-26-*.json).


<a id="claude-code-skills"></a>
### Extend Claude with skills

Url
: https://code.claude.com/docs/en/skills

Author
: Anthropic

Year
: 2026

Takes
: The description is always in context, the body loaded when used; SKILL.md under 500 lines, reference in files read only when needed.


<a id="ace-context-collapse"></a>
### Agentic Context Engineering

Url
: https://arxiv.org/abs/2510.04618

Author
: Zhang et al.

Year
: 2025

Takes
: Knowledge kept by rewriting one summary erodes (context collapse) and drifts terse; itemised additions keep the detail.


<a id="git-notes"></a>
### git notes

Url
: https://git-scm.com/docs/git-notes

By
: ikb-cli

Takes
: refuse to overwrite silently; text from file or stdin


<a id="adr-tools"></a>
### adr-tools

Url
: https://github.com/npryce/adr-tools

By
: ikb-cli

Takes
: a new entry is one command with the template and numbering done for you; not the numbers or the editor


<a id="log4brains"></a>
### log4brains

Url
: https://github.com/thomvaill/log4brains

By
: ikb-cli

Takes
: date-prefixed names avoid merge conflicts


<a id="taskwarrior-udas"></a>
### Taskwarrior user defined attributes

Url
: https://taskwarrior.org/docs/udas/

By
: ikb-cli

Takes
: typed attributes with allowed values and defaults


<a id="hugo-new-content"></a>
### hugo new content

Url
: https://gohugo.io/commands/hugo_new_content/

By
: ikb-cli

Takes
: the command decides the path and fills date and title


<a id="writing-tools-for-agents"></a>
### Writing tools for agents (Anthropic)

Url
: https://www.anthropic.com/engineering/writing-tools-for-agents

By
: ikb-cli

Takes
: few consolidated tools; errors that steer toward correct input


<a id="dep3"></a>
### DEP-3: Patch Tagging Guidelines

Url
: https://dep-team.pages.debian.net/deps/dep3/

By
: Debian

Takes
: Origin, Forwarded, Applied-Upstream, Bug, Reviewed-by, Last-Update as facts in a patch header


<a id="yocto-upstream-status"></a>
### Yocto recipe style guide: Upstream-Status

Url
: https://docs.yoctoproject.org/contributor-guide/recipe-style-guide.html

By
: Yocto Project

Takes
: Pending, Submitted, Backport, Denied, Inappropriate, Inactive-Upstream: one word per carried patch


<a id="b4-trailers"></a>
### b4: retrieving code-review trailers

Url
: https://b4.docs.kernel.org/en/latest/contributor/trailers.html

By
: kernel.org

Takes
: trailers from replies to any sent version, matched by patch-id; refusals remembered by provenance

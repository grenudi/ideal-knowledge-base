# CLIs that front structured records, read at source (2026-11-17)

The entry's shape is declared once; flags, defaults, validation, help and man page derive from it.
- git notes (git-scm.com/docs/git-notes): add refuses an existing note without -f, append is the safe way; -m/-F/- (stdin) carry text. Take: refuse to overwrite silently, text from file or stdin.
- adr-tools (github.com/npryce/adr-tools): `adr new [-s N] title` numbers, templates, supersedes by editing the old record. Not taken: sequential numbers (collide across branches), $EDITOR.
- log4brains (github.com/thomvaill/log4brains): date-prefixed file names avoid merge conflicts; records immutable but status. Take: dated names, never numbers.
- Dendron (wiki.dendron.so): schemas and templates apply on creation. Not taken: editor-plugin coupling.
- Taskwarrior UDAs (taskwarrior.org/docs/udas): typed attributes, allowed lists, defaults; `task add x project:Home`. Take: typed, defaulted, rejected with the accepted values named.
- Hugo `hugo new content` (gohugo.io): the path decides the kind, archetype supplies the template, date and title filled. Take: placement decided by the command, not the author.
- clap_mangen / argc (docs.rs/clap_mangen, github.com/sigoden/argc): help, man and completions generated from one declaration.
- Anthropic, Writing tools for agents (anthropic.com/engineering/writing-tools-for-agents): few consolidated tools, namespaced, described for a new hire; errors steer toward correct input.
- MCP vs CLI (manveerc.substack.com, buildwithfern.com): tool design matters more than transport; MCP often wraps a CLI.
- argenv (local): Record is an owned runtime struct; argenv_resolve::parse(&[Record]) and generate::man_page accept a contract built at run time, so the contract can be derived from a base's records/*.sql headers.
Not known: Dendron naming rules, adr-tools numbering internals.

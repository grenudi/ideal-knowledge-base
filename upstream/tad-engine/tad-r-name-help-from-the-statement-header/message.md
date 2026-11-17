# tad r NAME --help, from the statement's header

A draft for tad-engine; not sent (it waits for the author's word).

`tad r decision --help` fails with "--help is not a declared flag", and `tad statements` lists every record on
one line. Measured on 31 agent transcripts (2026-11-17): 14 of 41 failed `tad r` calls were an agent asking for
one record's help. The header of records/NAME.sql already holds everything: type, meaning, format, default.
Proposal: `tad r NAME --help` (and `tad q NAME --help`) prints the header as the man page of that statement;
and completion of enumerated values (the subjects `--about` names, the places `--project` names) from a query
the statement's header points to. Until then `ikb help NAME` (grenudi/ideal-knowledge-base) prints it.

-- Everything known of one subject - what was learned and decided, the work open, how it went, and the
-- sources the research cites - its whole knowledge in one read. A word before a dash names a family
-- (modem: modem-data, modem-calls). Without a subject: every subject the records are about, and how many.
-- --subject  string?  the subject (every subject when not given)
WITH s AS (SELECT $subject AS w),
hit AS (SELECT a FROM (SELECT about AS a FROM decisions UNION SELECT about FROM research UNION SELECT about FROM backlog
            UNION SELECT about FROM session_log), s
        WHERE a IS NOT NULL AND (a = s.w OR a LIKE s.w || '-%')),
known AS (
    SELECT 1 AS o, 'research' AS kind, id, about, NULL AS state, date AS day, question || ' - ' || found AS says
      FROM research WHERE about IN (SELECT a FROM hit)
    UNION ALL SELECT 2, 'decision', id, about, NULL, date, decision || coalesce(' Rejected: ' || rejected, '')
      FROM decisions WHERE about IN (SELECT a FROM hit)
    UNION ALL SELECT 3, 'work', id, about, status, opened, title || coalesce(' - ' || note, '') || coalesce(' Waits: ' || waits, '')
      FROM backlog WHERE status <> 'done' AND (about IN (SELECT a FROM hit) OR id IN (SELECT a FROM hit))
    UNION ALL SELECT 4, 'log', id, about, NULL, entry_date, title || ' - ' || done
      FROM session_log WHERE about IN (SELECT a FROM hit)
    UNION ALL SELECT DISTINCT 5, 'source', id, NULL, NULL, NULL, title || ' <' || url || '>'
      FROM sources WHERE id IN (SELECT trim(unnest(string_split(sources, ','))) FROM research WHERE about IN (SELECT a FROM hit))
)
SELECT kind, id, about, state, day, says FROM (
SELECT o, kind, id, about, state, day, says FROM known, s WHERE s.w IS NOT NULL
UNION ALL
SELECT 6, 'subject', a, NULL, NULL, NULL, count(*)::VARCHAR || ' records' FROM (
    SELECT about AS a FROM decisions UNION ALL SELECT about FROM research UNION ALL SELECT about FROM backlog
    UNION ALL SELECT about FROM session_log), s
WHERE s.w IS NULL AND a IS NOT NULL GROUP BY a
) ORDER BY o, day DESC NULLS LAST, id;

-- A decision, with what was rejected and why (a decision of that id is replaced).
-- --id        string        YYYY-MM-DD-what-was-decided
-- --decision  string        what was decided
-- --why       string        why: the evidence, whose words
-- --rejected  string?       what was weighed and not chosen, and why not
-- --about     string?       what it is about (tad q about lists the subjects)
-- --research  string?       the research it rests on (its id)
-- --date      date = today  when
DELETE FROM decisions WHERE id = $id;
INSERT INTO decisions (id, date, decision, why, rejected, about, research)
VALUES ($id, $date, $decision, $why, $rejected, $about, $research);

-- What was learned, and from where (a research of that id is replaced).
-- --id        string        a-short-name
-- --question  string        what was asked
-- --found     string        what was found
-- --sources   string?       the sources' ids, comma-separated (tad r source records each)
-- --about     string?       what it is about (tad q about lists the subjects)
-- --date      date = today  when
DELETE FROM research WHERE id = $id;
INSERT INTO research (id, date, question, found, sources, about)
VALUES ($id, $date, $question, $found, $sources, $about);

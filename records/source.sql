-- A source research and decisions cite (a source of that id is replaced).
-- --id      string    a-short-name
-- --title   string    its title
-- --url     string    https://...
-- --author  string?   who wrote it
-- --year    integer?  when
-- --takes   string?   what is taken from it
DELETE FROM sources WHERE id = $id;
INSERT INTO sources (id, title, url, author, year, takes)
VALUES ($id, $title, $url, $author, $year, $takes);

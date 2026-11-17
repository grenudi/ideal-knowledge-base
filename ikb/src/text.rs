//! The text of an option: `@FILE` reads a file, `@-` standard input, `@@x` is the text `@x`.
use anyhow::{Context, Result};
use std::io::Read;

pub fn expand(raw: &str, stdin: &mut dyn Read) -> Result<String> {
    if let Some(rest) = raw.strip_prefix("@@") {
        return Ok(format!("@{rest}"));
    }
    match raw.strip_prefix('@') {
        Some("-") => {
            let mut s = String::new();
            stdin.read_to_string(&mut s)?;
            Ok(s.trim_end().to_string())
        }
        Some(file) if !file.is_empty() => Ok(std::fs::read_to_string(file)
            .with_context(|| {
                format!(
                    "reading {file} (a text starting with @ is a file; write @@ for a literal @)"
                )
            })?
            .trim_end()
            .to_string()),
        _ => Ok(raw.to_string()),
    }
}

/// An id from a brief: lowercase words joined by dashes, at most 48 characters, cut between words;
/// with the date in front when the id's format asks for one.
pub fn slug(brief: &str, date: Option<&str>) -> String {
    let words: Vec<String> = brief
        .split(|c: char| !c.is_ascii_alphanumeric())
        .filter(|w| !w.is_empty())
        .map(str::to_lowercase)
        .collect();
    let mut s = String::new();
    for w in words {
        if !s.is_empty() && s.len() + 1 + w.len() > 48 {
            break;
        }
        if !s.is_empty() {
            s.push('-');
        }
        s.push_str(&w);
    }
    match date {
        Some(d) => format!("{d}-{s}"),
        None => s,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn slugs_cut_between_words() {
        assert_eq!(
            slug("Use X, not Y's way: it's better!", None),
            "use-x-not-y-s-way-it-s-better"
        );
        assert!(slug(&"a ".repeat(40), Some("2026-11-17")).len() <= 59);
        assert_eq!(
            slug("Hello World", Some("2026-11-17")),
            "2026-11-17-hello-world"
        );
    }

    #[test]
    fn at_expands() {
        let mut stdin = "from stdin\n".as_bytes();
        assert_eq!(expand("@-", &mut stdin).unwrap(), "from stdin");
        assert_eq!(expand("@@x", &mut stdin).unwrap(), "@x");
        assert_eq!(expand("plain", &mut stdin).unwrap(), "plain");
        assert!(expand("@/no/such/file", &mut stdin).is_err());
    }
}

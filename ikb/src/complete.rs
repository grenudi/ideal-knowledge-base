//! Completions: one small glue script per shell that asks `ikb complete` at completion time, so the record
//! names and each record's options always come from the base's own records/*.sql (through the same contract
//! that makes the help and the man page); nothing about a base is written into a script.
use tad::statements::Statement;

/// The commands that are not records, and what they do: the help, the man page and the completions are
/// all written from this list and from the records.
pub const FIXED: &[(&str, &str)] = &[
    ("help", "this list, or one record's options (help RECORD)"),
    (
        "page",
        "every record and query on one page, printed (ikb page > page.md for people to browse)",
    ),
    (
        "set",
        "change fields of one existing row of any table, checked (set TABLE --key K --field NAME=VALUE)",
    ),
    ("remove", "take one row away, checked (remove TABLE --key K)"),
    ("man", "the man page"),
    (
        "completions",
        "completions for bash, zsh, fish or nushell (completions SHELL)",
    ),
];

pub const SHELLS: [&str; 4] = ["bash", "zsh", "fish", "nushell"];

/// What the shell may offer next: `words` are the words typed after `ikb`, `cur` the one being typed.
pub fn candidates(records: &[Statement], words: &[String], cur: &str) -> Vec<String> {
    let names = || -> Vec<String> { records.iter().map(|s| s.name.clone()).collect() };
    let mut out: Vec<String> = match words.first().map(String::as_str) {
        None if cur.starts_with('-') => {
            vec!["--help".into(), "--version".into(), "--tables".into()]
        }
        None => FIXED
            .iter()
            .map(|(n, _)| n.to_string())
            .chain(names())
            .collect(),
        Some("help") if words.len() == 1 => names(),
        Some("completions") if words.len() == 1 => SHELLS.iter().map(|s| s.to_string()).collect(),
        Some("set") | Some("remove") => vec![
            "--key".into(),
            "--field".into(),
            "--skip-render".into(),
            "--tables".into(),
        ],
        Some("help") | Some("completions") | Some("man") => vec![],
        Some(name) => match records.iter().find(|s| s.name == name) {
            None => vec![],
            Some(s) => {
                let prev = words.last().map(String::as_str).unwrap_or("");
                let given = |p: &str| {
                    words
                        .iter()
                        .any(|w| w == &format!("--{p}") || w.starts_with(&format!("--{p}=")))
                };
                if let Some(p) = prev
                    .strip_prefix("--")
                    .and_then(|n| s.params.iter().find(|p| p.name == n))
                {
                    // the option just typed takes a value; a folder option can be made by `auto`
                    if p.name == "material" || p.name == "file" {
                        vec!["auto".into()]
                    } else {
                        vec![]
                    }
                } else {
                    s.params
                        .iter()
                        .filter(|p| !given(&p.name))
                        .map(|p| format!("--{}", p.name))
                        .chain(["--skip-render".to_string(), "--tables".to_string()])
                        .collect()
                }
            }
        },
    };
    out.retain(|c| c.starts_with(cur));
    out
}

/// The glue script for one shell.
pub fn script(shell: &str) -> Option<&'static str> {
    Some(match shell {
        "bash" => BASH,
        "zsh" => ZSH,
        "fish" => FISH,
        "nushell" | "nu" => NUSHELL,
        _ => return None,
    })
}

const BASH: &str = r#"# ikb completions for bash: `ikb completions bash`; the words come from ikb itself, asked as you type
_ikb() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(ikb complete --cur="$cur" "${COMP_WORDS[@]:1:COMP_CWORD-1}" 2>/dev/null) )
}
complete -F _ikb ikb
"#;

const ZSH: &str = r#"#compdef ikb
# ikb completions for zsh: `ikb completions zsh`; the words come from ikb itself, asked as you type
_ikb() {
    local -a c
    c=("${(@f)$(ikb complete --cur="${words[CURRENT]}" "${(@)words[2,CURRENT-1]}" 2>/dev/null)}")
    compadd -a c
}
compdef _ikb ikb
"#;

const FISH: &str = r#"# ikb completions for fish: `ikb completions fish`; the words come from ikb itself, asked as you type
function __ikb_complete
    set -l cur (commandline -ct)
    set -l words (commandline -opc)[2..-1]
    ikb complete --cur="$cur" $words 2>/dev/null
end
complete -c ikb -f -a '(__ikb_complete)'
"#;

const NUSHELL: &str = r#"# ikb completions for nushell: `ikb completions nushell | save -f ~/.config/nushell/ikb.nu`, then `source` it
def "nu-complete ikb" [context: string] {
    let words = ($context | split row ' ' | skip 1)
    let cur = ($words | last | default '')
    let before = ($words | drop 1)
    ^ikb complete $"--cur=($cur)" ...$before | lines
}
export extern "ikb" [ ...words: string@"nu-complete ikb" ]
"#;

#[cfg(test)]
mod tests {
    use super::*;

    fn records() -> Vec<Statement> {
        let d = std::env::temp_dir().join(format!("ikb-complete-{}", std::process::id()));
        std::fs::create_dir_all(d.join("records")).unwrap();
        std::fs::write(
            d.join("records/note.sql"),
            "-- A note.\n-- --id  string  x\n-- --material  string?  folder\nSELECT 1;\n",
        )
        .unwrap();
        crate::model::load(&d).unwrap()
    }

    #[test]
    fn names_options_and_values_come_from_the_records() {
        let r = records();
        assert!(candidates(&r, &[], "").contains(&"note".to_string()));
        assert_eq!(candidates(&r, &[], "no"), vec!["note"]);
        assert_eq!(candidates(&r, &["help".into()], ""), vec!["note"]);
        assert!(candidates(&r, &[], "re").contains(&"remove".to_string()));
        let opts = candidates(&r, &["note".into(), "--id".into(), "a".into()], "--");
        assert!(opts.contains(&"--material".to_string()) && !opts.contains(&"--id".to_string()));
        assert_eq!(
            candidates(&r, &["note".into(), "--material".into()], ""),
            vec!["auto"]
        );
        assert_eq!(candidates(&r, &["completions".into()], "fi"), vec!["fish"]);
    }

    #[test]
    fn every_shell_has_a_script() {
        for s in SHELLS {
            assert!(script(s).unwrap().contains("ikb complete"));
        }
    }
}

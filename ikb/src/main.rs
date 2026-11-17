//! ikb - record into a knowledge base by domain commands. Every record of the base (records/*.sql) is a
//! subcommand with its header's options; the man page and the page are written from the same headers. ikb
//! calls tad for the work and holds no table, no SQL and no layout of its own beyond the files a record names.
use anyhow::{bail, Context, Result};
use argenv_resolve::generate::{self, Program};
use argenv_resolve::*;
use std::path::Path;
use std::process::Command;
use tad::statements::Statement;

mod complete;
mod edit;
mod model;
mod text;

const ABOUT: &str =
    "Record into a knowledge base by domain commands read from its own records/*.sql";

contract! {
    /// The declaration.
    TABLES: String = Input {
        key:     "tables",
        ty:      Type::Path,
        default: Some(String::new()),
        arg:     Some(Arg { value_name: "FILE", ..Arg::long("tables") }),
        summary: "The base's declaration (default: tables.toml); its records/ and queries/ are read beside it",
        ..Input::EMPTY
    };

    /// A key value, for set and remove.
    KEY: String = Input {
        key:     "key",
        ty:      Type::String,
        arg:     Some(Arg { value_name: "VALUE", ..Arg::long("key") }),
        summary: "set, remove: the row's key value (repeat for a key of several fields)",
        ..Input::EMPTY
    };

    /// A field to change, for set.
    FIELD: String = Input {
        key:     "field",
        ty:      Type::String,
        arg:     Some(Arg { value_name: "NAME=VALUE", ..Arg::long("field") }),
        summary: "set: a field and its new value (repeat for several; @FILE or @- read text)",
        ..Input::EMPTY
    };

    /// Skip canon and render.
    SKIP_RENDER: bool = Input {
        key:     "skip_render",
        ty:      Type::Bool,
        arg:     Some(Arg::long("skip-render")),
        summary: "Do not run tad canon and tad render after the record (run them once after several records)",
        ..Input::EMPTY
    };
}

fn usage(all: &[Statement]) -> String {
    let mut s = format!(
        "ikb {}: {ABOUT}\n\nusage: ikb RECORD --option value ...   (ikb help RECORD for one; ikb page for the whole)\n\nrecords of this base:\n",
        env!("CARGO_PKG_VERSION")
    );
    for r in all {
        s.push_str(&format!("  {:<18} {}\n", r.name, r.summary));
    }
    s.push_str("\nother commands:\n");
    for (n, d) in complete::FIXED {
        s.push_str(&format!("  {n:<18} {d}\n"));
    }
    s
}

fn main() {
    if let Err(e) = run() {
        eprintln!("ikb: {e:#}");
        std::process::exit(1);
    }
}

fn run() -> Result<()> {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let tables = flag_value(&args, "tables").unwrap_or_else(|| "tables.toml".into());
    let root = tad::statements::root_of(Path::new(&tables));
    let all = model::load(&root)?;
    let hidden = model::machine(&root);
    let shown: Vec<Statement> = all
        .iter()
        .filter(|s| !hidden.contains(&s.name))
        .cloned()
        .collect();
    let first = args.first().map(String::as_str).unwrap_or("help");
    // --help (or -h) after any command says that command, the same way for a record and for the fixed ones
    if first != "help" && args[1..].iter().any(|a| a == "--help" || a == "-h") {
        print!("{}", command_help(first, &all)?);
        return Ok(());
    }
    match first {
        "-V" | "--version" => println!("ikb {}", env!("CARGO_PKG_VERSION")),
        "help" | "-h" | "--help" => match args.get(1).filter(|a| !a.starts_with('-')) {
            None => print!("{}", usage(&shown)),
            Some(n) => print!("{}", command_help(n, &all)?),
        },
        "set" | "remove" => {
            let call = edit::parse(first, &args[1..])?;
            let said = if first == "set" {
                edit::set(&tables, std::path::Path::new("data"), &call)?
            } else {
                edit::remove(&tables, std::path::Path::new("data"), &call)?
            };
            if !call.skip_render {
                for step in ["canon", "render"] {
                    let o = Command::new("tad")
                        .arg(step)
                        .arg(format!("--tables={tables}"))
                        .output()?;
                    if !o.status.success() {
                        eprint!(
                            "{}{}",
                            String::from_utf8_lossy(&o.stdout),
                            String::from_utf8_lossy(&o.stderr)
                        );
                        bail!("tad {step} failed after the change");
                    }
                }
            }
            println!(
                "{said}{}",
                if call.skip_render {
                    "; run tad canon && tad render once you have changed all"
                } else {
                    "; canon and render done"
                }
            );
        }
        "completions" => {
            let shell = args.get(1).map(String::as_str).unwrap_or("");
            print!(
                "{}",
                complete::script(shell).with_context(|| format!("completions for bash, zsh, fish or nushell; '{shell}' is none of them (ikb completions SHELL)"))?
            );
        }
        "complete" => {
            let cur = args
                .iter()
                .find_map(|a| a.strip_prefix("--cur="))
                .unwrap_or("");
            let words: Vec<String> = args[1..]
                .iter()
                .filter(|a| !a.starts_with("--cur=") && !a.starts_with("--tables"))
                .cloned()
                .collect();
            for c in complete::candidates(&shown, &words, cur) {
                println!("{c}");
            }
        }
        "page" | "man" => {
            let fixed = Contract::records();
            let resolved = Invocation {
                args: &args,
                env: &ProcessEnv,
            }
            .resolve(&fixed);
            handle_problems(&lint(&fixed, &resolved), OnProblems::FailOnError);
            if first == "man" {
                let commands: Vec<generate::Command> = shown
                    .iter()
                    .map(|s| generate::Command {
                        name: &s.name,
                        summary: &s.summary,
                    })
                    .chain(complete::FIXED.iter().map(|(n, d)| generate::Command {
                        name: n,
                        summary: d,
                    }))
                    .collect();
                let date = tad::today();
                let program = Program {
                    name: "ikb",
                    version: env!("CARGO_PKG_VERSION"),
                    about: ABOUT,
                    commands: &commands,
                    exit_status: &[
                        ("0", "done"),
                        (
                            "1",
                            "the record was refused or the call is wrong - nothing was kept",
                        ),
                        ("2", "the invocation is wrong"),
                    ],
                    see_also: &["tad(1)", "git(1)"],
                    date: &date,
                    asked: &[],
                };
                print!(
                    "{}",
                    generate::man_page(
                        &program,
                        &[fixed, model::records_prefixed(&shown)].concat()
                    )?
                );
            } else {
                print!("{}", model::page(&shown, &model::load_queries(&root)));
            }
        }
        name => record(&root, &tables, find(&all, name)?)?,
    }
    Ok(())
}

fn find<'a>(all: &'a [Statement], name: &str) -> Result<&'a Statement> {
    all.iter().find(|s| s.name == name).with_context(|| {
        format!(
            "'{name}' is not a record of this base; they are: {}\n\n(ikb help lists them with what they do)",
            all.iter().map(|s| s.name.as_str()).collect::<Vec<_>>().join(", ")
        )
    })
}

fn flag_value(args: &[String], flag: &str) -> Option<String> {
    let long = format!("--{flag}");
    args.iter().enumerate().find_map(|(i, a)| {
        if *a == long {
            args.get(i + 1).cloned()
        } else {
            a.strip_prefix(&format!("{long}=")).map(str::to_string)
        }
    })
}

fn record(root: &Path, tables: &str, s: &Statement) -> Result<()> {
    let model = [Contract::records(), model::records(std::slice::from_ref(s))].concat();
    let args: Vec<String> = std::env::args().skip(1).collect();
    let resolved = Invocation {
        args: &args,
        env: &ProcessEnv,
    }
    .resolve(&model);
    handle_problems(&lint(&model, &resolved), OnProblems::FailOnError);
    let stdin_uses = s
        .params
        .iter()
        .filter(|p| resolved.raw(&model::key(p)) == Some("@-"))
        .count();
    if stdin_uses > 1 {
        bail!("@- (standard input) is given to {stdin_uses} options; it can be read once - put the other texts in files (@FILE)");
    }
    // what was given, by an option or by its variable; a default is tad's to apply
    let mut given: Vec<(String, String)> = Vec::new();
    for p in &s.params {
        let k = model::key(p);
        if matches!(resolved.source(&k), Some(Source::Arg) | Some(Source::Env)) {
            let raw = resolved.raw(&k).unwrap_or_default();
            if raw.is_empty() {
                continue; // an empty value is not a value: the option is not given
            }
            given.push((p.name.clone(), text::expand(raw, &mut std::io::stdin())?));
        }
    }
    fn get(given: &[(String, String)], n: &str) -> Option<String> {
        given.iter().find(|(k, _)| k == n).map(|(_, v)| v.clone())
    }
    let date = get(&given, "date").unwrap_or_else(tad::today);
    let mut said = Vec::new();
    if model::id_is_made(s) && get(&given, "id").is_none() {
        let from = get(&given, "brief")
            .or_else(|| get(&given, "title"))
            .unwrap_or_default();
        let dated = s
            .params
            .iter()
            .any(|p| p.name == "id" && p.summary.starts_with("YYYY-MM-DD"));
        let id = text::slug(&from, dated.then_some(date.as_str()));
        said.push(format!("id {id}"));
        given.push(("id".into(), id));
    }
    // a file option names a place in the base's structure; `auto` makes the conventional one
    for (name, what) in [("material", "research material"), ("file", "upstream item")] {
        if let Some(i) = given.iter().position(|(k, v)| k == name && v == "auto") {
            given[i].1 = if name == "material" {
                let about = get(&given, "about")
                    .context("--material auto needs --about: the folder is research/ABOUT/DATE/")?;
                format!("research/{about}/{date}/")
            } else {
                let up = get(&given, "upstream")
                    .context("--file auto needs --upstream: the folder is upstream/UPSTREAM/ID/")?;
                let id = get(&given, "id")
                    .context("--file auto needs --id (or a title to make it from)")?;
                format!("upstream/{up}/{id}/")
            };
        }
        if let Some(m) = get(&given, name) {
            let dir = root.join(&m);
            if dir.is_file() {
                bail!("--{name} {m} is a file; it names a folder to put the {what} in");
            }
            std::fs::create_dir_all(&dir)?;
            said.push(format!("{name} folder {m}"));
        }
    }
    let mut cmd = Command::new("tad");
    cmd.arg("record")
        .arg(&s.name)
        .arg(format!("--tables={tables}"));
    for (k, v) in &given {
        cmd.arg(format!("--{k}={v}"));
    }
    let out = cmd
        .output()
        .context("running tad (is it installed? ./bin/install-tad.sh)")?;
    if !out.status.success() {
        eprint!(
            "{}{}",
            String::from_utf8_lossy(&out.stdout),
            String::from_utf8_lossy(&out.stderr)
        );
        bail!("{} was refused; nothing was kept", s.name);
    }
    if !Contract::SKIP_RENDER
        .get_from_or_default(&resolved)
        .unwrap_or(false)
    {
        for step in ["canon", "render"] {
            let o = Command::new("tad")
                .arg(step)
                .arg(format!("--tables={tables}"))
                .output()?;
            if !o.status.success() {
                eprint!(
                    "{}{}",
                    String::from_utf8_lossy(&o.stdout),
                    String::from_utf8_lossy(&o.stderr)
                );
                bail!("tad {step} failed after the record");
            }
        }
        said.push("canon and render done".into());
    } else {
        said.push("run tad canon && tad render once you have recorded all".into());
    }
    let id = get(&given, "id");
    println!(
        "recorded {}{}: {}",
        s.name,
        id.map(|i| format!(" {i}")).unwrap_or_default(),
        said.join("; ")
    );
    Ok(())
}

/// What `ikb help NAME` and `ikb NAME --help` say: a record's options from its header, a fixed command's
/// usage and its options from the contract.
fn command_help(name: &str, all: &[Statement]) -> Result<String> {
    if let Some(s) = all.iter().find(|s| s.name == name) {
        return Ok(model::help(s));
    }
    let said = complete::FIXED
        .iter()
        .find(|(n, _)| *n == name)
        .map(|(_, d)| *d)
        .with_context(|| {
            format!("'{name}' is not a command or a record of this base (ikb --help lists them)")
        })?;
    let usage = match name {
        "set" => "ikb set TABLE --key K [--key K2] --field NAME=VALUE [--field ...] [--skip-render] [--tables FILE]",
        "remove" => "ikb remove TABLE --key K [--key K2] [--skip-render] [--tables FILE]",
        "completions" => "ikb completions bash|zsh|fish|nushell",
        "help" => "ikb help [COMMAND]",
        _ => "ikb page|man [--tables FILE]",
    };
    let wanted: &[&str] = match name {
        "set" => &["key", "field", "skip_render", "tables"],
        "remove" => &["key", "skip_render", "tables"],
        "page" | "man" => &["tables"],
        _ => &[],
    };
    let mut t = format!("{said}\n\n{usage}\n\n");
    for r in Contract::records()
        .iter()
        .filter(|r| wanted.contains(&r.key.as_str()))
    {
        t.push_str(&format!(
            "  {}: {}\n",
            r.arg_labels().join(", "),
            r.summary.clone().unwrap_or_default()
        ));
    }
    Ok(t)
}

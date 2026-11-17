//! ikb - record into a knowledge base by domain commands. Every record of the base (records/*.sql) is a
//! subcommand with its header's options; the man page and IKB.md are written from the same headers. ikb
//! calls tad for the work and holds no table, no SQL and no layout of its own beyond the files a record names.
use anyhow::{bail, Context, Result};
use argenv_resolve::generate::{self, Program};
use argenv_resolve::*;
use std::path::Path;
use std::process::Command;
use tad::statements::Statement;

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

    /// Skip canon and render.
    SKIP_RENDER: bool = Input {
        key:     "skip_render",
        ty:      Type::Bool,
        arg:     Some(Arg::long("skip-render")),
        summary: "Do not run tad canon and tad render after the record (run them once after several records)",
        ..Input::EMPTY
    };

    /// Write IKB.md.
    WRITE: bool = Input {
        key:     "write",
        ty:      Type::Bool,
        arg:     Some(Arg::long("write")),
        summary: "page: write IKB.md in the base instead of printing it",
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
    s.push_str("\nother commands:\n  help [RECORD]      this list, or one record's options\n  page [--write]     IKB.md: the one page to read (written beside tables.toml with --write)\n  man                the man page\n");
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
    match first {
        "-V" | "--version" => println!("ikb {}", env!("CARGO_PKG_VERSION")),
        "help" | "-h" | "--help" => match args.get(1).filter(|a| !a.starts_with('-')) {
            None => print!("{}", usage(&shown)),
            Some(n) => print!("{}", model::help(find(&all, n)?)),
        },
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
                let md = model::page(
                    env!("CARGO_PKG_VERSION"),
                    &shown,
                    &model::load_queries(&root),
                );
                if Contract::WRITE
                    .get_from_or_default(&resolved)
                    .unwrap_or(false)
                {
                    let to = root.join("IKB.md");
                    std::fs::write(&to, &md)?;
                    println!("wrote {}", to.display());
                } else {
                    print!("{md}");
                }
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
    // what was given, by an option or by its variable; a default is tad's to apply
    let mut given: Vec<(String, String)> = Vec::new();
    for p in &s.params {
        let k = model::key(p);
        if matches!(resolved.source(&k), Some(Source::Arg) | Some(Source::Env)) {
            let raw = resolved.raw(&k).unwrap_or_default();
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
    if let Some(i) = given
        .iter()
        .position(|(k, v)| k == "material" && v == "auto")
    {
        let about = get(&given, "about")
            .context("--material auto needs --about: the folder is research/ABOUT/DATE/")?;
        let folder = format!("research/{about}/{date}/");
        given[i].1 = folder;
    }
    if let Some(m) = get(&given, "material") {
        let dir = root.join(&m);
        if dir.is_file() {
            bail!("--material {m} is a file; it names a folder: research/SUBJECT/YYYY-MM-DD/");
        }
        std::fs::create_dir_all(&dir)?;
        said.push(format!("material folder {m}"));
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

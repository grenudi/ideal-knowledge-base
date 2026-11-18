//! `ikb set` and `ikb remove`: the checked way to change or take away one row of any declared table, for what no
//! named record is made for - so that nobody writes `tad sql` by hand. Everything they accept comes from the
//! base's own tables.toml (the tables, their keys, fields and allowed values); tad checks every rule before a
//! change is kept (tad::set puts the file back when one breaks; a removal is run through `tad sql`, which does
//! the same). A row is changed only if it exists: adding one is the job of its record.
use anyhow::{bail, Context, Result};
use serde_json::Value;
use std::path::Path;
use std::process::Command;

pub struct Call {
    pub table: String,
    pub keys: Vec<String>,
    pub fields: Vec<(String, String)>,
    pub skip_render: bool,
}

fn declaration(tables: &str) -> Result<tad::Declaration> {
    toml::from_str(&std::fs::read_to_string(tables).with_context(|| format!("reading {tables}"))?)
        .with_context(|| format!("{tables} is not a declaration"))
}

/// The words after `set` or `remove`: TABLE, then --key V (repeated for a key of several fields), --field F=V
/// (repeated), --skip-render, --tables FILE (taken by the caller).
pub fn parse(verb: &str, args: &[String]) -> Result<Call> {
    let mut call = Call {
        table: String::new(),
        keys: vec![],
        fields: vec![],
        skip_render: false,
    };
    let mut i = 0;
    while i < args.len() {
        let a = &args[i];
        let (name, inline) = match a.split_once('=') {
            Some((n, v)) if n.starts_with("--") => (n, Some(v.to_string())),
            _ => (a.as_str(), None),
        };
        let mut value = |what: &str| -> Result<String> {
            match &inline {
                Some(v) => Ok(v.clone()),
                None => {
                    i += 1;
                    args.get(i)
                        .cloned()
                        .with_context(|| format!("{name} needs {what}"))
                }
            }
        };
        match name {
            "--key" => call.keys.push(value("a value")?),
            "--field" => {
                let v = value("NAME=VALUE")?;
                let (f, val) = v
                    .split_once('=')
                    .with_context(|| format!("--field wants NAME=VALUE; '{v}' has no ="))?;
                call.fields.push((
                    f.trim().to_string(),
                    crate::text::expand(val, &mut std::io::stdin())?,
                ));
            }
            "--skip-render" => call.skip_render = true,
            "--tables" => {
                value("a file")?;
            }
            n if n.starts_with("--") => {
                bail!("{n} is not an option of {verb}: --key, --field, --skip-render, --tables")
            }
            _ if call.table.is_empty() => call.table = a.clone(),
            _ => bail!("{verb} takes one TABLE; '{a}' is a second"),
        }
        i += 1;
    }
    Ok(call)
}

fn tables_help(d: &tad::Declaration) -> String {
    d.tables
        .iter()
        .map(|(n, t)| format!("  {n} (key: {})", t.key.join(", ")))
        .collect::<Vec<_>>()
        .join("\n")
}

fn fields_help(t: &tad::Table) -> String {
    t.fields
        .iter()
        .map(|f| {
            if f.allowed.is_empty() {
                format!("  {} ({})", f.name, f.ty)
            } else {
                format!("  {} ({}: {})", f.name, f.ty, f.allowed.join(", "))
            }
        })
        .collect::<Vec<_>>()
        .join("\n")
}

#[allow(clippy::cmp_owned)]
/// The row with this key, as the data file has it.
fn find_row(data: &Path, table: &str, key_fields: &[String], key: &[String]) -> Option<Value> {
    std::fs::read_to_string(data.join(format!("{table}.json")))
        .unwrap_or_default()
        .lines()
        .filter_map(|l| serde_json::from_str::<Value>(l).ok())
        .find(|r| {
            key_fields.iter().zip(key).all(|(k, v)| match r.get(k) {
                Some(Value::String(s)) => s == v,
                Some(other) => other.to_string() == *v,
                None => false,
            })
        })
}

#[allow(clippy::cmp_owned)]
fn row_exists(data: &Path, table: &str, key_fields: &[String], key: &[String]) -> bool {
    find_row(data, table, key_fields, key).is_some()
}

#[allow(clippy::cmp_owned)]
/// Whether the row already says what is asked: a field equal to its value, an empty value for a field with none.
fn says_already(row: &Value, f: &str, v: &str) -> bool {
    match row.get(f) {
        None | Some(Value::Null) => v.is_empty(),
        Some(Value::String(s)) => s == v,
        Some(other) => other.to_string() == v,
    }
}

/// Looks at what was asked against the declaration; returns the table and what to do next.
fn check<'a>(
    verb: &str,
    d: &'a tad::Declaration,
    data: &Path,
    call: &Call,
) -> Result<&'a tad::Table> {
    if call.table.is_empty() {
        bail!(
            "{verb} needs a TABLE; this base declares:\n{}",
            tables_help(d)
        );
    }
    let t = d.tables.get(&call.table).with_context(|| {
        format!(
            "no table {} is declared; they are:\n{}",
            call.table,
            tables_help(d)
        )
    })?;
    if call.keys.len() != t.key.len() {
        bail!(
            "{} is keyed by ({}): give {} --key value(s), in that order",
            call.table,
            t.key.join(", "),
            t.key.len()
        );
    }
    if !row_exists(data, &call.table, &t.key, &call.keys) {
        bail!(
            "{} has no row with key ({}) = ({}){}",
            call.table,
            t.key.join(", "),
            call.keys.join(", "),
            if verb == "set" {
                "; a row is added by its own record (ikb help lists them)"
            } else {
                ""
            }
        );
    }
    Ok(t)
}

pub fn set(tables: &str, data: &Path, call: &Call) -> Result<String> {
    let d = declaration(tables)?;
    let t = check("set", &d, data, call)?;
    if call.fields.is_empty() {
        bail!(
            "set needs at least one --field NAME=VALUE; {} has:\n{}",
            call.table,
            fields_help(t)
        );
    }
    for (f, v) in &call.fields {
        let Some(field) = t.fields.iter().find(|x| &x.name == f) else {
            bail!(
                "{} has no field {f}; it has:\n{}",
                call.table,
                fields_help(t)
            );
        };
        if t.key.contains(f) {
            bail!(
                "{f} is the key of {}; a row is not renamed here",
                call.table
            );
        }
        if !field.allowed.is_empty() && !field.allowed.contains(v) {
            bail!(
                "{f} of {} is one of: {} - not '{v}'",
                call.table,
                field.allowed.join(", ")
            );
        }
    }
    // a change that changes nothing is said, not shown as done
    if let Some(row) = find_row(data, &call.table, &t.key, &call.keys) {
        if call.fields.iter().all(|(f, v)| says_already(&row, f, v)) {
            bail!(
                "nothing changed: {} ({}) already has {}",
                call.table,
                call.keys.join(", "),
                call.fields
                    .iter()
                    .map(|(f, v)| format!("{f}={v}"))
                    .collect::<Vec<_>>()
                    .join(", ")
            );
        }
    }
    tad::set(data, &d, &call.table, &call.keys, &call.fields)
}

fn quote(s: &str) -> String {
    format!("'{}'", s.replace('\'', "''"))
}

pub fn remove(tables: &str, data: &Path, call: &Call) -> Result<String> {
    let d = declaration(tables)?;
    let t = check("remove", &d, data, call)?;
    if !call.fields.is_empty() {
        bail!("remove takes no --field; it takes the row away whole (set changes a field)");
    }
    let cond = t
        .key
        .iter()
        .zip(&call.keys)
        .map(|(k, v)| format!("\"{k}\" = {}", quote(v)))
        .collect::<Vec<_>>()
        .join(" AND ");
    let sql = format!("DELETE FROM \"{}\" WHERE {cond}", call.table);
    let out = Command::new("tad")
        .arg("sql")
        .arg(&sql)
        .arg(format!("--tables={tables}"))
        .output()
        .context("running tad (is it installed? ./bin/install-tad.sh)")?;
    if !out.status.success() {
        bail!(
            "{}{}removal refused; nothing was kept",
            String::from_utf8_lossy(&out.stdout),
            String::from_utf8_lossy(&out.stderr)
        );
    }
    Ok(format!("removed {} ({})", call.table, call.keys.join(", ")))
}

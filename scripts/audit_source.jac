"""Read-only source composition audit. Run with jac run scripts/audit_source.jac."""
import os;
import json;

def audit_source() -> dict[str, any] {
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)));
    languages = {
        ".jac": "Jac", ".css": "CSS", ".html": "HTML", ".htm": "HTML",
        ".ps1": "PowerShell", ".bat": "Batch", ".py": "Python",
        ".js": "JavaScript", ".mjs": "JavaScript", ".cjs": "JavaScript",
        ".ts": "TypeScript", ".jsx": "JSX", ".tsx": "TSX", ".sh": "Shell"
    };
    excluded_dirs = [
        ".git", ".jac", ".venv", "venv", "node_modules", "reference_materials",
        "__pycache__", ".pytest_cache", ".mypy_cache", ".ruff_cache", ".cache",
        "generated", ".generated", "dist", "build", "out", "coverage", "data", "docs"
    ];
    by_suffix: dict[str, dict[str, int]] = {};
    by_language: dict[str, dict[str, int]] = {};
    files: list[dict[str, any]] = [];
    pruned: list[str] = [];
    read_errors: list[str] = [];
    symlinks: list[str] = [];
    noncode_skipped = 0;
    for (directory, children, names) in os.walk(project_root, followlinks=False) {
        kept = [];
        for child in sorted(children) {
            child_path = os.path.join(directory, child);
            if child.lower() in excluded_dirs or os.path.islink(child_path) {
                pruned.append(os.path.relpath(child_path, project_root).replace("\\", "/"));
            } else { kept.append(child); }
        }
        children[:] = kept;
        for name in sorted(names) {
            suffix = os.path.splitext(name)[1].lower();
            if suffix not in languages { noncode_skipped = noncode_skipped + 1; continue; }
            source_path = os.path.join(directory, name);
            relative = os.path.relpath(source_path, project_root).replace("\\", "/");
            if os.path.islink(source_path) { symlinks.append(relative); continue; }
            try {
                with open(source_path, "r", encoding="utf-8-sig") as source { content = source.read(); }
            } except (OSError, UnicodeError) { read_errors.append(relative); continue; }
            lines = len([line for line in content.splitlines() if line.strip()]);
            byte_count = len("".join(content.split()).encode("utf-8"));
            language = str(languages[suffix]);
            row = {"path": relative, "suffix": suffix, "language": language,
                "nonblank_lines": lines, "nonwhitespace_utf8_bytes": byte_count};
            files.append(row);
            for (key, table) in [(suffix, by_suffix), (language, by_language)] {
                if key not in table { table[key] = {"files": 0, "nonblank_lines": 0, "nonwhitespace_utf8_bytes": 0}; }
                table[key]["files"] = table[key]["files"] + 1;
                table[key]["nonblank_lines"] = table[key]["nonblank_lines"] + lines;
                table[key]["nonwhitespace_utf8_bytes"] = table[key]["nonwhitespace_utf8_bytes"] + byte_count;
            }
        }
    }
    total_lines: int = sum([int(row["nonblank_lines"]) for row in files]);
    total_bytes: int = sum([int(row["nonwhitespace_utf8_bytes"]) for row in files]);
    jac: dict[str, int] = by_language.get("Jac", {"nonblank_lines": 0, "nonwhitespace_utf8_bytes": 0});
    return {
        "complete": len(read_errors) == 0, "project_root": project_root,
        "method": "UTF-8 source; optional BOM removed; nonblank lines and UTF-8 bytes after removing Unicode whitespace; comments included; audit includes itself",
        "total_files": len(files), "total_nonblank_lines": total_lines,
        "total_nonwhitespace_utf8_bytes": total_bytes,
        "jac_percent_nonblank_lines": 100.0 * jac["nonblank_lines"] / total_lines if total_lines else 0,
        "jac_percent_nonwhitespace_utf8_bytes": 100.0 * jac["nonwhitespace_utf8_bytes"] / total_bytes if total_bytes else 0,
        "by_language": by_language, "by_suffix": by_suffix, "files": files,
        "included_suffixes": sorted(languages), "excluded_directory_names": excluded_dirs,
        "pruned_directories": pruned, "symlink_files_skipped": symlinks,
        "noncode_files_skipped": noncode_skipped,
        "excluded_noncode_examples": [".env", ".env.example", ".md", ".json", ".toml", ".yaml", ".yml", ".txt", ".pdf", ".pptx", ".png"],
        "read_errors": read_errors, "note": "Composition measurement only; no competition compliance verdict or Linguist override. No source content or credentials are printed."
    };
}

with entry:__main__ { print(json.dumps(audit_source(), indent=2, sort_keys=True)); }

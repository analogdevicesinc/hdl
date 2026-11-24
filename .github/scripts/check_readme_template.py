#!/usr/bin/env python3
###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: BSD-1-Clause
##
## Enforces the README template on HDL project READMEs. Invoked from
## .github/workflows/check_readme_template.yaml.
###############################################################################
"""Enforce README template conventions on HDL project READMEs.

Usage:
    python3 check_readme_template.py --all
    python3 check_readme_template.py path/to/README.md [path/to/other/README.md ...]

Exits 0 if every README passes, 1 on any violation. Output format depends
on context: inline `::error file=...,line=N::<msg>` annotations when invoked
by GitHub Actions on a PR; colored `[ERROR]`/`[WARNING]`/`[INFO]` stderr
lines otherwise
"""
import argparse
import os
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

# ---------------------------------------------------------------------------
# Regexes
# ---------------------------------------------------------------------------

TAG_NAMES = ("no_build_example", "no_dts", "no_no_os")

# e.g.: `<!-- no_dts, no_no_os -->`
TAG_COMMENT_RE = re.compile(r"<!--\s*(.+?)\s*-->", re.S)
# e.g.: `# AD9081-FMCA-EBZ/VCU118 HDL Project`
FIRST_H1_RE = re.compile(r"^#\s", re.M)
# e.g.: `### Example configurations` -- lenient on `#` count so the checker can
# diagnose wrong-level variants (`## Example configurations`, etc.).
EXAMPLE_SECTION_RE = re.compile(r"^(#+)\s+Example configurations\s*$", re.M)
# e.g.: `### Overridable parameters`
OVERRIDABLE_SECTION_RE = re.compile(r"^(#+)\s+Overridable parameters\s*$", re.M)
# e.g.: `## Building the project` or `### Supported parts` -- any H1/H2/H3 heading.
NEXT_SECTION_RE = re.compile(r"^#{1,3}\s", re.M)
# e.g.: `#### [DEFAULT] 1-channel TX mode 9, RX mode 10`
VARIANT_HEADING_RE = re.compile(r"^####\s+(.+?)\s*$", re.M)
# e.g.: ```` ```\nmake JESD_MODE=8B10B RX_LANE_RATE=10\n``` ````
CODE_BLOCK_RE = re.compile(r"```[^\n]*\n(.*?)```", re.S)
# e.g.: `Corresponding device tree: [vcu118_ad9081.dts](https://.../vcu118_ad9081.dts)`
DTS_SINGLE_RE = re.compile(r"Corresponding device tree:\s*\[([^\]]+?\.dts)\]\(([^)]+)\)")
# e.g.: `Corresponding device trees:` (bare line, followed by a bullet list of DTS links)
DTS_PLURAL_START_RE = re.compile(r"Corresponding device trees:\s*$", re.M)
# e.g.: `[vcu118_ad9081.dts](https://.../vcu118_ad9081.dts)` -- one entry of the plural list
DTS_LINK_RE = re.compile(r"\[([^\]]+?\.dts)\]\(([^)]+)\)")
# e.g.: `Corresponding No-OS project: [AD9081 project](https://github.com/.../ad9081)`
NOOS_LINE_RE = re.compile(
    r"Corresponding\s+No[-_ ]?OS\s+project[^:]*:\s*\[([^\]]+)\]\(([^)]+)\)",
    re.I,
)
# e.g.: `[analog.com](https://www.analog.com/ad9081)` -- any Markdown link with an http(s) URL
MARKDOWN_HTTP_LINK_RE = re.compile(r"\[[^\]]*\]\((https?://[^)\s]+)\)")

# Overridable parameters table header + rows.
# e.g. header: `| Key | Default | Values and description |`
TABLE_HEADER_RE = re.compile(
    r"^\|\s*Key\s*\|\s*Default\s*\|\s*Values and description\s*\|\s*$",
    re.I | re.M,
)
# e.g. row:    `| JESD_MODE | 8B10B | ``8B10B`` (JESD204B) / ``64B66B`` (JESD204C) |`
#              captures the KEY column; value/description are ignored for validation.
TABLE_ROW_RE = re.compile(r"^\|\s*([A-Z][A-Z0-9_]*)\s*\|\s*([^|]*?)\s*\|", re.M)

# Required H2 section headings -- lenient on `#` count, same reason as above.
# e.g.: `## Building the project`
BUILDING_SECTION_RE = re.compile(r"^(#+)\s+Building the project\s*$", re.M)
# e.g.: `## Supported parts`
SUPPORTED_PARTS_RE = re.compile(r"^(#+)\s+Supported parts\s*$", re.M)

# e.g.: `[analog.com]( )` or `[analog.com]()` -- a Markdown link with an empty target.
EMPTY_LINK_RE = re.compile(r"\]\(\s*\)")

# Blacklisted URLs (never want these referenced in a README).
BLACKLISTED_URLS = (
    "https://wiki.analog.com/resources/tools-software/linux-drivers-all",
    "https://wiki.analog.com/linux",
)

# Carriers whose README title is a common template that doesn't follow the
# "<BOARD>/<CARRIER> HDL Project" convention.
SPECIAL_CARRIERS_SKIP_TITLE = (
    "adrv2crr_fmc", "adrv2crr_fmcomms8", "adrv2crr_fmcxmwbr1",
)
SPECIAL_CARRIER_PREFIXES_SKIP_TITLE = ("ccbob_", "ccfmc_", "ccpackrf_")

# Projects whose README needs neither the title check nor the "Supported parts"
# section.
SPECIAL_PROJECTS = ("xcvr_wizard",)

# Subdirs under `projects/` that aren't actually projects.
PROJECTS_IGNORED_SUBDIRS = ("common", "scripts")


# ---------------------------------------------------------------------------
# Error reporting
# ---------------------------------------------------------------------------

errors: list[tuple[str, int, str]] = []
warnings: list[tuple[str, int, str]] = []

_ANSI_RESET = "\033[0m"
_LEVEL_COLORS = {
    "ERROR":   "\033[1;31m",  # bold red
    "WARNING": "\033[1;33m",  # bold yellow
    "INFO":    "\033[1;36m",  # bold cyan
}

# Only emit annotations for GA workflows.
IN_GITHUB_ACTIONS = os.environ.get("GITHUB_ACTIONS") == "true"
_emit_annotations = IN_GITHUB_ACTIONS


def tag(level: str) -> str:
    """Colored `[LEVEL] ` prefix for stderr lines; empty in annotation mode."""
    if _emit_annotations:
        return ""
    return f"{_LEVEL_COLORS[level]}[{level}]{_ANSI_RESET} "


def report(path: Path, line_number: int, msg: str, level: str = "error") -> None:
    file_path = str(path)
    (errors if level == "error" else warnings).append((file_path, line_number, msg))
    if _emit_annotations:
        # Annotation body is just the message; GHA renders the file/line
        # separately from the `file=`/`line=` metadata.
        print(f"::{level} file={file_path},line={line_number}::{msg}")
    else:
        print(f"{tag(level.upper())}{file_path}:{line_number}: {msg}", file=sys.stderr)


def line_of(text: str, index: int) -> int:
    """Convert a 0-based character index into a 1-based line number."""
    return text.count("\n", 0, index) + 1


def check_heading_level(
    match: re.Match | None,
    text: str,
    path: Path,
    name: str,
    expected: int,
) -> None:
    """If `match` was found, verify its captured `#`-run is exactly `expected` long."""
    if match is None:
        return
    actual = len(match.group(1))
    if actual != expected:
        report(
            path,
            line_of(text, match.start()),
            f"'{name}' section must use `{'#' * expected}` "
            f"(found `{'#' * actual}`)",
        )


# ---------------------------------------------------------------------------
# Per-README checks
# ---------------------------------------------------------------------------


def check_tags(text: str, path: Path) -> set[str]:
    """Return the set of tags declared in the top-of-file HTML comment.
    Report unknown tags."""
    first_h1 = FIRST_H1_RE.search(text)
    head = text[: first_h1.start()] if first_h1 else text
    comment = TAG_COMMENT_RE.search(head)
    if comment is None:
        return set()
    tokens = {t.strip() for t in comment.group(1).split(",") if t.strip()}
    for unknown in tokens - set(TAG_NAMES):
        report(
            path,
            line_of(text, comment.start()),
            f"unknown tag token '{unknown}' in top-of-file HTML comment "
            f"(allowed: {', '.join(TAG_NAMES)})",
        )
    return tokens & set(TAG_NAMES)


def check_example_section_consistency(text: str, tags: set[str], path: Path) -> re.Match | None:
    """Verify tag <-> `### Example configurations` section agreement. Returns the match or None."""
    section = EXAMPLE_SECTION_RE.search(text)
    check_heading_level(section, text, path, "Example configurations", 3)
    if "no_build_example" in tags and section:
        report(
            path,
            line_of(text, section.start()),
            "`no_build_example` tag is set but README has a '### Example configurations' section",
        )
    elif "no_build_example" not in tags and not section:
        report(
            path,
            1,
            "no '### Example configurations' section found and `no_build_example` tag is not set",
        )
    return section


def check_overridable_table(text: str, section: re.Match | None, path: Path) -> set[str]:
    """Return the keys declared in the `### Overridable parameters` table.

    Empty set if the section isn't required (no Example configurations) or if
    the table is missing/malformed (both of which are also reported).
    """
    if section is None:
        return set()  # project has no Example configurations; table isn't required
    overridable = OVERRIDABLE_SECTION_RE.search(text)
    check_heading_level(overridable, text, path, "Overridable parameters", 3)
    if overridable is None:
        report(
            path,
            line_of(text, section.start()),
            "no '### Overridable parameters' table found (required whenever "
            "'### Example configurations' is present)",
        )
        return set()
    # Body spans from the Overridable heading to the next `#`..`###` heading.
    tail = text[overridable.end():]
    next_major = NEXT_SECTION_RE.search(tail)
    body = tail[: next_major.start()] if next_major else tail
    if TABLE_HEADER_RE.search(body) is None:
        report(
            path,
            line_of(text, overridable.start()),
            "'### Overridable parameters' is not followed by a `| Key | Default | Values and description |` table",
        )
        return set()
    return {m.group(1) for m in TABLE_ROW_RE.finditer(body)}


def check_variants(
    text: str,
    section: re.Match | None,
    declared_keys: set[str],
    path: Path,
) -> None:
    """Enforce per-variant rules: [DEFAULT] count, make block format, key coverage."""
    if section is None:
        return
    body_start = section.end()
    tail = text[body_start:]
    next_major = NEXT_SECTION_RE.search(tail)
    body = tail[: next_major.start()] if next_major else tail

    headings = list(VARIANT_HEADING_RE.finditer(body))
    defaults: list[int] = []
    variant_count = 0
    for i, heading in enumerate(headings):
        name = heading.group(1).strip()
        start = heading.end()
        end = headings[i + 1].start() if i + 1 < len(headings) else len(body)
        chunk = body[start:end]
        heading_line = line_of(text, body_start + heading.start())

        # A `####` is a variant only if it's followed by a code block. A
        # `####` with just prose is a non-variant subsection header and is
        # ignored (used e.g. for carrier-specific notes inside the section).
        block = CODE_BLOCK_RE.search(chunk)
        if block is None:
            continue
        variant_count += 1

        if name.startswith("[DEFAULT]"):
            defaults.append(heading_line)

        block_text = re.sub(r"\\\n\s*", " ", block.group(1))
        make_line = next(
            (ln.strip() for ln in block_text.splitlines() if ln.strip().startswith("make")),
            None,
        )
        if make_line is None:
            report(path, heading_line, f"variant '{name}': code block found but no `make ...` line inside it")
            continue

        params_raw = re.sub(r"\s+", " ", make_line[len("make"):].strip())
        params_tight = re.sub(r"\s*=\s*", "=", params_raw)
        if params_tight != params_raw:
            report(path, heading_line, f"variant '{name}': `KEY = VALUE` spacing in make block; use `KEY=VALUE`")

        if declared_keys:
            for pair in params_tight.split():
                key = pair.split("=", 1)[0] if "=" in pair else None
                if key and key not in declared_keys:
                    report(
                        path,
                        heading_line,
                        f"variant '{name}': overrides key '{key}' not declared in '### Overridable parameters'",
                    )

    if variant_count == 0:
        report(
            path,
            line_of(text, body_start),
            "'### Example configurations' has no variants (a `####` heading with a code block)",
        )
        return
    if len(defaults) == 0:
        report(
            path,
            line_of(text, section.start()),
            "no `[DEFAULT]` tag found on any variant under '### Example configurations'",
        )
    elif len(defaults) > 1:
        for d_line in defaults:
            report(
                path,
                d_line,
                f"`[DEFAULT]` tag appears on {len(defaults)} variants; exactly one is allowed",
            )


def check_noos(text: str, tags: set[str], path: Path) -> None:
    """`Corresponding No-OS project:` line vs `no_no_os` tag."""
    matches = list(NOOS_LINE_RE.finditer(text))
    if "no_no_os" in tags and matches:
        report(
            path,
            line_of(text, matches[0].start()),
            "`no_no_os` tag is set but README has a `Corresponding No-OS project:` line",
        )
    elif "no_no_os" not in tags and not matches:
        report(
            path,
            1,
            "no `Corresponding No-OS project:` line found and `no_no_os` tag is not set",
        )


def check_dts(text: str, tags: set[str], path: Path) -> None:
    """DTS vs `no_dts` tag consistency. The DTS URLs themselves are HEAD-checked
    by the generic link-reachability sweep in `main()`."""
    dts_hits: list[int] = [line_of(text, m.start()) for m in DTS_SINGLE_RE.finditer(text)]
    plural = DTS_PLURAL_START_RE.search(text)
    if plural:
        tail = text[plural.end():]
        stop = NEXT_SECTION_RE.search(tail)
        plural_body = tail[: stop.start()] if stop else tail
        dts_hits.extend(
            line_of(text, plural.end() + m.start()) for m in DTS_LINK_RE.finditer(plural_body)
        )
    if "no_dts" in tags and dts_hits:
        report(path, dts_hits[0], "`no_dts` tag is set but DTS references were found")


def collect_links(text: str) -> list[tuple[str, int]]:
    """Return every (url, line_number) for Markdown links whose URL is http(s)."""
    return [
        (m.group(1), line_of(text, m.start()))
        for m in MARKDOWN_HTTP_LINK_RE.finditer(text)
    ]


# ---------------------------------------------------------------------------
# Link reachability (shared HEAD-check pool)
# ---------------------------------------------------------------------------

# Hosts whose reachability we don't HEAD-check. analog.com's WAF blocks batch
# HEAD/GET requests from a single runner, so every URL comes back as a false
# "network error". HDL reviewers catch typos in product URLs by eye.
UNCHECKED_HOSTS = ("analog.com", "www.analog.com")


def is_unchecked_host(url: str) -> bool:
    return (urllib.parse.urlparse(url).hostname or "").lower() in UNCHECKED_HOSTS


def blob_url_to_raw(url: str) -> str:
    """Convert github.com/.../blob/<ref>/<path> file URLs to raw.githubusercontent.com.

    `/tree/` URLs point at *directories*, which raw.githubusercontent.com does
    not serve -- those are left alone (and hit github.com directly). Any other
    URL is returned unchanged.
    """
    prefix = "https://github.com/"
    if not url.startswith(prefix) or "/blob/" not in url:
        return url
    return url.replace(prefix, "https://raw.githubusercontent.com/", 1).replace("/blob/", "/", 1)


def head_check(urls: set[str]) -> dict[str, str]:
    """Concurrent HEAD-check. Returns {url: 'ok' | 'missing' | 'network_error'}."""

    def _request(url: str, method: str) -> tuple[int | None, bool]:
        """Return (status, network_ok). status is None if network_ok is False."""
        req = urllib.request.Request(url, method=method)
        try:
            with urllib.request.urlopen(req, timeout=15) as resp:
                return resp.status, True
        except urllib.error.HTTPError as e:
            return e.code, True
        except (urllib.error.URLError, TimeoutError):
            return None, False

    def probe(url: str) -> tuple[str, str]:
        target = blob_url_to_raw(url)
        status, net_ok = _request(target, "HEAD")
        # DokuWiki (wiki.analog.com) and some other servers return 5xx or 405
        # to HEAD but serve GET fine. Fall back once before giving up.
        if net_ok and (status >= 500 or status == 405):
            status, net_ok = _request(target, "GET")
        if not net_ok:
            return url, "network_error"
        if 200 <= status < 400:
            return url, "ok"
        if status == 404:
            return url, "missing"
        return url, "network_error"

    results: dict[str, str] = {}
    if not urls:
        return results
    with ThreadPoolExecutor(max_workers=16) as pool:
        for future in as_completed(pool.submit(probe, u) for u in urls):
            url, status = future.result()
            results[url] = status
    return results


# ---------------------------------------------------------------------------
# Top-level per-file driver
# ---------------------------------------------------------------------------


def check_title(text: str, path: Path, project: str, carrier: str | None) -> None:
    """Enforce the exact `# <BOARD>[/CARRIER] HDL Project` H1 (skipped for special carriers/projects)."""
    if project in SPECIAL_PROJECTS:
        return
    if carrier is not None and (
        carrier in SPECIAL_CARRIERS_SKIP_TITLE
        or any(carrier.startswith(p) for p in SPECIAL_CARRIER_PREFIXES_SKIP_TITLE)
    ):
        return
    board = project.upper().replace("_", "-")  # ad9081_fmca_ebz -> AD9081-FMCA-EBZ
    expected = f"# {board} HDL Project" if carrier is None else f"# {board}/{carrier.upper()} HDL Project"
    if expected not in text:
        report(path, 1, f"incorrect or missing title; expected `{expected}`")


def check_required_sections(text: str, tags: set[str], path: Path, project: str, carrier: str | None) -> None:
    """Enforce `## Building the project` + `## Supported parts` presence."""
    # `## Building the project`: required unless `no_build_example` is set.
    building = BUILDING_SECTION_RE.search(text)
    check_heading_level(building, text, path, "Building the project", 2)
    if "no_build_example" not in tags and building is None:
        report(path, 1, "missing `## Building the project` section")
    # `## Supported parts`: project-level READMEs only (not carrier-level), except special projects.
    if carrier is None and project not in SPECIAL_PROJECTS:
        supported = SUPPORTED_PARTS_RE.search(text)
        check_heading_level(supported, text, path, "Supported parts", 2)
        if supported is None:
            report(path, 1, "missing `## Supported parts` section")


def check_blacklisted_links(text: str, path: Path) -> None:
    """Fail on known-bad URLs the HDL team doesn't want referenced."""
    for bad in BLACKLISTED_URLS:
        idx = text.find(bad)
        if idx != -1:
            report(path, line_of(text, idx), f"do not link to {bad}")


def check_empty_links(text: str, path: Path) -> None:
    """Fail on markdown links with empty URL targets: `]( )` or `](`."""
    for m in EMPTY_LINK_RE.finditer(text):
        report(path, line_of(text, m.start()), "empty markdown link `()`")


def project_carrier_from_path(path: Path) -> tuple[str, str | None]:
    """Infer (project, carrier) from a README path.

    `projects/<proj>/README.md`           -> (<proj>, None)   -- project-level README
    `projects/<proj>/<carrier>/README.md` -> (<proj>, <carrier>)
    Raises ValueError for anything else (path not under projects/).
    """
    parts = path.parts
    try:
        proj_idx = parts.index("projects")
    except ValueError:
        raise ValueError(f"path '{path}' is not under projects/")
    tail = parts[proj_idx + 1 :]
    if len(tail) == 2 and tail[-1].lower() == "readme.md":
        return tail[0], None
    if len(tail) == 3 and tail[-1].lower() == "readme.md":
        return tail[0], tail[1]
    raise ValueError(f"path '{path}' is not a project/carrier README")


def has_carrier_subdirs(project: str) -> bool:
    """True if `projects/<project>/` has any carrier subdirectories.

    Used to tell a *summary* project-level README (project has carrier
    subdirs; the template rules are per-carrier) apart from a standalone
    project README (no carrier subdirs; the template rules apply directly).
    """
    proj_dir = Path("projects") / project
    if not proj_dir.is_dir():
        return False
    for sub in proj_dir.iterdir():
        if sub.is_dir() and sub.name not in PROJECTS_IGNORED_SUBDIRS:
            return True
    return False


def walk_all_readmes() -> list[Path]:
    """Enumerate every expected README under `projects/`. Reports missing ones.

    Returns the list of paths that *exist* (so the caller can then run the full
    content checks against them). A missing README is counted as an error but
    not appended to the returned list (there's nothing to parse).
    """
    projects_dir = Path("projects")
    if not projects_dir.is_dir():
        report(Path("projects"), 1, "`projects/` directory not found at repo root")
        return []
    found: list[Path] = []
    for project_dir in sorted(projects_dir.iterdir()):
        if not project_dir.is_dir() or project_dir.name in PROJECTS_IGNORED_SUBDIRS:
            continue
        main_readme = project_dir / "README.md"
        if main_readme.is_file():
            found.append(main_readme)
        else:
            report(main_readme, 1, "README.md not found")
        for carrier_dir in sorted(project_dir.iterdir()):
            if not carrier_dir.is_dir() or carrier_dir.name in PROJECTS_IGNORED_SUBDIRS:
                continue
            carrier_readme = carrier_dir / "README.md"
            if carrier_readme.is_file():
                found.append(carrier_readme)
            else:
                report(carrier_readme, 1, "README.md not found")
    return found


def check_readme(path: Path) -> list[tuple[str, int]]:
    """Run every structural check on `path` and return the list of (url, line) links to HEAD-check later."""
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except FileNotFoundError:
        report(path, 1, "README.md not found")
        return []

    try:
        project, carrier = project_carrier_from_path(path)
    except ValueError as e:
        report(path, 1, str(e))
        return []

    tags = check_tags(text, path)
    check_blacklisted_links(text, path)
    check_empty_links(text, path)

    # Internal tools (e.g. xcvr_wizard) don't follow the HDL-project template,
    # so skip all the structural checks for them. Tag/link validation still
    # applies.
    if project in SPECIAL_PROJECTS:
        return collect_links(text)

    check_title(text, path, project, carrier)
    check_required_sections(text, tags, path, project, carrier)

    # The template is scoped to per-carrier READMEs (`<proj>/<carrier>/README.md`).
    # A `<proj>/README.md` for a project that has carrier subdirs is just a
    # summary page and skips the template-specific checks. Standalone projects
    # (no carrier subdirs -- e.g. jupiter_sdr, m2k, pluto) still get the full
    # template treatment on their project-level README.
    if carrier is None and has_carrier_subdirs(project):
        return collect_links(text)

    section = check_example_section_consistency(text, tags, path)
    declared_keys = check_overridable_table(text, section, path)
    check_variants(text, section, declared_keys, path)
    check_noos(text, tags, path)
    check_dts(text, tags, path)
    return collect_links(text)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "--all", action="store_true",
        help="Check every projects/**/README.md in the repo.",
    )
    parser.add_argument(
        "paths", nargs="*", type=Path,
        help="Specific README paths to check (ignored with --all).",
    )
    args = parser.parse_args()

    if args.all:
        # Full-repo sweep blows past GHA's 10-annotation cap, so emit plain
        # stderr lines instead.
        global _emit_annotations
        _emit_annotations = False
        files = walk_all_readmes()
    else:
        files = args.paths

    if not files:
        print(f"{tag('INFO')}No README files to check.", file=sys.stderr)
        return 1 if errors else 0

    link_map: dict[Path, list[tuple[str, int]]] = {f: check_readme(f) for f in files}

    # One HEAD-check pass for every unique URL. UNCHECKED_HOSTS are skipped.
    all_urls = {url for links in link_map.values() for url, _ in links}
    checked_urls = {u for u in all_urls if not is_unchecked_host(u)}
    if checked_urls:
        skipped = len(all_urls) - len(checked_urls)
        msg = f"{tag('INFO')}HEAD-checking {len(checked_urls)} links across {len(files)} README(s)"
        if skipped:
            msg += f" ({skipped} skipped: {', '.join(UNCHECKED_HOSTS)})"
        print(msg + "...", file=sys.stderr)
        results = head_check(checked_urls)
        for file_path, links in link_map.items():
            for url, line in links:
                status = results.get(url)
                if status == "missing":
                    report(file_path, line, f"link not reachable (404): {url}")
                elif status == "network_error":
                    report(file_path, line, f"link availability could not be verified (network error): {url}", level="warning")

    if warnings:
        print(f"\n{tag('INFO')}{len(warnings)} warning(s) across {len({w[0] for w in warnings})} file(s)", file=sys.stderr)
    if errors:
        print(f"{tag('INFO')}{len(errors)} error(s) across {len({e[0] for e in errors})} file(s)", file=sys.stderr)
        return 1
    print(f"{tag('INFO')}All README(s) pass the template check.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())

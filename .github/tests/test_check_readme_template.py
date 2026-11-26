##############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: BSD-1-Clause
##############################################################################
"""Tests for the README template checker. One good + one bad case per rule."""
import pytest


# Helpers -------------------------------------------------------------------

def msgs(checker):
    return [e[2] for e in checker.errors]


def match(checker, substring):
    return any(substring in m for m in msgs(checker))


# Happy path ----------------------------------------------------------------

def test_valid_readme_passes(checker, write, valid_readme):
    path = write("projects/adtest/vcu118/README.md", valid_readme)
    checker.check_readme(path)
    assert checker.errors == []


# Title ---------------------------------------------------------------------

def test_title_wrong_board_name_fails(checker, write, valid_readme):
    path = write("projects/adtest/vcu118/README.md",
                 valid_readme.replace("# ADTEST/VCU118", "# WRONG/VCU118"))
    checker.check_readme(path)
    assert match(checker, "incorrect or missing title")
    assert match(checker, "ADTEST/VCU118 HDL Project")


def test_title_wrong_level_fails(checker, write, valid_readme):
    path = write("projects/adtest/vcu118/README.md",
                 valid_readme.replace("# ADTEST/VCU118", "## ADTEST/VCU118"))
    checker.check_readme(path)
    assert match(checker, "incorrect or missing title")


def test_title_skipped_for_special_carrier(checker, write, valid_readme):
    # ccbob_* carriers skip the title check entirely.
    body = valid_readme.replace("# ADTEST/VCU118", "# wrong title")
    path = write("projects/adtest/ccbob_foo/README.md", body)
    checker.check_readme(path)
    assert not match(checker, "incorrect or missing title")


# Tags ----------------------------------------------------------------------

def test_unknown_tag_token_fails(checker, write, valid_readme):
    body = "<!-- no_dts, no-no-os -->\n" + valid_readme  # hyphen typo
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "unknown tag token")


def test_no_no_os_tag_without_line_passes(checker, write, valid_readme):
    body = "<!-- no_no_os -->\n" + valid_readme.replace(
        "Corresponding No-OS project: [adtest](https://github.com/analogdevicesinc/no-OS/tree/main/projects/adtest)\n\n",
        "",
    )
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert not match(checker, "Corresponding No-OS")


def test_no_no_os_tag_with_line_fails(checker, write, valid_readme):
    body = "<!-- no_no_os -->\n" + valid_readme
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "`no_no_os` tag is set but README has a `Corresponding No-OS project:`")


def test_missing_no_os_line_without_tag_fails(checker, write, valid_readme):
    body = valid_readme.replace(
        "Corresponding No-OS project: [adtest](https://github.com/analogdevicesinc/no-OS/tree/main/projects/adtest)\n\n",
        "",
    )
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "no `Corresponding No-OS project:` line found")


# Example configurations / Overridable table --------------------------------

def test_wrong_heading_level_for_example_configurations_fails(checker, write, valid_readme):
    body = valid_readme.replace("### Example configurations", "#### Example configurations")
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "'Example configurations' section must use `###`")


def test_wrong_heading_level_for_overridable_parameters_fails(checker, write, valid_readme):
    body = valid_readme.replace("### Overridable parameters", "## Overridable parameters")
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "'Overridable parameters' section must use `###`")


def test_wrong_heading_level_for_building_fails(checker, write, valid_readme):
    body = valid_readme.replace("## Building the project", "### Building the project")
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "'Building the project' section must use `##`")


def test_no_build_example_tag_without_section_passes(checker, write, valid_readme):
    body = "<!-- no_build_example -->\n" + "\n".join(
        valid_readme.splitlines()[:11]
    ) + "\n"
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert not match(checker, "Example configurations")


def test_missing_overridable_table_fails(checker, write, valid_readme):
    body = valid_readme.replace(
        "### Overridable parameters\n\n"
        "| Key | Default | Values and description |\n"
        "| --- | --- | --- |\n"
        "| JESD_MODE | 8B10B | `8B10B` or `64B66B` |\n\n", "")
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "no '### Overridable parameters' table found")


# Variants ------------------------------------------------------------------

def test_variant_unknown_key_fails(checker, write, valid_readme):
    body = valid_readme.replace("make JESD_MODE=64B66B", "make UNKNOWN_KEY=1 JESD_MODE=64B66B")
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "overrides key 'UNKNOWN_KEY' not declared")


def test_variant_sloppy_spacing_fails(checker, write, valid_readme):
    body = valid_readme.replace("make JESD_MODE=64B66B", "make JESD_MODE = 64B66B")
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "`KEY = VALUE` spacing")


def test_variant_missing_default_tag_fails(checker, write, valid_readme):
    body = valid_readme.replace("#### [DEFAULT] base build", "#### base build")
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "no `[DEFAULT]` tag found")


def test_variant_multiple_default_tags_fails(checker, write, valid_readme):
    body = valid_readme.replace("#### 64B66B variant", "#### [DEFAULT] 64B66B variant")
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "`[DEFAULT]` tag appears on 2 variants")


def test_pound4_without_code_block_is_subsection_header(checker, write, valid_readme):
    body = valid_readme + "\n#### Notes\n\nJust prose, no code block.\n"
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert not match(checker, "'Notes'")  # not treated as a variant


def test_no_variants_at_all_fails(checker, write, valid_readme):
    lines = valid_readme.splitlines()
    stop = lines.index("### Example configurations") + 2
    body = "\n".join(lines[:stop]) + "\n#### Notes\n\njust prose\n"
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "has no variants")


# Links ---------------------------------------------------------------------

def test_blacklisted_url_fails(checker, write, valid_readme):
    body = valid_readme + "\nSee [kernel drivers](https://wiki.analog.com/linux).\n"
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "do not link to")


def test_empty_link_fails(checker, write, valid_readme):
    body = valid_readme + "\nSee [the thing]().\n"
    path = write("projects/adtest/vcu118/README.md", body)
    checker.check_readme(path)
    assert match(checker, "empty markdown link")


# Missing file --------------------------------------------------------------

def test_missing_readme_fails(checker, repo):
    # Path points under projects/ but the file doesn't exist.
    from pathlib import Path
    target = Path("projects/adtest/vcu118/README.md")
    checker.check_readme(target)
    assert match(checker, "README.md not found")


# Project-level README (summary page with carrier subdirs) ------------------

def test_project_level_readme_skips_template_checks(checker, write):
    # Give the project a carrier subdir so it's treated as a summary page.
    write("projects/adtest/vcu118/README.md", "placeholder\n")
    body = (
        "# ADTEST HDL Project\n\n"
        "Summary of all carriers.\n\n"
        "## Building the project\n\n```\nmake\n```\n\n"
        "## Supported parts\n\n- ADTEST\n"
    )
    path = write("projects/adtest/README.md", body)
    checker.check_readme(path)
    # No "Example configurations missing" or "No-OS line missing" errors.
    assert not match(checker, "Example configurations")
    assert not match(checker, "Corresponding No-OS")


def test_project_level_readme_missing_supported_parts_fails(checker, write):
    write("projects/adtest/vcu118/README.md", "placeholder\n")
    body = (
        "# ADTEST HDL Project\n\n"
        "## Building the project\n\n```\nmake\n```\n"
    )
    path = write("projects/adtest/README.md", body)
    checker.check_readme(path)
    assert match(checker, "missing `## Supported parts`")


# Special projects ----------------------------------------------------------

def test_special_project_bypasses_structural_checks(checker, write):
    body = "# xcvr_wizard\n\nPlain prose README, no template structure.\n"
    path = write("projects/xcvr_wizard/README.md", body)
    checker.check_readme(path)
    assert checker.errors == []

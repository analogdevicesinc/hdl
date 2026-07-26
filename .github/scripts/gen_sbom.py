#!/usr/bin/python3
"""
Generate one CycloneDX 1.7 SBOM (JSON) per HDL project.

Each Makefile with "PROJECT_NAME := ..." becomes an SBOM; its "LIB_DEPS" become
component dependencies, each with its declared license.
The FPGA vendor SDK used is a build-scoped dependency.

Environment:
  OUT      path to write the SBOMs to.
  VERSION  version for the package URL (git tag, branch or sha),
           e.g. pkg:github/analogdevicesinc/hdl@2023_R2_p1

Usage:
  OUT=/path/to/out VERSION=2023_R2_p1 python3 .github/scripts/gen_sbom.py
"""

import datetime
import json
import os
import re
import sys
from os import path, environ, getcwd
from urllib.parse import quote
from makefile_deps_tree import get_deps_tree, sdk_packages_for_project, DEFAULT_LICENSE

PURL_TYPE = "github"
PURL_NAMESPACE = "analogdevicesinc"
PURL_NAME = "hdl"
VCS_URL = "https://github.com/analogdevicesinc/hdl"

TOOL_NAME = "hdl-sbom-gen"
TOOL_VERSION = "1.0.0"


def purl(version, subpath=None):
    namespace = quote(PURL_NAMESPACE.lower(), safe="")
    name = quote(PURL_NAME.lower(), safe="")
    p = f"pkg:{PURL_TYPE}/{namespace}/{name}@{quote(str(version), safe='')}"
    if subpath:
        segments = [s for s in subpath.split("/") if s not in ("", ".", "..")]
        p += "#" + "/".join(quote(s, safe="") for s in segments)
    return p


def env_versions(repo):
    text = open(path.join(repo, "scripts", "adi_env.tcl"), errors="replace").read()

    def tcl_string(var):
        match = re.search(r'^\s*set\s+' + re.escape(var) + r'\s+"([^"]+)"', text, re.M)
        if not match:
            sys.exit(f"error: '{var}' not found in scripts/adi_env.tcl")
        return match.group(1)

    return {
        "vivado": tcl_string("required_vivado_version"),
        "quartus": tcl_string("required_quartus_version"),
        "quartus_std": tcl_string("required_quartus_std_version"),
        "lattice": tcl_string("required_lattice_version"),
    }


def cdx_license(expr):
    if " OR " in expr or " AND " in expr or expr.startswith("LicenseRef-"):
        return [{"expression": expr}]
    return [{"license": {"id": expr}}]


def build_cdx(rel_dir, project_name, lib_deps, sdk_packages, version, created, libraries):
    project_ref = f"project:{project_name}"
    project_purl = purl(version, f"projects/{rel_dir}")

    components = []
    dependencies = []

    # Project component
    components.append({
        "type": "application",
        "bom-ref": project_ref,
        "name": project_name,
        "version": version,
        "purl": project_purl,
        "licenses": cdx_license(DEFAULT_LICENSE),
        "externalReferences": [{
            "type": "vcs",
            "url": VCS_URL,
        }],
    })

    project_depends_on = []

    # SDK components
    for idx, sdk in enumerate(sdk_packages):
        ref = f"sdk:{idx}"
        components.append({
            "type": "application",
            "bom-ref": ref,
            "name": sdk["name"],
            "version": sdk["version"],
            "purl": sdk["purl"],
            "scope": "required",
        })
        project_depends_on.append(ref)
        dependencies.append({"ref": ref, "dependsOn": []})

    # Library components
    for idx, dep in enumerate(lib_deps):
        ref = f"lib:{dep}"
        license_expr = libraries.get(dep, {}).get("license", DEFAULT_LICENSE)
        components.append({
            "type": "library",
            "bom-ref": ref,
            "name": dep,
            "version": version,
            "purl": purl(version, f"library/{dep}"),
            "licenses": cdx_license(license_expr),
        })
        project_depends_on.append(ref)
        dependencies.append({"ref": ref, "dependsOn": []})

    dependencies.insert(0, {"ref": project_ref, "dependsOn": project_depends_on})

    return {
        "$schema": "http://cyclonedx.org/schema/bom-1.7.schema.json",
        "bomFormat": "CycloneDX",
        "specVersion": "1.7",
        "version": 1,
        "metadata": {
            "timestamp": created,
            "tools": {
                "components": [{
                    "type": "application",
                    "name": TOOL_NAME,
                    "version": TOOL_VERSION,
                }],
            },
            "component": {
                "type": "application",
                "bom-ref": project_ref,
                "name": project_name,
                "version": version,
                "purl": project_purl,
            },
            "manufacture": {
                "name": "Analog Devices Inc.",
                "contact": [{"email": "hdl@analog.com"}],
            },
        },
        "components": components,
        "dependencies": dependencies,
    }


def main():
    out = environ.get("OUT")
    version = environ.get("VERSION", "unknown")
    if not out:
        sys.exit("error: env variables 'OUT' must be set")
    repo = getcwd()
    if not path.isfile(path.join(repo, "LICENSE_ADIBSD")):
        sys.exit(f"error: '{repo}' is not an hdl repository (no 'LICENSE_ADIBSD')")

    os.makedirs(out, exist_ok=True)
    created = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    sdk_versions = env_versions(repo)
    deps_tree = get_deps_tree()

    count = 0
    for key, pdata in sorted(deps_tree["projects"].items()):
        rel_dir = key.replace(".", "/")
        lib_deps = pdata.get("lib_deps", [])
        sdk_kind = pdata.get("sdk_kind")
        sdk_packages = sdk_packages_for_project(sdk_kind, rel_dir, sdk_versions)
        doc = build_cdx(rel_dir, key, lib_deps, sdk_packages, version, created, deps_tree["libraries"])
        fname = f"{key}.cdx.json"
        with open(path.join(out, fname), "w") as f:
            json.dump(doc, f, indent=2)
        count += 1

    print(f"wrote {count} SBOM(s) to {out}", file=sys.stderr)


if __name__ == "__main__":
    main()

#!/usr/bin/python3
"""
Generate one SPDX 3.0.1 SBOM per HDL project.

Each Makefile with "PROJECT_NAME := ..." becomes an SBOM; its "LIB_DEPS" become
dependsOn relationships to library packages, each with its declared license.
The FPGA vendor SDK used is a build-scoped dependency.

Environment:
  OUT      path to write the SBOMs to.
  VERSION  version for the package URL (git tag, branch or sha),
           e.g. pkg:github/analogdevicesinc/hdl@2023_R2_p1

Usage:
  OUT=/path/to/out VERSION=2023_R2_p1 python3 .github/scripts/gen_sbom.py
"""

import datetime
import glob
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
    """Build a PURL"""
    namespace = quote(PURL_NAMESPACE.lower(), safe="")
    name = quote(PURL_NAME.lower(), safe="")
    p = f"pkg:{PURL_TYPE}/{namespace}/{name}@{quote(str(version), safe='')}"
    if subpath:
        segments = [s for s in subpath.split("/") if s not in ("", ".", "..")]
        p += "#" + "/".join(quote(s, safe="") for s in segments)
    return p


def generic_purl(vendor, name, version):
    """Build a generic package URL for a build SDK."""
    return "pkg:generic/{}/{}@{}".format(
        quote(vendor.lower(), safe=""),
        quote(name.lower(), safe=""),
        quote(str(version), safe=""),
    )


def env_versions(repo):
    """Parse the SDK versions from scripts/adi_env.tcl."""
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




def get_projects(repo, versions):
    """Yield (rel_dir, project_name, lib_deps, sdk_packages) for every project in deps tree."""
    deps = get_deps_tree()
    projects = deps["projects"]
    for key, pdata in projects.items():
        rel_dir = key.replace(".", "/")  # path (slash) form for SPDX output/url
        project_name = key
        lib_deps = pdata.get("lib_deps", [])
        sdk_kind = pdata.get("sdk_kind")
        sdk_packages = sdk_packages_for_project(sdk_kind, rel_dir, versions)
        yield rel_dir, project_name, lib_deps, sdk_packages


def build_spdx(repo, rel_dir, project_name, lib_deps, sdk_packages, version, created, libraries):
    """Return an SPDX 3.0.1 JSON-LD dict for one project.

    SpdxDocument -> software_Sbom -> software_Package (project)
      dependsOn -> library packages; hasDeclaredLicense -> LicenseExpression
    """
    slug = rel_dir.replace("/", "-")
    ns = f"urn:analog.com:hdl:{version}:{slug}"

    graph = []
    element_ids = []

    def add(elem):
        elem["creationInfo"] = "_:creationinfo"
        graph.append(elem)
        return elem["spdxId"]

    def _id(tag):
        return f"{ns}:{tag}"

    # Deduplicated LicenseExpression nodes.
    lic_ids = {}

    def lic_id(expr):
        if expr not in lic_ids:
            node = {
                "type":                              "simplelicensing_LicenseExpression",
                "spdxId":                            _id(f"lic/{len(lic_ids)}"),
                "simplelicensing_licenseExpression": expr,
            }
            refs = re.findall(r"LicenseRef-[\w.-]+", expr)
            if refs:
                node["simplelicensing_customIdToUri"] = [{
                    "type":  "DictionaryEntry",
                    "key":   ref,
                    "value": f"{VCS_URL}/blob/{version}/LICENSE_ADIJESD204"
                             if ref == "LicenseRef-ADIJESD204-commercial"
                             else f"{VCS_URL}/blob/{version}/LICENSE",
                } for ref in refs]
            lic_ids[expr] = node["spdxId"]
            add(node)
        return lic_ids[expr]

    id_org = add({
        "type": "Organization",
        "spdxId": _id("org/analog"),
        "name": "Analog Devices Inc.",
        "externalIdentifier": [{
            "type": "ExternalIdentifier",
            "externalIdentifierType": "email",
            "identifier": "hdl@analog.com",
        }],
    })
    id_tool = add({
        "type": "Tool",
        "spdxId": _id("tool"),
        "name": TOOL_NAME,
        "summary": f"{TOOL_NAME} {TOOL_VERSION}",
    })

    id_pkg = _id("pkg/project")
    element_ids.append(add({
        "type": "software_Package",
        "spdxId": id_pkg,
        "name": project_name,
        "software_packageVersion": version,
        "software_primaryPurpose": "configuration",
        "software_packageUrl": purl(version, f"projects/{rel_dir}"),
        "externalRef": [{
            "type": "ExternalRef",
            "externalRefType": "vcs",
            "locator": [VCS_URL],
        }],
    }))

    # Build SDK packages.
    sdk_ids = []
    for idx, sdk in enumerate(sdk_packages):
        sdk_id = _id(f"pkg/sdk/{idx}")
        sdk_ids.append(sdk_id)
        element_ids.append(add({
            "type": "software_Package",
            "spdxId": sdk_id,
            "name": sdk["name"],
            "software_packageVersion": sdk["version"],
            "software_primaryPurpose": "application",
            "software_packageUrl": sdk["purl"],
        }))

    if sdk_ids:
        element_ids.append(add({
            "type": "LifecycleScopedRelationship",
            "spdxId": _id("rel/build-sdk-depends-on"),
            "from": id_pkg,
            "relationshipType": "dependsOn",
            "scope": "build",
            "to": sdk_ids,
        }))

    # Library packages + their declared licenses.
    lib_ids = []
    for idx, dep in enumerate(lib_deps):
        lib_id = _id(f"pkg/lib/{idx}")
        lib_ids.append(lib_id)
        element_ids.append(add({
            "type": "software_Package",
            "spdxId": lib_id,
            "name": dep,
            "software_packageVersion": version,
            "software_primaryPurpose": "library",
            "software_packageUrl": purl(version, f"library/{dep}"),
        }))
        license_expr = libraries.get(dep, {}).get('license', DEFAULT_LICENSE)
        element_ids.append(add({
            "type": "Relationship",
            "spdxId": _id(f"rel/lib-license/{idx}"),
            "relationshipType": "hasDeclaredLicense",
            "from": lib_id,
            "to": [lic_id(license_expr)],
        }))

    if lib_ids:
        element_ids.append(add({
            "type": "Relationship",
            "spdxId": _id("rel/depends-on"),
            "relationshipType": "dependsOn",
            "from": id_pkg,
            "to": lib_ids,
            "completeness": "complete",
        }))

    element_ids.append(add({
        "type": "Relationship",
        "spdxId": _id("rel/project-license"),
        "relationshipType": "hasDeclaredLicense",
        "from": id_pkg,
        "to": [lic_id(DEFAULT_LICENSE)],
    }))

    # LicenseExpression nodes were added to `graph` but not to element_ids yet.
    element_ids += [e["spdxId"] for e in graph
                    if e["type"] == "simplelicensing_LicenseExpression"]

    id_sbom = add({
        "type": "software_Sbom",
        "spdxId": _id("sbom"),
        "name": f"hdl-{slug}-{version}",
        "rootElement": [id_pkg],
        "element": element_ids,
        "software_sbomType": ["source"],
    })
    add({
        "type": "SpdxDocument",
        "spdxId": _id("document"),
        "rootElement": [id_sbom],
        "element": [id_sbom, id_org, id_tool] + element_ids,
        "profileConformance": ["core", "software", "simpleLicensing"],
    })

    creation_info = {
        "type": "CreationInfo",
        "@id": "_:creationinfo",
        "specVersion": "3.0.1",
        "createdBy": [id_org],
        "createdUsing": [id_tool],
        "created": created,
    }

    return {
        "@context": "https://spdx.org/rdf/3.0.1/spdx-context.jsonld",
        "@graph": [creation_info] + graph,
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
    for rel_dir, name, deps, sdk_packages in sorted(get_projects(repo, sdk_versions)):
        doc = build_spdx(repo, rel_dir, name, deps, sdk_packages, version, created, deps_tree['libraries'])
        fname = rel_dir.replace("/", ".") + ".sbom.spdx30.json"
        with open(path.join(out, fname), "w") as f:
            json.dump(doc, f, indent=2)
        count += 1

    print(f"wrote {count} SBOM(s) to {out}", file=sys.stderr)


if __name__ == "__main__":
    main()

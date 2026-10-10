import os
import re
import json

MAKEFILE_ASSIGN = re.compile(r'^(.*?)\s*\+=\s*(.+)$')
LIB_DEPS_KEYS = ['GENERIC_DEPS', 'XILINX_DEPS', 'INTEL_DEPS', 'LATTICE_DEPS', 'XILINX_LIB_DEPS']

SDK_DEFS = {
    "xilinx": [{
        "name": "AMD Vivado",
        "vendor": "amd",
        "package": "vivado",
        "version_key": "vivado",
    }],
    "intel": [{
        "name": "Intel Quartus",
        "vendor": "intel",
        "package": "quartus",
        "version_key": "quartus",
    }],
    "lattice": [{
        "name": "Lattice Radiant",
        "vendor": "lattice",
        "package": "radiant",
        "version_key": "lattice",
    }, {
        "name": "Lattice Propel",
        "vendor": "lattice",
        "package": "propel",
        "version_key": "lattice",
    }],
}

def sdk_packages_for_project(kind, rel_dir, versions):
    """Return SDK package definitions for a project."""
    if not kind:
        return []
    project_versions = dict(versions)
    if kind == "intel" and rel_dir.split("/")[-1] in ("de10nano", "c5soc"):
        project_versions["quartus"] = project_versions["quartus_std"]

    packages = []
    for sdk in SDK_DEFS[kind]:
        version = project_versions[sdk["version_key"]]
        packages.append({
            "name": sdk["name"],
            "version": version,
            "purl": f"pkg:generic/{sdk['vendor']}/{sdk['package']}@{version}",
        })
    return packages

LICENSE_MAP = {
    "ADIJESD204":   "LicenseRef-ADIJESD204-Commercial",
    "ADIBSD":       "GPL-2.0-only OR ADIBSD",
    "LGPL":         "LGPL-2.1-only",
    "BSD-1-Clause": "BSD-1-Clause",
}
DEFAULT_LICENSE = "GPL-2.0-only OR ADIBSD"

def get_deps_tree():
    projects, libraries = {}, {}
    for root, dirs, files in os.walk('projects'):
        if 'Makefile' in files:
            path = os.path.join(root, 'Makefile')
            with open(path) as mf:
                lines = mf.readlines()
            if not any('PROJECT_NAME' in line for line in lines):
                continue
            rel = os.path.relpath(root, 'projects').split(os.sep)
            key = rel[0] if len(rel) == 1 else f"{rel[0]}.{rel[1]}"
            assigns = {}
            for line in lines:
                m = MAKEFILE_ASSIGN.match(line.strip())
                if m:
                    assigns.setdefault(m.group(1), []).append(m.group(2))
            sdk_kind = None
            for line in lines:
                m = re.match(r'^\s*include\s+\S*project-(xilinx|intel|lattice)\.mk\s*$', line.strip())
                if m:
                    sdk_kind = m.group(1)
                    break
            projects[key] = {
                'm_deps': [os.path.normpath(os.path.join(root, d)) for d in assigns.get('M_DEPS', [])],
                'lib_deps': assigns.get('LIB_DEPS', []),
                'sdk_kind': sdk_kind
            }

    for root, dirs, files in os.walk('library'):
        if 'Makefile' in files:
            path = os.path.join(root, 'Makefile')
            rel = os.path.relpath(root, 'library')
            assigns = {}
            with open(path) as mf:
                for line in mf:
                    m = MAKEFILE_ASSIGN.match(line.strip())
                    if m:
                        assigns.setdefault(m.group(1), []).append(m.group(2))
            license_expr = DEFAULT_LICENSE
            for ext in ('.v', '.sv', '.vh', '.vhd'):
                for dirpath, _, fnames in os.walk(root):
                    for fname in fnames:
                        if not fname.endswith(ext):
                            continue
                        fpath = os.path.join(dirpath, fname)
                        if ".gen" in fpath:
                            continue
                        with open(fpath, errors="replace") as f:
                            m = re.search(r"SPDX short identifier:\s*(\S+)", f.read(1024))
                        if m:
                            license_expr = LICENSE_MAP.get(m.group(1), DEFAULT_LICENSE)
                            break
                    else:
                        continue
                    break
            libraries.setdefault(rel, {})
            libraries[rel]["license"] = license_expr
            for k in LIB_DEPS_KEYS:
                if k in assigns:
                    if k == 'XILINX_LIB_DEPS':
                        libraries[rel].setdefault(k, []).extend(assigns[k])
                    else:
                        libraries[rel].setdefault(k, []).extend([
                            os.path.normpath(os.path.join(root, d)) for d in assigns[k]
                        ])
    return {'projects': projects, 'libraries': libraries}

if __name__ == '__main__':
    print(json.dumps(get_deps_tree(), indent=2))

# Export LICENSE constants for downstream use
__all__ = ['get_deps_tree', 'sdk_packages_for_project', 'DEFAULT_LICENSE', 'LICENSE_MAP']

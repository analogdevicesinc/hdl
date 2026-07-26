import sys
import json
import os
import argparse

from makefile_deps_tree import get_deps_tree

def path2target(path):
    p = path.split(os.sep)
    if len(p) == 3 and p[0] == 'projects':
        return f'{p[1]}.{p[2]}'
    if len(p) == 2 and p[0] == 'projects':
        return p[1]
    return None

def get_touched_projects():
    dep = get_deps_tree()
    projs, libs = dep['projects'], dep['libraries']

    proj_paths = {}
    for root, dirs, files in os.walk('projects'):
        if 'Makefile' in files:
            rel = os.path.relpath(os.path.join(root, 'Makefile'))
            tgt = path2target(rel[:-9]) # strip '/Makefile'
            if tgt:
                proj_paths[tgt] = rel

    library_deps = {}
    for lname, ldef in libs.items():
        for k in ['GENERIC_DEPS','XILINX_DEPS','INTEL_DEPS','LATTICE_DEPS']:
            for f in ldef.get(k, []):
                library_deps.setdefault(os.path.normpath(f), set()).add(lname)

    lib2proj = {}
    for pname, pdata in projs.items():
        for l in pdata['lib_deps']:
            lib2proj.setdefault(l, set()).add(pname)
    file2proj = {}
    for pname, pdata in projs.items():
        for f in pdata['m_deps']:
            file2proj.setdefault(os.path.normpath(f), set()).add(pname)

    touched = set()
    stdin = sys.stdin.read()
    stdin = json.loads(stdin) if stdin.startswith('[') else stdin.split()

    arch_deps = {}
    for lname, ldef in libs.items():
        for k in ['XILINX_DEPS', 'INTEL_DEPS', 'LATTICE_DEPS']:
            for f in ldef.get(k, []):
                arch = k.split('_')[0].lower()
                arch_deps.setdefault(os.path.normpath(f), set()).add(arch)

    skip_sdk = set()
    if os.environ.get('NO_AMD_XILINX') is not None:
        skip_sdk.add('xilinx')
    if os.environ.get('NO_LATTICE') is not None:
        skip_sdk.add('lattice')
    if os.environ.get('NO_ALTERA') is not None:
        skip_sdk.add('intel')

    for cf in stdin:
        norm = os.path.normpath(cf)
        touched |= file2proj.get(norm, set())
        for lib in library_deps.get(norm, []):
            dep_archs = arch_deps.get(norm, set())
            for pname in lib2proj.get(lib, set()):
                proj_kind = projs[pname].get('sdk_kind')
                if proj_kind in skip_sdk:
                    continue
                if dep_archs and proj_kind and proj_kind not in dep_archs:
                    continue
                touched.add(pname)

    return json.dumps(sorted([t for t in touched if t in proj_paths or t]))

if __name__ == '__main__':
    print(get_touched_projects())

from typing import Dict, List, Tuple
from os import path, mkdir, walk, chdir
from glob import glob
import sys
import yaml
import re
import argparse

org_: str = "analogdevicesinc"
repo_: str = "hdl"
branch_: str = "main"
dir_: str = "backstage_yaml"
doc_link_: str = 'https://{org}.github.io/{repo}'
source_location_: str = 'https://github.com/{org}/{repo}/tree/{tag}'
loc_url_: str = "https://github.com/{org}/{repo}/tree/backstage_yaml"
dep_base: str = "Component:hdl-library"

link_entry_doc: Dict = {
    'url': None,
    'title': 'Documentation',
    'icon': 'web'
}

delimeters = ('===', '---', '~~~', '^^^', '"""', "'''")

vendor = {
    'xilinx': "AMD Xilinx",
    'intel': "Intel Altera",
    'lattice': "Lattice"
}


def yaml_template() -> dict:
    return {
        'apiVersion': 'backstage.io/v1alpha1',
        'kind': 'Component',
        'metadata': {
            'name': None,
            'title': None,
            'description': None,
            'version': None,
            'classification': 'software',
            'license': ['ADI BSD License'],
            'annotations': {
                'backstage.io/source-location': None
            },
            'tags': ['hdl'],
            'links': []
        },
        'spec': {
            'owner': 'group:default/hdl-sw-team',
            'type': 'source',
            'lifecycle': 'sustain'
            # For versioned components, add 'subcomponentOf'
        }
    }


def get_description_parts(
    desc_: List[str]
) -> Tuple[str, List[str]]:
    desc: str = ''.join(desc_)
    # Grab ADI role part name without text
    r0 = r"(:adi:`)([^<>:]+?)(`)"
    # Pop roles without text
    r2 = r'(:\S+?:`)([^<>:]+?)(`)'

    # Grab ADI role part name with text
    r1 = r'(:adi:`)([^<]+?)( <)([^:>]+?)(>)(`)'
    # Pop roles with text
    r3 = r'(:\S+?:`)([^<]+?)( <)([^:>]+?)(>)(`)'

    parts = set()
    for m in re.finditer(r0, desc):
        if not ('/' in m.group(2)):
            parts.add(m.group(2).lower().replace('_', '-'))
    desc = re.sub(r2, r'\2', desc)

    for m in re.finditer(r1, desc):
        if not ('/' in m.group(4)):
            parts.add(m.group(4).lower().replace('_', '-'))
    desc = re.sub(r3, r'\2', desc)
    # Try to preserve lists
    desc = re.sub(r'(\n){1,2}(\s*)[\*-]\s+', r'\n\n\2- ', desc)
    desc = desc.replace('`', '').replace('*', '')

    # Un-fold, let pyyaml re-fold for us
    desc = desc.replace('\n\n', '\\n')
    desc = desc.replace('\n', ' ')
    desc = re.sub(' +', ' ', desc)
    desc = desc.replace('\\n', '\n').strip()+'\n'

    return desc, list(parts)


def get_description(
    data: List[str],
    file: str
) -> List[str]:
    desc = []
    directive_lock = False
    for d in data:
        if d.startswith(delimeters):
            break
        elif d.startswith(".. "):
            directive_lock = True
            continue
        elif directive_lock:
            if not (d.startswith("   ") or d == "\n"):
                directive_lock = False
            else:
                continue
        desc.append(d)

    if len(desc) < 3:
        sys.exit(f"{file}: Missing overview/short-description.")

    desc.pop()
    desc.pop()
    return desc


def get_description_library(
    file: str
) -> Tuple[str, List[str], str]:
    """
    Get the first paragraph of a project index file.
    Accepts
    ::

       Libray name
       ============
    """
    with open(file) as f:
        data = f.readlines()

    index = -1
    for i, d in enumerate(data):
        if d.startswith("==="):
            index = i+2 if data[i+1] == '\n' else i+1
            break

    if index == -1:
        return '', [], ''

    title = data[index-3][:-1]
    data = data[index:]
    desc = get_description(data, file)

    return *get_description_parts(desc), title


def get_description_project(
    file: str
) -> Tuple[str, List[str], str]:
    """
    Get the first paragraph of a project index file.
    Accepts both
    ::

       Project name
       ============
    and
    ::

       Project name
       ============

       Overview
       --------
    """
    with open(file) as f:
        data = f.readlines()

    index = -1
    for i, d in enumerate(data):
        if d.startswith("==="):
            index = i+2 if data[i+1] == '\n' else i+1
            break

    if index == -1:
        return '', [], ''

    title = data[index-3][:-1]

    if "Overview\n" in data:
        index = data.index("Overview\n")+2
        index = index+1 if data[index] == '\n' else index

    data = data[index:]
    desc = get_description(data, file)

    return *get_description_parts(desc), title


def write_hdl_library_yaml(
    library,
    key: str,
    tag: str,
    dir_: str,
    args
) -> None:
    doc_link = doc_link_.format(org=args.org, repo=args.repo)
    if tag != 'main':
        doc_link += '/' + tag
    source_location = source_location_.format(org=args.org, repo=args.repo,
                                              tag=tag)
    key_ = key.replace('/', '-')
    t: Dict = yaml_template()
    m = t['metadata']
    a = m['annotations']
    m['name'] = f"hdl-library-{key_}"
    if tag != "main":
        t['spec']['subcomponentOf'] = m['name']
        m['name'] = m['name'] + '-' + tag
    m['title'] = f"{library['name'].upper()} HDL IP core"
    m['version'] = tag
    a['backstage.io/source-location'] = f'url:{source_location}/library/{key}'
    m['tags'].extend(['library', 'ip-core'])
    tags_ = None
    file1 = path.join('docs', 'library', key, 'index.rst')
    file2 = path.join('docs', 'library', key+'.rst')
    if path.isfile(file1):
        link_entry_doc['url'] = f"{doc_link}/library/{key}/index.html"
        m['links'].append(link_entry_doc)
        m['description'], tags_, title = get_description_library(file1)
    elif path.isfile(file2):
        link_entry_doc['url'] = f"{doc_link}/library/{key}.html"
        m['links'].append(link_entry_doc)
        m['description'], tags_, title = get_description_library(file2)
    if tags_:
        m['tags'].extend(tags_)
        m['title'] = title + " HDL IP core"
    if tag != "main":
        m['title'] = m['title'] + ' ' + tag
    m['tags'].sort()

    if key.startswith('jesd204'):
        m['license'].append('ADIJESD204')
    elif key.startswith('corundum'):
        m['license'].append('BSD-2-Clause-Views')

    if tag != "main":
        for v in library['vendor']:
            ld = library['vendor'][v]['library_dependencies']
            depends_on = [f"{dep_base}-{ld_.replace('/', '-')}-{tag}"
                          for ld_ in ld]
            if len(ld) > 0:
                if 'depends_on' not in t['spec']:
                    t['spec']['dependsOn'] = []
                t['spec']['dependsOn'].extend(depends_on)

    if m['description'] is None:
        m['description'] = m['title']

    file = path.join(dir_, f"library-{key_}-catalog-info.yaml")
    with open(file, 'w', encoding='utf-8') as f:
        yaml.dump(t, f, default_flow_style=False, sort_keys=False,
                  allow_unicode=True)


def write_hdl_project_yaml(
    project,
    key: str,
    tag: str,
    dir_: str,
    args
) -> None:
    doc_link = doc_link_.format(org=args.org, repo=args.repo)
    if tag != 'main':
        doc_link += '/' + tag
    source_location = source_location_.format(org=args.org, repo=args.repo,
                                              tag=tag)
    key_ = key.replace('/', '-')
    t: Dict = yaml_template()
    m = t['metadata']
    a = m['annotations']
    m['name'] = f"hdl-project-{key_}"
    if tag != "main":
        t['spec']['subcomponentOf'] = m['name']
        m['name'] = m['name'] + '-' + tag
    m['title'] = f"{project['name'].upper()} HDL project"
    m['version'] = tag
    a['backstage.io/source-location'] = f'url:{source_location}/projects/{key}'
    m['tags'].extend(['project', 'reference-design'])
    if key.startswith('common'):
        m['tags'].append('template')
    if key.startswith('common'):
        m['description'] = "Template project."

    tags_ = None
    key__ = key[:key.find('/')] if '/' in key else key
    key___ = key[key.find('/')+1:] if '/' in key else None
    file1 = path.join('docs', 'projects', key__, 'index.rst')
    file2 = path.join('docs', 'projects', key__+'.rst')
    if path.isfile(file1):
        link_entry_doc['url'] = f"{doc_link}/projects/{key__}/index.html"
        m['links'].append(link_entry_doc)
        m['description'], tags_, title = get_description_project(file1)
    elif path.isfile(file2):
        link_entry_doc['url'] = f"{doc_link}/projects/{key__}.html"
        m['links'].append(link_entry_doc)
        m['description'], tags_, title = get_description_project(file2)
    if tags_:
        m['tags'].extend(tags_)
        m['title'] = title
    if tag != "main":
        m['title'] = m['title'] + ' ' + tag
    if key___ is not None:
        m['tags'].append(key___.replace('_', '-'))

    if tag != "main":
        if len(project['lib_deps']) > 0:
            depends_on = [f"{dep_base}-{ld_.replace('/', '-')}-{tag}"
                          for ld_ in project['lib_deps']]
            t['spec']['dependsOn'] = depends_on

    if m['description'] is None:
        m['description'] = m['title']
    elif key___ is not None:
        m['description'] += ("It targets the "
                             f"{vendor[project['vendor']]} "
                             f"{key___.upper()}.\n")
    m['tags'].sort()

    file = path.join(dir_, f"project-{key_}-catalog-info.yaml")
    with open(file, 'w', encoding='utf-8') as f:
        yaml.dump(t, f, default_flow_style=False, sort_keys=False,
                  allow_unicode=True)


def concat_and_write_yaml(dir_: str) -> Tuple[List[str], str]:
    if not path.isdir(dir_):
        mkdir(dir_)

    dirs = next(walk('.'))[1]
    dirs.remove(dir_)
    dirs.remove('main')
    dirs.sort()
    dirs.insert(0, 'main')

    targets: Dict[str, List[str]] = {}
    for d in dirs:
        chdir(d)
        targets[d] = glob('*.yaml')
        chdir('..')

    files: Dict[str, List[str]] = {}

    for d in targets:
        for d_ in targets[d]:
            if d_ not in targets['main']:
                print(f"Warning: {d} version of component {d_} not on "
                      "component (main), skipped")
                continue
            if d_ in files:
                files[d_].append('---\n')
            else:
                files[d_] = []

            with open(path.join(d, d_)) as f:
                data = f.readlines()
            files[d_].extend(data)

    for d_ in files:
        with open(path.join(dir_, d_), "w") as f:
            for line in files[d_]:
                f.write(line)

    return list(files.keys()), dir_


def write_hdl_locations_yaml(
    targets: List[str],
    dir_: str,
    args
) -> None:
    """
    Generate locations.yaml
    """
    loc_url = loc_url_.format(org=args.org, repo=args.repo)
    targets = [f"{loc_url}/{dir_}/{t}" for t in targets]
    targets.sort()
    chunks = [targets[t:t+100] for t in range(0, len(targets), 100)]

    for i, c in enumerate(chunks):
        with open(path.join(f"locations-{i}.yaml"),
                  'w', encoding='utf-8') as f:
            yaml.dump({
                'apiVersion': 'backstage.io/v1alpha1',
                'kind': 'Location',
                'metadata': {
                    'name': f"hdl-locations-{i}"
                },
                'spec': {
                    'owner': 'group:default/hdl-sw-team',
                    'type': 'url',
                    'targets': c
                }
            }, f)


def str_presenter(dumper, data):
    if '\n' in data:
        return dumper.represent_scalar('tag:yaml.org,2002:str',
                                       data, style='>')
    return dumper.represent_scalar('tag:yaml.org,2002:str', data)


def generate(tag: str, args) -> None:
    from adi_doctools.cli.hdl_gen import makefile_pre

    if tag is None:
        tag = "main"

    yaml.add_representer(str, str_presenter)

    dir_: str = ".backstage_yaml"
    if not path.isdir(dir_):
        mkdir(dir_)
    dir_ = path.join(dir_, tag)
    if not path.isdir(dir_):
        import pathlib
        pathlib.Path(dir_).mkdir(parents=True, exist_ok=True)

    project, library = makefile_pre()

    for key in library:
        write_hdl_library_yaml(library[key], key, tag, dir_, args)

    for key in project:
        write_hdl_project_yaml(project[key], key, tag, dir_, args)


def resolve_yaml(tag: str, args) -> None:
    if tag is not None:
        print("--resolve does not take positional arguments.")
        return
    if not path.isdir('main'):
        print("The components need to be generate first (main folder).")
        return

    dir_: str = "yaml"

    write_hdl_locations_yaml(
        *concat_and_write_yaml(dir_),
        args
    )


if __name__ == '__main__':
    """
    Run from repo root.
    For components (ci push to main):

    ::

        # At main root
        /path/to/gen_backstage_yaml.py
        # At backstage_yaml branch root
        /path/to/gen_backstage_yaml.py --resolve

    For version of components (semi-annually):

    ::

        # At main root
        /path/to/gen_backstage_yaml.py 2022_r2_p1
        # At backstage_yaml branch root
        /path/to/gen_backstage_yaml.py --resolve

    Do not remove yaml files from main after they have been created,
    because even if deprecated, older version of components still link
    to it.
    """
    parser = argparse.ArgumentParser(description='Generate Backstage YAML')
    parser.add_argument('tag', metavar='Tag', type=str, nargs='?',
                        default=None,
                        help="Generate 'component' (main) or 'version of "
                             "component' (e.g. 2022.r2) component (default: "
                             "main)")
    parser.add_argument('--resolve', dest='do', action='store_const',
                        const=resolve_yaml, default=generate,
                        help=("Resolve YAML by concating 'components' with "
                              "'version of components' and updates "
                              "locations_*.yaml"))

    parser.add_argument('--org', dest='org',
                        nargs='?',
                        const=org_, default=org_,
                        help=(f"Organization (default: {org_})"))

    parser.add_argument('--repo', dest='repo',
                        nargs='?',
                        const=repo_, default=repo_,
                        help=(f"Repository (default: {repo_})"))

    args = parser.parse_args()
    args.do(args.tag, args)

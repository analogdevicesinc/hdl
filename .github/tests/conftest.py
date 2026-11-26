##############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: BSD-1-Clause
##############################################################################
"""Fixtures for the README template checker tests."""
import importlib.util
import sys
from pathlib import Path

import pytest

SCRIPTS_DIR = Path(__file__).resolve().parent.parent / "scripts"


def _load_checker():
    spec = importlib.util.spec_from_file_location(
        "check_readme_template", SCRIPTS_DIR / "check_readme_template.py",
    )
    mod = importlib.util.module_from_spec(spec)
    sys.modules["check_readme_template"] = mod
    spec.loader.exec_module(mod)
    return mod


@pytest.fixture(scope="session")
def checker():
    return _load_checker()


@pytest.fixture(autouse=True)
def reset_state(checker, monkeypatch):
    """Clear the checker's global error/warning buffers between tests."""
    checker.errors.clear()
    checker.warnings.clear()
    monkeypatch.setattr(checker, "_emit_annotations", False)


@pytest.fixture
def repo(tmp_path, monkeypatch):
    """Create an empty `projects/` tree and cd into it. Tests write READMEs
    under `projects/<proj>/[<carrier>/]README.md` and call `check_readme`."""
    (tmp_path / "projects").mkdir()
    monkeypatch.chdir(tmp_path)
    return tmp_path


def _write(repo: Path, rel: str, text: str) -> Path:
    p = repo / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(text)
    return p.relative_to(repo)


@pytest.fixture
def write(repo):
    """`write("projects/x/vcu118/README.md", "<content>")` -> relative Path."""
    return lambda rel, text: _write(repo, rel, text)


# Minimal fully-valid carrier-level README. Tests mutate copies of this.
VALID_README = """\
# ADTEST/VCU118 HDL Project

Short project description.

Corresponding No-OS project: [adtest](https://github.com/analogdevicesinc/no-OS/tree/main/projects/adtest)

## Building the project

```
cd projects/adtest/vcu118
make
```

### Overridable parameters

| Key | Default | Values and description |
| --- | --- | --- |
| JESD_MODE | 8B10B | `8B10B` or `64B66B` |

### Example configurations

#### [DEFAULT] base build

```
make
```

#### 64B66B variant

```
make JESD_MODE=64B66B
```
"""


@pytest.fixture
def valid_readme():
    return VALID_README

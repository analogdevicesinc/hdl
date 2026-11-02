#!/bin/bash
####################################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: BSD-1-Clause
####################################################################################

# Builds the Hart Software Services (HSS, the PolarFire SoC boot loader of the
# eNVM) with the MSS configuration of a project, and optionally exports the
# FlashPro job of the project with it (adi_project_envm_job.tcl).
#
# Requirements:
#   - SoftConsole: its directory in PATH (softconsole.sh, softconsole.cmd on
#     Windows), or SC_INSTALL_DIR; its RISC-V compiler, Python, make (Windows)
#     and mpfsBootmodeProgrammer, which makes the eNVM hex
#   - libero in PATH (the version of scripts/adi_env.tcl): fpgenprog, and the
#     job (-j)
#   - git
#
# Usage (in the project directory, e.g. projects/fmcomms2/mpfs_video_kit):
#   adi_make_hss.sh [options]
#
# Options (all optional):
#   -b <dir>   build directory of the project (default: _bld); the MSS XML and
#              the Libero project are taken from it
#   -x <file>  MSS configuration XML (default: <build>/mss/*_mss_cfg.xml)
#   -r <dir>   HSS repository, used as committed (git archive of its HEAD);
#              default: a clone of HSS_VERSION in <build>/tmp/hss
#   -v <ref>   HSS version (tag or commit) of the clone (default: HSS_VERSION)
#   -o <dir>   output directory (default: <build>/hss)
#   -j         export the job of the project with the HSS
#
# Output: hss-envm-wrapper.elf, the eNVM hex
# (hss-envm-wrapper.mpfs-video-kit.hex) and hss_info.txt (versions, XML
# checksum); with -j, <output>/system_top_hss.job.

set -e

HSS_URL=https://github.com/polarfire-soc/hart-software-services.git
HSS_VERSION=v2026.04.1
HSS_VERSION_COMMIT=711a983527cef51b8d1dbb92f91d1674a02f2270
HSS_BOARD=mpfs-video-kit

hdl_dir=$(cd "$(dirname "$0")/../.." && pwd)

build_dir=_bld
xml=
repo=
version=
out_dir=
job=0

while getopts "b:x:r:v:o:jh" opt; do
  case $opt in
    b) build_dir=$OPTARG ;;
    x) xml=$OPTARG ;;
    r) repo=$OPTARG ;;
    v) version=$OPTARG ;;
    o) out_dir=$OPTARG ;;
    j) job=1 ;;
    *) sed -n '/^# Builds/,/^# checksum/p' "$0"; exit 2 ;;
  esac
done

error() { echo "ERROR: $*" >&2; exit 1; }

# Windows (Cygwin): the SoftConsole tools take Windows paths
if command -v cygpath > /dev/null; then
  host_path() { cygpath -m "$1"; }
  unix_path() { cygpath -u "$1"; }
  exe=.exe
  sc_launcher=softconsole.cmd
  export OS=Windows_NT
else
  host_path() { echo "$1"; }
  unix_path() { echo "$1"; }
  exe=
  sc_launcher=softconsole.sh
fi

if [ -n "$SC_INSTALL_DIR" ]; then
  sc_dir=$(unix_path "$SC_INSTALL_DIR")
else
  sc=$(command -v $sc_launcher) || error "no SoftConsole: $sc_launcher is not in PATH (or set SC_INSTALL_DIR)"
  sc_dir=$(dirname "$(realpath "$sc")")
fi
[ -d "$sc_dir/riscv-unknown-elf-gcc" ] || error "no SoftConsole in $sc_dir"
libero=$(command -v libero) || error "libero is not in PATH"

build_dir=$(realpath -m "$build_dir")
out_dir=$(realpath -m "${out_dir:-$build_dir/hss}")

# -- MSS configuration -------------------------------------------------------------
if [ -z "$xml" ]; then
  set -- "$build_dir"/mss/*_mss_cfg.xml
  [ -f "$1" ] || error "no MSS XML in $build_dir/mss (build the project, or give -x)"
  [ $# -eq 1 ] || error "more MSS XML in $build_dir/mss, give one with -x"
  xml=$1
fi
xml=$(realpath "$xml")

# -- HSS source ----------------------------------------------------------------------
src=$build_dir/tmp/hss
rm -rf "$src"
mkdir -p "$src"
if [ -n "$repo" ]; then
  [ -z "$version" ] || error "-v is for the clone; check out the version in the repository of -r"
  hss_commit=$(git -C "$repo" rev-parse HEAD)
  git -C "$repo" archive HEAD | tar -x -C "$src"
  [ -z "$(git -C "$repo" status --porcelain --untracked-files=no)" ] || \
    echo "WARNING: $repo has local changes; they are not in the build (git archive of HEAD)"
else
  version=${version:-$HSS_VERSION}
  git -c advice.detachedHead=false clone -q --depth 1 --branch "$version" "$HSS_URL" "$src"
  hss_commit=$(git -C "$src" rev-parse HEAD)
  if [ "$version" = "$HSS_VERSION" ] && [ "$hss_commit" != "$HSS_VERSION_COMMIT" ]; then
    error "$HSS_VERSION is $hss_commit, expected $HSS_VERSION_COMMIT"
  fi
fi

# -- Build -----------------------------------------------------------------------------
# The board configuration with the project's MSS XML and the SoftConsole
# compiler; genconfig instead of the interactive configuration of the HSS make.
cp "$src/boards/$HSS_BOARD/def_config" "$src/.config"
sed -i "s#^CONFIG_SOC_FPGA_DESIGN_XML=.*#CONFIG_SOC_FPGA_DESIGN_XML=\"$(host_path "$xml")\"#" "$src/.config"
echo "CONFIG_CC_USE_SOFTCONSOLE=y" >> "$src/.config"

export SC_INSTALL_DIR=$(host_path "$sc_dir")
export FPGENPROG=$(host_path "$(dirname "$(realpath "$libero")")/../bin64/fpgenprog$exe")
# The SoftConsole tools only for the HSS make: its build tools (Windows) would
# hide the tools of this script (mkdir, ...)
sc_gcc=$sc_dir/riscv-unknown-elf-gcc/bin
if [ -n "$exe" ]; then
  sc_path=$sc_gcc:$sc_dir/build_tools/bin:$sc_dir/python3
else
  sc_path=$sc_gcc:$sc_dir/python3/bin
fi

log=$build_dir/tmp/hss_build.log
(cd "$src" && PATH=$sc_path:$PATH make$exe BOARD=$HSS_BOARD genconfig) > "$log" 2>&1 || \
  { tail -20 "$log"; error "HSS configuration failed, see $log"; }
(cd "$src" && PATH=$sc_path:$PATH make$exe BOARD=$HSS_BOARD) >> "$log" 2>&1 || \
  { tail -20 "$log"; error "HSS build failed, see $log"; }

hex=$src/build/hss-envm-wrapper.$HSS_BOARD.hex
[ -f "$hex" ] || error "no eNVM hex, see $log"

mkdir -p "$out_dir"
cp "$src/build/hss-envm-wrapper.elf" "$hex" "$out_dir/"

cat > "$out_dir/hss_info.txt" << EOF
hss:        $HSS_URL $hss_commit ${version:-$repo}
board:      $HSS_BOARD
mss xml:    $xml
xml sha256: $(sha256sum "$xml" | cut -d' ' -f1)
compiler:   $("$sc_gcc/riscv64-unknown-elf-gcc$exe" --version | head -1)
softconsole: $SC_INSTALL_DIR
hex sha256: $(sha256sum "$hex" | cut -d' ' -f1)
EOF
echo "HSS: $out_dir"

# -- Job -------------------------------------------------------------------------------
if [ $job -eq 1 ]; then
  set -- "$build_dir"/prj/*.prjx
  [ -f "$1" ] || error "no Libero project in $build_dir/prj"
  libero "SCRIPT:$(host_path "$hdl_dir/projects/scripts/adi_project_envm_job.tcl")" \
    "SCRIPT_ARGS:$(host_path "$1") $(host_path "$out_dir/$(basename "$hex")") $(host_path "$out_dir")" \
    "LOGFILE:$(host_path "$out_dir/hss_job.log")" > /dev/null || \
    error "job export failed, see $out_dir/hss_job.log"
  echo "Job: $out_dir/system_top_hss.job"
fi

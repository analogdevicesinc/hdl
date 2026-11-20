#!/bin/bash
##############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: BSD-1-Clause
##############################################################################

# Runs a testbench with the QuestaSim of Libero and the PolarFire primitive
# library; libero has to be in PATH (Cygwin or Linux). The testbench scripts of
# the library and make tb / tb-cli (projects/scripts/project-microchip.mk) call
# it the same way:
#
#   run_tb_microchip.sh [options] --top xyz_tb xyz_tb.v ../xyz.v
#
# Relative paths are taken from the current directory. vlog takes the language
# from the file extension (.v Verilog, .sv SystemVerilog); --vlog -sv compiles
# the .v files as SystemVerilog too, as Libero synthesizes them.

usage() {
	echo "usage: $(basename $0) [options] [files]"
	echo "  --gui              run in the GUI (default)"
	echo "  --cli              run in batch mode, exit 1 on errors"
	echo "  --top NAME         top module (required)"
	echo "  --dir DIR          run directory (default: the current directory)"
	echo "  -G NAME=VALUE      set a top level parameter (repeatable)"
	echo "  --vlog OPTION      pass an option to vlog (repeatable)"
	echo "  --vcom OPTION      pass an option to vcom (repeatable)"
	echo "  --vsim OPTION      pass an option to vsim (repeatable)"
	echo "  --do COMMAND       a simulator command before the run (repeatable)"
	echo "  --do-file FILE     a .do file before the run (repeatable, in order with --do)"
	echo "  --wave FILE        a wave .do file, in the GUI only (repeatable)"
	echo "  --run TIME         the run time instead of -all (e.g. 10us)"
	echo "  --post-do COMMAND  a simulator command after the run (repeatable)"
	echo "  -h, --help         this help"
	echo "  files              .v/.sv go to vlog, .vhd/.vhdl to vcom"
}

abs_path() {
	echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

gui=1
top=
dir=.
vlog_opts=
vcom_opts=
vsim_opts=
pre_run=()
post_run=()
run_time=-all
waves=()
files=()

while [ $# -gt 0 ]; do
	case "$1" in
		--gui) gui=1 ;;
		--cli) gui=0 ;;
		--top) shift; top=$1 ;;
		--dir) shift; dir=$1 ;;
		-G) shift; vsim_opts="$vsim_opts -g$1" ;;
		--vlog) shift; vlog_opts="$vlog_opts $1" ;;
		--vcom) shift; vcom_opts="$vcom_opts $1" ;;
		--vsim) shift; vsim_opts="$vsim_opts $1" ;;
		--do) shift; pre_run+=("cmd:$1") ;;
		--do-file) shift; pre_run+=("file:$(abs_path "$1")") ;;
		--wave) shift; waves+=("$(abs_path "$1")") ;;
		--run) shift; run_time=$1 ;;
		--post-do) shift; post_run+=("$1") ;;
		-h|--help) usage; exit 0 ;;
		-*) echo "ERROR: unknown option '$1'"; usage; exit 2 ;;
		*) files+=("$(abs_path "$1")") ;;
	esac
	shift
done

if [ -z "$top" ]; then
	echo "ERROR: no top module, use --top"; usage; exit 2
fi
if [ ${#files[@]} -eq 0 ]; then
	echo "ERROR: no source files"; usage; exit 2
fi

libero=$(command -v libero) || { echo "ERROR: libero is not in PATH"; exit 2; }
# Designer/bin on Windows, Designer/bin64 on Linux
root=${libero%/Designer/bin*/*}

if command -v cygpath > /dev/null; then
	bin=$root/QuestaSim_Pro/win64
	win_path() { cygpath -m "$1"; }
else
	bin=$root/QuestaSim_Pro/linux_x86_64
	win_path() { echo "$1"; }
fi

vlog_files=
vhdl_files=
for f in "${files[@]}"; do
	case "$f" in
		*.vhd|*.vhdl) vhdl_files="$vhdl_files $(win_path "$f")" ;;
		*) vlog_files="$vlog_files $(win_path "$f")" ;;
	esac
done

mkdir -p "$dir" && cd "$dir" || exit 1

# the --do commands and --do-file files, then the run, then --post-do
run_steps() {
	for e in "${pre_run[@]}"; do
		case "$e" in
			cmd:*) echo "${e#cmd:}" ;;
			file:*) echo "do {$(win_path "${e#file:}")}" ;;
		esac
	done
	echo "run $run_time"
	for c in "${post_run[@]}"; do echo "$c"; done
}

if [ $gui -eq 1 ]; then
	# +acc keeps every signal visible, so any of them can go to the waves
	# later; it turns optimizations off, so only in the GUI (--vsim
	# -voptargs=+acc adds it in batch mode)
	vsim_mode="-gui -voptargs=+acc"
	{
		for w in "${waves[@]}"; do echo "do {$(win_path "$w")}"; done
		echo "add log -r /*"
		run_steps
	} > run.do
else
	vsim_mode=-c
	{
		# $finish, $error and $fatal stop the run: go on with the script, so
		# --post-do runs also after a failure; the result is the test status
		# and the log check below (also for errors of the script commands)
		echo "onbreak {resume}"
		echo "onerror {resume}"
		run_steps
		echo "quit -code [expr {[coverage attribute -name TESTSTATUS -concise] >= 2}] -force"
	} > run.do
fi

"$bin/vlib" work || exit 1
"$bin/vmap" polarfire "$(win_path "$root/Designer/lib/questasim/precompiled/vlog/polarfire")" || exit 1
if [ -n "$vhdl_files" ]; then
	"$bin/vcom" ${vcom_opts} -work work ${vhdl_files} || exit 1
fi
if [ -n "$vlog_files" ]; then
	"$bin/vlog" ${vlog_opts} -work work ${vlog_files} || exit 1
fi
# -onfinish stop: after $finish the rest of run.do (--post-do, quit) still runs
"$bin/vsim" $vsim_mode -onfinish stop ${vsim_opts} -L polarfire -L work -t 1ps \
	work.$top -do run.do -l $top.vsim.log || exit 1

if grep -Eq "\*\* (Fatal|Error)" $top.vsim.log; then
	echo "ERROR: the simulation reported errors, see $(pwd)/$top.vsim.log"
	exit 1
fi

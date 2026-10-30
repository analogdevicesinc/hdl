##############################################################################
## Copyright (C) 2014-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: BSD-1-Clause
##############################################################################

export NAME=`basename $0`

# MODE not defined or defined to something else than 'batch'
if [[ -z ${MODE+x} ]] || [[ ! "$MODE" =~ "batch" ]]; then MODE="gui";fi
MODE="-"${MODE##*-} #remove any eventual extra dashes

case "$SIMULATOR" in
	modelsim)
  		# ModelSim flow
  		vlib work
  		vlog ${SOURCE} || exit 1
		vsim ${NAME} -do "add log /* -r; run -a" $MODE -logfile ${NAME}_modelsim.log || exit 1
		;;

	xsim)
		# XSim flow
		# XVLOG_OPTS and XELAB_OPTS are optional and empty by default. A test
		# bench that needs vendor primitive libraries or parameter overrides sets
		# them before sourcing this script, for example
		# XELAB_OPTS="-L unisims_ver glbl -generic_top NUM_LANES=2"
		xvlog -log ${NAME}_xvlog.log --sourcelibdir . ${XVLOG_OPTS} ${SOURCE} || exit 1
		xelab -log ${NAME}_xelab.log -debug all ${NAME} ${XELAB_OPTS} || exit 1
		if [[ "$MODE" == "-gui" ]]; then
			echo "log_wave -r *" > xsim_gui_cmd.tcl
			echo "run all" >> xsim_gui_cmd.tcl
			xsim ${XSIM_SNAPSHOT:-work.${NAME}} -gui -tclbatch xsim_gui_cmd.tcl -log ${NAME}_xsim.log
		else
			xsim ${XSIM_SNAPSHOT:-work.${NAME}} -R -log ${NAME}_xsim.log
		fi
		;;

	xcelium)
		# Xcelium flow
		xmvlog -NOWARN NONPRT ${SOURCE} || exit 1
		xmelab -access +rc ${NAME}
		xmsim ${NAME} -gui || exit 1
		;;

	*)
		#Icarus flow is the default
		mkdir -p run
		mkdir -p vcd
		iverilog -o run/run_${NAME} -I.. ${SOURCE} $1 || exit 1
		cd vcd
		../run/run_${NAME}
		;;
esac


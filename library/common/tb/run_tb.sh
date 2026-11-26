##############################################################################
## Copyright (C) 2014-2024, 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: BSD-1-Clause
##############################################################################

export NAME=`basename $0`

if [[ -z ${MODE+x} ]]; then
	MODE="batch"
	echo "INFO: MODE environment variable is not set. Defaulting to batch simulation mode."
else
	case "$MODE" in
		batch|gui)
			;;
		*)
			echo "ERROR: Invalid mode option."
			echo "Please export or re-export the MODE environment variable."
			echo "Valid simulator options:"
			echo "* batch - Command line"
			echo "* gui - Graphical User Interface"
			;;
	esac
fi
MODE="-"${MODE##*-} #remove any eventual extra dashes

case "$SIMULATOR" in
	modelsim|questasim)
  	# ModelSim / QuestaSim flow
  	vlib work
  	vlog ${SOURCE} || exit 1
		vsim ${NAME} -do "add log /* -r; run -a" $MODE -logfile ${NAME}_modelsim.log || exit 1
		;;

	xsim)
		# XSim flow
		xvlog -sv -log ${NAME}_xvlog.log --sourcelibdir . ${SOURCE} || exit 1
		xelab -log ${NAME}_xelab.log -debug all ${NAME} || exit 1
		if [[ "$MODE" == "-gui" ]]; then
			echo "log_wave -r *" > xsim_gui_cmd.tcl
			echo "run all" >> xsim_gui_cmd.tcl
			xsim work.${NAME} -gui -tclbatch xsim_gui_cmd.tcl -log ${NAME}_xsim.log
		else
			xsim work.${NAME} -R -log ${NAME}_xsim.log
		fi
		;;

	xcelium)
		# Xcelium flow
		xmvlog -NOWARN NONPRT ${SOURCE} || exit 1
		xmelab -access +rc ${NAME}
		if [[ "$MODE" == "-gui" ]]; then
			xmsim ${NAME} -gui || exit 1
		else
			xmsim ${NAME} || exit 1
		fi
		;;

	icarus)
		#Icarus flow
		iverilog -g2005-sv -o run_${NAME} -I.. ${SOURCE} || exit 1
		./run_${NAME} > ${NAME}_icarus.log
		cat ${NAME}_icarus.log
		;;

	*)
		echo "ERROR: Invalid simulator option."
		echo "Please export or re-export the SIMULATOR environment variable."
		echo "Valid simulator options:"
		echo "* modelsim / questasim -> Mentor / Siemens"
		echo "* xsim -> Vivado"
		echo "* xcelium -> Cadence"
		echo "* icarus -> Icarus Verilog"
esac

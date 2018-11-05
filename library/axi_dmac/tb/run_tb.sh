NAME=`basename $0`

case "$SIMULATOR" in
	modelsim)
  		# ModelSim flow
  		vlib work
  		vlog ${SOURCE} || exit 1
  		vsim "dmac_"${NAME} -do "add log /* -r; run -a" -gui || exit 1
		;;
	xsim)
  		# xsim flow
  		xvlog -log ${NAME}_xvlog.log --sourcelibdir . ${SOURCE}
  		xelab -log ${NAME}_xelab.log -debug all dmac_${NAME}
  		xsim work.dmac_${NAME} -R
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

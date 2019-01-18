NAME=`basename $0`

case "$SIMULATOR" in
	  modelsim)
  		# ModelSim flow
  		vlib work
  		vlog ${SOURCE} || exit 1
  		vsim ${NAME} -do "add log /* -r; run -a" -gui || exit 1
		;;
  	xsim)
  		# xsim flow
  		xvlog -log ${NAME}_xvlog.log --sourcelibdir . ${SOURCE}
  		xelab -log ${NAME}_xelab.log -debug all ${NAME}
  		xsim work.${NAME} -R
		;;
	  *)
      mkdir -p run
      mkdir -p vcd
      iverilog ${SOURCE} -o run/run_${NAME} $1 || exit 1
  
      cd vcd
      ../run/run_${NAME}
	  ;;
esac

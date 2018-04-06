NAME=`basename $0`

if [[ ${SIMULATOR} != "modelsim" ]]; then

  #Icarus flow
  mkdir -p run
  mkdir -p vcd
  iverilog -o run/run_${NAME} -I.. ${SOURCE} $1 || exit 1

  cd vcd
  ../run/run_${NAME}

else

  # ModelSim flow
  vlib work

  vlog ${SOURCE} || exit 1
  vsim "dmac_"${NAME} -do "add log /* -r; run -a" -gui || exit 1

fi

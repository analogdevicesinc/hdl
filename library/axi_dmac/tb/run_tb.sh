NAME=`basename $0`

if [[ ${SIMULATOR} != "modelsim" ]]; then

  #Icarus flow
  WARNINGS="-Wimplicit -Wportbind -Wselect-range -Wtimescale"

  # Version 10 does not have these warnings
  iverilog -v 2>&1 | grep -o "version 1[^0]" > /dev/null
  if [[ $? = 0 ]]; then
    WARNINGS+=" -Wfloating-nets -Wanachronisms -Wimplicit-dimensions"
  fi

  mkdir -p run
  mkdir -p vcd
  iverilog ${WARNINGS} -o run/run_${NAME} -I.. ${SOURCE} $1 || exit 1

  cd vcd
  vvp -n ../run/run_${NAME}

else

  # ModelSim flow
  vlib work

  vlog ${SOURCE} || exit 1
  vsim "dmac_"${NAME} -do "add log /* -r; run -a" -gui || exit 1

fi

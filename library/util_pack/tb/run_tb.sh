NAME=`basename $0`

mkdir -p run
mkdir -p vcd

WARNINGS="-Wimplicit -Wportbind -Wselect-range -Wtimescale"

# These warnings are only available with version 11
iverilog -v 2>&1 | grep -o "version 1[^0]" > /dev/null
if [[ $? = 0 ]]; then
  WARNINGS+=" -Wfloating-nets -Wanachronisms -Wimplicit-dimensions"
fi

# Can be overwritten using a environment variables
NUM_CHANNELS=${NUM_CHANNELS:-"1 2 4 8 16 32"}
SAMPLES_PER_CHANNEL=${SAMPLES_PER_CHANNEL:-1}
ENABLE_RANDOM=${ENABLE_RANDOM:-0}
VCD=${VCD:-0}

for i in ${NUM_CHANNELS}; do
	if [[ $VCD = 0 ]]; then
		VCD_FILE='""';
	else
		VCD_FILE='"'${NAME}_${SAMPLES_PER_CHANNEL}_${i}'.vcd"'
	fi
	echo Testing $i Channels...
	iverilog ${WARNINGS} ${SOURCE} -o run/run_${NAME}_${i} $1 \
		-P ${NAME}.NUM_OF_CHANNELS=${i} \
		-P ${NAME}.SAMPLES_PER_CHANNEL=${SAMPLES_PER_CHANNEL} \
		-P ${NAME}.ENABLE_RANDOM=${ENABLE_RANDOM} \
		-P ${NAME}.VCD_FILE=${VCD_FILE} \
	|| exit 1
	(cd vcd; vvp -N ../run/run_${NAME}_${i})
done

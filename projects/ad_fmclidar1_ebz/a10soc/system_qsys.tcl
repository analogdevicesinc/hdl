# Configurable parameters

set SAMPLE_RATE_MHZ 1000.0
set NUM_OF_CHANNELS 4           ; # M
set SAMPLES_PER_FRAME 1         ; # S
set NUM_OF_LANES 4              ; # L
set ADC_RESOLUTION 8            ; # N & NP

set LANE_RATE [expr {($ADC_RESOLUTION * $NUM_OF_CHANNELS *$SAMPLE_RATE_MHZ * 1.25) / $NUM_OF_LANES}]

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_qsys.tcl
source ../common/ad_fmclidar1_ebz_qsys.tcl


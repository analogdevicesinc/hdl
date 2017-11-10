
# Configurable parameters

set SAMPLE_RATE_MHZ 1000.0
set NUM_OF_CHANNELS 4           ; # M
set SAMPLES_PER_FRAME 1         ; # S
set NUM_OF_LANES 4              ; # L
set ADC_RESOLUTION 8            ; # N & NP

# Auto-computed parameters

set CHANNEL_DATA_WIDTH [expr 32 * $NUM_OF_LANES / $NUM_OF_CHANNELS]
set ADC_DATA_WIDTH [expr $CHANNEL_DATA_WIDTH * $NUM_OF_CHANNELS]
set DMA_DATA_WIDTH [expr $ADC_DATA_WIDTH < 128 ? $ADC_DATA_WIDTH : 128]
set SAMPLE_WIDTH [expr $ADC_RESOLUTION > 8 ? 16 : 8]

# add RTL sources which will be instantiated in system_bd directly
adi_project_files ad_fmclidar1_ebz_zc706 [list \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/library/common/util_axis_syncgen.v" ]

# source all the block designs
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source ../common/ad_fmclidar1_ebz_bd.tcl


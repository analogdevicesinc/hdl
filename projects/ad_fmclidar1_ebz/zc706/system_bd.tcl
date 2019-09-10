
# Configurable parameters

set SAMPLE_RATE_MHZ 1000.0
set NUM_OF_CHANNELS 4           ; # M
set SAMPLES_PER_FRAME 1         ; # S
set NUM_OF_LANES 4              ; # L
set ADC_RESOLUTION 8            ; # N & NP

# Auto-computed parameters

set CHANNEL_DATA_WIDTH [expr 32 * $NUM_OF_LANES / $NUM_OF_CHANNELS]
set ADC_DATA_WIDTH [expr $CHANNEL_DATA_WIDTH * $NUM_OF_CHANNELS]
# we have to calculate with an additional dummy channel for TIA
set DMA_DATA_WIDTH [expr $ADC_DATA_WIDTH > 127 ? 256 : \
                         $ADC_DATA_WIDTH >  63 ? 128 : 64]
set SAMPLE_WIDTH [expr $ADC_RESOLUTION > 8 ? 16 : 8]

# add RTL sources which will be instantiated in system_bd directly
adi_project_files ad_fmclidar1_ebz_zc706 [list \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "../common/util_tia_chsel.v" \
  "../common/util_axis_syncgen.v" ]

# source all the block designs
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source ../common/ad_fmclidar1_ebz_bd.tcl

# I2C for AFE board's DAC

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_dac

ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_GRP_IO1_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C1_PERIPHERAL_ENABLE 1

ad_connect iic_dac sys_ps7/IIC_1

# System ID instance and configuration
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring


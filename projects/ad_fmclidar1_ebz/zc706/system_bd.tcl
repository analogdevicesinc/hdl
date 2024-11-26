###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Configurable parameters
set SAMPLE_RATE_MHZ 1000.0
set NUM_OF_CHANNELS 4           ; # M
set SAMPLES_PER_FRAME 1         ; # S
set NUM_OF_LANES 4              ; # L
set ADC_RESOLUTION 8            ; # N & NP

# data_offload attributes
set offload_name ad9694_offload
set adc_offload_type 1                             ; # PL_DDR
set adc_offload_size [expr 1 * 1024 * 1024 * 1024] ; # 1 Gbyte
set plddr_offload_axi_data_width 512

# Auto-computed parameters

set CHANNEL_DATA_WIDTH [expr 32 * $NUM_OF_LANES / $NUM_OF_CHANNELS]
set ADC_DATA_WIDTH [expr $CHANNEL_DATA_WIDTH * $NUM_OF_CHANNELS]
# since we removed the additional dummy channel for TIA, now the
# source data width for the dma is the adc data width
set DMA_DATA_WIDTH $ADC_DATA_WIDTH
set SAMPLE_WIDTH [expr $ADC_RESOLUTION > 8 ? 16 : 8]

# add RTL sources which will be instantiated in system_bd directly
adi_project_files ad_fmclidar1_ebz_zc706 [list \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
]
# source all the block designs
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source ../common/ad_fmclidar1_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

################################################################################
## DDR3 MIG for Data Offload IP
################################################################################

if {$adc_offload_type} {

    ad_ip_instance proc_sys_reset axi_rstgen
    ad_ip_instance mig_7series axi_ddr_cntrl
    file copy -force $ad_hdl_dir/projects/common/zc706/zc706_plddr3_mig.prj [get_property IP_DIR \
      [get_ips [get_property CONFIG.Component_Name [get_bd_cells axi_ddr_cntrl]]]]
    ad_ip_parameter axi_ddr_cntrl CONFIG.XML_INPUT_FILE zc706_plddr3_mig.prj

    # PL-DDR data offload interfaces
    create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk
    create_bd_port -dir I -type rst sys_rst
    set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports sys_rst]
    create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3

    ad_connect axi_ddr_cntrl/ui_clk axi_rstgen/slowest_sync_clk
    ad_connect axi_ddr_cntrl/ui_clk $offload_name/storage_unit/m_axi_aclk
    ad_connect axi_ddr_cntrl/S_AXI $offload_name/storage_unit/MAXI_0
    ad_connect axi_rstgen/peripheral_aresetn $offload_name/storage_unit/m_axi_aresetn
    ad_connect axi_rstgen/peripheral_aresetn axi_ddr_cntrl/aresetn
    ad_connect sys_cpu_resetn axi_rstgen/ext_reset_in

    assign_bd_address [get_bd_addr_segs -of_objects [get_bd_cells axi_ddr_cntrl]]

    ad_connect  sys_rst axi_ddr_cntrl/sys_rst
    ad_connect  sys_clk axi_ddr_cntrl/SYS_CLK
    ad_connect  ddr3    axi_ddr_cntrl/DDR3
    ad_connect  axi_ddr_cntrl/device_temp_i GND
    ad_connect  $offload_name/i_data_offload/ddr_calib_done axi_ddr_cntrl/init_calib_complete
}

ad_ip_parameter $offload_name/storage_unit CONFIG.DDR_BASE_ADDDRESS [format "%d" 0x80000000]

# I2C for AFE board's DAC

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_dac

ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_GRP_IO1_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C1_PERIPHERAL_ENABLE 1

ad_connect iic_dac sys_ps7/IIC_1

# System ID instance and configuration
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "SAMPLE_RATE_MHZ=$SAMPLE_RATE_MHZ\
M=$NUM_OF_CHANNELS\
S=$SAMPLES_PER_FRAME\
L=$NUM_OF_LANES\
NP=$ADC_RESOLUTION\
CHANNEL_DATA_WIDTH=$CHANNEL_DATA_WIDTH\
ADC_DATA_WIDTH=$ADC_DATA_WIDTH\
DMA_DATA_WIDTH=$DMA_DATA_WIDTH\
SAMPLE_WIDTH=$SAMPLE_WIDTH"

sysid_gen_sys_init_file $sys_cstring

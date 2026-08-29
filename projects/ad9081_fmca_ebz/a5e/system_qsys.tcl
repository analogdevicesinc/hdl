###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## RX2 ADC FIFO depth in samples per converter
set adc_rx2_fifo_samples_per_converter [expr $ad_project_params(RX2_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/intel/dacfifo_qsys.tcl
source $ad_hdl_dir/projects/common/intel/adcfifo_qsys.tcl
source $ad_hdl_dir/projects/common/a5e/a5e_system_qsys.tcl

set jesd_mode $ad_project_params(JESD_MODE)

set jesd204_ref_clock [format {%.6f} $ad_project_params(REF_CLK_RATE)]
if {$jesd_mode == "64B66B"} {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 32]]
} else {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 20]]
}

set TRANSCEIVER_TYPE "E-Tile"
if [info exists ad_project_dir] {
  source ../../common/ad9081_fmca_ebz_qsys.tcl
} else {
  source ../common/ad9081_fmca_ebz_qsys.tcl
}

# RX2 parameters
set RX2_NUM_OF_LINKS $ad_project_params(RX2_NUM_LINKS)

# RX2 JESD parameter per link
set RX2_JESD_M     $ad_project_params(RX2_JESD_M)
set RX2_JESD_L     $ad_project_params(RX2_JESD_L)
set RX2_JESD_S     $ad_project_params(RX2_JESD_S)
set RX2_JESD_NP    $ad_project_params(RX2_JESD_NP)

if {$JESD_MODE == "8B10B"} {
  set RX2_DATA_PATH_WIDTH 4
  set RX2_TPL_DATA_PATH_WIDTH 4
  if {$RX2_JESD_NP==12} {
    set RX2_TPL_DATA_PATH_WIDTH 6
  }
} else {
  set RX2_DATA_PATH_WIDTH 8
  set RX2_TPL_DATA_PATH_WIDTH 8
  if {$RX2_JESD_NP==12} {
    set RX2_TPL_DATA_PATH_WIDTH 12
  }
}

set RX2_NUM_OF_LANES      [expr $RX2_JESD_L * $RX2_NUM_OF_LINKS]
set RX2_NUM_OF_CONVERTERS [expr $RX2_JESD_M * $RX2_NUM_OF_LINKS]
set RX2_SAMPLES_PER_FRAME $RX2_JESD_S
set RX2_SAMPLE_WIDTH      $RX2_JESD_NP
set RX2_DMA_SAMPLE_WIDTH  16

set RX2_OCTETS_PER_FRAME    [expr $RX2_NUM_OF_CONVERTERS * $RX2_SAMPLES_PER_FRAME * $RX2_SAMPLE_WIDTH / (8 * $RX2_NUM_OF_LANES)] ; # F
if {$RX2_OCTETS_PER_FRAME > $RX2_TPL_DATA_PATH_WIDTH} {
  set RX2_TPL_DATA_PATH_WIDTH $RX2_OCTETS_PER_FRAME
}

set RX2_SAMPLES_PER_CHANNEL [expr $RX2_NUM_OF_LANES * 8*$RX2_TPL_DATA_PATH_WIDTH / \
                                ($RX2_NUM_OF_CONVERTERS * $RX2_SAMPLE_WIDTH)]

set adc_rx2_fifo_name mxfe_rx2_adc_fifo
set adc_rx2_data_width [expr 8*$RX2_TPL_DATA_PATH_WIDTH*$RX2_NUM_OF_LANES*$RX2_DMA_SAMPLE_WIDTH/$RX2_SAMPLE_WIDTH]
set adc_rx2_dma_data_width $adc_rx2_data_width
set adc_rx2_fifo_address_width [expr int(ceil(log(($adc_rx2_fifo_samples_per_converter*$RX2_NUM_OF_CONVERTERS) / ($adc_rx2_data_width/$RX2_DMA_SAMPLE_WIDTH))/log(2)))]

# Extend the shared PHY / GTS reset instances to cover the RX2 lanes

set_instance_parameter_value jesd204_phy {NUM_OF_LANES} [expr $RX_NUM_OF_LANES + $RX2_NUM_OF_LANES]
set_instance_parameter_value gts_reset_phy NUM_BANKS_SHORELINE [expr int(ceil(($RX_NUM_OF_LANES + $RX2_NUM_OF_LANES) / 4.0))]
set_instance_parameter_value gts_reset_phy NUM_LANES_SHORELINE [expr $RX_NUM_OF_LANES + $RX2_NUM_OF_LANES]

# RX2 JESD204 clock bridge

add_instance rx2_device_clk altera_clock_bridge
set_instance_parameter_value rx2_device_clk {EXPLICIT_CLOCK_RATE} [expr $DEVICE_CLK_RATE * $RX2_DATA_PATH_WIDTH / $RX2_TPL_DATA_PATH_WIDTH ]

# RX2 JESD204 PHY-Link layer

add_instance mxfe_rx2_jesd204 adi_jesd204
set_instance_parameter_value mxfe_rx2_jesd204 {ID} {0}
set_instance_parameter_value mxfe_rx2_jesd204 {LINK_MODE} $LINK_MODE
set_instance_parameter_value mxfe_rx2_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value mxfe_rx2_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value mxfe_rx2_jesd204 {LANE_RATE} $RX_LANE_RATE
set_instance_parameter_value mxfe_rx2_jesd204 {SYSCLK_FREQUENCY} {100.0}
set_instance_parameter_value mxfe_rx2_jesd204 {REFCLK_FREQUENCY} $REF_CLK_RATE
set_instance_parameter_value mxfe_rx2_jesd204 {INPUT_PIPELINE_STAGES} {2}
set_instance_parameter_value mxfe_rx2_jesd204 {NUM_OF_LANES} $RX2_NUM_OF_LANES
set_instance_parameter_value mxfe_rx2_jesd204 {EXT_DEVICE_CLK_EN} {1}
set_instance_parameter_value mxfe_rx2_jesd204 {TPL_DATA_PATH_WIDTH} $RX2_TPL_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_rx2_jesd204 {DATA_PATH_WIDTH} $RX2_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_rx2_jesd204 {EXTERNAL_PHY} $EXTERNAL_PHY
# set_instance_parameter_value mxfe_rx_jesd204 {LANE_MAP} {5 7 0 1 2 3 4 6}


add_instance mxfe_rx2_tpl ad_ip_jesd204_tpl_adc
set_instance_parameter_value mxfe_rx2_tpl {ID} {0}
set_instance_parameter_value mxfe_rx2_tpl {NUM_CHANNELS} $RX2_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_rx2_tpl {NUM_LANES} $RX2_NUM_OF_LANES
set_instance_parameter_value mxfe_rx2_tpl {BITS_PER_SAMPLE} $RX2_SAMPLE_WIDTH
set_instance_parameter_value mxfe_rx2_tpl {CONVERTER_RESOLUTION} $RX2_SAMPLE_WIDTH
set_instance_parameter_value mxfe_rx2_tpl {TWOS_COMPLEMENT} {1}
set_instance_parameter_value mxfe_rx2_tpl {OCTETS_PER_BEAT} $RX2_TPL_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_rx2_tpl {DMA_BITS_PER_SAMPLE} $RX2_DMA_SAMPLE_WIDTH

# RX2 pack

add_instance mxfe_rx2_cpack util_cpack2
set_instance_parameter_value mxfe_rx2_cpack {NUM_OF_CHANNELS} $RX2_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_rx2_cpack {SAMPLES_PER_CHANNEL} $RX2_SAMPLES_PER_CHANNEL
set_instance_parameter_value mxfe_rx2_cpack {SAMPLE_DATA_WIDTH} $RX2_DMA_SAMPLE_WIDTH

# RX2 data offload buffer

ad_adcfifo_create $adc_rx2_fifo_name $adc_rx2_data_width $adc_rx2_dma_data_width $adc_rx2_fifo_address_width 0

# RX2 DMA instance

add_instance mxfe_rx2_dma axi_dmac
set_instance_parameter_value mxfe_rx2_dma {ID} {0}
set_instance_parameter_value mxfe_rx2_dma {DMA_DATA_WIDTH_SRC} $adc_rx2_dma_data_width
set_instance_parameter_value mxfe_rx2_dma {DMA_DATA_WIDTH_DEST} $adc_rx2_dma_data_width
set_instance_parameter_value mxfe_rx2_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value mxfe_rx2_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value mxfe_rx2_dma {AXI_SLICE_DEST} {1}
set_instance_parameter_value mxfe_rx2_dma {AXI_SLICE_SRC} {1}
set_instance_parameter_value mxfe_rx2_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value mxfe_rx2_dma {CYCLIC} {0}
set_instance_parameter_value mxfe_rx2_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value mxfe_rx2_dma {DMA_TYPE_SRC} {1}
set_instance_parameter_value mxfe_rx2_dma {FIFO_SIZE} {16}
set_instance_parameter_value mxfe_rx2_dma {DMA_AXI_PROTOCOL_DEST} {0}
set_instance_parameter_value mxfe_rx2_dma {MAX_BYTES_PER_BURST} {2048}

# clocks and resets

# system clock and reset
add_connection sys_clk.clk mxfe_rx2_jesd204.sys_clk
add_connection sys_clk.clk mxfe_rx2_tpl.s_axi_clock
add_connection sys_clk.clk mxfe_rx2_dma.s_axi_clock

add_connection sys_clk.clk_reset mxfe_rx2_jesd204.sys_resetn
add_connection sys_clk.clk_reset mxfe_rx2_tpl.s_axi_reset
add_connection sys_clk.clk_reset mxfe_rx2_dma.s_axi_reset

# device clock and reset
add_connection rx2_device_clk.out_clk mxfe_rx2_jesd204.device_clk
add_connection rx2_device_clk.out_clk mxfe_rx2_tpl.link_clk
if {$EXTERNAL_PHY} {
  if {$RX2_TPL_DATA_PATH_WIDTH > $RX2_DATA_PATH_WIDTH} {
    add_connection jesd204_phy.rx_clkout mxfe_rx2_jesd204.phy_link_clk
  }
}
add_connection rx2_device_clk.out_clk mxfe_rx2_cpack.clk
add_connection rx2_device_clk.out_clk $adc_rx2_fifo_name.if_adc_clk

add_connection mxfe_rx2_jesd204.link_reset mxfe_rx2_cpack.reset
add_connection mxfe_rx2_jesd204.link_reset $adc_rx2_fifo_name.if_adc_rst

# dma clock and reset
add_connection sys_dma_clk.clk $adc_rx2_fifo_name.if_dma_clk
add_connection sys_dma_clk.clk mxfe_rx2_dma.if_s_axis_aclk
add_connection sys_dma_clk.clk mxfe_rx2_dma.m_dest_axi_clock

add_connection sys_dma_clk.clk_reset mxfe_rx2_dma.m_dest_axi_reset

#
## Exported signals
#

add_interface rx2_sysref       conduit end
add_interface rx2_sync         conduit end
add_interface rx2_device_clk   clock   sink

set_interface_property rx2_sysref       EXPORT_OF mxfe_rx2_jesd204.sysref
set_interface_property rx2_sync         EXPORT_OF mxfe_rx2_jesd204.sync
set_interface_property rx2_device_clk   EXPORT_OF rx2_device_clk.in_clk

add_interface rx2_ref_clk      clock   sink
add_interface tx_os_ref_clk    clock   sink
add_interface rx2_serial_data  conduit end

if {$TRANSCEIVER_TYPE == "F-Tile" || $TRANSCEIVER_TYPE == "E-Tile"} {
  add_interface rx2_serial_data_n  conduit end
}

# RX2 PHY exports and connections
set_interface_property mxfe_rx2_jesd204_reset_ack EXPORT_OF mxfe_rx2_jesd204.reset_ack
set_interface_property mxfe_rx2_jesd204_ready EXPORT_OF mxfe_rx2_jesd204.ready
set_interface_property mxfe_rx2_jesd204_rx_is_lockedtodata EXPORT_OF mxfe_rx2_jesd204.rx_is_lockedtodata

for {set i 0} {$i < $RX2_NUM_OF_LANES} {incr i} {
  set idx [expr $RX_NUM_OF_LANES + $i]
  add_connection jesd204_phy.phy_rx_${idx} mxfe_rx2_jesd204.rx_phy${i}
}

#
## Data interface / data path
#

# RX2 link to tpl
add_connection mxfe_rx2_jesd204.link_sof mxfe_rx2_tpl.if_link_sof
add_connection mxfe_rx2_jesd204.link_data mxfe_rx2_tpl.link_data
# RX2 tpl to cpack
for {set i 0} {$i < $RX2_NUM_OF_CONVERTERS} {incr i} {
  add_connection mxfe_rx2_tpl.adc_ch_$i mxfe_rx2_cpack.adc_ch_$i
}
add_connection mxfe_rx2_tpl.if_adc_dovf $adc_rx2_fifo_name.if_adc_wovf
# RX2 cpack to offload
add_connection mxfe_rx2_cpack.if_packed_fifo_wr_en $adc_rx2_fifo_name.if_adc_wr
add_connection mxfe_rx2_cpack.if_packed_fifo_wr_data $adc_rx2_fifo_name.if_adc_wdata
# RX2 offload to dma
add_connection $adc_rx2_fifo_name.if_dma_xfer_req mxfe_rx2_dma.if_s_axis_xfer_req
add_connection $adc_rx2_fifo_name.m_axis mxfe_rx2_dma.s_axis
# RX2 dma to HPS
ad_dma_interconnect mxfe_rx2_dma.m_dest_axi 0x0000000 $adc_rx2_dma_data_width

#
## address map
#

ad_cpu_interconnect 0x000B0000 mxfe_rx2_jesd204.link_reconfig
ad_cpu_interconnect 0x000B4000 mxfe_rx2_jesd204.link_management
ad_cpu_interconnect 0x000B8000 mxfe_rx2_tpl.s_axi
ad_cpu_interconnect 0x000BC000 mxfe_rx2_dma.s_axi

#
## interrupts
#

ad_cpu_interrupt  9  mxfe_rx2_jesd204.interrupt
ad_cpu_interrupt 12  mxfe_rx2_dma.interrupt_sender

# GTS PLL
add_instance gts_pll intel_systemclk_gts
set_instance_parameter_value gts_pll syspll_mod_0 {User Configuration}
set_instance_parameter_value gts_pll syspll_freq_mhz_0 $syspll_freq
set_instance_parameter_value gts_pll refclk_xcvr_freq_mhz_0 $jesd204_ref_clock

add_interface i_refclk_rdy conduit end
add_interface o_pll_lock   conduit end
add_interface refclk_xcvr  clock sink
add_interface o_syspll_c0  clock source

set_interface_property i_refclk_rdy EXPORT_OF gts_pll.i_refclk_rdy
set_interface_property o_pll_lock   EXPORT_OF gts_pll.o_pll_lock
set_interface_property refclk_xcvr  EXPORT_OF gts_pll.refclk_xcvr
set_interface_property o_syspll_c0  EXPORT_OF gts_pll.o_syspll_c0

# Internal 100 MHz clock exported
add_instance sys_cpu_clk_bridge altera_clock_bridge
set_instance_parameter_value sys_cpu_clk_bridge {EXPLICIT_CLOCK_RATE} {100000000}
add_connection sys_clk.clk sys_cpu_clk_bridge.in_clk

add_interface sys_cpu_clk clock source
set_interface_property sys_cpu_clk EXPORT_OF sys_cpu_clk_bridge.out_clk

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {10}
set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "$mem_init_sys_file_path/mem_init_sys.txt"
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {10}

set sys_cstring "$ad_project_params(JESD_MODE)\
RX:RATE=$ad_project_params(RX_LANE_RATE)\
M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
NP=$ad_project_params(RX_JESD_NP)\
LINKS=$ad_project_params(RX_NUM_LINKS)\
KS/CH=$ad_project_params(RX_KS_PER_CHANNEL)\
M2=$ad_project_params(RX2_JESD_M)\
L2=$ad_project_params(RX2_JESD_L)\
S2=$ad_project_params(RX2_JESD_S)\
NP2=$ad_project_params(RX2_JESD_NP)\
LINKS2=$ad_project_params(RX2_NUM_LINKS)\
KS2/CH=$ad_project_params(RX2_KS_PER_CHANNEL)\
TX:RATE=$ad_project_params(TX_LANE_RATE)\
M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
NP=$ad_project_params(TX_JESD_NP)\
LINKS=$ad_project_params(TX_NUM_LINKS)\
KS/CH=$ad_project_params(TX_KS_PER_CHANNEL)\
REF_CLK=$ad_project_params(REF_CLK_RATE)\
DEV_CLK=$ad_project_params(DEVICE_CLK_RATE)"

sysid_gen_sys_init_file sys_cstring 10

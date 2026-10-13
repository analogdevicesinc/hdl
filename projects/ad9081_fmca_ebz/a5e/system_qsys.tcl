###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## RX2 ADC FIFO depth in samples per converter
set adc_rx2_fifo_samples_per_converter [expr $ad_project_params(RX2_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/a5e/a5e_system_qsys.tcl

set jesd_mode $ad_project_params(JESD_MODE)

set jesd204_ref_clock [format {%.6f} $ad_project_params(REF_CLK_RATE)]
if {$jesd_mode == "64B66B"} {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 32]]
} else {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 20]]
}

set TRANSCEIVER_TYPE "GTS"
if [info exists ad_project_dir] {
  source ../../common/ad9081_fmca_ebz_qsys.tcl
} else {
  source ../common/ad9081_fmca_ebz_qsys.tcl
}

set RX2_NUM_OF_LINKS $ad_project_params(RX2_NUM_LINKS)

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

set adc_rx2_data_offload_name mxfe_rx2_data_offload
set adc_rx2_data_width [expr 8*$RX2_TPL_DATA_PATH_WIDTH*$RX2_NUM_OF_LANES*$RX2_DMA_SAMPLE_WIDTH/$RX2_SAMPLE_WIDTH]
set adc_rx2_dma_data_width $adc_rx2_data_width

# RX2 transceiver IP, with its lanes in the same shoreline bank as the RX ones.
# The GTS reset sequencer is extended to cover both PHYs.

add_instance jesd204_phy_rx2 jesd204_gts_phy
set_instance_parameter_value jesd204_phy_rx2 {ID} {1}
set_instance_parameter_value jesd204_phy_rx2 {LINK_MODE} $LINK_MODE
set_instance_parameter_value jesd204_phy_rx2 {LANE_RATE} $RX_LANE_RATE
set_instance_parameter_value jesd204_phy_rx2 {REFCLK_FREQUENCY} $REF_CLK_RATE
set_instance_parameter_value jesd204_phy_rx2 {NUM_OF_LANES} $RX2_NUM_OF_LANES
set_instance_parameter_value jesd204_phy_rx2 {INPUT_PIPELINE_STAGES} {2}
set_instance_parameter_value jesd204_phy_rx2 {EXTERNAL_LINK_CLK} {1}
set_instance_parameter_value jesd204_phy_rx2 {INSTANTIATE_RESET_CONTROLLER} {0}

add_interface system_pll_clk_rx2 clock sink
set_interface_property system_pll_clk_rx2 EXPORT_OF jesd204_phy_rx2.system_pll_clk

add_interface system_pll_lock_rx2 conduit end
set_interface_property system_pll_lock_rx2 EXPORT_OF jesd204_phy_rx2.system_pll_lock

set_instance_parameter_value gts_reset_phy NUM_BANKS_SHORELINE [expr int(ceil(($RX_NUM_OF_LANES + $RX2_NUM_OF_LANES) / 4.0))]
set_instance_parameter_value gts_reset_phy NUM_LANES_SHORELINE [expr $RX_NUM_OF_LANES + $RX2_NUM_OF_LANES]

add_interface jesd204_phy_rx2_i_pma_cu_clk conduit end
add_interface jesd204_phy_rx2_i_src_rs_grant conduit end
add_interface jesd204_phy_rx2_o_src_rs_req conduit end
add_interface jesd204_phy_rx2_i_refclk_cmd_bus_in conduit end
add_interface jesd204_phy_rx2_o_refclk_status_bus_out conduit end

set_interface_property jesd204_phy_rx2_i_pma_cu_clk EXPORT_OF jesd204_phy_rx2.i_pma_cu_clk
set_interface_property jesd204_phy_rx2_i_src_rs_grant EXPORT_OF jesd204_phy_rx2.i_src_rs_grant
set_interface_property jesd204_phy_rx2_o_src_rs_req EXPORT_OF jesd204_phy_rx2.o_src_rs_req
set_interface_property jesd204_phy_rx2_i_refclk_cmd_bus_in EXPORT_OF jesd204_phy_rx2.i_refclk_cmd_bus_in
set_interface_property jesd204_phy_rx2_o_refclk_status_bus_out EXPORT_OF jesd204_phy_rx2.o_refclk_status_bus_out

add_instance rx2_device_clk altera_clock_bridge
set_instance_parameter_value rx2_device_clk {EXPLICIT_CLOCK_RATE} [expr $DEVICE_CLK_RATE * $RX2_DATA_PATH_WIDTH / $RX2_TPL_DATA_PATH_WIDTH ]

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

add_instance mxfe_rx2_cpack util_cpack2
set_instance_parameter_value mxfe_rx2_cpack {NUM_OF_CHANNELS} $RX2_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_rx2_cpack {SAMPLES_PER_CHANNEL} $RX2_SAMPLES_PER_CHANNEL
set_instance_parameter_value mxfe_rx2_cpack {SAMPLE_DATA_WIDTH} $RX2_DMA_SAMPLE_WIDTH

ad9081_offload_create $adc_rx2_data_offload_name 0 \
  [ad9081_offload_size $adc_rx2_fifo_samples_per_converter $RX2_NUM_OF_CONVERTERS $RX2_DMA_SAMPLE_WIDTH] \
  $adc_rx2_data_width $adc_rx2_dma_data_width

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

add_connection sys_clk.clk mxfe_rx2_jesd204.sys_clk
add_connection sys_clk.clk mxfe_rx2_tpl.s_axi_clock
add_connection sys_clk.clk mxfe_rx2_dma.s_axi_clock

add_connection sys_clk.clk_reset mxfe_rx2_jesd204.sys_resetn
add_connection sys_clk.clk_reset mxfe_rx2_tpl.s_axi_reset
add_connection sys_clk.clk_reset mxfe_rx2_dma.s_axi_reset

add_connection rx2_device_clk.out_clk mxfe_rx2_jesd204.device_clk
add_connection rx2_device_clk.out_clk mxfe_rx2_tpl.link_clk
if {$EXTERNAL_PHY} {
  add_connection mxfe_rx2_jesd204.phy_link_clk jesd204_phy_rx2.rx_link_clock
  # The TX side has no link layer behind it, see below.
  add_connection jesd204_phy_rx2.tx_clkout2 jesd204_phy_rx2.tx_link_clock
}
add_connection rx2_device_clk.out_clk mxfe_rx2_cpack.clk
add_connection rx2_device_clk.out_clk $adc_rx2_data_offload_name.s_axis_aclk

add_connection mxfe_rx2_jesd204.link_reset mxfe_rx2_cpack.reset
add_connection mxfe_rx2_jesd204.link_reset $adc_rx2_data_offload_name.s_axis_aresetn

add_connection sys_clk.clk $adc_rx2_data_offload_name.sys_clk
add_connection sys_clk.clk_reset $adc_rx2_data_offload_name.sys_resetn
add_connection sys_dma_clk.clk $adc_rx2_data_offload_name.m_axis_aclk
add_connection sys_dma_clk.clk_reset $adc_rx2_data_offload_name.m_axis_aresetn
add_connection sys_dma_clk.clk mxfe_rx2_dma.if_s_axis_aclk
add_connection sys_dma_clk.clk mxfe_rx2_dma.m_dest_axi_clock

add_connection sys_dma_clk.clk_reset mxfe_rx2_dma.m_dest_axi_reset

add_interface rx2_sysref       conduit end
add_interface rx2_sync         conduit end
add_interface rx2_device_clk   clock   sink

set_interface_property rx2_sysref       EXPORT_OF mxfe_rx2_jesd204.sysref
set_interface_property rx2_sync         EXPORT_OF mxfe_rx2_jesd204.sync
set_interface_property rx2_device_clk   EXPORT_OF rx2_device_clk.in_clk

add_interface rx2_ref_clk      clock   sink
add_interface rx2_tx_ref_clk   clock   sink
add_interface rx2_serial_data  conduit end

if {$TRANSCEIVER_TYPE == "F-Tile" || $TRANSCEIVER_TYPE == "GTS"} {
  add_interface rx2_serial_data_n  conduit end
}

# intel_directphy_gts is duplex only, so the RX2 PHY has a TX side with no
# link layer behind it. It is taken through the same reset sequence as the TX
# PHY, and its ready/ack/pll_locked are deliberately left unconnected.
add_connection mxfe_tx_jesd204.if_up_rst jesd204_phy_rx2.tx_link_reset
add_connection mxfe_tx_jesd204.reset     jesd204_phy_rx2.tx_reset

add_connection mxfe_rx2_jesd204.if_up_rst  jesd204_phy_rx2.rx_link_reset
add_connection mxfe_rx2_jesd204.reset      jesd204_phy_rx2.rx_reset
add_connection jesd204_phy_rx2.rx_reset_ack  mxfe_rx2_jesd204.reset_ack
add_connection jesd204_phy_rx2.rx_ready      mxfe_rx2_jesd204.ready

add_connection jesd204_phy_rx2.rx_is_lockedtodata mxfe_rx2_jesd204.rx_is_lockedtodata

for {set i 0} {$i < $RX2_NUM_OF_LANES} {incr i} {
  add_connection jesd204_phy_rx2.phy_rx_${i} mxfe_rx2_jesd204.rx_phy${i}
}

set_interface_property rx2_ref_clk         EXPORT_OF jesd204_phy_rx2.rx_ref_clk
set_interface_property rx2_serial_data     EXPORT_OF jesd204_phy_rx2.rx_serial_data
set_interface_property rx2_serial_data_n   EXPORT_OF jesd204_phy_rx2.rx_serial_data_n
set_interface_property rx2_tx_ref_clk      EXPORT_OF jesd204_phy_rx2.tx_ref_clk

add_connection mxfe_rx2_jesd204.link_sof mxfe_rx2_tpl.if_link_sof
add_connection mxfe_rx2_jesd204.link_data mxfe_rx2_tpl.link_data
for {set i 0} {$i < $RX2_NUM_OF_CONVERTERS} {incr i} {
  add_connection mxfe_rx2_tpl.adc_ch_$i mxfe_rx2_cpack.adc_ch_$i
}
add_connection mxfe_rx2_tpl.if_adc_dovf mxfe_rx2_cpack.if_fifo_wr_overflow
add_connection mxfe_rx2_cpack.if_packed_fifo_wr_en $adc_rx2_data_offload_name.if_src_fifo_wr_en
add_connection mxfe_rx2_cpack.if_packed_fifo_wr_data $adc_rx2_data_offload_name.if_src_fifo_wr_data
add_connection mxfe_rx2_dma.if_s_axis_xfer_req $adc_rx2_data_offload_name.init_req
add_connection $adc_rx2_data_offload_name.m_axis mxfe_rx2_dma.s_axis
ad_dma_interconnect mxfe_rx2_dma.m_dest_axi 0x0000000 $adc_rx2_dma_data_width

ad_cpu_interconnect 0x00000000 jesd204_phy_rx2.reconfig_avmm "avl_mm_bridge_1" 0x02000000 22
set_instance_parameter_value avl_mm_bridge_1 {MAX_PENDING_RESPONSES} {1}
add_connection sys_clk.clk jesd204_phy_rx2.reconfig_clk
add_connection sys_clk.clk_reset jesd204_phy_rx2.reconfig_reset

ad_cpu_interconnect 0x000B0000 mxfe_rx2_jesd204.link_reconfig
ad_cpu_interconnect 0x000B4000 mxfe_rx2_jesd204.link_management
ad_cpu_interconnect 0x000B8000 mxfe_rx2_tpl.s_axi
ad_cpu_interconnect 0x000BC000 mxfe_rx2_dma.s_axi
ad_cpu_interconnect 0x00120000 $adc_rx2_data_offload_name.s_axi

ad_cpu_interrupt  9  mxfe_rx2_jesd204.interrupt
ad_cpu_interrupt 12  mxfe_rx2_dma.interrupt_sender

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

add_instance sys_cpu_clk_bridge altera_clock_bridge
set_instance_parameter_value sys_cpu_clk_bridge {EXPLICIT_CLOCK_RATE} {100000000}
add_connection sys_clk.clk sys_cpu_clk_bridge.in_clk

add_interface sys_cpu_clk clock source
set_interface_property sys_cpu_clk EXPORT_OF sys_cpu_clk_bridge.out_clk

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

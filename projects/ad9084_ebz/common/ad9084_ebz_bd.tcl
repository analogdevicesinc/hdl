###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

if {![info exists ADI_PHY_SEL]} {
  set ADI_PHY_SEL 1
}

if {![info exists EXTERNAL_LINK_CLK]} {
  set EXTERNAL_LINK_CLK 0
}

source $ad_hdl_dir/projects/common/xilinx/data_offload_bd.tcl
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl
source $ad_hdl_dir/library/axi_fsrc/scripts/axi_fsrc.tcl

# Common parameter for TX and RX
set JESD_MODE  $ad_project_params(JESD_MODE)
set RX_LANE_RATE $ad_project_params(RX_LANE_RATE)
set TX_LANE_RATE $ad_project_params(TX_LANE_RATE)

if {$ASYMMETRIC_A_B_MODE} {
  set RX_B_LANE_RATE $ad_project_params(RX_B_LANE_RATE)
  set TX_B_LANE_RATE $ad_project_params(TX_B_LANE_RATE)
}

set HSCI_ENABLE [ expr { [info exists ad_project_params(HSCI_ENABLE)] \
                          ? $ad_project_params(HSCI_ENABLE) : 1 } ]
set SIDE_B_ONLY [ expr { [info exists ad_project_params(SIDE_B_ONLY)] \
                          ? $ad_project_params(SIDE_B_ONLY) : 0 } ]
set TDD_SUPPORT [ expr { [info exists ad_project_params(TDD_SUPPORT)] \
                          ? $ad_project_params(TDD_SUPPORT) : 0 } ]
set SHARED_DEVCLK [ expr { [info exists ad_project_params(SHARED_DEVCLK)] \
                          ? $ad_project_params(SHARED_DEVCLK) : 0 } ]
set DO_HAS_BYPASS [ expr { [info exists ad_project_params(DO_HAS_BYPASS)] \
                          ? $ad_project_params(DO_HAS_BYPASS) : 1 } ]

# AION clock/trigger distribution. When enabled, the adf4030 sources sysref and
# aligns the trigger pins onto its bsync grid instead of the FMC sysref input.
set AION_ENABLE [ expr { [info exists ad_project_params(AION_ENABLE)] \
                          ? $ad_project_params(AION_ENABLE) : 0 } ]

# Fractional sample rate conversion. Apollo marks the sample slots it does not
# use with a sentinel value, so RX has to delete those samples and compact what
# is left, and TX has to leave holes where Apollo will not read.
set FSRC_ENABLE [ expr { [info exists ad_project_params(FSRC_ENABLE)] \
                          ? $ad_project_params(FSRC_ENABLE) : 0 } ]
set FSRC_ACCUM_WIDTH [ expr { [info exists ad_project_params(FSRC_ACCUM_WIDTH)] \
                          ? $ad_project_params(FSRC_ACCUM_WIDTH) : 56 } ]

if {$SIDE_B_ONLY && $ASYMMETRIC_A_B_MODE} {
  error "ERROR: SIDE_B_ONLY and ASYMMETRIC_A_B_MODE cannot be both enabled!"
}

if {$TDD_SUPPORT && !$SHARED_DEVCLK} {
  error "ERROR: Cannot enable TDD support without shared deviceclocks!"
}

set adc_do_mem_type [ expr { [info exists ad_project_params(ADC_DO_MEM_TYPE)] \
                          ? $ad_project_params(ADC_DO_MEM_TYPE) : 0 } ]
set dac_do_mem_type [ expr { [info exists ad_project_params(DAC_DO_MEM_TYPE)] \
                          ? $ad_project_params(DAC_DO_MEM_TYPE) : 0 } ]

set do_axi_data_width [ expr { [info exists do_axi_data_width] \
                          ? $do_axi_data_width : 256 } ]

if {$JESD_MODE == "8B10B"} {
  set DATAPATH_WIDTH 4
  set NP12_DATAPATH_WIDTH 6
  set ENCODER_SEL 1
} else {
  set DATAPATH_WIDTH 8
  set NP12_DATAPATH_WIDTH 12
  set ENCODER_SEL 2
}

proc ad_next_pow2 {value} {
  set result 1
  while {$result < $value} {
    set result [expr $result * 2]
  }
  return $result
}

# These are max values specific to the board
set MAX_RX_LANES_PER_LINK 12
set MAX_TX_LANES_PER_LINK 12
set MAX_RX_LINKS [expr $ASYMMETRIC_A_B_MODE ? 1 : 2]
set MAX_TX_LINKS [expr $ASYMMETRIC_A_B_MODE ? 1 : 2]
set MAX_RX_LANES [expr $MAX_RX_LANES_PER_LINK*$MAX_RX_LINKS]
set MAX_TX_LANES [expr $MAX_TX_LANES_PER_LINK*$MAX_TX_LINKS]
set MAX_APOLLO_LANES 24

# RX parameters
set RX_NUM_LINKS $ad_project_params(RX_NUM_LINKS)
if {$ASYMMETRIC_A_B_MODE} {
  set RX_NUM_LINKS 1
}

# RX JESD parameter per link
set RX_JESD_M     $ad_project_params(RX_JESD_M)
set RX_JESD_L     $ad_project_params(RX_JESD_L)
set RX_JESD_S     $ad_project_params(RX_JESD_S)
set RX_JESD_NP    $ad_project_params(RX_JESD_NP)

set RX_NUM_OF_LANES      [expr $RX_JESD_L * $RX_NUM_LINKS]
set RX_NUM_OF_CONVERTERS [expr $RX_JESD_M * $RX_NUM_LINKS]
set RX_SAMPLES_PER_FRAME $RX_JESD_S
set RX_SAMPLE_WIDTH      $RX_JESD_NP

set RX_DMA_SAMPLE_WIDTH $RX_JESD_NP
if {$RX_DMA_SAMPLE_WIDTH == 12} {
  set RX_DMA_SAMPLE_WIDTH 16
}

set RX_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $RX_JESD_L $RX_JESD_M $RX_JESD_S $RX_JESD_NP]

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8* $RX_DATAPATH_WIDTH / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

# TX parameters
set TX_NUM_LINKS $ad_project_params(TX_NUM_LINKS)
if {$ASYMMETRIC_A_B_MODE} {
  set TX_NUM_LINKS 1
}

# TX JESD parameter per link
set TX_JESD_M     $ad_project_params(TX_JESD_M)
set TX_JESD_L     $ad_project_params(TX_JESD_L)
set TX_JESD_S     $ad_project_params(TX_JESD_S)
set TX_JESD_NP    $ad_project_params(TX_JESD_NP)

set TX_NUM_OF_LANES      [expr $TX_JESD_L * $TX_NUM_LINKS]
set TX_NUM_OF_CONVERTERS [expr $TX_JESD_M * $TX_NUM_LINKS]
set TX_SAMPLES_PER_FRAME $TX_JESD_S
set TX_SAMPLE_WIDTH      $TX_JESD_NP

set TX_DMA_SAMPLE_WIDTH $TX_JESD_NP
if {$TX_DMA_SAMPLE_WIDTH == 12} {
  set TX_DMA_SAMPLE_WIDTH 16
}

set TX_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $TX_JESD_L $TX_JESD_M $TX_JESD_S $TX_JESD_NP]

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8* $TX_DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

# The pack cores, the data offload and the DMA all need a power of two width.
# When the transport layer does not give one - JESD mode 77 carries 24 samples
# per channel per beat - a gearbox converts the rate instead of the width and
# the pack chain runs on its own clock. See the gearbox instantiations below.
set RX_PACK_SAMPLES_PER_CHANNEL [ad_next_pow2 $RX_SAMPLES_PER_CHANNEL]
set RX_GEARBOX [expr $RX_PACK_SAMPLES_PER_CHANNEL != $RX_SAMPLES_PER_CHANNEL]
set rx_pack_clk_net [expr {$RX_GEARBOX ? "rx_pack_clk" : "rx_device_clk"}]
set rx_pack_rstgen_net [expr {$RX_GEARBOX ? "rx_pack_rstgen" : "rx_device_clk_rstgen"}]

set TX_PACK_SAMPLES_PER_CHANNEL [ad_next_pow2 $TX_SAMPLES_PER_CHANNEL]
set TX_GEARBOX [expr $TX_PACK_SAMPLES_PER_CHANNEL != $TX_SAMPLES_PER_CHANNEL]

set adc_data_offload_name apollo_rx_data_offload
set adc_data_width [expr $RX_DMA_SAMPLE_WIDTH*$RX_NUM_OF_CONVERTERS*$RX_PACK_SAMPLES_PER_CHANNEL]
set adc_dma_data_width $adc_data_width
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS) / ($adc_data_width/$RX_DMA_SAMPLE_WIDTH))/log(2)))]

set dac_data_offload_name apollo_tx_data_offload
set dac_data_width [expr $TX_DMA_SAMPLE_WIDTH*$TX_NUM_OF_CONVERTERS*$TX_PACK_SAMPLES_PER_CHANNEL]
set dac_dma_data_width $dac_data_width
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS) / ($dac_data_width/$TX_DMA_SAMPLE_WIDTH))/log(2)))]

set num_quads_a [expr int(ceil(1.0 * $RX_NUM_OF_LANES / 4))]
set num_quads_b 0

if {$ASYMMETRIC_A_B_MODE} {
  # RX B Side JESD parameter per link
  set RX_B_JESD_M     $ad_project_params(RX_B_JESD_M)
  set RX_B_JESD_L     $ad_project_params(RX_B_JESD_L)
  set RX_B_JESD_S     $ad_project_params(RX_B_JESD_S)
  set RX_B_JESD_NP    $ad_project_params(RX_B_JESD_NP)

  set RX_B_NUM_OF_LANES      $RX_B_JESD_L
  set RX_B_NUM_OF_CONVERTERS $RX_B_JESD_M
  set RX_B_SAMPLES_PER_FRAME $RX_B_JESD_S
  set RX_B_SAMPLE_WIDTH      $RX_B_JESD_NP

  set RX_B_DMA_SAMPLE_WIDTH $RX_B_JESD_NP
  if {$RX_B_DMA_SAMPLE_WIDTH == 12} {
    set RX_B_DMA_SAMPLE_WIDTH 16
  }

  set RX_B_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $RX_B_JESD_L $RX_B_JESD_M $RX_B_JESD_S $RX_B_JESD_NP]

  set RX_B_SAMPLES_PER_CHANNEL [expr $RX_B_NUM_OF_LANES * 8 * $RX_B_DATAPATH_WIDTH / ($RX_B_NUM_OF_CONVERTERS * $RX_B_SAMPLE_WIDTH)]

  # TX B Side JESD parameter per link
  set TX_B_JESD_M     $ad_project_params(TX_B_JESD_M)
  set TX_B_JESD_L     $ad_project_params(TX_B_JESD_L)
  set TX_B_JESD_S     $ad_project_params(TX_B_JESD_S)
  set TX_B_JESD_NP    $ad_project_params(TX_B_JESD_NP)

  set TX_B_NUM_OF_LANES      $TX_B_JESD_L
  set TX_B_NUM_OF_CONVERTERS $TX_B_JESD_M
  set TX_B_SAMPLES_PER_FRAME $TX_B_JESD_S
  set TX_B_SAMPLE_WIDTH      $TX_B_JESD_NP

  set TX_B_DMA_SAMPLE_WIDTH $TX_B_JESD_NP
  if {$TX_B_DMA_SAMPLE_WIDTH == 12} {
    set TX_B_DMA_SAMPLE_WIDTH 16
  }

  set TX_B_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $TX_B_JESD_L $TX_B_JESD_M $TX_B_JESD_S $TX_B_JESD_NP]

  set TX_B_SAMPLES_PER_CHANNEL [expr $TX_B_NUM_OF_LANES * 8 * $TX_B_DATAPATH_WIDTH / ($TX_B_NUM_OF_CONVERTERS * $TX_B_SAMPLE_WIDTH)]

  set RX_B_PACK_SAMPLES_PER_CHANNEL [ad_next_pow2 $RX_B_SAMPLES_PER_CHANNEL]
  set RX_B_GEARBOX [expr $RX_B_PACK_SAMPLES_PER_CHANNEL != $RX_B_SAMPLES_PER_CHANNEL]
  set rx_b_pack_clk_net [expr {$RX_B_GEARBOX ? "rx_b_pack_clk" : "rx_b_device_clk"}]
  set rx_b_pack_rstgen_net [expr {$RX_B_GEARBOX ? "rx_b_pack_rstgen" : "rx_b_device_clk_rstgen"}]

  set TX_B_PACK_SAMPLES_PER_CHANNEL [ad_next_pow2 $TX_B_SAMPLES_PER_CHANNEL]
  set TX_B_GEARBOX [expr $TX_B_PACK_SAMPLES_PER_CHANNEL != $TX_B_SAMPLES_PER_CHANNEL]

  set adc_b_data_offload_name apollo_rx_b_data_offload
  set adc_b_data_width [expr $RX_B_DMA_SAMPLE_WIDTH*$RX_B_NUM_OF_CONVERTERS*$RX_B_PACK_SAMPLES_PER_CHANNEL]
  set adc_b_dma_data_width $adc_b_data_width
  set adc_b_fifo_address_width [expr int(ceil(log(($adc_b_fifo_samples_per_converter*$RX_B_NUM_OF_CONVERTERS) / ($adc_b_data_width/$RX_B_DMA_SAMPLE_WIDTH))/log(2)))]

  set dac_b_data_offload_name apollo_tx_b_data_offload
  set dac_b_data_width [expr $TX_B_DMA_SAMPLE_WIDTH*$TX_B_NUM_OF_CONVERTERS*$TX_B_PACK_SAMPLES_PER_CHANNEL]
  set dac_b_dma_data_width $dac_b_data_width
  set dac_b_fifo_address_width [expr int(ceil(log(($dac_b_fifo_samples_per_converter*$TX_B_NUM_OF_CONVERTERS) / ($dac_b_data_width/$TX_B_DMA_SAMPLE_WIDTH))/log(2)))]

  set num_quads_b [expr int(ceil(1.0 * $RX_B_NUM_OF_LANES / 4))]
}

set num_quads [expr $num_quads_a + $num_quads_b]

create_bd_port -dir I rx_device_clk
create_bd_port -dir I tx_device_clk
create_bd_port -dir I rx_b_device_clk
create_bd_port -dir I tx_b_device_clk

# These exist whether or not FSRC is enabled, so that one system_top fits both
# cases: a Verilog instantiation cannot leave a port out.
create_bd_port -dir I fsrc_sysref
create_bd_port -dir I fsrc_trig_in
create_bd_port -dir O -from 3 -to 0 fsrc_trig_out
create_bd_port -dir O -from 39 -to 0 fsrc_ctrl

# Same reasoning for the AION ports. One channel per trigger pin, so
# trig_channel is four wide rather than the three the AION branch used with all
# four pins tied to channel 0.
create_bd_port -dir IO adf4030_bsync_p
create_bd_port -dir IO adf4030_bsync_n
create_bd_port -dir I adf4030_clk
create_bd_port -dir I adf4030_trigger
create_bd_port -dir O adf4030_sysref
create_bd_port -dir O -from 3 -to 0 adf4030_trig_channel

##AXI_HSCI IP
if {$HSCI_ENABLE} {
  if {$ADI_PHY_SEL} {
    create_bd_port -dir O selectio_clk_in
    create_bd_port -dir O hsci_pll_reset
    create_bd_port -dir O -from 7 -to 0 hsci_menc_clk
    create_bd_port -dir O -from 7 -to 0 hsci_data_out
    create_bd_port -dir I -from 7 -to 0 hsci_data_in
    create_bd_port -dir I hsci_pclk
    create_bd_port -dir I hsci_rst_seq_done
    create_bd_port -dir I hsci_pll_locked
    create_bd_port -dir I hsci_vtc_rdy_bsc_tx
    create_bd_port -dir I hsci_dly_rdy_bsc_tx
    create_bd_port -dir I hsci_vtc_rdy_bsc_rx
    create_bd_port -dir I hsci_dly_rdy_bsc_rx

    ad_ip_instance axi_hsci axi_hsci_0
    ad_connect axi_hsci_0/hsci_miso_data hsci_data_in
    ad_connect axi_hsci_0/hsci_menc_clk hsci_menc_clk
    ad_connect axi_hsci_0/hsci_pclk hsci_pclk
    ad_connect axi_hsci_0/hsci_rst_seq_done hsci_rst_seq_done
    ad_connect axi_hsci_0/hsci_pll_locked hsci_pll_locked
    ad_connect axi_hsci_0/hsci_vtc_rdy_bsc_tx hsci_vtc_rdy_bsc_tx
    ad_connect axi_hsci_0/hsci_dly_rdy_bsc_tx hsci_dly_rdy_bsc_tx
    ad_connect axi_hsci_0/hsci_vtc_rdy_bsc_rx hsci_vtc_rdy_bsc_rx
    ad_connect axi_hsci_0/hsci_dly_rdy_bsc_rx hsci_dly_rdy_bsc_rx
    ad_connect hsci_data_out axi_hsci_0/hsci_mosi_data
    ad_connect hsci_pll_reset axi_hsci_0/hsci_pll_reset

    ad_ip_instance axi_clkgen axi_hsci_clkgen
    ad_ip_parameter axi_hsci_clkgen CONFIG.ID 1
    ad_ip_parameter axi_hsci_clkgen CONFIG.CLKIN_PERIOD 10
    ad_ip_parameter axi_hsci_clkgen CONFIG.VCO_DIV 1
    ad_ip_parameter axi_hsci_clkgen CONFIG.VCO_MUL 8
    ad_ip_parameter axi_hsci_clkgen CONFIG.CLK0_DIV 4

    ad_connect $sys_cpu_clk axi_hsci_clkgen/clk
    ad_connect selectio_clk_in axi_hsci_clkgen/clk_0
  } else {
    source ../common/versal_hsci_phy.tcl
    create_hsci_phy hsci_phy $HSCI_BANKS

    ad_ip_instance axi_hsci axi_hsci_0

    create_bd_port -dir O intf_rdy
    create_bd_port -dir O fifo_empty
    create_bd_port -dir O data_out_p
    create_bd_port -dir O data_out_n
    create_bd_port -dir O clk_out_p
    create_bd_port -dir O clk_out_n
    create_bd_port -dir O -from 7 -to 0 data_to_fabric
    create_bd_port -dir O -from 7 -to 0 hsci_data_out

    create_bd_port -dir I fifo_rd_en
    create_bd_port -dir I data_in_p
    create_bd_port -dir I data_in_n
    create_bd_port -dir I clk_in_p
    create_bd_port -dir I clk_in_n
    create_bd_port -dir I -from 7 -to 0 hsci_data_in
    create_bd_port -dir I -from 7 -to 0 data_from_fabric

    ad_connect axi_hsci_0/hsci_miso_data hsci_data_in
    ad_connect hsci_data_out axi_hsci_0/hsci_mosi_data

    ad_connect hsci_phy/data_from_fabric_data_out data_from_fabric
    ad_connect hsci_phy/data_from_fabric_clk_out axi_hsci_0/hsci_menc_clk

    ad_connect hsci_phy/fifo_rd_en fifo_rd_en
    ad_connect hsci_phy/data_in_p data_in_p
    ad_connect hsci_phy/data_in_n data_in_n
    ad_connect hsci_phy/clk_in_p clk_in_p
    ad_connect hsci_phy/clk_in_n clk_in_n
    ad_connect hsci_phy/bank0_pll_clkout0 hsci_phy/fifo_rd_clk
    ad_connect hsci_phy/bank0_pll_clkout0 axi_hsci_0/hsci_pclk
    ad_connect hsci_phy/bank0_pll_clkout0 hsci_phy/ctrl_clk
    ad_connect hsci_phy/en_vtc VCC
    ad_connect hsci_phy/t_data_out GND
    ad_connect hsci_phy/t_clk_out GND

    ad_ip_instance ilconcat hsci_pll_locked_concat [list \
     NUM_PORTS ${HSCI_BANKS} \
    ]
    ad_connect hsci_pll_locked_concat/In0  hsci_phy/bank0_pll_locked
    if {$HSCI_BANKS > 1} {
      ad_connect hsci_pll_locked_concat/In1  hsci_phy/bank1_pll_locked
    }

    ad_connect hsci_pll_locked_concat/dout axi_hsci_0/hsci_pll_locked

    ad_connect hsci_phy/phy_rdy axi_hsci_0/hsci_vtc_rdy_bsc_tx
    ad_connect hsci_phy/dly_rdy axi_hsci_0/hsci_dly_rdy_bsc_tx
    ad_connect hsci_phy/phy_rdy axi_hsci_0/hsci_vtc_rdy_bsc_rx
    ad_connect hsci_phy/dly_rdy axi_hsci_0/hsci_dly_rdy_bsc_rx
    ad_connect hsci_phy/intf_rdy axi_hsci_0/hsci_rst_seq_done

    ad_connect intf_rdy   hsci_phy/intf_rdy
    ad_connect fifo_empty hsci_phy/fifo_empty
    ad_connect data_to_fabric hsci_phy/data_to_fabric_data_in
    ad_connect data_out_p hsci_phy/data_out_p
    ad_connect data_out_n hsci_phy/data_out_n
    ad_connect clk_out_p hsci_phy/clk_out_p
    ad_connect clk_out_n hsci_phy/clk_out_n

    ad_ip_instance axi_clkgen axi_hsci_clkgen
    ad_ip_parameter axi_hsci_clkgen CONFIG.ID 1
    ad_ip_parameter axi_hsci_clkgen CONFIG.CLKIN_PERIOD 10
    ad_ip_parameter axi_hsci_clkgen CONFIG.VCO_DIV 1
    ad_ip_parameter axi_hsci_clkgen CONFIG.VCO_MUL 30
    ad_ip_parameter axi_hsci_clkgen CONFIG.CLK0_DIV 15

    ad_connect $sys_cpu_clk axi_hsci_clkgen/clk
    ad_connect axi_hsci_0/hsci_pll_reset hsci_phy/rst
    for {set i 0} {$i < $HSCI_BANKS} {incr i} {
      ad_connect axi_hsci_clkgen/clk_0 hsci_phy/bank${i}_pll_clkin
      ad_connect axi_hsci_0/hsci_pll_reset hsci_phy/bank${i}_pll_rst_pll
    }
  }
}

##AXI_ADF4030 IP
# The adf4030 recovers sysref from the AION bsync pair and re-times an incoming
# trigger request onto that same grid, so when it is present it, not the FMC
# sysref input, is the timing reference for the whole design.
#
# CHANNEL_COUNT is 4 rather than the 3 the AION branch used: there are four
# trigger pins here (trig_a[1:0] and trig_b[1:0]) and one channel per pin lets
# them fire independently, which is also what the FSRC sequencer's NUM_TRIG
# assumes.
if {$AION_ENABLE} {
  ad_ip_instance axi_adf4030 axi_adf4030_0
  ad_ip_parameter axi_adf4030_0 CONFIG.CHANNEL_COUNT 4

  ad_connect axi_adf4030_0/bsync_p adf4030_bsync_p
  ad_connect axi_adf4030_0/bsync_n adf4030_bsync_n
  ad_connect axi_adf4030_0/device_clk adf4030_clk
  if {!$FSRC_ENABLE} {
    # With FSRC the request comes from the sequencer instead; see below, where
    # that instance exists.
    ad_connect axi_adf4030_0/trigger adf4030_trigger
  }
  ad_connect axi_adf4030_0/sysref adf4030_sysref
  ad_connect axi_adf4030_0/trig_channel adf4030_trig_channel
} else {
  ad_connect GND adf4030_sysref
  ad_connect GND adf4030_trig_channel
}

# common xcvr
if {$ASYMMETRIC_A_B_MODE} {
  set MAX_RX_LANE_RATE [expr max($RX_LANE_RATE, $RX_B_LANE_RATE)]
  set MAX_TX_LANE_RATE [expr max($TX_LANE_RATE, $TX_B_LANE_RATE)]
} else {
  set MAX_RX_LANE_RATE $RX_LANE_RATE
  set MAX_TX_LANE_RATE $TX_LANE_RATE
}

if {$ADI_PHY_SEL} {
  ad_ip_instance util_adxcvr util_apollo_xcvr
  ad_ip_parameter util_apollo_xcvr CONFIG.CPLL_FBDIV_4_5 5
  ad_ip_parameter util_apollo_xcvr CONFIG.TX_NUM_OF_LANES $MAX_APOLLO_LANES
  ad_ip_parameter util_apollo_xcvr CONFIG.RX_NUM_OF_LANES $MAX_APOLLO_LANES
  ad_ip_parameter util_apollo_xcvr CONFIG.RX_OUT_DIV 1
  ad_ip_parameter util_apollo_xcvr CONFIG.LINK_MODE $ENCODER_SEL
  ad_ip_parameter util_apollo_xcvr CONFIG.RX_LANE_RATE $MAX_RX_LANE_RATE
  ad_ip_parameter util_apollo_xcvr CONFIG.TX_LANE_RATE $MAX_TX_LANE_RATE

  ad_ip_instance axi_adxcvr axi_apollo_rx_xcvr
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.ID 0
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.TX_OR_RX_N 0
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.QPLL_ENABLE 0
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.LPM_OR_DFE_N 1
  ad_ip_parameter axi_apollo_rx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0

  ad_ip_instance axi_adxcvr axi_apollo_tx_xcvr
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.ID 0
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.NUM_OF_LANES $TX_NUM_OF_LANES
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.TX_OR_RX_N 1
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.QPLL_ENABLE 1
  ad_ip_parameter axi_apollo_tx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0
} else {
  source $ad_hdl_dir/library/xilinx/scripts/versal_xcvr_subsystem.tcl

  # Reset gpios
  create_bd_port -dir O gt_powergood
  create_bd_port -dir I gt_reset
  create_bd_port -dir I gt_reset_rx_datapath
  create_bd_port -dir I gt_reset_rx_pll_and_datapath
  create_bd_port -dir I gt_reset_tx_datapath
  create_bd_port -dir I gt_reset_tx_pll_and_datapath
  create_bd_port -dir O rx_resetdone
  create_bd_port -dir O tx_resetdone

  create_bd_port -dir I gt_b_reset
  create_bd_port -dir I gt_b_reset_rx_datapath
  create_bd_port -dir I gt_b_reset_rx_pll_and_datapath
  create_bd_port -dir I gt_b_reset_tx_datapath
  create_bd_port -dir I gt_b_reset_tx_pll_and_datapath
  create_bd_port -dir O rx_b_resetdone
  create_bd_port -dir O tx_b_resetdone

  create_bd_port -dir I ref_clk_a
  create_bd_port -dir I ref_clk_b
  create_bd_port -dir I rx_sysref_0
  create_bd_port -dir I tx_sysref_0
  create_bd_port -dir I rx_sysref_12
  create_bd_port -dir I tx_sysref_12
  create_bd_port -dir O rx_sync_12
  create_bd_port -dir I tx_sync_12
  create_bd_port -dir O -from [expr $RX_NUM_LINKS - 1] -to 0 rx_sync_0
  create_bd_port -dir I -from [expr $RX_NUM_LINKS - 1] -to 0 tx_sync_0

  set REF_CLK_RATE $ad_project_params(REF_CLK_RATE)
  set CONSECUTIVE_QUAD_MODE [expr { $ASYMMETRIC_A_B_MODE == 1 ? true : false }]
  # instantiate versal phy
  create_versal_jesd_xcvr_subsystem jesd204_phy $JESD_MODE $RX_NUM_OF_LANES $TX_NUM_OF_LANES $MAX_RX_LANE_RATE $MAX_TX_LANE_RATE $REF_CLK_RATE $TRANSCEIVER_TYPE RXTX $CONSECUTIVE_QUAD_MODE $EXTERNAL_LINK_CLK
  # reset generator
  ad_ip_instance proc_sys_reset rx_device_clk_rstgen
  ad_connect rx_device_clk rx_device_clk_rstgen/slowest_sync_clk
  ad_connect $sys_cpu_resetn rx_device_clk_rstgen/ext_reset_in

  ad_ip_instance proc_sys_reset tx_device_clk_rstgen
  ad_connect tx_device_clk tx_device_clk_rstgen/slowest_sync_clk
  ad_connect $sys_cpu_resetn tx_device_clk_rstgen/ext_reset_in

  ad_connect gt_reset jesd204_phy/gtreset_in
  ad_connect gt_reset_rx_datapath jesd204_phy/gtreset_rx_datapath
  ad_connect gt_reset_rx_pll_and_datapath jesd204_phy/gtreset_rx_pll_and_datapath
  ad_connect gt_reset_tx_datapath jesd204_phy/gtreset_tx_datapath
  ad_connect gt_reset_tx_pll_and_datapath jesd204_phy/gtreset_tx_pll_and_datapath
  ad_connect rx_resetdone jesd204_phy/rx_resetdone
  ad_connect tx_resetdone jesd204_phy/tx_resetdone

  # gt powergood
  ad_ip_instance ilconcat gt_powergood_concat [list \
   NUM_PORTS 2 \
  ]
  ad_ip_instance ilreduced_logic gt_powergood_and [list \
     C_SIZE 2 \
  ]
  ad_connect jesd204_phy/gtpowergood gt_powergood_concat/In0
  if {!$ASYMMETRIC_A_B_MODE} {
    ad_connect VCC gt_powergood_concat/In1
  }
  ad_connect gt_powergood_concat/dout gt_powergood_and/Op1
  ad_connect gt_powergood_and/Res gt_powergood
}

if {$ASYMMETRIC_A_B_MODE} {
  if ($ADI_PHY_SEL) {
    ad_ip_instance axi_adxcvr axi_apollo_rx_b_xcvr
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.ID 0
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.LINK_MODE $ENCODER_SEL
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.NUM_OF_LANES $RX_B_NUM_OF_LANES
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.TX_OR_RX_N 0
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.QPLL_ENABLE 0
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.LPM_OR_DFE_N 1
    ad_ip_parameter axi_apollo_rx_b_xcvr CONFIG.SYS_CLK_SEL 0x2 ; # QPLL1

    ad_ip_instance axi_adxcvr axi_apollo_tx_b_xcvr
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.ID 0
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.LINK_MODE $ENCODER_SEL
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.NUM_OF_LANES $TX_B_NUM_OF_LANES
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.TX_OR_RX_N 1
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.QPLL_ENABLE 1
    ad_ip_parameter axi_apollo_tx_b_xcvr CONFIG.SYS_CLK_SEL 0x2 ; # QPLL1
  } else {
    # instantiate versal phy
    create_versal_jesd_xcvr_subsystem jesd204_phy_b $JESD_MODE $RX_B_NUM_OF_LANES $TX_B_NUM_OF_LANES $MAX_RX_LANE_RATE $MAX_TX_LANE_RATE $REF_CLK_RATE $TRANSCEIVER_TYPE RXTX $CONSECUTIVE_QUAD_MODE $EXTERNAL_LINK_CLK

    ad_connect gt_b_reset jesd204_phy_b/gtreset_in
    ad_connect gt_b_reset_rx_datapath jesd204_phy_b/gtreset_rx_datapath
    ad_connect gt_b_reset_rx_pll_and_datapath jesd204_phy_b/gtreset_rx_pll_and_datapath
    ad_connect gt_b_reset_tx_datapath jesd204_phy_b/gtreset_tx_datapath
    ad_connect gt_b_reset_tx_pll_and_datapath jesd204_phy_b/gtreset_tx_pll_and_datapath
    ad_connect rx_b_resetdone jesd204_phy_b/rx_resetdone
    ad_connect tx_b_resetdone jesd204_phy_b/tx_resetdone

    ad_connect jesd204_phy_b/gtpowergood gt_powergood_concat/In1
    # reset generator
    ad_ip_instance proc_sys_reset rx_b_device_clk_rstgen
    ad_connect rx_b_device_clk rx_b_device_clk_rstgen/slowest_sync_clk
    ad_connect $sys_cpu_resetn rx_b_device_clk_rstgen/ext_reset_in

    ad_ip_instance proc_sys_reset tx_b_device_clk_rstgen
    ad_connect tx_b_device_clk tx_b_device_clk_rstgen/slowest_sync_clk
    ad_connect $sys_cpu_resetn tx_b_device_clk_rstgen/ext_reset_in
  }
}

# adc peripherals

adi_axi_jesd204_rx_create axi_apollo_rx_jesd $RX_NUM_OF_LANES $RX_NUM_LINKS $ENCODER_SEL
ad_ip_parameter axi_apollo_rx_jesd/rx CONFIG.TPL_DATA_PATH_WIDTH $RX_DATAPATH_WIDTH

ad_ip_parameter axi_apollo_rx_jesd/rx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_apollo_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 1

adi_tpl_jesd204_rx_create rx_apollo_tpl_core $RX_NUM_OF_LANES \
                                           $RX_NUM_OF_CONVERTERS \
                                           $RX_SAMPLES_PER_FRAME \
                                           $RX_SAMPLE_WIDTH \
                                           $RX_DATAPATH_WIDTH \
                                           $RX_DMA_SAMPLE_WIDTH

ad_ip_instance util_cpack2 util_apollo_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_DMA_SAMPLE_WIDTH \
]

set adc_data_offload_size [expr $adc_data_width / 8 * 2**$adc_fifo_address_width]
ad_data_offload_create $adc_data_offload_name \
                       0 \
                       $adc_do_mem_type \
                       $adc_data_offload_size \
                       $adc_data_width \
                       $adc_data_width \
                       $do_axi_data_width \
                       $SHARED_DEVCLK

ad_ip_parameter $adc_data_offload_name/i_data_offload CONFIG.HAS_BYPASS $DO_HAS_BYPASS

ad_ip_instance axi_dmac axi_apollo_rx_dma
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_apollo_rx_dma CONFIG.ID 0
ad_ip_parameter axi_apollo_rx_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_apollo_rx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_apollo_rx_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_apollo_rx_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_apollo_rx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_data_width
if {$ADI_PHY_SEL} {
  ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_DATA_WIDTH_DEST [expr min(1024, $adc_data_width)]
} else {
  # Versal limitation
  ad_ip_parameter axi_apollo_rx_dma CONFIG.DMA_DATA_WIDTH_DEST [expr min(512, $adc_data_width)]
}

if {$ASYMMETRIC_A_B_MODE} {
  adi_axi_jesd204_rx_create axi_apollo_rx_b_jesd $RX_B_NUM_OF_LANES $RX_NUM_LINKS $ENCODER_SEL
  ad_ip_parameter axi_apollo_rx_b_jesd/rx CONFIG.TPL_DATA_PATH_WIDTH $RX_B_DATAPATH_WIDTH

  ad_ip_parameter axi_apollo_rx_b_jesd/rx CONFIG.SYSREF_IOB false
  ad_ip_parameter axi_apollo_rx_b_jesd/rx CONFIG.NUM_INPUT_PIPELINE 1

  adi_tpl_jesd204_rx_create rx_b_apollo_tpl_core $RX_B_NUM_OF_LANES \
                                                 $RX_B_NUM_OF_CONVERTERS \
                                                 $RX_B_SAMPLES_PER_FRAME \
                                                 $RX_B_SAMPLE_WIDTH \
                                                 $RX_B_DATAPATH_WIDTH \
                                                 $RX_B_DMA_SAMPLE_WIDTH

  ad_ip_instance util_cpack2 util_apollo_cpack_b [list \
    NUM_OF_CHANNELS $RX_B_NUM_OF_CONVERTERS \
    SAMPLES_PER_CHANNEL $RX_B_SAMPLES_PER_CHANNEL \
    SAMPLE_DATA_WIDTH $RX_B_DMA_SAMPLE_WIDTH \
  ]

  set adc_b_data_offload_size [expr $adc_b_data_width / 8 * 2**$adc_b_fifo_address_width]
  ad_data_offload_create $adc_b_data_offload_name \
                         0 \
                         $adc_do_mem_type \
                         $adc_b_data_offload_size \
                         $adc_b_data_width \
                         $adc_b_data_width \
                         $do_axi_data_width \
                         $SHARED_DEVCLK

  ad_ip_parameter $adc_b_data_offload_name/i_data_offload CONFIG.HAS_BYPASS $DO_HAS_BYPASS

  ad_ip_instance axi_dmac axi_apollo_rx_b_dma
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_TYPE_SRC 1
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_TYPE_DEST 0
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.ID 0
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.AXI_SLICE_SRC 1
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.AXI_SLICE_DEST 1
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.SYNC_TRANSFER_START 0
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_LENGTH_WIDTH 24
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_2D_TRANSFER 0
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.MAX_BYTES_PER_BURST 4096
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.CYCLIC 0
  ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_b_data_width
  if {$ADI_PHY_SEL} {
    ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_DATA_WIDTH_DEST $adc_b_data_width
  } else {
  # Versal limitation
    ad_ip_parameter axi_apollo_rx_b_dma CONFIG.DMA_DATA_WIDTH_DEST [expr min(512, $adc_b_data_width)]
  }
}

# dac peripherals

adi_axi_jesd204_tx_create axi_apollo_tx_jesd $TX_NUM_OF_LANES $TX_NUM_LINKS $ENCODER_SEL
ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.TPL_DATA_PATH_WIDTH $TX_DATAPATH_WIDTH

ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.SYSREF_IOB false
#ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1

adi_tpl_jesd204_tx_create tx_apollo_tpl_core $TX_NUM_OF_LANES \
                                             $TX_NUM_OF_CONVERTERS \
                                             $TX_SAMPLES_PER_FRAME \
                                             $TX_SAMPLE_WIDTH \
                                             $TX_DATAPATH_WIDTH \
                                             $TX_DMA_SAMPLE_WIDTH

ad_ip_parameter tx_apollo_tpl_core/dac_tpl_core CONFIG.IQCORRECTION_DISABLE 0

ad_ip_instance util_upack2 util_apollo_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_DMA_SAMPLE_WIDTH \
]

set dac_data_offload_size [expr $dac_data_width / 8 * 2**$dac_fifo_address_width]
ad_data_offload_create $dac_data_offload_name \
                       1 \
                       $dac_do_mem_type \
                       $dac_data_offload_size \
                       $dac_data_width \
                       $dac_data_width \
                       $do_axi_data_width \
                       $SHARED_DEVCLK

ad_ip_parameter $dac_data_offload_name/i_data_offload CONFIG.HAS_BYPASS $DO_HAS_BYPASS

ad_ip_instance axi_dmac axi_apollo_tx_dma
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_apollo_tx_dma CONFIG.ID 0
ad_ip_parameter axi_apollo_tx_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_apollo_tx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_apollo_tx_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_apollo_tx_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_apollo_tx_dma CONFIG.MAX_BYTES_PER_BURST 4096
if {$ADI_PHY_SEL} {
  ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_DATA_WIDTH_SRC [expr min(1024, $dac_data_width)]
} else {
  # Versal limitation
  ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_DATA_WIDTH_SRC [expr min(512, $dac_data_width)]
}
ad_ip_parameter axi_apollo_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_data_width

if {$ASYMMETRIC_A_B_MODE} {
  adi_axi_jesd204_tx_create axi_apollo_tx_b_jesd $TX_B_NUM_OF_LANES $TX_NUM_LINKS $ENCODER_SEL
  ad_ip_parameter axi_apollo_tx_b_jesd/tx CONFIG.TPL_DATA_PATH_WIDTH $TX_B_DATAPATH_WIDTH

  ad_ip_parameter axi_apollo_tx_b_jesd/tx CONFIG.SYSREF_IOB false
  #ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1

  adi_tpl_jesd204_tx_create tx_b_apollo_tpl_core $TX_B_NUM_OF_LANES \
                                                 $TX_B_NUM_OF_CONVERTERS \
                                                 $TX_B_SAMPLES_PER_FRAME \
                                                 $TX_B_SAMPLE_WIDTH \
                                                 $TX_B_DATAPATH_WIDTH \
                                                 $TX_B_DMA_SAMPLE_WIDTH

  ad_ip_parameter tx_b_apollo_tpl_core/dac_tpl_core CONFIG.IQCORRECTION_DISABLE 0

  ad_ip_instance util_upack2 util_apollo_upack_b [list \
    NUM_OF_CHANNELS $TX_B_NUM_OF_CONVERTERS \
    SAMPLES_PER_CHANNEL $TX_B_SAMPLES_PER_CHANNEL \
    SAMPLE_DATA_WIDTH $TX_B_DMA_SAMPLE_WIDTH \
  ]

  set dac_b_data_offload_size [expr $dac_b_data_width / 8 * 2**$dac_b_fifo_address_width]
  ad_data_offload_create $dac_b_data_offload_name \
                         1 \
                         $dac_do_mem_type \
                         $dac_b_data_offload_size \
                         $dac_b_data_width \
                         $dac_b_data_width \
                         $do_axi_data_width \
                         $SHARED_DEVCLK

  ad_ip_parameter $dac_b_data_offload_name/i_data_offload CONFIG.HAS_BYPASS $DO_HAS_BYPASS

  ad_ip_instance axi_dmac axi_apollo_tx_b_dma
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_TYPE_SRC 0
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_TYPE_DEST 1
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.ID 0
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.AXI_SLICE_SRC 1
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.AXI_SLICE_DEST 1
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.SYNC_TRANSFER_START 0
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_LENGTH_WIDTH 24
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_2D_TRANSFER 0
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.CYCLIC 1
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.MAX_BYTES_PER_BURST 4096
  if {$ADI_PHY_SEL} {
    ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_DATA_WIDTH_SRC $dac_b_data_width
  } else {
    # Versal limitation
    ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_DATA_WIDTH_SRC [expr min(512, $dac_b_data_width)]
  }
  ad_ip_parameter axi_apollo_tx_b_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_b_data_width
}

# reference clocks & resets

if {$ADI_PHY_SEL} {
  for {set i 0} {$i < $MAX_APOLLO_LANES} {incr i} {
    set quad_index [expr int($i / 4)]
    if {[expr $i % 4] == 0} {
      create_bd_port -dir I ref_clk_q$quad_index
      ad_xcvrpll  ref_clk_q$quad_index  util_apollo_xcvr/qpll_ref_clk_$i
    }
    ad_xcvrpll  ref_clk_q$quad_index  util_apollo_xcvr/cpll_ref_clk_$i
  }

  for {set i 0} {$i < [expr max($MAX_TX_LANES,$MAX_RX_LANES)]} {incr i} {
    set j [expr $i + [expr max($MAX_TX_LANES,$MAX_RX_LANES)]]
    ad_xcvrpll  axi_apollo_tx_xcvr/up_pll_rst util_apollo_xcvr/up_qpll_rst_${i}
    ad_xcvrpll  axi_apollo_rx_xcvr/up_pll_rst util_apollo_xcvr/up_cpll_rst_${i}
    ad_xcvrpll  axi_apollo_tx_b_xcvr/up_pll_rst util_apollo_xcvr/up_qpll_rst_${j}
    ad_xcvrpll  axi_apollo_rx_b_xcvr/up_pll_rst util_apollo_xcvr/up_cpll_rst_${j}
  }

  ad_connect  $sys_cpu_resetn util_apollo_xcvr/up_rstn
  ad_connect  $sys_cpu_clk util_apollo_xcvr/up_clk
} else {
  ad_connect ref_clk_a jesd204_phy/GT_REFCLK

  for {set j 0} {$j < $RX_NUM_OF_LANES} {incr j} {
    ad_connect axi_apollo_rx_jesd/rx_phy${j} jesd204_phy/rx${j}
    ad_connect axi_apollo_tx_jesd/tx_phy${j} jesd204_phy/tx${j}
  }

  ad_connect jesd204_phy/rxusrclk_out /axi_apollo_rx_jesd/link_clk
  ad_connect rx_device_clk /axi_apollo_rx_jesd/device_clk

  ad_connect jesd204_phy/txusrclk_out /axi_apollo_tx_jesd/link_clk
  ad_connect tx_device_clk /axi_apollo_tx_jesd/device_clk

  ad_connect axi_apollo_rx_jesd/sysref rx_sysref_0
  ad_connect axi_apollo_tx_jesd/sysref tx_sysref_0

  ad_connect $sys_cpu_clk jesd204_phy/s_axi_clk
  ad_connect $sys_cpu_resetn jesd204_phy/s_axi_resetn

  if {$JESD_MODE == "8B10B"} {
    ad_connect axi_apollo_rx_jesd/phy_en_char_align jesd204_phy/en_char_align
    ad_connect axi_apollo_rx_jesd/sync rx_sync_0
    ad_connect axi_apollo_tx_jesd/sync tx_sync_0
  }

  if {$ASYMMETRIC_A_B_MODE} {
    ad_connect ref_clk_b jesd204_phy_b/GT_REFCLK

    for {set j 0} {$j < $RX_B_NUM_OF_LANES} {incr j} {
      ad_connect axi_apollo_rx_b_jesd/rx_phy${j} jesd204_phy_b/rx${j}
      ad_connect axi_apollo_tx_b_jesd/tx_phy${j} jesd204_phy_b/tx${j}
    }

    ad_connect jesd204_phy_b/rxusrclk_out /axi_apollo_rx_b_jesd/link_clk
    ad_connect rx_b_device_clk /axi_apollo_rx_b_jesd/device_clk

    ad_connect jesd204_phy_b/txusrclk_out /axi_apollo_tx_b_jesd/link_clk
    ad_connect tx_b_device_clk /axi_apollo_tx_b_jesd/device_clk

    ad_connect axi_apollo_rx_b_jesd/sysref rx_sysref_12
    ad_connect axi_apollo_tx_b_jesd/sysref tx_sysref_12

    ad_connect $sys_cpu_clk jesd204_phy_b/s_axi_clk
    ad_connect $sys_cpu_resetn jesd204_phy_b/s_axi_resetn
    if {$JESD_MODE == "8B10B"} {
    ad_connect axi_apollo_rx_b_jesd/phy_en_char_align jesd204_phy_b/en_char_align
    ad_connect axi_apollo_rx_b_jesd/sync rx_sync_12
    ad_connect axi_apollo_tx_b_jesd/sync tx_sync_0
    }
  }

  # Export serial interfaces
  for {set j 0} {$j < $MAX_NUMBER_OF_QUADS} {incr j} {
    create_bd_port -dir I -from 3 -to 0 rx_${j}_p
    create_bd_port -dir I -from 3 -to 0 rx_${j}_n
    create_bd_port -dir O -from 3 -to 0 tx_${j}_p
    create_bd_port -dir O -from 3 -to 0 tx_${j}_n
  }

  if {!$SIDE_B_ONLY} {
    if {!$ASYMMETRIC_A_B_MODE} {
      set half_lanes [expr max($RX_NUM_OF_LANES, $TX_NUM_OF_LANES) / 2]
      set half_quads [expr int(ceil($half_lanes / 4.0))]
      for {set j 0} {$j < $half_quads} {incr j} {
        set jj [expr $j + 1]
        ad_connect rx_${j}_p jesd204_phy/rx_${j}_p
        ad_connect rx_${j}_n jesd204_phy/rx_${j}_n
        ad_connect tx_${j}_p jesd204_phy/tx_${j}_p
        ad_connect tx_${j}_n jesd204_phy/tx_${j}_n

        ad_connect rx_${jj}_p jesd204_phy/rx_${jj}_p
        ad_connect rx_${jj}_n jesd204_phy/rx_${jj}_n
        ad_connect tx_${jj}_p jesd204_phy/tx_${jj}_p
        ad_connect tx_${jj}_n jesd204_phy/tx_${jj}_n
      }
    } else {
      for {set j 0} {$j < $num_quads_a} {incr j} {
        ad_connect rx_${j}_p jesd204_phy/rx_${j}_p
        ad_connect rx_${j}_n jesd204_phy/rx_${j}_n
        ad_connect tx_${j}_p jesd204_phy/tx_${j}_p
        ad_connect tx_${j}_n jesd204_phy/tx_${j}_n
      }
      for {set j $num_quads_a} {$j < $num_quads} {incr j} {
        set jj [expr $j - $num_quads_a]
        ad_connect rx_${j}_p jesd204_phy_b/rx_${jj}_p
        ad_connect rx_${j}_n jesd204_phy_b/rx_${jj}_n
        ad_connect tx_${j}_p jesd204_phy_b/tx_${jj}_p
        ad_connect tx_${j}_n jesd204_phy_b/tx_${jj}_n
      }
    }
  } else {
    # Map the serial lanes to side B only
    for {set j 0} {$j < $num_quads} {incr j} {
      set idx [expr $j + 1]
      ad_connect rx_${idx}_p jesd204_phy/rx_${j}_p
      ad_connect rx_${idx}_n jesd204_phy/rx_${j}_n
      ad_connect tx_${idx}_p jesd204_phy/tx_${j}_p
      ad_connect tx_${idx}_n jesd204_phy/tx_${j}_n
    }
  }
}

# connections (adc)
#  map the logical lane $n onto the physical lane  $lane_map[$n]
#         n     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
#  lane_map = {11  2  3  5 10  1  9  0  6  7  8  4 15 21 17 16 14 18 13 19 20 23 12 22}
#

if {$ASYMMETRIC_A_B_MODE} {
  if {$ADI_PHY_SEL} {
    # set lane_map {11 2 3 5 10 1 9 0 6 7 8 4}
    ad_xcvrcon  util_apollo_xcvr axi_apollo_rx_xcvr axi_apollo_rx_jesd {0 1 2 3 4 5 6 7 8 9 10 11} {} rx_device_clk $MAX_RX_LANES

    # set lane_map {15 21 17 16 14 18 13 19 20 23 12 22}
    ad_xcvrcon  util_apollo_xcvr axi_apollo_rx_b_xcvr axi_apollo_rx_b_jesd {12 13 14 15 16 17 18 19 20 21 22 23} {} rx_b_device_clk $MAX_RX_LANES
  }
} else {
  set max_lane_map {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23}
  set lane_map {}

  for {set i 0}  {$i < $RX_NUM_LINKS} {incr i} {
    for {set j 0}  {$j < $RX_JESD_L} {incr j} {
      set cur_lane [expr $i*$MAX_RX_LANES_PER_LINK+$j]
      lappend lane_map [lindex $max_lane_map $cur_lane]
    }
  }

  # The unused lanes of every physical link have to end up in the map as well,
  # including the links this configuration does not use at all, otherwise the
  # map is shorter than MAX_RX_LANES and ad_xcvrcon connects nothing for the
  # lanes past its end.
  for {set i 0}  {$i < $MAX_RX_LINKS} {incr i} {
    set first_unused [expr {$i < $RX_NUM_LINKS ? $RX_JESD_L : 0}]
    for {set j $first_unused}  {$j < $MAX_RX_LANES_PER_LINK} {incr j} {
      set cur_lane [expr $i*$MAX_RX_LANES_PER_LINK+$j]
      lappend lane_map [lindex $max_lane_map $cur_lane]
    }
  }

  if {$ADI_PHY_SEL} {
    ad_xcvrcon  util_apollo_xcvr axi_apollo_rx_xcvr axi_apollo_rx_jesd $lane_map {} rx_device_clk $MAX_RX_LANES
    create_bd_port -dir I rx_sysref_12
    create_bd_port -dir O rx_sync_12
  }
}

# connections (dac)
#  map the logical lane $n onto the physical lane  $lane_map[$n]
#         n     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
#  lane_map = {11  5 10  6  8  4  9  7  1  2  0  3 15 16 14 19 12 20 13 17 21 22 18 23}
#

if {$ASYMMETRIC_A_B_MODE} {
  if {$ADI_PHY_SEL} {
    # set lane_map {11 5 10 6 8 4 9 7 1 2 0 3}
    ad_xcvrcon  util_apollo_xcvr axi_apollo_tx_xcvr axi_apollo_tx_jesd {0 1 2 3 4 5 6 7 8 9 10 11} {} tx_device_clk $MAX_TX_LANES

    # set lane_map {15 16 14 19 12 20 13 17 21 22 18 23}
    ad_xcvrcon  util_apollo_xcvr axi_apollo_tx_b_xcvr axi_apollo_tx_b_jesd {12 13 14 15 16 17 18 19 20 21 22 23} {} tx_b_device_clk $MAX_TX_LANES
  }
} else {
  set max_lane_map {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23}
  set lane_map {}

 for {set i 0}  {$i < $TX_NUM_LINKS} {incr i} {
    for {set j 0}  {$j < $TX_JESD_L} {incr j} {
      set cur_lane [expr $i*$MAX_TX_LANES_PER_LINK+$j]
      lappend lane_map [lindex $max_lane_map $cur_lane]
    }
  }

  # The unused lanes of every physical link have to end up in the map as well,
  # including the links this configuration does not use at all, otherwise the
  # map is shorter than MAX_TX_LANES and ad_xcvrcon connects nothing for the
  # lanes past its end.
  for {set i 0}  {$i < $MAX_TX_LINKS} {incr i} {
    set first_unused [expr {$i < $TX_NUM_LINKS ? $TX_JESD_L : 0}]
    for {set j $first_unused}  {$j < $MAX_TX_LANES_PER_LINK} {incr j} {
      set cur_lane [expr $i*$MAX_TX_LANES_PER_LINK+$j]
      lappend lane_map [lindex $max_lane_map $cur_lane]
    }
  }

  if {$ADI_PHY_SEL} {
    ad_xcvrcon  util_apollo_xcvr axi_apollo_tx_xcvr axi_apollo_tx_jesd $lane_map {} tx_device_clk $MAX_TX_LANES

    if {$TX_JESD_L == 8} {
      delete_bd_objs [get_bd_intf_nets axi_apollo_tx_xcvr_up_cm_8]
      delete_bd_objs [get_bd_intf_nets axi_apollo_tx_xcvr_up_cm_12]
      connect_bd_intf_net [get_bd_intf_pins axi_apollo_tx_xcvr/up_cm_8] [get_bd_intf_pins util_apollo_xcvr/up_cm_12]
      connect_bd_intf_net [get_bd_intf_pins axi_apollo_tx_xcvr/up_cm_12] [get_bd_intf_pins util_apollo_xcvr/up_cm_16]
    } elseif {$TX_JESD_L == 4} {
      delete_bd_objs [get_bd_intf_nets axi_apollo_tx_xcvr_up_cm_4]
      connect_bd_intf_net [get_bd_intf_pins axi_apollo_tx_xcvr/up_cm_4] [get_bd_intf_pins util_apollo_xcvr/up_cm_12]
    }
    create_bd_port -dir I tx_sysref_12
    create_bd_port -dir I tx_sync_12
  }
}

# The pack chain runs slower than the device clock by exactly the gearbox width
# ratio, so the narrow beat at the device rate and the wide beat here carry the
# same bits per second. Each side gets its own MMCM fed from its own device
# clock: the two must stay frequency-locked or the async FIFO between them
# drifts into overflow, and ASYMMETRIC_A_B_MODE allows the two sides to run at
# different lane rates.
proc ad_pack_clkgen_create {name device_clk resetn lane_rate jesd_mode samples
                            pack_samples versal} {
  set divisor [expr {$jesd_mode == "8B10B" ? 40 : 66}]
  set device_freq [expr $lane_rate * 1000.0 / $divisor]
  set pack_freq [expr $device_freq * $samples / double($pack_samples)]

  if {$versal} {
    # clk_wiz is not available for Versal parts.
    ad_ip_instance clk_wizard ${name}_clkgen
    ad_ip_parameter ${name}_clkgen CONFIG.PRIMITIVE_TYPE {MMCM}
    ad_ip_parameter ${name}_clkgen CONFIG.PRIM_SOURCE {No_buffer}
    ad_ip_parameter ${name}_clkgen CONFIG.RESET_TYPE ACTIVE_LOW
    ad_ip_parameter ${name}_clkgen CONFIG.USE_LOCKED {false}
    ad_ip_parameter ${name}_clkgen CONFIG.JITTER_SEL {Min_O_Jitter}
    ad_ip_parameter ${name}_clkgen CONFIG.PRIM_IN_FREQ $device_freq
    ad_ip_parameter ${name}_clkgen CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY $pack_freq
  } else {
    ad_ip_instance clk_wiz ${name}_clkgen
    ad_ip_parameter ${name}_clkgen CONFIG.PRIMITIVE MMCM
    ad_ip_parameter ${name}_clkgen CONFIG.PRIM_SOURCE No_buffer
    ad_ip_parameter ${name}_clkgen CONFIG.RESET_TYPE ACTIVE_LOW
    ad_ip_parameter ${name}_clkgen CONFIG.USE_LOCKED false
    ad_ip_parameter ${name}_clkgen CONFIG.PRIM_IN_FREQ $device_freq
    ad_ip_parameter ${name}_clkgen CONFIG.CLKOUT1_REQUESTED_OUT_FREQ $pack_freq
  }

  ad_connect $device_clk ${name}_clkgen/clk_in1
  ad_connect $resetn ${name}_clkgen/resetn
  ad_connect ${name}_clk ${name}_clkgen/clk_out1

  ad_ip_instance proc_sys_reset ${name}_rstgen
  ad_connect ${name}_clk ${name}_rstgen/slowest_sync_clk
  ad_connect $resetn ${name}_rstgen/ext_reset_in
}

set VERSAL [expr $ADI_PHY_SEL == 0]

if {$RX_GEARBOX} {
  ad_pack_clkgen_create rx_pack rx_device_clk $sys_cpu_resetn $RX_LANE_RATE \
    $JESD_MODE $RX_SAMPLES_PER_CHANNEL $RX_PACK_SAMPLES_PER_CHANNEL $VERSAL
}
if {$ASYMMETRIC_A_B_MODE && $RX_B_GEARBOX} {
  ad_pack_clkgen_create rx_b_pack rx_b_device_clk $sys_cpu_resetn $RX_B_LANE_RATE \
    $JESD_MODE $RX_B_SAMPLES_PER_CHANNEL $RX_B_PACK_SAMPLES_PER_CHANNEL $VERSAL
}

# device clock domain
ad_connect  rx_device_clk rx_apollo_tpl_core/link_clk
ad_connect  $rx_pack_clk_net util_apollo_cpack/clk
ad_connect  $rx_pack_clk_net $adc_data_offload_name/s_axis_aclk

ad_connect  tx_device_clk tx_apollo_tpl_core/link_clk
ad_connect  tx_device_clk util_apollo_upack/clk
ad_connect  tx_device_clk $dac_data_offload_name/m_axis_aclk

if {$ASYMMETRIC_A_B_MODE} {
  ad_connect  rx_b_device_clk rx_b_apollo_tpl_core/link_clk
  ad_connect  $rx_b_pack_clk_net util_apollo_cpack_b/clk
  ad_connect  $rx_b_pack_clk_net $adc_b_data_offload_name/s_axis_aclk

  ad_connect  tx_b_device_clk tx_b_apollo_tpl_core/link_clk
  ad_connect  tx_b_device_clk util_apollo_upack_b/clk
  ad_connect  tx_b_device_clk $dac_b_data_offload_name/m_axis_aclk
}

# Clocks
ad_connect  $sys_dma_clk $adc_data_offload_name/m_axis_aclk
ad_connect  $sys_dma_clk $dac_data_offload_name/s_axis_aclk

ad_connect  $sys_dma_clk axi_apollo_rx_dma/s_axis_aclk
ad_connect  $sys_dma_clk axi_apollo_tx_dma/m_axis_aclk
ad_connect  $sys_cpu_clk $dac_data_offload_name/s_axi_aclk
ad_connect  $sys_cpu_clk $adc_data_offload_name/s_axi_aclk

if {$ASYMMETRIC_A_B_MODE} {
  ad_connect  $sys_dma_clk $adc_b_data_offload_name/m_axis_aclk
  ad_connect  $sys_dma_clk $dac_b_data_offload_name/s_axis_aclk

  ad_connect  $sys_dma_clk axi_apollo_rx_b_dma/s_axis_aclk
  ad_connect  $sys_dma_clk axi_apollo_tx_b_dma/m_axis_aclk
  ad_connect  $sys_cpu_clk $dac_b_data_offload_name/s_axi_aclk
  ad_connect  $sys_cpu_clk $adc_b_data_offload_name/s_axi_aclk
}

# Resets
# create_bd_port -dir O rx_device_clk_rstn
# ad_connect rx_device_clk_rstn rx_device_clk_rstgen/peripheral_aresetn

ad_connect  $rx_pack_rstgen_net/peripheral_aresetn $adc_data_offload_name/s_axis_aresetn
ad_connect  $sys_dma_resetn $adc_data_offload_name/m_axis_aresetn
ad_connect  tx_device_clk_rstgen/peripheral_aresetn $dac_data_offload_name/m_axis_aresetn
ad_connect  $sys_dma_resetn $dac_data_offload_name/s_axis_aresetn

ad_connect  $sys_dma_resetn axi_apollo_rx_dma/m_dest_axi_aresetn
ad_connect  $sys_dma_resetn axi_apollo_tx_dma/m_src_axi_aresetn
ad_connect  $sys_cpu_resetn $dac_data_offload_name/s_axi_aresetn
ad_connect  $sys_cpu_resetn $adc_data_offload_name/s_axi_aresetn

if {$ASYMMETRIC_A_B_MODE} {
  ad_connect  $rx_b_pack_rstgen_net/peripheral_aresetn $adc_b_data_offload_name/s_axis_aresetn
  ad_connect  $sys_dma_resetn $adc_b_data_offload_name/m_axis_aresetn
  ad_connect  tx_b_device_clk_rstgen/peripheral_aresetn $dac_b_data_offload_name/m_axis_aresetn
  ad_connect  $sys_dma_resetn $dac_b_data_offload_name/s_axis_aresetn

  ad_connect  $sys_dma_resetn axi_apollo_rx_b_dma/m_dest_axi_aresetn
  ad_connect  $sys_dma_resetn axi_apollo_tx_b_dma/m_src_axi_aresetn
  ad_connect  $sys_cpu_resetn $dac_b_data_offload_name/s_axi_aresetn
  ad_connect  $sys_cpu_resetn $adc_b_data_offload_name/s_axi_aresetn
}

# The sequencer starts the TX accumulators on a sysref boundary, so it has to
# live on the same clock as the TX FSRC it starts. The two sides have separate
# device clocks - separate pins and separate buffers on every board here - so a
# side B FSRC gets its own sequencer rather than a pulse stretched across an
# unrelated domain. Both count the same sysref, so programming them alike starts
# both sides on the same boundary, which a synchroniser could not promise.
#
# rx_data_start has no consumer: the RX side has no sentinel phase to line up,
# it just deletes what it is given.
#
# Side A owns the trigger pins and the ctrl word; the side B sequencer's copies
# are left open.
if {$FSRC_ENABLE} {
  ad_ip_instance axi_fsrc_sequencer fsrc_sequencer [list \
    CTRL_WIDTH 40 \
    NUM_TRIG 4 \
  ]
  ad_connect tx_device_clk fsrc_sequencer/clk
  ad_connect tx_device_clk_rstgen/peripheral_reset fsrc_sequencer/reset
  ad_connect fsrc_sysref fsrc_sequencer/sysref
  ad_connect fsrc_trig_in fsrc_sequencer/trig_in
  ad_connect fsrc_sequencer/trig_out fsrc_trig_out
  ad_connect fsrc_sequencer/ctrl fsrc_ctrl

  if {$ASYMMETRIC_A_B_MODE} {
    ad_ip_instance axi_fsrc_sequencer fsrc_sequencer_b [list \
      CTRL_WIDTH 40 \
      NUM_TRIG 4 \
    ]
    ad_connect tx_b_device_clk fsrc_sequencer_b/clk
    ad_connect tx_b_device_clk_rstgen/peripheral_reset fsrc_sequencer_b/reset
    ad_connect fsrc_sysref fsrc_sequencer_b/sysref
    ad_connect fsrc_trig_in fsrc_sequencer_b/trig_in
  }

  if {$AION_ENABLE} {
    # Chain the two rather than let one override the other: the sequencer says
    # when a trigger is wanted, the adf4030 places it on the bsync grid and
    # drives the pins. Only channel 0 is a request; the adf4030 fans the
    # aligned pulse out to its own channels. No synchroniser here - the
    # sequencer runs on tx_device_clk and the adf4030 on rx_device_clk, but the
    # IP already treats trigger as fully asynchronous (ad_rst on device_clk),
    # as it must to accept a raw pin.
    ad_ip_instance ilslice fsrc_trig_req_slice [list \
      DIN_WIDTH 4 \
      DIN_FROM  0 \
      DIN_TO    0 \
    ]
    ad_connect fsrc_sequencer/trig_out fsrc_trig_req_slice/Din
    ad_connect fsrc_trig_req_slice/Dout axi_adf4030_0/trigger
  }
} else {
  ad_connect GND fsrc_trig_out
  ad_connect GND fsrc_ctrl
}

#
# connect adc dataflow
#
# Connect Link Layer to Transport Layer
#
ad_connect  axi_apollo_rx_jesd/rx_sof rx_apollo_tpl_core/link_sof
ad_connect  axi_apollo_rx_jesd/rx_data_tdata rx_apollo_tpl_core/link_data
ad_connect  axi_apollo_rx_jesd/rx_data_tvalid rx_apollo_tpl_core/link_valid

if {$RX_GEARBOX} {
  ad_ip_instance util_pack_cdc apollo_rx_pack_cdc [list \
    NUM_OF_ENABLES $RX_NUM_OF_CONVERTERS \
  ]
  ad_connect rx_device_clk apollo_rx_pack_cdc/device_clk
  ad_connect rx_device_clk_rstgen/peripheral_aresetn apollo_rx_pack_cdc/device_aresetn
  ad_connect rx_apollo_tpl_core/adc_tpl_core/adc_rst apollo_rx_pack_cdc/adc_rst
  ad_connect axi_apollo_rx_dma/s_axis_xfer_req apollo_rx_pack_cdc/xfer_req

  ad_connect $rx_pack_clk_net apollo_rx_pack_cdc/pack_clk
  ad_connect $rx_pack_rstgen_net/peripheral_aresetn apollo_rx_pack_cdc/pack_aresetn
  ad_connect rx_apollo_tpl_core/adc_tpl_core/enable apollo_rx_pack_cdc/enable_in

  # One FIFO for all channels, not one each: each async FIFO resolves its
  # gray pointers on its own metastability timing, so per-channel FIFOs drift
  # apart by a beat and cpack then interleaves samples from different times.
  ad_ip_instance ilconcat apollo_rx_pack_concat [list \
    NUM_PORTS $RX_NUM_OF_CONVERTERS \
  ]
  ad_ip_instance util_axis_fifo apollo_rx_pack_fifo [list \
    DATA_WIDTH [expr $RX_PACK_SAMPLES_PER_CHANNEL * $RX_DMA_SAMPLE_WIDTH * $RX_NUM_OF_CONVERTERS] \
    ADDRESS_WIDTH 5 \
    ASYNC_CLK 1 \
  ]
  ad_connect rx_device_clk apollo_rx_pack_fifo/s_axis_aclk
  ad_connect $rx_pack_clk_net apollo_rx_pack_fifo/m_axis_aclk
  ad_connect rx_device_clk_rstgen/peripheral_aresetn apollo_rx_pack_fifo/s_axis_aresetn
  ad_connect $rx_pack_rstgen_net/peripheral_aresetn apollo_rx_pack_fifo/m_axis_aresetn
  ad_connect apollo_rx_pack_concat/dout apollo_rx_pack_fifo/s_axis_data
  ad_connect VCC apollo_rx_pack_fifo/m_axis_ready
}

if {$FSRC_ENABLE} {
  if {!$RX_GEARBOX} {
    # Without a gearbox there is no util_pack_cdc, but the FSRC still needs a
    # reset that is held across DMA transfer boundaries, so add one for that
    # alone. cpack takes its enables straight from the transport layer here, so
    # enable_out stays unused.
    ad_ip_instance util_pack_cdc apollo_rx_pack_cdc [list \
      NUM_OF_ENABLES $RX_NUM_OF_CONVERTERS \
    ]
    ad_connect rx_device_clk apollo_rx_pack_cdc/device_clk
    ad_connect rx_device_clk_rstgen/peripheral_aresetn apollo_rx_pack_cdc/device_aresetn
    ad_connect rx_apollo_tpl_core/adc_tpl_core/adc_rst apollo_rx_pack_cdc/adc_rst
    ad_connect axi_apollo_rx_dma/s_axis_xfer_req apollo_rx_pack_cdc/xfer_req
    ad_connect rx_device_clk apollo_rx_pack_cdc/pack_clk
    ad_connect rx_device_clk_rstgen/peripheral_aresetn apollo_rx_pack_cdc/pack_aresetn
    ad_connect rx_apollo_tpl_core/adc_tpl_core/enable apollo_rx_pack_cdc/enable_in
  }

  adi_fsrc_rx_create fsrc_rx rx_device_clk apollo_rx_pack_cdc/device_resetn \
    $RX_NUM_OF_CONVERTERS \
    [expr $RX_SAMPLES_PER_CHANNEL * $RX_DMA_SAMPLE_WIDTH] \
    $RX_DMA_SAMPLE_WIDTH
  ad_connect rx_apollo_tpl_core/adc_valid_0 fsrc_rx/data_in_valid
}

# Whatever follows the transport layer - gearbox or cpack - takes its data from
# the FSRC output instead when FSRC is enabled.
set rx_data_src  [expr {$FSRC_ENABLE ? "fsrc_rx/data_out" : "rx_apollo_tpl_core/adc_data"}]
set rx_valid_src [expr {$FSRC_ENABLE ? "fsrc_rx/data_out_valid" : "rx_apollo_tpl_core/adc_valid_0"}]

for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  if {$FSRC_ENABLE} {
    ad_connect rx_apollo_tpl_core/adc_data_$i fsrc_rx/data_in_$i
  }
  if {$RX_GEARBOX} {
    ad_ip_instance ilslice apollo_rx_enable_slice_$i [list \
      DIN_WIDTH $RX_NUM_OF_CONVERTERS \
      DIN_FROM $i \
      DIN_TO $i \
    ]
    ad_connect apollo_rx_pack_cdc/enable_out apollo_rx_enable_slice_$i/Din
    ad_connect apollo_rx_enable_slice_$i/Dout util_apollo_cpack/enable_$i

    ad_ip_instance util_axis_gearbox apollo_rx_gearbox_$i [list \
      S_DATA_WIDTH [expr $RX_SAMPLES_PER_CHANNEL      * $RX_DMA_SAMPLE_WIDTH] \
      M_DATA_WIDTH [expr $RX_PACK_SAMPLES_PER_CHANNEL * $RX_DMA_SAMPLE_WIDTH] \
    ]
    ad_connect  rx_device_clk apollo_rx_gearbox_$i/clk
    ad_connect  ${rx_data_src}_$i apollo_rx_gearbox_$i/s_axis_data
    ad_connect  $rx_valid_src apollo_rx_gearbox_$i/s_axis_valid
    ad_connect  apollo_rx_pack_fifo/s_axis_ready apollo_rx_gearbox_$i/m_axis_ready
    ad_connect  apollo_rx_gearbox_$i/m_axis_data apollo_rx_pack_concat/In$i

    ad_ip_instance ilslice apollo_rx_pack_slice_$i [list \
      DIN_WIDTH [expr $RX_PACK_SAMPLES_PER_CHANNEL * $RX_DMA_SAMPLE_WIDTH * $RX_NUM_OF_CONVERTERS] \
      DIN_FROM [expr $RX_PACK_SAMPLES_PER_CHANNEL * $RX_DMA_SAMPLE_WIDTH * ($i+1) - 1] \
      DIN_TO   [expr $RX_PACK_SAMPLES_PER_CHANNEL * $RX_DMA_SAMPLE_WIDTH * $i] \
    ]
    ad_connect  apollo_rx_pack_fifo/m_axis_data apollo_rx_pack_slice_$i/Din
    ad_connect  apollo_rx_pack_slice_$i/Dout util_apollo_cpack/fifo_wr_data_$i
  } else {
    ad_connect  rx_apollo_tpl_core/adc_enable_$i util_apollo_cpack/enable_$i
    ad_connect  ${rx_data_src}_$i util_apollo_cpack/fifo_wr_data_$i
  }
}
if {$RX_GEARBOX} {
  ad_connect apollo_rx_gearbox_0/m_axis_valid apollo_rx_pack_fifo/s_axis_valid
  ad_connect apollo_rx_pack_fifo/m_axis_valid util_apollo_cpack/fifo_wr_en
} else {
  ad_connect $rx_valid_src util_apollo_cpack/fifo_wr_en
}
ad_connect rx_apollo_tpl_core/adc_dovf util_apollo_cpack/fifo_wr_overflow

ad_connect  util_apollo_cpack/packed_fifo_wr_data $adc_data_offload_name/s_axis_tdata
ad_connect  util_apollo_cpack/packed_fifo_wr_en $adc_data_offload_name/s_axis_tvalid
ad_connect  $adc_data_offload_name/s_axis_tlast GND
ad_connect  $adc_data_offload_name/s_axis_tkeep VCC

ad_connect $adc_data_offload_name/m_axis axi_apollo_rx_dma/s_axis

if {$ASYMMETRIC_A_B_MODE} {
  ad_connect  axi_apollo_rx_b_jesd/rx_sof rx_b_apollo_tpl_core/link_sof
  ad_connect  axi_apollo_rx_b_jesd/rx_data_tdata rx_b_apollo_tpl_core/link_data
  ad_connect  axi_apollo_rx_b_jesd/rx_data_tvalid rx_b_apollo_tpl_core/link_valid

  if {$RX_B_GEARBOX} {
    ad_ip_instance util_pack_cdc apollo_rx_b_pack_cdc [list \
      NUM_OF_ENABLES $RX_B_NUM_OF_CONVERTERS \
    ]
    ad_connect rx_b_device_clk apollo_rx_b_pack_cdc/device_clk
    ad_connect rx_b_device_clk_rstgen/peripheral_aresetn apollo_rx_b_pack_cdc/device_aresetn
    ad_connect rx_b_apollo_tpl_core/adc_tpl_core/adc_rst apollo_rx_b_pack_cdc/adc_rst
    ad_connect axi_apollo_rx_b_dma/s_axis_xfer_req apollo_rx_b_pack_cdc/xfer_req

    ad_connect $rx_b_pack_clk_net apollo_rx_b_pack_cdc/pack_clk
    ad_connect $rx_b_pack_rstgen_net/peripheral_aresetn apollo_rx_b_pack_cdc/pack_aresetn
    ad_connect rx_b_apollo_tpl_core/adc_tpl_core/enable apollo_rx_b_pack_cdc/enable_in

    # One FIFO for all channels, not one each - see the A side above.
    ad_ip_instance ilconcat apollo_rx_b_pack_concat [list \
      NUM_PORTS $RX_B_NUM_OF_CONVERTERS \
    ]
    ad_ip_instance util_axis_fifo apollo_rx_b_pack_fifo [list \
      DATA_WIDTH [expr $RX_B_PACK_SAMPLES_PER_CHANNEL * $RX_B_DMA_SAMPLE_WIDTH * $RX_B_NUM_OF_CONVERTERS] \
      ADDRESS_WIDTH 5 \
      ASYNC_CLK 1 \
    ]
    ad_connect rx_b_device_clk apollo_rx_b_pack_fifo/s_axis_aclk
    ad_connect $rx_b_pack_clk_net apollo_rx_b_pack_fifo/m_axis_aclk
    ad_connect rx_b_device_clk_rstgen/peripheral_aresetn apollo_rx_b_pack_fifo/s_axis_aresetn
    ad_connect $rx_b_pack_rstgen_net/peripheral_aresetn apollo_rx_b_pack_fifo/m_axis_aresetn
    ad_connect apollo_rx_b_pack_concat/dout apollo_rx_b_pack_fifo/s_axis_data
    ad_connect VCC apollo_rx_b_pack_fifo/m_axis_ready
  }

  if {$FSRC_ENABLE} {
    # See the A side above for why the reset comes from a util_pack_cdc.
    if {!$RX_B_GEARBOX} {
      ad_ip_instance util_pack_cdc apollo_rx_b_pack_cdc [list \
        NUM_OF_ENABLES $RX_B_NUM_OF_CONVERTERS \
      ]
      ad_connect rx_b_device_clk apollo_rx_b_pack_cdc/device_clk
      ad_connect rx_b_device_clk_rstgen/peripheral_aresetn apollo_rx_b_pack_cdc/device_aresetn
      ad_connect rx_b_apollo_tpl_core/adc_tpl_core/adc_rst apollo_rx_b_pack_cdc/adc_rst
      ad_connect axi_apollo_rx_b_dma/s_axis_xfer_req apollo_rx_b_pack_cdc/xfer_req
      ad_connect rx_b_device_clk apollo_rx_b_pack_cdc/pack_clk
      ad_connect rx_b_device_clk_rstgen/peripheral_aresetn apollo_rx_b_pack_cdc/pack_aresetn
      ad_connect rx_b_apollo_tpl_core/adc_tpl_core/enable apollo_rx_b_pack_cdc/enable_in
    }

    adi_fsrc_rx_create fsrc_rx_b rx_b_device_clk apollo_rx_b_pack_cdc/device_resetn \
      $RX_B_NUM_OF_CONVERTERS \
      [expr $RX_B_SAMPLES_PER_CHANNEL * $RX_B_DMA_SAMPLE_WIDTH] \
      $RX_B_DMA_SAMPLE_WIDTH
    ad_connect rx_b_apollo_tpl_core/adc_valid_0 fsrc_rx_b/data_in_valid
  }

  set rx_b_data_src  [expr {$FSRC_ENABLE ? "fsrc_rx_b/data_out" : "rx_b_apollo_tpl_core/adc_data"}]
  set rx_b_valid_src [expr {$FSRC_ENABLE ? "fsrc_rx_b/data_out_valid" : "rx_b_apollo_tpl_core/adc_valid_0"}]

  for {set i 0} {$i < $RX_B_NUM_OF_CONVERTERS} {incr i} {
    if {$FSRC_ENABLE} {
      ad_connect rx_b_apollo_tpl_core/adc_data_$i fsrc_rx_b/data_in_$i
    }
    if {$RX_B_GEARBOX} {
      ad_ip_instance ilslice apollo_rx_b_enable_slice_$i [list \
        DIN_WIDTH $RX_B_NUM_OF_CONVERTERS \
        DIN_FROM $i \
        DIN_TO $i \
      ]
      ad_connect apollo_rx_b_pack_cdc/enable_out apollo_rx_b_enable_slice_$i/Din
      ad_connect apollo_rx_b_enable_slice_$i/Dout util_apollo_cpack_b/enable_$i

      ad_ip_instance util_axis_gearbox apollo_rx_b_gearbox_$i [list \
        S_DATA_WIDTH [expr $RX_B_SAMPLES_PER_CHANNEL      * $RX_B_DMA_SAMPLE_WIDTH] \
        M_DATA_WIDTH [expr $RX_B_PACK_SAMPLES_PER_CHANNEL * $RX_B_DMA_SAMPLE_WIDTH] \
      ]
      ad_connect  rx_b_device_clk apollo_rx_b_gearbox_$i/clk
      ad_connect  ${rx_b_data_src}_$i apollo_rx_b_gearbox_$i/s_axis_data
      ad_connect  $rx_b_valid_src apollo_rx_b_gearbox_$i/s_axis_valid
      ad_connect  apollo_rx_b_pack_fifo/s_axis_ready apollo_rx_b_gearbox_$i/m_axis_ready
      ad_connect  apollo_rx_b_gearbox_$i/m_axis_data apollo_rx_b_pack_concat/In$i

      ad_ip_instance ilslice apollo_rx_b_pack_slice_$i [list \
        DIN_WIDTH [expr $RX_B_PACK_SAMPLES_PER_CHANNEL * $RX_B_DMA_SAMPLE_WIDTH * $RX_B_NUM_OF_CONVERTERS] \
        DIN_FROM [expr $RX_B_PACK_SAMPLES_PER_CHANNEL * $RX_B_DMA_SAMPLE_WIDTH * ($i+1) - 1] \
        DIN_TO   [expr $RX_B_PACK_SAMPLES_PER_CHANNEL * $RX_B_DMA_SAMPLE_WIDTH * $i] \
      ]
      ad_connect  apollo_rx_b_pack_fifo/m_axis_data apollo_rx_b_pack_slice_$i/Din
      ad_connect  apollo_rx_b_pack_slice_$i/Dout util_apollo_cpack_b/fifo_wr_data_$i
    } else {
      ad_connect  rx_b_apollo_tpl_core/adc_enable_$i util_apollo_cpack_b/enable_$i
      ad_connect  ${rx_b_data_src}_$i util_apollo_cpack_b/fifo_wr_data_$i
    }
  }
  if {$RX_B_GEARBOX} {
    ad_connect apollo_rx_b_gearbox_0/m_axis_valid apollo_rx_b_pack_fifo/s_axis_valid
    ad_connect apollo_rx_b_pack_fifo/m_axis_valid util_apollo_cpack_b/fifo_wr_en
  } else {
    ad_connect $rx_b_valid_src util_apollo_cpack_b/fifo_wr_en
  }
  ad_connect rx_b_apollo_tpl_core/adc_dovf util_apollo_cpack_b/fifo_wr_overflow

  ad_connect  util_apollo_cpack_b/packed_fifo_wr_data $adc_b_data_offload_name/s_axis_tdata
  ad_connect  util_apollo_cpack_b/packed_fifo_wr_en $adc_b_data_offload_name/s_axis_tvalid
  ad_connect  $adc_b_data_offload_name/s_axis_tlast GND
  ad_connect  $adc_b_data_offload_name/s_axis_tkeep VCC

  ad_connect $adc_b_data_offload_name/m_axis axi_apollo_rx_b_dma/s_axis
}

# connect dac dataflow
#

# Connect Link Layer to Transport Layer
#
ad_connect  tx_apollo_tpl_core/link axi_apollo_tx_jesd/tx_data

# upack has to be a power of two wide because its s_axis comes straight from the
# data offload, so it emits TX_PACK_SAMPLES_PER_CHANNEL samples while the DAC
# transport layer wants TX_SAMPLES_PER_CHANNEL.  A gearbox does the reduction.
#
# The direction is what makes this cheap compared to RX.  For 512 -> 384 the
# gearbox holds 128-bit units and settles into level 4,5,6,3,4,... which means
# m_axis_valid is high every cycle and s_axis_ready drops one cycle in four.
# The stall therefore lands on the offload, which has backpressure, instead of
# on the transport layer, which has none - so no second clock and no CDC here.
# The lookahead FIFO is needed for the gearbox and for the FSRC alike: both are
# ready/valid consumers and upack cannot be stalled directly.
set TX_UNPACK_FIFO [expr {$TX_GEARBOX || $FSRC_ENABLE}]

if {$TX_UNPACK_FIFO} {
  # upack is a pull with one cycle of latency and no hold: fifo_rd_data and
  # fifo_rd_valid only update when fifo_rd_en was high the cycle before, and
  # fifo_rd_valid goes low otherwise.  Driving fifo_rd_en from the gearbox
  # s_axis_ready would therefore skip the request in every stall cycle and
  # leave the gearbox with nothing to hand out in the cycle after it, putting a
  # bubble on the DAC side.  A shallow synchronous FIFO supplies the missing
  # beat of lookahead: request while it still has room for two, so the answer
  # always fits.
  #
  # One FIFO for all channels and then slice, for the same reason as on RX:
  # every gearbox must see the same valid and the same ready, or the channels
  # drift apart and the DAC gets I and Q from different times.
  ad_ip_instance ilconcat apollo_tx_unpack_concat [list \
    NUM_PORTS $TX_NUM_OF_CONVERTERS \
  ]
  # The FIFO drops a beat that arrives while it is full - s_mem_write is gated
  # on s_axis_ready, and upack cannot be told to hold a beat it has already
  # produced - so almost_full has to stop the source before that can happen.
  # The margin is thinner than it looks: a depth of 2**N holds 2**N-1 beats, and
  # almost_full asserts at a fill above ~ALMOST_FULL_THRESHOLD, so a threshold of
  # 2 on a depth of 8 asserts at a fill of 6 and leaves a single free slot. One
  # beat is always already in flight, because the fill is computed from
  # registered pointers and upack's fifo_rd_valid is registered off fifo_rd_en,
  # so that single slot is all the margin there is.
  #
  # Without the FSRC the fill rate equals the drain rate and the FIFO sits near
  # empty, so the threshold never does any work. The FSRC consumes only
  # RATE_DEN/RATE_NUM of what the source offers, which parks the FIFO on the
  # threshold permanently, and every overshoot loses a whole beat of samples
  # silently. Hence the room below, which is well past the beat in flight.
  ad_ip_instance util_axis_fifo apollo_tx_unpack_fifo [list \
    DATA_WIDTH [expr $TX_PACK_SAMPLES_PER_CHANNEL * $TX_DMA_SAMPLE_WIDTH * $TX_NUM_OF_CONVERTERS] \
    ADDRESS_WIDTH 5 \
    ASYNC_CLK 0 \
    ALMOST_FULL_THRESHOLD 8 \
  ]
  ad_connect tx_device_clk apollo_tx_unpack_fifo/s_axis_aclk
  ad_connect tx_device_clk apollo_tx_unpack_fifo/m_axis_aclk
  ad_connect apollo_tx_unpack_concat/dout apollo_tx_unpack_fifo/s_axis_data
  ad_connect util_apollo_upack/fifo_rd_valid apollo_tx_unpack_fifo/s_axis_valid

  ad_ip_instance ilvector_logic apollo_tx_unpack_rd_en [list \
    C_SIZE 1 \
    C_OPERATION {not} \
  ]
  ad_connect apollo_tx_unpack_fifo/s_axis_almost_full apollo_tx_unpack_rd_en/Op1
  ad_connect apollo_tx_unpack_rd_en/Res util_apollo_upack/fifo_rd_en
} else {
  ad_connect  tx_apollo_tpl_core/dac_valid_0 util_apollo_upack/fifo_rd_en
}

if {$FSRC_ENABLE} {
  adi_fsrc_tx_create fsrc_tx tx_device_clk \
    $TX_NUM_OF_CONVERTERS \
    [expr $TX_SAMPLES_PER_CHANNEL * $TX_DMA_SAMPLE_WIDTH] \
    $TX_DMA_SAMPLE_WIDTH $FSRC_ACCUM_WIDTH
  ad_connect fsrc_sequencer/tx_data_start fsrc_tx/tx_data_start
  # The transport layer has no valid input; dac_valid_0 is its request for the
  # next beat, so it is the FSRC output ready.
  ad_connect tx_apollo_tpl_core/dac_valid_0 fsrc_tx/data_out_ready
}

# The last stage before the transport layer, and what it hands its data to.
set tx_gearbox_sink [expr {$FSRC_ENABLE ? "fsrc_tx/data_in" : "tx_apollo_tpl_core/dac_data"}]
set tx_gearbox_ready [expr {$FSRC_ENABLE ? "fsrc_tx/data_in_ready" : "tx_apollo_tpl_core/dac_valid_0"}]

for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  if {$TX_UNPACK_FIFO} {
    ad_connect  util_apollo_upack/fifo_rd_data_$i apollo_tx_unpack_concat/In$i

    ad_ip_instance ilslice apollo_tx_unpack_slice_$i [list \
      DIN_WIDTH [expr $TX_PACK_SAMPLES_PER_CHANNEL * $TX_DMA_SAMPLE_WIDTH * $TX_NUM_OF_CONVERTERS] \
      DIN_FROM [expr $TX_PACK_SAMPLES_PER_CHANNEL * $TX_DMA_SAMPLE_WIDTH * ($i+1) - 1] \
      DIN_TO   [expr $TX_PACK_SAMPLES_PER_CHANNEL * $TX_DMA_SAMPLE_WIDTH * $i] \
    ]
    ad_connect  apollo_tx_unpack_fifo/m_axis_data apollo_tx_unpack_slice_$i/Din
  }
  if {$TX_GEARBOX} {
    ad_ip_instance util_axis_gearbox apollo_tx_gearbox_$i [list \
      S_DATA_WIDTH [expr $TX_PACK_SAMPLES_PER_CHANNEL * $TX_DMA_SAMPLE_WIDTH] \
      M_DATA_WIDTH [expr $TX_SAMPLES_PER_CHANNEL      * $TX_DMA_SAMPLE_WIDTH] \
    ]
    ad_connect  tx_device_clk apollo_tx_gearbox_$i/clk
    ad_connect  apollo_tx_unpack_slice_$i/Dout apollo_tx_gearbox_$i/s_axis_data
    ad_connect  apollo_tx_unpack_fifo/m_axis_valid apollo_tx_gearbox_$i/s_axis_valid
    ad_connect  $tx_gearbox_ready apollo_tx_gearbox_$i/m_axis_ready
    ad_connect  apollo_tx_gearbox_$i/m_axis_data ${tx_gearbox_sink}_$i
  } elseif {$FSRC_ENABLE} {
    ad_connect  apollo_tx_unpack_slice_$i/Dout fsrc_tx/data_in_$i
  } else {
    ad_connect  util_apollo_upack/fifo_rd_data_$i tx_apollo_tpl_core/dac_data_$i
  }
  if {$FSRC_ENABLE} {
    ad_connect  fsrc_tx/data_out_$i tx_apollo_tpl_core/dac_data_$i
  }
  ad_connect  tx_apollo_tpl_core/dac_enable_$i  util_apollo_upack/enable_$i
}
if {$TX_GEARBOX} {
  ad_connect apollo_tx_gearbox_0/s_axis_ready apollo_tx_unpack_fifo/m_axis_ready
  if {$FSRC_ENABLE} {
    ad_connect apollo_tx_gearbox_0/m_axis_valid fsrc_tx/data_in_valid
  }
} elseif {$FSRC_ENABLE} {
  ad_connect fsrc_tx/data_in_ready apollo_tx_unpack_fifo/m_axis_ready
  ad_connect apollo_tx_unpack_fifo/m_axis_valid fsrc_tx/data_in_valid
}

ad_connect $dac_data_offload_name/s_axis axi_apollo_tx_dma/m_axis

ad_connect  util_apollo_upack/s_axis $dac_data_offload_name/m_axis

ad_connect $dac_data_offload_name/init_req axi_apollo_tx_dma/m_axis_xfer_req
ad_connect $adc_data_offload_name/init_req axi_apollo_rx_dma/s_axis_xfer_req
ad_connect tx_apollo_tpl_core/dac_dunf GND

if {$ASYMMETRIC_A_B_MODE} {
  ad_connect  tx_b_apollo_tpl_core/link axi_apollo_tx_b_jesd/tx_data

  # See the A side above for why 512 -> 384 needs no second clock and why the
  # lookahead FIFO is there.
  set TX_B_UNPACK_FIFO [expr {$TX_B_GEARBOX || $FSRC_ENABLE}]

  if {$TX_B_UNPACK_FIFO} {
    ad_ip_instance ilconcat apollo_tx_b_unpack_concat [list \
      NUM_PORTS $TX_B_NUM_OF_CONVERTERS \
    ]
    ad_ip_instance util_axis_fifo apollo_tx_b_unpack_fifo [list \
      DATA_WIDTH [expr $TX_B_PACK_SAMPLES_PER_CHANNEL * $TX_B_DMA_SAMPLE_WIDTH * $TX_B_NUM_OF_CONVERTERS] \
      ADDRESS_WIDTH 3 \
      ASYNC_CLK 0 \
      ALMOST_FULL_THRESHOLD 2 \
    ]
    ad_connect tx_b_device_clk apollo_tx_b_unpack_fifo/s_axis_aclk
    ad_connect tx_b_device_clk apollo_tx_b_unpack_fifo/m_axis_aclk
    ad_connect apollo_tx_b_unpack_concat/dout apollo_tx_b_unpack_fifo/s_axis_data
    ad_connect util_apollo_upack_b/fifo_rd_valid apollo_tx_b_unpack_fifo/s_axis_valid

    ad_ip_instance ilvector_logic apollo_tx_b_unpack_rd_en [list \
      C_SIZE 1 \
      C_OPERATION {not} \
    ]
    ad_connect apollo_tx_b_unpack_fifo/s_axis_almost_full apollo_tx_b_unpack_rd_en/Op1
    ad_connect apollo_tx_b_unpack_rd_en/Res util_apollo_upack_b/fifo_rd_en
  } else {
    ad_connect  tx_b_apollo_tpl_core/dac_valid_0 util_apollo_upack_b/fifo_rd_en
  }

  if {$FSRC_ENABLE} {
    adi_fsrc_tx_create fsrc_tx_b tx_b_device_clk \
      $TX_B_NUM_OF_CONVERTERS \
      [expr $TX_B_SAMPLES_PER_CHANNEL * $TX_B_DMA_SAMPLE_WIDTH] \
      $TX_B_DMA_SAMPLE_WIDTH $FSRC_ACCUM_WIDTH
    ad_connect fsrc_sequencer_b/tx_data_start fsrc_tx_b/tx_data_start
    ad_connect tx_b_apollo_tpl_core/dac_valid_0 fsrc_tx_b/data_out_ready
  }

  set tx_b_gearbox_sink [expr {$FSRC_ENABLE ? "fsrc_tx_b/data_in" : "tx_b_apollo_tpl_core/dac_data"}]
  set tx_b_gearbox_ready [expr {$FSRC_ENABLE ? "fsrc_tx_b/data_in_ready" : "tx_b_apollo_tpl_core/dac_valid_0"}]

  for {set i 0} {$i < $TX_B_NUM_OF_CONVERTERS} {incr i} {
    if {$TX_B_UNPACK_FIFO} {
      ad_connect  util_apollo_upack_b/fifo_rd_data_$i apollo_tx_b_unpack_concat/In$i

      ad_ip_instance ilslice apollo_tx_b_unpack_slice_$i [list \
        DIN_WIDTH [expr $TX_B_PACK_SAMPLES_PER_CHANNEL * $TX_B_DMA_SAMPLE_WIDTH * $TX_B_NUM_OF_CONVERTERS] \
        DIN_FROM [expr $TX_B_PACK_SAMPLES_PER_CHANNEL * $TX_B_DMA_SAMPLE_WIDTH * ($i+1) - 1] \
        DIN_TO   [expr $TX_B_PACK_SAMPLES_PER_CHANNEL * $TX_B_DMA_SAMPLE_WIDTH * $i] \
      ]
      ad_connect  apollo_tx_b_unpack_fifo/m_axis_data apollo_tx_b_unpack_slice_$i/Din
    }
    if {$TX_B_GEARBOX} {
      ad_ip_instance util_axis_gearbox apollo_tx_b_gearbox_$i [list \
        S_DATA_WIDTH [expr $TX_B_PACK_SAMPLES_PER_CHANNEL * $TX_B_DMA_SAMPLE_WIDTH] \
        M_DATA_WIDTH [expr $TX_B_SAMPLES_PER_CHANNEL      * $TX_B_DMA_SAMPLE_WIDTH] \
      ]
      ad_connect  tx_b_device_clk apollo_tx_b_gearbox_$i/clk
      ad_connect  apollo_tx_b_unpack_slice_$i/Dout apollo_tx_b_gearbox_$i/s_axis_data
      ad_connect  apollo_tx_b_unpack_fifo/m_axis_valid apollo_tx_b_gearbox_$i/s_axis_valid
      ad_connect  $tx_b_gearbox_ready apollo_tx_b_gearbox_$i/m_axis_ready
      ad_connect  apollo_tx_b_gearbox_$i/m_axis_data ${tx_b_gearbox_sink}_$i
    } elseif {$FSRC_ENABLE} {
      ad_connect  apollo_tx_b_unpack_slice_$i/Dout fsrc_tx_b/data_in_$i
    } else {
      ad_connect  util_apollo_upack_b/fifo_rd_data_$i tx_b_apollo_tpl_core/dac_data_$i
    }
    if {$FSRC_ENABLE} {
      ad_connect  fsrc_tx_b/data_out_$i tx_b_apollo_tpl_core/dac_data_$i
    }
    ad_connect  tx_b_apollo_tpl_core/dac_enable_$i  util_apollo_upack_b/enable_$i
  }
  if {$TX_B_GEARBOX} {
    ad_connect apollo_tx_b_gearbox_0/s_axis_ready apollo_tx_b_unpack_fifo/m_axis_ready
    if {$FSRC_ENABLE} {
      ad_connect apollo_tx_b_gearbox_0/m_axis_valid fsrc_tx_b/data_in_valid
    }
  } elseif {$FSRC_ENABLE} {
    ad_connect fsrc_tx_b/data_in_ready apollo_tx_b_unpack_fifo/m_axis_ready
    ad_connect apollo_tx_b_unpack_fifo/m_axis_valid fsrc_tx_b/data_in_valid
  }

  ad_connect $dac_b_data_offload_name/s_axis axi_apollo_tx_b_dma/m_axis

  ad_connect  util_apollo_upack_b/s_axis $dac_b_data_offload_name/m_axis

  ad_connect $dac_b_data_offload_name/init_req axi_apollo_tx_b_dma/m_axis_xfer_req
  ad_connect $adc_b_data_offload_name/init_req axi_apollo_rx_b_dma/s_axis_xfer_req
  ad_connect tx_b_apollo_tpl_core/dac_dunf GND
}

# interconnect (cpu)

if {$ADI_PHY_SEL} {
  ad_cpu_interconnect 0x44a60000 axi_apollo_rx_xcvr
  ad_cpu_interconnect 0x44b60000 axi_apollo_tx_xcvr
} else {
  for {set i 0} {$i < $num_quads} {incr i} {
    set addr [expr 0x44040000 + $i * 0x40000]
    ad_cpu_interconnect $addr jesd204_phy s_axi_${i}
  }
}
ad_cpu_interconnect 0x44a10000 rx_apollo_tpl_core
ad_cpu_interconnect 0x44b10000 tx_apollo_tpl_core
ad_cpu_interconnect 0x44a90000 axi_apollo_rx_jesd
ad_cpu_interconnect 0x44b90000 axi_apollo_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_apollo_rx_dma
ad_cpu_interconnect 0x7c430000 axi_apollo_tx_dma
ad_cpu_interconnect 0x7c440000 $dac_data_offload_name
ad_cpu_interconnect 0x7c450000 $adc_data_offload_name
if {$FSRC_ENABLE} {
  ad_cpu_interconnect 0x44500000 fsrc_rx
  ad_cpu_interconnect 0x44510000 fsrc_tx
  ad_cpu_interconnect 0x44540000 fsrc_sequencer
}
if {$HSCI_ENABLE} {
  ad_cpu_interconnect 0x44ad0000 axi_hsci_clkgen
  ad_cpu_interconnect 0x7c500000 axi_hsci_0
}
if {$AION_ENABLE} {
  ad_cpu_interconnect 0x7c600000 axi_adf4030_0
}
# Reserved for TDD! 0x7c460000

if {$ASYMMETRIC_A_B_MODE} {
  if {$ADI_PHY_SEL} {
    ad_cpu_interconnect 0x44aa0000 axi_apollo_rx_b_xcvr
    ad_cpu_interconnect 0x44ba0000 axi_apollo_tx_b_xcvr
  } else {
    for {set i 0} {$i < $num_quads} {incr i} {
      set addr [expr 0x44140000 + $i * 0x40000]
      ad_cpu_interconnect $addr jesd204_phy_b s_axi_${i}
    }
  }
  ad_cpu_interconnect 0x44ab0000 rx_b_apollo_tpl_core
  ad_cpu_interconnect 0x44bb0000 tx_b_apollo_tpl_core
  ad_cpu_interconnect 0x44ac0000 axi_apollo_rx_b_jesd
  ad_cpu_interconnect 0x44bc0000 axi_apollo_tx_b_jesd
  ad_cpu_interconnect 0x7c470000 axi_apollo_rx_b_dma
  ad_cpu_interconnect 0x7c480000 axi_apollo_tx_b_dma
  ad_cpu_interconnect 0x7c490000 $dac_b_data_offload_name
  ad_cpu_interconnect 0x7c4a0000 $adc_b_data_offload_name
  if {$FSRC_ENABLE} {
    ad_cpu_interconnect 0x44520000 fsrc_rx_b
    ad_cpu_interconnect 0x44530000 fsrc_tx_b
    ad_cpu_interconnect 0x44550000 fsrc_sequencer_b
  }
}

# interconnect (gt/adc)

if ${ADI_PHY_SEL} {
  ad_mem_hp0_interconnect $sys_cpu_clk axi_apollo_rx_xcvr/m_axi
}
ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_dma_clk axi_apollo_rx_dma/m_dest_axi
ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_apollo_tx_dma/m_src_axi

if {$ASYMMETRIC_A_B_MODE} {
  if ${ADI_PHY_SEL} {
    ad_mem_hp0_interconnect $sys_cpu_clk axi_apollo_rx_b_xcvr/m_axi
  }
  ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
  ad_mem_hp1_interconnect $sys_dma_clk axi_apollo_rx_b_dma/m_dest_axi
  ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
  ad_mem_hp2_interconnect $sys_dma_clk axi_apollo_tx_b_dma/m_src_axi
}

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_apollo_rx_dma/irq
ad_cpu_interrupt ps-12 mb-13 axi_apollo_tx_dma/irq
ad_cpu_interrupt ps-11 mb-14 axi_apollo_rx_jesd/irq
ad_cpu_interrupt ps-10 mb-15 axi_apollo_tx_jesd/irq

if {$ASYMMETRIC_A_B_MODE} {
  ad_cpu_interrupt ps-4 mb-5 axi_apollo_rx_b_dma/irq
  ad_cpu_interrupt ps-3 mb-6 axi_apollo_tx_b_dma/irq
  ad_cpu_interrupt ps-2 mb-7 axi_apollo_rx_b_jesd/irq
  ad_cpu_interrupt ps-1 mb-8 axi_apollo_tx_b_jesd/irq
}

#
# Sync at TPL level
#

create_bd_port -dir I ext_sync_in

# Enable ADC external sync
ad_ip_parameter rx_apollo_tpl_core/adc_tpl_core CONFIG.EXT_SYNC 1
ad_connect ext_sync_in rx_apollo_tpl_core/adc_tpl_core/adc_sync_in

# Enable DAC external sync
ad_ip_parameter tx_apollo_tpl_core/dac_tpl_core CONFIG.EXT_SYNC 1
ad_connect ext_sync_in tx_apollo_tpl_core/dac_tpl_core/dac_sync_in

ad_ip_instance ilvector_logic manual_sync_or [list \
  C_SIZE 1 \
  C_OPERATION {or} \
]

ad_connect rx_apollo_tpl_core/adc_tpl_core/adc_sync_manual_req_out manual_sync_or/Op1
ad_connect tx_apollo_tpl_core/dac_tpl_core/dac_sync_manual_req_out manual_sync_or/Op2

if {$ASYMMETRIC_A_B_MODE == 0} {
  ad_connect manual_sync_or/Res tx_apollo_tpl_core/dac_tpl_core/dac_sync_manual_req_in
  ad_connect manual_sync_or/Res rx_apollo_tpl_core/adc_tpl_core/adc_sync_manual_req_in
} else {
  # Enable ADC B side external sync
  ad_ip_parameter rx_b_apollo_tpl_core/adc_tpl_core CONFIG.EXT_SYNC 1
  ad_connect ext_sync_in rx_b_apollo_tpl_core/adc_tpl_core/adc_sync_in

  # Enable DAC B side external sync
  ad_ip_parameter tx_b_apollo_tpl_core/dac_tpl_core CONFIG.EXT_SYNC 1
  ad_connect ext_sync_in tx_b_apollo_tpl_core/dac_tpl_core/dac_sync_in

  ad_ip_instance ilvector_logic manual_sync_or_b [list \
    C_SIZE 1 \
    C_OPERATION {or} \
  ]

  ad_connect rx_b_apollo_tpl_core/adc_tpl_core/adc_sync_manual_req_out manual_sync_or_b/Op1
  ad_connect tx_b_apollo_tpl_core/dac_tpl_core/dac_sync_manual_req_out manual_sync_or_b/Op2

  ad_ip_instance ilvector_logic manual_sync_or_res [list \
    C_SIZE 1 \
    C_OPERATION {or} \
  ]

  ad_connect manual_sync_or/Res manual_sync_or_res/Op1
  ad_connect manual_sync_or_b/Res manual_sync_or_res/Op2

  ad_connect manual_sync_or_res/Res tx_apollo_tpl_core/dac_tpl_core/dac_sync_manual_req_in
  ad_connect manual_sync_or_res/Res rx_apollo_tpl_core/adc_tpl_core/adc_sync_manual_req_in
  ad_connect manual_sync_or_res/Res tx_b_apollo_tpl_core/dac_tpl_core/dac_sync_manual_req_in
  ad_connect manual_sync_or_res/Res rx_b_apollo_tpl_core/adc_tpl_core/adc_sync_manual_req_in
}

# Reset pack cores
#
# On the gearbox path cpack runs on rx_pack_clk, so its reset comes from that
# domain's rstgen; adc_rst is left out of it because it belongs to
# rx_device_clk and cpack has nothing of its own to flush - the gearbox
# upstream is what holds the state, and it is reset from device_resetn below.
set RX_CPACK_RST_SOURCES [expr {$RX_GEARBOX ? 2 : 3}]

ad_ip_instance ilreduced_logic cpack_rst_logic
ad_ip_parameter cpack_rst_logic config.c_operation {or}
ad_ip_parameter cpack_rst_logic config.c_size $RX_CPACK_RST_SOURCES

ad_ip_instance  ilvector_logic rx_do_rstout_logic
ad_ip_parameter rx_do_rstout_logic config.c_operation {not}
ad_ip_parameter rx_do_rstout_logic config.c_size {1}

ad_connect $adc_data_offload_name/s_axis_tready rx_do_rstout_logic/Op1

ad_ip_instance ilconcat cpack_reset_sources
ad_ip_parameter cpack_reset_sources config.num_ports $RX_CPACK_RST_SOURCES
ad_connect $rx_pack_rstgen_net/peripheral_reset cpack_reset_sources/in0
if {$RX_GEARBOX} {
  ad_connect rx_do_rstout_logic/res cpack_reset_sources/in1
} else {
  ad_connect rx_apollo_tpl_core/adc_tpl_core/adc_rst cpack_reset_sources/in1
  ad_connect rx_do_rstout_logic/res cpack_reset_sources/in2
}

ad_connect cpack_reset_sources/dout cpack_rst_logic/op1
ad_connect cpack_rst_logic/res util_apollo_cpack/reset

# The gearbox holds part of a packed word, so it must come out of reset with
# the pack chain and not a cycle either side of it - a private reset would
# leave a stale remainder and rotate every channel by it.
if {$RX_GEARBOX} {
  for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
    ad_connect apollo_rx_pack_cdc/device_resetn apollo_rx_gearbox_$i/resetn
  }
}

if {$ASYMMETRIC_A_B_MODE} {
  # See the A side above.
  set RX_B_CPACK_RST_SOURCES [expr {$RX_B_GEARBOX ? 2 : 3}]

  ad_ip_instance ilreduced_logic cpack_b_rst_logic
  ad_ip_parameter cpack_b_rst_logic config.c_operation {or}
  ad_ip_parameter cpack_b_rst_logic config.c_size $RX_B_CPACK_RST_SOURCES

  ad_ip_instance  ilvector_logic rx_b_do_rstout_logic
  ad_ip_parameter rx_b_do_rstout_logic config.c_operation {not}
  ad_ip_parameter rx_b_do_rstout_logic config.c_size {1}

  ad_connect $adc_b_data_offload_name/s_axis_tready rx_b_do_rstout_logic/Op1

  ad_ip_instance ilconcat cpack_b_reset_sources
  ad_ip_parameter cpack_b_reset_sources config.num_ports $RX_B_CPACK_RST_SOURCES
  ad_connect $rx_b_pack_rstgen_net/peripheral_reset cpack_b_reset_sources/in0
  if {$RX_B_GEARBOX} {
    ad_connect rx_b_do_rstout_logic/res cpack_b_reset_sources/in1
  } else {
    ad_connect rx_b_apollo_tpl_core/adc_tpl_core/adc_rst cpack_b_reset_sources/in1
    ad_connect rx_b_do_rstout_logic/res cpack_b_reset_sources/in2
  }

  ad_connect cpack_b_reset_sources/dout cpack_b_rst_logic/op1
  ad_connect cpack_b_rst_logic/res util_apollo_cpack_b/reset

  if {$RX_B_GEARBOX} {
    for {set i 0} {$i < $RX_B_NUM_OF_CONVERTERS} {incr i} {
      ad_connect apollo_rx_b_pack_cdc/device_resetn apollo_rx_b_gearbox_$i/resetn
    }
  }
}

# Reset unpack cores
ad_ip_instance ilreduced_logic upack_rst_logic
ad_ip_parameter upack_rst_logic config.c_operation {or}
ad_ip_parameter upack_rst_logic config.c_size {2}

ad_ip_instance ilconcat upack_reset_sources
ad_ip_parameter upack_reset_sources config.num_ports {2}
ad_connect tx_device_clk_rstgen/peripheral_reset upack_reset_sources/in0
ad_connect tx_apollo_tpl_core/dac_tpl_core/dac_rst upack_reset_sources/in1

ad_connect upack_reset_sources/dout upack_rst_logic/op1
ad_connect upack_rst_logic/res util_apollo_upack/reset

# The TX FSRC is part of the same chain: it holds the accumulator phase and a
# beat it has not finished handing out, so a DAC reset that restarts upack
# without restarting it leaves the two at different sample positions for good.
if {$FSRC_ENABLE} {
  ad_connect upack_rst_logic/res fsrc_tx/reset
}

# The gearbox and its lookahead FIFO hold part of a packed word, so they must
# come out of reset with upack and not a cycle either side of it - a private
# reset would leave a stale remainder and rotate every channel by whatever it
# happened to be holding.  Same source, just active low.
if {$TX_UNPACK_FIFO} {
  ad_ip_instance ilvector_logic tx_gearbox_rstn [list \
    C_SIZE 1 \
    C_OPERATION {not} \
  ]
  ad_connect upack_rst_logic/res tx_gearbox_rstn/Op1
  ad_connect tx_gearbox_rstn/Res apollo_tx_unpack_fifo/s_axis_aresetn
  ad_connect tx_gearbox_rstn/Res apollo_tx_unpack_fifo/m_axis_aresetn
  if {$TX_GEARBOX} {
    for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
      ad_connect tx_gearbox_rstn/Res apollo_tx_gearbox_$i/resetn
    }
  }
}

if {$ASYMMETRIC_A_B_MODE} {
  ad_ip_instance ilreduced_logic upack_b_rst_logic
  ad_ip_parameter upack_b_rst_logic config.c_operation {or}
  ad_ip_parameter upack_b_rst_logic config.c_size {2}

  ad_ip_instance ilconcat upack_b_reset_sources
  ad_ip_parameter upack_b_reset_sources config.num_ports {2}
  ad_connect tx_b_device_clk_rstgen/peripheral_reset upack_b_reset_sources/in0
  ad_connect tx_b_apollo_tpl_core/dac_tpl_core/dac_rst upack_b_reset_sources/in1

  ad_connect upack_b_reset_sources/dout upack_b_rst_logic/op1
  ad_connect upack_b_rst_logic/res util_apollo_upack_b/reset

  if {$FSRC_ENABLE} {
    ad_connect upack_b_rst_logic/res fsrc_tx_b/reset
  }

  if {$TX_B_UNPACK_FIFO} {
    ad_ip_instance ilvector_logic tx_b_gearbox_rstn [list \
      C_SIZE 1 \
      C_OPERATION {not} \
    ]
    ad_connect upack_b_rst_logic/res tx_b_gearbox_rstn/Op1
    ad_connect tx_b_gearbox_rstn/Res apollo_tx_b_unpack_fifo/s_axis_aresetn
    ad_connect tx_b_gearbox_rstn/Res apollo_tx_b_unpack_fifo/m_axis_aresetn
    if {$TX_B_GEARBOX} {
      for {set i 0} {$i < $TX_B_NUM_OF_CONVERTERS} {incr i} {
        ad_connect tx_b_gearbox_rstn/Res apollo_tx_b_gearbox_$i/resetn
      }
    }
  }
}

if {$TDD_SUPPORT} {
  ad_ip_instance util_tdd_sync tdd_sync_0
  ad_connect tx_device_clk tdd_sync_0/clk
  ad_connect tx_device_clk_rstgen/peripheral_aresetn tdd_sync_0/rstn
  ad_connect tdd_sync_0/sync_in GND
  ad_connect tdd_sync_0/sync_mode GND
  ad_ip_parameter tdd_sync_0 CONFIG.TDD_SYNC_PERIOD 250000000; # More or less 1 PPS ;)

  ad_ip_instance axi_tdd axi_tdd_0 [list ASYNC_TDD_SYNC 0]
  ad_connect tx_device_clk axi_tdd_0/clk
  ad_connect tx_device_clk_rstgen/peripheral_reset axi_tdd_0/rst
  ad_connect $sys_cpu_clk axi_tdd_0/s_axi_aclk
  ad_connect $sys_cpu_resetn axi_tdd_0/s_axi_aresetn
  ad_cpu_interconnect 0x7c460000 axi_tdd_0

  ad_connect tdd_sync_0/sync_out axi_tdd_0/tdd_sync

  delete_bd_objs [get_bd_nets apollo_adc_fifo_dma_wr]

  ad_connect axi_tdd_0/tdd_tx_valid $dac_data_offload_name/sync_ext
  ad_connect axi_tdd_0/tdd_rx_valid $adc_data_offload_name/sync_ext

} else {
  ad_connect GND $dac_data_offload_name/sync_ext
  ad_connect GND $adc_data_offload_name/sync_ext

  if {$ASYMMETRIC_A_B_MODE} {
    ad_connect GND $dac_b_data_offload_name/sync_ext
    ad_connect GND $adc_b_data_offload_name/sync_ext
  }
}

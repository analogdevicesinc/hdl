# ***************************************************************************
# ***************************************************************************
# Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
#
# In this HDL repository, there are many different and unique modules, consisting
# of various HDL (Verilog or VHDL) components. The individual modules are
# developed independently, and may be accompanied by separate and unique license
# terms.
#
# The user should read each of these license terms, and understand the
# freedoms and responsibilities that he or she has by using this source/core.
#
# This core is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.
#
# Redistribution and use of source or resulting binaries, with or without modification
# of this file, are permitted under one of the following two license terms:
#
#   1. The GNU General Public License version 2 as published by the
#      Free Software Foundation, which can be found in the top level directory
#      of this repository (LICENSE_GPL2), and also online at:
#      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
#
# OR
#
#   2. An ADI specific BSD license, which can be found in the top level directory
#      of this repository (LICENSE_ADIBSD), and also on-line at:
#      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
#      This will allow to generate bit files and not release the source code,
#      as long as it attaches to an ADI device.
#
# ***************************************************************************
# ***************************************************************************

source ../../library/scripts/adi_env.tcl
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

global ad_project_params

set NUM_OF_CONVERTERS $ad_project_params(JESD_M)
set NUM_OF_LANES $ad_project_params(JESD_L)
set SAMPLES_PER_FRAME $ad_project_params(JESD_S)
set SAMPLE_WIDTH $ad_project_params(JESD_NP)

set DAC_DATA_WIDTH [expr $NUM_OF_LANES * 32]
set SAMPLES_PER_CHANNEL [expr $DAC_DATA_WIDTH / $NUM_OF_CONVERTERS / $SAMPLE_WIDTH]



# TX JESD204 PHY layer peripheral
ad_ip_instance axi_adxcvr dac_jesd204_xcvr [list \
  NUM_OF_LANES $NUM_OF_LANES \
  QPLL_ENABLE 0 \
  TX_OR_RX_N 1 \
]

# TX JESD204 link layer peripheral
adi_axi_jesd204_tx_create dac_jesd204_link $NUM_OF_LANES

# TX JESD204 transport layer peripheral
adi_tpl_jesd204_tx_create dac_jesd204_transport $NUM_OF_LANES \
                                                $NUM_OF_CONVERTERS \
                                                $SAMPLES_PER_FRAME \
                                                $SAMPLE_WIDTH



# RX JESD204 PHY layer peripheral
ad_ip_instance axi_adxcvr adc_jesd204_xcvr [list \
  NUM_OF_LANES $NUM_OF_LANES \
  QPLL_ENABLE 0 \
  TX_OR_RX_N 0 \
]

# RX JESD204 link layer peripheral
adi_axi_jesd204_rx_create adc_jesd204_link $NUM_OF_LANES

# RX JESD204 transport layer peripheral
adi_tpl_jesd204_rx_create adc_jesd204_transport $NUM_OF_LANES \
                                                $NUM_OF_CONVERTERS \
                                                $SAMPLES_PER_FRAME \
                                                $SAMPLE_WIDTH



ad_ip_instance util_adxcvr util_jesd204_xcvr [list \
  RX_NUM_OF_LANES $NUM_OF_LANES \
  TX_NUM_OF_LANES $NUM_OF_LANES \
  CPLL_FBDIV 4 \
  RX_CLK25_DIV 5 \
  TX_CLK25_DIV 5 \
  RX_OUT_DIV 2 \
  TX_OUT_DIV 2 \
]

ad_xcvrcon util_jesd204_xcvr dac_jesd204_xcvr dac_jesd204_link
ad_xcvrcon util_jesd204_xcvr adc_jesd204_xcvr adc_jesd204_link

# connect link layer to transport layer
ad_connect dac_jesd204_link/tx_data dac_jesd204_transport/link

ad_connect adc_jesd204_link/rx_sof adc_jesd204_transport/link_sof
ad_connect adc_jesd204_link/rx_data_tdata adc_jesd204_transport/link_data
ad_connect adc_jesd204_link/rx_data_tvalid adc_jesd204_transport/link_valid

# reference clocks & resets

create_bd_port -dir I ref_clk

ad_xcvrpll ref_clk util_jesd204_xcvr/qpll_ref_clk_*
ad_xcvrpll ref_clk util_jesd204_xcvr/cpll_ref_clk_*
ad_xcvrpll dac_jesd204_xcvr/up_pll_rst util_jesd204_xcvr/up_qpll_rst_*
ad_xcvrpll adc_jesd204_xcvr/up_pll_rst util_jesd204_xcvr/up_cpll_rst_*


ad_connect util_jesd204_xcvr/tx_out_clk_0 dac_jesd204_transport/link_clk
ad_connect util_jesd204_xcvr/tx_out_clk_0 adc_jesd204_transport/link_clk



#  ------------------
#  Test harness
#  ------------------

global mng_axi_cfg

# add interconnect
# config
ad_ip_instance axi_interconnect axi_cfg_interconnect [ list \
  NUM_SI {1} \
  NUM_MI {6} \
]


# Create instance: mng_axi , and set properties
# VIP for management port
ad_ip_instance axi_vip mng_axi_vip $mng_axi_cfg
adi_sim_add_define "MNG_AXI=mng_axi_vip"

ad_connect mng_axi_vip/M_AXI  axi_cfg_interconnect/S00_AXI
ad_connect axi_cfg_interconnect/M00_AXI dac_jesd204_xcvr/s_axi
ad_connect axi_cfg_interconnect/M01_AXI adc_jesd204_xcvr/s_axi
ad_connect axi_cfg_interconnect/M02_AXI dac_jesd204_link/s_axi
ad_connect axi_cfg_interconnect/M03_AXI adc_jesd204_link/s_axi
ad_connect axi_cfg_interconnect/M04_AXI dac_jesd204_transport/s_axi
ad_connect axi_cfg_interconnect/M05_AXI adc_jesd204_transport/s_axi


make_bd_pins_external  [get_bd_pins mng_axi_vip/aclk]
set_property NAME mng_clk [get_bd_ports /aclk_0]

create_bd_port -dir I mng_rst

ad_connect mng_rst axi_cfg_interconnect/ARESETN
ad_connect mng_rst axi_cfg_interconnect/S00_ARESETN
ad_connect mng_rst axi_cfg_interconnect/M00_ARESETN
ad_connect mng_rst axi_cfg_interconnect/M01_ARESETN
ad_connect mng_rst axi_cfg_interconnect/M02_ARESETN
ad_connect mng_rst axi_cfg_interconnect/M03_ARESETN
ad_connect mng_rst axi_cfg_interconnect/M04_ARESETN
ad_connect mng_rst axi_cfg_interconnect/M05_ARESETN

ad_connect mng_clk axi_cfg_interconnect/ACLK
ad_connect mng_clk axi_cfg_interconnect/S00_ACLK
ad_connect mng_clk axi_cfg_interconnect/M00_ACLK
ad_connect mng_clk axi_cfg_interconnect/M01_ACLK
ad_connect mng_clk axi_cfg_interconnect/M02_ACLK


# connect clocks
ad_connect mng_clk /dac_jesd204_xcvr/s_axi_aclk
ad_connect mng_clk /dac_jesd204_link/s_axi_aclk
ad_connect mng_clk /dac_jesd204_transport/s_axi_aclk
ad_connect mng_clk /adc_jesd204_xcvr/s_axi_aclk
ad_connect mng_clk /adc_jesd204_link/s_axi_aclk
ad_connect mng_clk /adc_jesd204_transport/s_axi_aclk
ad_connect mng_clk /util_jesd204_xcvr/up_clk
ad_connect mng_clk /axi_cfg_interconnect/M03_ACLK
ad_connect mng_clk /axi_cfg_interconnect/M04_ACLK
ad_connect mng_clk /axi_cfg_interconnect/M05_ACLK

# connect resets
ad_connect mng_rst /dac_jesd204_link/s_axi_aresetn
ad_connect mng_rst /dac_jesd204_transport/s_axi_aresetn
ad_connect mng_rst /adc_jesd204_link/s_axi_aresetn
ad_connect mng_rst /adc_jesd204_transport/s_axi_aresetn
ad_connect mng_rst mng_axi_vip/aresetn
ad_connect mng_rst adc_jesd204_xcvr/s_axi_aresetn
ad_connect mng_rst dac_jesd204_xcvr/s_axi_aresetn
ad_connect mng_rst util_jesd204_xcvr/up_rstn
ad_connect mng_rst dac_jesd204_link_rstgen/ext_reset_in

assign_bd_address

create_bd_port -dir I -from 31 -to 0 dac_data_0
create_bd_port -dir O link_clk

ad_connect dac_data_0 dac_jesd204_transport/dac_data_0
ad_connect util_jesd204_xcvr/tx_out_clk_0 link_clk

make_bd_pins_external  [get_bd_pins /dac_jesd204_transport/dac_dunf]
make_bd_pins_external  [get_bd_pins /adc_jesd204_transport/adc_dovf]

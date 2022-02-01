# ***************************************************************************
# ***************************************************************************
# Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
#
# Each core or library found in this collection may have its own licensing terms.
# The user should keep this in in mind while exploring these cores.
#
# Redistribution and use in source and binary forms,
# with or without modification of this file, are permitted under the terms of either
#  (at the option of the user):
#
#   1. The GNU General Public License version 2 as published by the
#      Free Software Foundation, which can be found in the top level directory, or at:
# https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
#
# OR
#
#   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
# https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
#
# ***************************************************************************
# ***************************************************************************

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_dds
adi_ip_files axi_dds [list \
  "$ad_hdl_dir/library/xilinx/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/ad_mux.v" \
  "$ad_hdl_dir/library/common/ad_mux_core.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine.v" \
  "$ad_hdl_dir/library/common/ad_dds_cordic_pipe.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine_cordic.v" \
  "$ad_hdl_dir/library/common/ad_dds_2.v" \
  "$ad_hdl_dir/library/common/ad_dds_1.v" \
  "$ad_hdl_dir/library/common/ad_dds.v" \
  "$ad_hdl_dir/library/common/ad_iqcor.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_dac_common.v" \
  "$ad_hdl_dir/library/common/up_dac_channel.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "$ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_common/up_tpl_common.v" \
  "ad_ip_jesd204_tpl_dac_channel.v" \
  "ad_ip_jesd204_tpl_dac_core.v" \
  "ad_ip_jesd204_tpl_dac_regmap.v" \
  "ad_ip_jesd204_tpl_dac_pn.v" \
  "ad_ip_jesd204_tpl_dac.v" ]

adi_ip_properties axi_dds
#adi_ip_ttcl axi_spi_engine "spi_engine_offload_constr.ttcl"

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals} [ipx::current_core]

#ipx::remove_all_bus_interface [ipx::current_core]


adi_add_bus "m_axis_dds" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"m_axis_dds_valid" "TVALID"} \
		{"m_axis_dds_ready" "TREADY"} \
		{"m_axis_dds_data" "TDATA"} \
	}

adi_add_bus_clock "spi_clk" "m_axis_dds"


#adi_add_bus "spi_engine_ctrl" "master" \
  "analog.com:interface:spi_engine_ctrl_rtl:1.0" \
  "analog.com:interface:spi_engine_ctrl:1.0" \
#  {
#    {"cmd_ready" "CMD_READY"} \
    {"cmd_valid" "CMD_VALID"} \
    {"cmd" "CMD_DATA"} \
    {"sdo_data_ready" "SDO_READY"} \
    {"sdo_data_valid" "SDO_VALID"} \
    {"sdo_data" "SDO_DATA"} \
    {"sdi_data_ready" "SDI_READY"} \
    {"sdi_data_valid" "SDI_VALID"} \
    {"sdi_data" "SDI_DATA"} \
    {"sync_ready" "SYNC_READY"} \
    {"sync_valid" "SYNC_VALID"} \
    {"sync_data" "SYNC_DATA"} \
#  }

#adi_add_bus_clock "spi_clk" "spi_engine_ctrl"

set cc [ipx::current_core]

ipx::save_core $cc

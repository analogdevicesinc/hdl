###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_pulsar_lvds

adi_ip_files axi_pulsar_lvds [list \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_in.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_pulsar_lvds_if.v" \
  "axi_pulsar_lvds_channel.v" \
  "axi_pulsar_lvds.v" ]

adi_ip_properties axi_pulsar_lvds

adi_add_bus "fifo_wr" "master" \
        "analog.com:interface:fifo_wr_rtl:1.0" \
        "analog.com:interface:fifo_wr:1.0" \
        { \
                {"adc_valid" "EN"} \
                {"adc_data" "DATA"} \
                {"adc_dovf" "OVERFLOW"} \
        }
adi_add_bus_clock "fifo_wr_clk" "fifo_wr"

adi_init_bd_tcl
adi_ip_bd axi_pulsar_lvds "bd/bd.tcl"

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
	analog.com:$VIVADO_IP_LIBRARY:util_rst:1.0 \
]

set cc [ipx::current_core]

ipx::infer_bus_interface ref_clk xilinx.com:signal:clock_rtl:1.0   $cc
ipx::infer_bus_interface dco_p   xilinx.com:signal:clock_rtl:1.0   $cc
ipx::infer_bus_interface dco_n   xilinx.com:signal:clock_rtl:1.0   $cc

adi_add_auto_fpga_spec_params

ipx::create_xgui_files $cc
ipx::save_core $cc

###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_adc_trigger
adi_ip_files axi_adc_trigger [list \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "axi_adc_trigger_constr.xdc" \
  "axi_adc_trigger_reg.v" \
  "axi_adc_trigger.v" ]

adi_ip_properties axi_adc_trigger

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_adc_trigger} [ipx::current_core]

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface reset xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]


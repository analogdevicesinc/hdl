###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_var_fifo
adi_ip_files util_var_fifo [list \
  "util_var_fifo.v" ]

adi_ip_properties_lite util_var_fifo

set_property company_url {https://wiki.analog.com/resources/fpga/docs/util_var_fifo} [ipx::current_core]

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]



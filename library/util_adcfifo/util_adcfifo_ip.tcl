###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create util_adcfifo
adi_ip_files util_adcfifo [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_axis_inf_rx.v" \
  "$ad_hdl_dir/library/common/ad_mem_asym.v" \
  "util_adcfifo.v" \
  "util_adcfifo_constr.xdc" ]

adi_ip_properties_lite util_adcfifo

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

ipx::infer_bus_interface adc_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface adc_rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::infer_bus_interface dma_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]

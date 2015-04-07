# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_adcfifo_axi
adi_ip_files util_adcfifo_axi [list \
  "$ad_hdl_dir/library/common/ad_mem.v" \
  "$ad_hdl_dir/library/common/ad_mem_asym.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/ad_axis_inf_rx.v" \
  "util_adcfifo_axi_adc.v" \
  "util_adcfifo_axi_dma.v" \
  "util_adcfifo_axi_wr.v" \
  "util_adcfifo_axi_rd.v" \
  "util_adcfifo_axi.v" \
  "util_adcfifo_axi_constr.xdc" ]

adi_ip_properties_lite util_adcfifo_axi
adi_ip_constraints util_adcfifo_axi [list \
  "util_adcfifo_axi_constr.xdc" ]

ipx::infer_bus_interfaces {{xilinx.com:interface:aximm:1.0}} [ipx::current_core]

ipx::save_core [ipx::current_core]


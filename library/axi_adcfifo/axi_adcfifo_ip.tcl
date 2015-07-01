# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_adcfifo
adi_ip_files axi_adcfifo [list \
  "$ad_hdl_dir/library/common/ad_mem.v" \
  "$ad_hdl_dir/library/common/ad_mem_asym.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/ad_axis_inf_rx.v" \
  "axi_adcfifo_adc.v" \
  "axi_adcfifo_dma.v" \
  "axi_adcfifo_wr.v" \
  "axi_adcfifo_rd.v" \
  "axi_adcfifo.v" \
  "axi_adcfifo_constr.xdc" ]

adi_ip_properties_lite axi_adcfifo
adi_ip_constraints axi_adcfifo [list \
  "axi_adcfifo_constr.xdc" ]

ipx::infer_bus_interfaces {{xilinx.com:interface:aximm:1.0}} [ipx::current_core]

ipx::save_core [ipx::current_core]


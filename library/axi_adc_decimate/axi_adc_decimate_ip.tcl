# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_adc_decimate
adi_ip_files axi_adc_decimate [list \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_iqcor.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_mul.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "fir_decim.v" \
  "cic_decim.v" \
  "axi_adc_decimate_filter.v" \
  "axi_adc_decimate_reg.v" \
  "axi_adc_decimate.v" ]

adi_ip_properties axi_adc_decimate

adi_ip_add_core_dependencies { \
  analog.com:user:util_cic:1.0 \
}

ipx::infer_bus_interface adc_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface adc_rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]


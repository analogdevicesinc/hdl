# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_fifo2dac
adi_ip_files axi_fifo2dac [list \
  "$ad_hdl_dir/library/common/ad_mem.v" \
  "axi_fifo2dac.v" ]

adi_ip_properties_lite axi_fifo2dac

ipx::save_core [ipx::current_core]


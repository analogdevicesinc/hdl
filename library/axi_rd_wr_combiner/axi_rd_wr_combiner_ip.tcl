# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_rd_wr_combiner
adi_ip_files axi_rd_wr_combiner [list \
  "axi_rd_wr_combiner.v" \
  ]

adi_ip_properties_lite axi_rd_wr_combiner
adi_ip_infer_mm_interfaces axi_rd_wr_combiner

# Dummy clock to helper with clock rate and clock domain propagation to the
# interface
adi_add_bus_clock "clk" "m_axi:s_wr_axi:s_rd_axi"

ipx::save_core [ipx::current_core]

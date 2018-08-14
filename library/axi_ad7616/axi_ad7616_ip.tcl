# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ad7616
adi_ip_files axi_ad7616 [list \
    "$ad_hdl_dir/library/common/ad_edge_detect.v" \
    "$ad_hdl_dir/library/common/up_axi.v" \
    "axi_ad7616_control.v" \
    "axi_ad7616_pif.v" \
    "axi_ad7616_maxis2wrfifo.v" \
    "axi_ad7616.v" ]

adi_ip_properties axi_ad7616

adi_ip_add_core_dependencies { \
    analog.com:user:spi_engine_execution:1.0 \
    analog.com:user:axi_spi_engine:1.0 \
    analog.com:user:spi_engine_offload:1.0 \
    analog.com:user:spi_engine_interconnect:1.0 \
}

set_property DRIVER_VALUE "0" [ipx::get_ports rx_db_i]

ipx::save_core [ipx::current_core]


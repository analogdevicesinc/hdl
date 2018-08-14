source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_sigma_delta_spi
adi_ip_files util_sigma_delta_spi [list \
	  "util_sigma_delta_spi.v" \
]

adi_ip_properties_lite util_sigma_delta_spi

adi_add_bus "m_spi" "master" \
	"analog.com:interface:spi_master_rtl:1.0" \
	"analog.com:interface:spi_master:1.0" \
	{
		{"m_sclk" "SCLK"} \
		{"m_sdi" "SDI"} \
		{"m_sdo" "SDO"} \
		{"m_sdo_t" "SDO_T"} \
		{"m_cs" "CS"} \
	}

adi_add_bus "s_spi" "slave" \
	"analog.com:interface:spi_master_rtl:1.0" \
	"analog.com:interface:spi_master:1.0" \
	{
		{"s_sclk" "SCLK"} \
		{"s_sdi" "SDI"} \
		{"s_sdo" "SDO"} \
		{"s_sdo_t" "SDO_T"} \
		{"s_cs" "CS"} \
	}

adi_add_bus_clock "clk" "m_spi:s_spi" "resetn"

ipx::save_core [ipx::current_core]

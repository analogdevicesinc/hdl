###############################################################################
## Copyright (C) 2024 - 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::parse_module ./spi_engine_interconnect.v]
set ip $::ipl::ip

set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]

set ip [ipl::general \
    -vlnv "analog.com:ip:spi_engine_interconnect:1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2023.2" \
    -min_esi_version "2023.2" -ip $ip]

set ip [ipl::general -ip $ip -display_name "AXI SPI Engine interconnect ADI"]
set ip [ipl::general -ip $ip -supported_products {*}]
set ip [ipl::general -ip $ip -supported_platforms {esi radiant}]
set ip [ipl::general -ip $ip -href "https://analogdevicesinc.github.io/hdl/library/spi_engine/spi_engine_interconnect.html#spi-engine-interconnect"]

set ip [ipl::add_interface -ip $ip \
    -inst_name m_ctrl \
    -display_name m_ctrl \
    -description m_ctrl \
    -master_slave master \
    -portmap { \
        {"m_cmd_ready" "CMD_READY"} \
        {"m_cmd_valid" "CMD_VALID"} \
        {"m_cmd_data" "CMD_DATA"} \
        {"m_sdo_ready" "SDO_READY"} \
        {"m_sdo_valid" "SDO_VALID"} \
        {"m_sdo_data" "SDO_DATA"} \
        {"m_sdi_ready" "SDI_READY"} \
        {"m_sdi_valid" "SDI_VALID"} \
        {"m_sdi_data" "SDI_DATA"} \
        {"m_sync_ready" "SYNC_READY"} \
        {"m_sync_valid" "SYNC_VALID"} \
        {"m_sync" "SYNC_DATA"} \
    } \
    -vlnv {analog.com:ADI:spi_engine_ctrl:1.0}]

foreach prefix [list "s0" "s1"] {
    set ip [ipl::add_interface -ip $ip \
        -inst_name ${prefix}_ctrl \
        -display_name ${prefix}_ctrl \
        -description ${prefix}_ctrl \
        -master_slave slave \
        -portmap [list \
			[list [format "%s_cmd_ready" $prefix] "CMD_READY"] \
			[list [format "%s_cmd_valid" $prefix] "CMD_VALID"] \
			[list [format "%s_cmd_data" $prefix] "CMD_DATA"] \
			[list [format "%s_sdo_ready" $prefix] "SDO_READY"] \
			[list [format "%s_sdo_valid" $prefix] "SDO_VALID"] \
			[list [format "%s_sdo_data" $prefix] "SDO_DATA"] \
			[list [format "%s_sdi_ready" $prefix] "SDI_READY"] \
			[list [format "%s_sdi_valid" $prefix] "SDI_VALID"] \
			[list [format "%s_sdi_data" $prefix] "SDI_DATA"] \
			[list [format "%s_sync_ready" $prefix] "SYNC_READY"] \
			[list [format "%s_sync_valid" $prefix] "SYNC_VALID"] \
			[list [format "%s_sync" $prefix] "SYNC_DATA"] \
        ] \
        -vlnv {analog.com:ADI:spi_engine_ctrl:1.0}]
}

set ip [ipl::add_ip_files -ip $ip -dpath rtl -flist [list \
    "spi_engine_interconnect.v" ]]

set ip [ipl::set_parameter -ip $ip \
    -id DATA_WIDTH \
    -type param \
    -value_type int \
    -conn_mod spi_engine_interconnect \
    -title {Parallel data width} \
    -default 8 \
    -output_formatter nostr \
    -value_range {(8, 256)} \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id NUM_OF_SDI \
    -type param \
    -value_type int \
    -conn_mod spi_engine_interconnect \
    -title {Number of MISO lines} \
    -default 1 \
    -output_formatter nostr \
    -value_range {(1, 8)} \
    -group1 {General Configuration} \
    -group2 Config]

ipl::generate_ip $ip

###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::getmod ./spi_axis_reorder.v]
set ip $::ipl::ip

set ip [ipl::addports -ip $ip -mod_data $mod_data]

set ip [ipl::general -ip $ip -name [dict get $mod_data mod_name]]
set ip [ipl::general -ip $ip -display_name "AXI SPI Engine AXIS Reorder ADI"]
set ip [ipl::general -ip $ip -supported_products {*}]
set ip [ipl::general -ip $ip -supported_platforms {esi radiant}]
set ip [ipl::general -ip $ip -href "https://analogdevicesinc.github.io/hdl/library/spi_engine/index.html#"]
set ip [ipl::general  -vendor "analog.com" \
    -library "ip" \
    -version "1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2022.1" \
    -min_esi_version "2022.1" -ip $ip]

set ip [ipl::addif -ip $ip \
    -iname m_axis \
    -display_name m_axis \
    -description m_axis \
    -master_slave master \
    -portmap { \
        {"m_axis_ready" "TREADY"} \
        {"m_axis_valid" "TVALID"} \
        {"m_axis_data" "TDATA"}
    } \
    -vendor amba.com -library AMBA4 -name AXI4Stream -version r0p0]

set ip [ipl::addif -ip $ip \
    -iname s_axis \
    -display_name s_axis \
    -description s_axis \
    -master_slave slave \
    -portmap { \
        {"s_axis_ready" "TREADY"} \
        {"s_axis_valid" "TVALID"} \
        {"s_axis_data" "TDATA"}
    } \
    -vendor amba.com -library AMBA4 -name AXI4Stream -version r0p0]

set ip [ipl::addfiles -spath ./ -dpath rtl -extl {*.v} -ip $ip]

set ip [ipl::settpar -ip $ip \
    -id NUM_OF_LANES \
    -type param \
    -value_type int \
    -conn_mod spi_axis_reorder \
    -title {Num Of Lanes} \
    -default 2 \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]

ipl::genip $ip
ipl::genip $ip ./

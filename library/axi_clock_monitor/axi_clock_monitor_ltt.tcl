###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::getmod ./axi_clock_monitor.v]
set ip $::ipl::ip

set ip [ipl::addports -ip $ip -mod_data $mod_data]

set ip [ipl::general \
    -name [dict get $mod_data mod_name] \
    -display_name "ADI AXI clock monitor" \
    -supported_products {*} \
    -supported_platforms {esi radiant} \
    -href "https://wiki.analog.com/resources/fpga/docs/axi_clock_monitor" \
    -vendor "analog.com" \
    -library "ip" \
    -version "1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2023.1" \
    -min_esi_version "2023.1" -ip $ip]

set ip [ipl::mmap -ip $ip \
    -name "axi_clock_monitor_mem_map" \
    -description "axi_clock_monitor_mem_map" \
    -baseAddress 0 \
    -range 4096 \
    -width 32]

set ip [ipl::addifa -ip $ip -mod_data $mod_data -iname s_axi -v_name s_axi \
    -exept_pl [list s_axi_aclk s_axi_aresetn] \
    -display_name s_axi \
    -description s_axi \
    -master_slave slave \
    -mmap_ref axi_clock_monitor_mem_map \
    -vendor amba.com -library AMBA4 -name AXI4-Lite -version r0p0 ]

set ip [ipl::settpar -ip $ip \
    -id ID \
    -type param \
    -value_type int \
    -conn_mod axi_clock_monitor \
    -title {ID} \
    -default 0 \
    -output_formatter nostr \
    -group1 {General configurations} \
    -group2 Global]
set ip [ipl::settpar -ip $ip \
    -id NUM_OF_CLOCKS \
    -type param \
    -value_type int \
    -conn_mod axi_clock_monitor \
    -title {Number of clocks} \
    -default 1 \
    -output_formatter nostr \
    -value_range {(1, 16)} \
    -group1 {General configurations} \
    -group2 Global]

for {set i 0} {$i < 16} {incr i} {
    set ip [ipl::igports -ip $ip -portlist clock_$i \
        -expression "not(NUM_OF_CLOCKS > $i)"]
}

set ip [ipl::addfiles -spath ./ -dpath rtl -extl {axi_clock_monitor.v} -ip $ip]
set ip [ipl::addfiles -spath ../common -dpath rtl -ip $ip \
    -extl {up_clock_mon.v up_axi.v}]

ipl::genip $ip
ipl::genip $ip ./

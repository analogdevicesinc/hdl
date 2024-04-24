###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::getmod ./axi_clock_monitor.v]
set ip $::ipl::ip

set ip [ipl::addports -ip $ip -mod_data $mod_data]
set ip [ipl::addpars -ip $ip -mod_data $mod_data]

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

set ip [ipl::igports -ip $ip -portlist {clock_1} -expression {not(NUM_OF_CLOCKS > 1)}]
set ip [ipl::igports -ip $ip -portlist {clock_2} -expression {not(NUM_OF_CLOCKS > 2)}]
set ip [ipl::igports -ip $ip -portlist {clock_3} -expression {not(NUM_OF_CLOCKS > 3)}]
set ip [ipl::igports -ip $ip -portlist {clock_4} -expression {not(NUM_OF_CLOCKS > 4)}]
set ip [ipl::igports -ip $ip -portlist {clock_5} -expression {not(NUM_OF_CLOCKS > 5)}]
set ip [ipl::igports -ip $ip -portlist {clock_6} -expression {not(NUM_OF_CLOCKS > 6)}]
set ip [ipl::igports -ip $ip -portlist {clock_7} -expression {not(NUM_OF_CLOCKS > 7)}]
set ip [ipl::igports -ip $ip -portlist {clock_8} -expression {not(NUM_OF_CLOCKS > 8)}]
set ip [ipl::igports -ip $ip -portlist {clock_9} -expression {not(NUM_OF_CLOCKS > 9)}]
set ip [ipl::igports -ip $ip -portlist {clock_10} -expression {not(NUM_OF_CLOCKS > 10)}]
set ip [ipl::igports -ip $ip -portlist {clock_11} -expression {not(NUM_OF_CLOCKS > 11)}]
set ip [ipl::igports -ip $ip -portlist {clock_12} -expression {not(NUM_OF_CLOCKS > 12)}]
set ip [ipl::igports -ip $ip -portlist {clock_13} -expression {not(NUM_OF_CLOCKS > 13)}]
set ip [ipl::igports -ip $ip -portlist {clock_14} -expression {not(NUM_OF_CLOCKS > 14)}]
set ip [ipl::igports -ip $ip -portlist {clock_15} -expression {not(NUM_OF_CLOCKS > 15)}]

set ip [ipl::setport -ip $ip -name s_axi_aclk -port_type clock]
set ip [ipl::setport -ip $ip -name s_axi_aresetn -port_type reset]
set ip [ipl::setport -ip $ip -name clock_0 -port_type clock]

set ip [ipl::addfiles -spath ./ -dpath rtl -extl {axi_clock_monitor.v} -ip $ip]
set ip [ipl::addfiles -spath ../common -dpath rtl -ip $ip \
    -extl {up_clock_mon.v up_axi.v}]

ipl::genip $ip
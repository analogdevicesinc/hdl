###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::parse_module ./axi_pulse_gen.v]
set ip $::ipl::ip

set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]

set ip [ipl::general \
    -name [dict get $mod_data mod_name] \
    -display_name "ADI AXI Pulse generator" \
    -supported_products {*} \
    -supported_platforms {esi radiant} \
    -href "https://wiki.analog.com/resources/fpga/docs/axi_pwm_gen" \
    -vendor "analog.com" \
    -library "ip" \
    -version "1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2023.1" \
    -min_esi_version "2023.1" -ip $ip]

set ip [ipl::add_memory_map -ip $ip \
    -name "axi_pulse_gen_mem_map" \
    -description "axi_pulse_gen_mem_map" \
    -baseAddress 0 \
    -range 65536 \
    -width 32]

set ip [ipl::add_interface_by_prefix -ip $ip -mod_data $mod_data -inst_name s_axi -v_prefix s_axi \
    -xptn_portlist [list s_axi_aclk s_axi_aresetn] \
    -display_name s_axi \
    -description s_axi \
    -master_slave slave \
    -mem_map_ref axi_pulse_gen_mem_map \
    -vendor amba.com -library AMBA4 -name AXI4-Lite -version r0p0 ]

set ip [ipl::set_parameter -ip $ip \
    -id ASYNC_CLK_EN \
    -type param \
    -value_type int \
    -conn_mod axi_pulse_gen \
    -title {ASYNC_CLK_EN} \
    -options {[(True, 1), (False, 0)]} \
    -default 1 \
    -output_formatter nostr \
    -group1 {AXI Pulse Generator} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id PULSE_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_pulse_gen \
    -title {Pulse width} \
    -default 7 \
    -output_formatter nostr \
    -value_range {(0, 2147483647)} \
    -group1 {AXI Pulse Generator} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id PULSE_PERIOD \
    -type param \
    -value_type int \
    -conn_mod axi_pulse_gen \
    -title {Pulse period} \
    -default 10 \
    -output_formatter nostr \
    -value_range {(0, 2147483647)} \
    -group1 {AXI Pulse Generator} \
    -group2 Config]

set ip [ipl::ignore_ports -ip $ip -portlist ext_clk -expression {(ASYNC_CLK_EN == 0)}]

set ip [ipl::add_ip_files_auto -spath ./ -dpath rtl -ip $ip \
    -extl {*.v *.sv}]
set ip [ipl::add_ip_files_auto -spath ../common -dpath rtl -ip $ip \
    -extl {ad_rst.v up_axi.v util_pulse_gen.v}]
set ip [ipl::add_ip_files_auto -spath ../util_cdc -dpath rtl -extl {*.v} -ip $ip]

ipl::generate_ip $ip
ipl::generate_ip $ip ./

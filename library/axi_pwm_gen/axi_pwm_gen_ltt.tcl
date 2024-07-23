###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::getmod ./axi_pwm_gen.sv]
set ip $::ipl::ip

set ip [ipl::addports -ip $ip -mod_data $mod_data]

set ip [ipl::general \
    -name [dict get $mod_data mod_name] \
    -display_name "ADI AXI PWM generator" \
    -supported_products {*} \
    -supported_platforms {esi radiant} \
    -href "https://analogdevicesinc.github.io/hdl/library/axi_pwm_gen/index.html" \
    -vendor "analog.com" \
    -library "ip" \
    -version "1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2023.1" \
    -min_esi_version "2023.1" -ip $ip]

set ip [ipl::mmap -ip $ip \
    -name "axi_pwm_gen_mem_map" \
    -description "axi_pwm_gen_mem_map" \
    -baseAddress 0 \
    -range 65536 \
    -width 32]

set ip [ipl::addifa -ip $ip -mod_data $mod_data -iname s_axi -v_name s_axi \
    -exept_pl [list s_axi_aclk s_axi_aresetn] \
    -display_name s_axi \
    -description s_axi \
    -master_slave slave \
    -mmap_ref axi_pwm_gen_mem_map \
    -vendor amba.com -library AMBA4 -name AXI4-Lite -version r0p0 ]

set ip [ipl::settpar -ip $ip \
    -id N_PWMS \
    -type param \
    -value_type int \
    -conn_mod axi_pwm_gen \
    -title {Number of pwms} \
    -default 1 \
    -output_formatter nostr \
    -value_range {(1, 16)} \
    -group1 {General configurations} \
    -group2 Global]
set ip [ipl::settpar -ip $ip \
    -id ASYNC_CLK_EN \
    -type param \
    -value_type int \
    -conn_mod axi_pwm_gen \
    -title {ASYNC_CLK_EN} \
    -options {[(True, 1), (False, 0)]} \
    -default 1 \
    -output_formatter nostr \
    -group1 {General configurations} \
    -group2 Global]
set ip [ipl::settpar -ip $ip \
    -id PWM_EXT_SYNC \
    -type param \
    -value_type int \
    -conn_mod axi_pwm_gen \
    -title {External sync} \
    -options {[(True, 1), (False, 0)]} \
    -default 0 \
    -output_formatter nostr \
    -group1 {General configurations} \
    -group2 Global]
set ip [ipl::settpar -ip $ip \
    -id EXT_ASYNC_SYNC \
    -type param \
    -value_type int \
    -conn_mod axi_pwm_gen \
    -title {External sync signal is asynchronous} \
    -options {[(True, 1), (False, 0)]} \
    -editable {(PWM_EXT_SYNC == 1)} \
    -default 0 \
    -output_formatter nostr \
    -group1 {General configurations} \
    -group2 Global]
set ip [ipl::settpar -ip $ip \
    -id EXT_SYNC_PHASE_ALIGN \
    -type param \
    -value_type int \
    -conn_mod axi_pwm_gen \
    -title {External sync enable phase align} \
    -options {[(True, 1), (False, 0)]} \
    -editable {(PWM_EXT_SYNC == 1)} \
    -default 0 \
    -output_formatter nostr \
    -group1 {General configurations} \
    -group2 Global]
set ip [ipl::settpar -ip $ip \
    -id SOFTWARE_BRINGUP \
    -type param \
    -value_type int \
    -conn_mod axi_pwm_gen \
    -title {Require software bringup} \
    -options {[(True, 1), (False, 0)]} \
    -default 1 \
    -output_formatter nostr \
    -group1 {General configurations} \
    -group2 Global]
set ip [ipl::settpar -ip $ip \
    -id FORCE_ALIGN \
    -type param \
    -value_type int \
    -conn_mod axi_pwm_gen \
    -title {Force align} \
    -options {[(True, 1), (False, 0)]} \
    -default 0 \
    -output_formatter nostr \
    -group1 {General configurations} \
    -group2 Global]
set ip [ipl::settpar -ip $ip \
    -id START_AT_SYNC \
    -type param \
    -value_type int \
    -conn_mod axi_pwm_gen \
    -title {Start at sync} \
    -options {[(True, 1), (False, 0)]} \
    -default 1 \
    -output_formatter nostr \
    -group1 {General configurations} \
    -group2 Global]

for {set i 0} {$i < 16} {incr i} {
    set ip [ipl::igports -ip $ip -portlist [list pwm_$i] \
        -expression "not(N_PWMS > $i)"]
    set ip [ipl::settpar -ip $ip \
        -id PULSE_${i}_WIDTH \
        -type param \
        -value_type int \
        -conn_mod axi_pwm_gen \
        -title "PULSE ${i} width" \
        -default 7 \
        -output_formatter nostr \
        -value_range {(0, 2147483647)} \
        -editable "(N_PWMS > $i)" \
        -group1 "pwm_$i" \
        -group2 Global]
    set ip [ipl::settpar -ip $ip \
        -id PULSE_${i}_PERIOD \
        -type param \
        -value_type int \
        -conn_mod axi_pwm_gen \
        -title "PULSE ${i} period" \
        -default 10 \
        -output_formatter nostr \
        -value_range {(0, 2147483647)} \
        -editable "(N_PWMS > $i)" \
        -group1 "pwm_$i" \
        -group2 Global]
    set ip [ipl::settpar -ip $ip \
        -id PULSE_${i}_OFFSET \
        -type param \
        -value_type int \
        -conn_mod axi_pwm_gen \
        -title "PULSE ${i} offset" \
        -default 0 \
        -output_formatter nostr \
        -value_range {(0, 2147483647)} \
        -editable "(N_PWMS > $i)" \
        -group1 "pwm_$i" \
        -group2 Global]
}

set ip [ipl::igports -ip $ip -portlist ext_clk -expression {(ASYNC_CLK_EN == 0)}]
set ip [ipl::igports -ip $ip -portlist ext_sync -expression {(PWM_EXT_SYNC == 0)}]

set ip [ipl::addfiles -spath ./ -dpath rtl -ip $ip \
    -extl {*.v *.sv}]
set ip [ipl::addfiles -spath ../common -dpath rtl -ip $ip \
    -extl {ad_rst.v up_axi.v}]
set ip [ipl::addfiles -spath ../util_cdc -dpath rtl -extl {*.v} -ip $ip]

ipl::genip $ip
ipl::genip $ip ./


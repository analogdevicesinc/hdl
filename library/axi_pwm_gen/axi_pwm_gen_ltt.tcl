###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::getmod ./axi_pwm_gen.sv]
set ip $::ipl::ip

set ip [ipl::addports -ip $ip -mod_data $mod_data]
set ip [ipl::addpars -ip $ip -mod_data $mod_data]

set ip [ipl::general \
    -name [dict get $mod_data mod_name] \
    -display_name "ADI AXI PWM generator" \
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


for {set i 1} {$i < 16} {incr i} {
    set ip [ipl::igports -ip $ip -portlist [list pwm_$i] -expression "not(N_PWMS > $i)"]
    set ip [ipl::settpar -ip $ip -id PULSE_${i}_WIDTH -hidden "not(N_PWMS > $i)"]
    set ip [ipl::settpar -ip $ip -id PULSE_${i}_PERIOD -hidden "not(N_PWMS > $i)"]
    set ip [ipl::settpar -ip $ip -id PULSE_${i}_OFFSET -hidden "not(N_PWMS > $i)"]
}

for {set i 0} {$i < 16} {incr i} {
    set ip [ipl::settpar -ip $ip -id PULSE_${i}_WIDTH -group2 pwm_$i]
    set ip [ipl::settpar -ip $ip -id PULSE_${i}_PERIOD -group2 pwm_$i]
    set ip [ipl::settpar -ip $ip -id PULSE_${i}_OFFSET -group2 pwm_$i]
}

set ip [ipl::igports -ip $ip -portlist ext_clk -expression {(ASYNC_CLK_EN == 0)}]
set ip [ipl::igports -ip $ip -portlist ext_sync -expression {(PWM_EXT_SYNC == 0)}]

set ip [ipl::settpar -ip $ip -id ASYNC_CLK_EN -options {[(True, 1), (False, 0)]}]
set ip [ipl::settpar -ip $ip -id PWM_EXT_SYNC -options {[(True, 1), (False, 0)]}]
set ip [ipl::settpar -ip $ip -id EXT_ASYNC_SYNC -options {[(True, 1), (False, 0)]}]
set ip [ipl::settpar -ip $ip -id EXT_ASYNC_SYNC -hidden {(PWM_EXT_SYNC == 0)}]

set ip [ipl::addfiles -spath ./ -dpath rtl -ip $ip \
    -extl {*.v *.sv}]
set ip [ipl::addfiles -spath ../common -dpath rtl -ip $ip \
    -extl {ad_rst.v up_axi.v}]
set ip [ipl::addfiles -spath ../util_cdc -dpath rtl -extl {*.v} -ip $ip]

ipl::genip $ip
###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::parse_module ./sysid_rom.v]
set ip $::ipl::ip

set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]

set ip [ipl::general -ip $ip \
    -display_name "sysid_rom" \
    -supported_products {*} \
    -supported_platforms {esi radiant} \
    -href "<Web link to the IP docs>" \
    -vlnv "analog.com:ip:sysid_rom:1.0" \
    -category "CUSTOM_IP" \
    -keywords "sysid_rom" \
    -min_radiant_version "2023.2" \
    -min_esi_version "2023.2"]

# Use this only if you don't want to costumize the IP parameters!
set ip [ipl::add_parameters_from_module -ip $ip -mod_data $mod_data]

set ip [ipl::add_ip_files -ip $ip -dpath rtl -flist [list \
   sysid_rom.v \
]]

set ip [ipl::set_parameter -ip $ip \
   -id {PATH_TO_FILE} \
   -type param \
   -value_type string \
   -conn_mod {sysid_rom} \
   -default {sysid_init_file.mem} \
   -output_formatter str \
   -description "PATH_TO_FILE" \
   -group1 "PARAMS" \
   -group2 "GLOB"]

ipl::generate_ip $ip

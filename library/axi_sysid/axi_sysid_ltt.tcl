###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::parse_module ./axi_sysid.v]
set ip $::ipl::ip

set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]

set ip [ipl::general -ip $ip \
    -display_name "axi_sysid" \
    -supported_products {*} \
    -supported_platforms {esi radiant} \
    -href "<Web link to the IP docs>" \
    -vlnv "analog.com:ip:axi_sysid:1.0" \
    -category "CUSTOM_IP" \
    -keywords "axi_sysid" \
    -min_radiant_version "2023.2" \
    -min_esi_version "2023.2"]

set ip [ipl::add_axi_interfaces -ip $ip -mod_data $mod_data]

# Use this only if you don't want to costumize the IP parameters!
set ip [ipl::add_parameters_from_module -ip $ip -mod_data $mod_data]

set ip [ipl::add_ip_files -ip $ip -dpath rtl -flist [list \
   axi_sysid.v \
   ../common/up_axi.v \
]]

ipl::generate_ip $ip

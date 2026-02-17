
###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::parse_module ./spi_sdo_sin_tb.sv]
set ip $::ipl::ip

set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]

set ip [ipl::general -ip $ip \
    -display_name "spi_sdo_sin_tb" \
    -supported_products {*} \
    -supported_platforms {esi radiant} \
    -href "<Web link to the IP docs>" \
    -vlnv "analog.com:sim_model:spi_sdo_sin_tb:1.0" \
    -category "Verification IP" \
    -keywords "spi_sdo_sin_tb" \
    -min_radiant_version "2023.2" \
    -min_esi_version "2023.2"]

set ip [ipl::add_parameters_from_module -ip $ip -mod_data $mod_data]

set ip [ipl::add_ip_files -ip $ip -dpath rtl -flist [list \
   spi_sdo_sin_tb.sv \
]]

ipl::generate_ip $ip

###############################################################################
## Copyright (C) 2024 - 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::parse_module ./spi_axis_reorder.v]
set ip $::ipl::ip

set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]

set ip [ipl::general \
    -vlnv "analog.com:ip:spi_axis_reorder:1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2023.2" \
    -min_esi_version "2023.2" -ip $ip]

set ip [ipl::general -ip $ip -display_name "AXI SPI Engine AXIS Reorder ADI"]
set ip [ipl::general -ip $ip -supported_products {*}]
set ip [ipl::general -ip $ip -supported_platforms {esi radiant}]
set ip [ipl::general -ip $ip -href "https://analogdevicesinc.github.io/hdl/library/spi_engine/index.html#"]

set ip [ipl::add_interface -ip $ip \
    -inst_name m_axis \
    -display_name m_axis \
    -description m_axis \
    -master_slave master \
    -portmap { \
        {"m_axis_ready" "TREADY"} \
        {"m_axis_valid" "TVALID"} \
        {"m_axis_data" "TDATA"}
    } \
    -vlnv {amba.com:AMBA4:AXI4Stream:r0p0}]

set ip [ipl::add_interface -ip $ip \
    -inst_name s_axis \
    -display_name s_axis \
    -description s_axis \
    -master_slave slave \
    -portmap { \
        {"s_axis_ready" "TREADY"} \
        {"s_axis_valid" "TVALID"} \
        {"s_axis_data" "TDATA"}
    } \
    -vlnv {amba.com:AMBA4:AXI4Stream:r0p0}]

set ip [ipl::add_ip_files -ip $ip -dpath rtl -flist [list \
    "spi_axis_reorder.v" ]]

set ip [ipl::set_parameter -ip $ip \
    -id NUM_OF_LANES \
    -type param \
    -value_type int \
    -conn_mod spi_axis_reorder \
    -title {Num Of Lanes} \
    -default 2 \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]

ipl::generate_ip $ip

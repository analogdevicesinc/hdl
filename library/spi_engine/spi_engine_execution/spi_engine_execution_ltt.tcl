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

set mod_data [ipl::parse_module ./spi_engine_execution.v]
set ip $::ipl::ip

set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]

set ip [ipl::general \
    -vlnv "analog.com:ip:spi_engine_execution:1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2023.2" \
    -min_esi_version "2023.2" -ip $ip]

set ip [ipl::general -ip $ip -display_name "AXI SPI Engine execution ADI"]
set ip [ipl::general -ip $ip -supported_products {*}]
set ip [ipl::general -ip $ip -supported_platforms {esi radiant}]
set ip [ipl::general -ip $ip -href "https://analogdevicesinc.github.io/hdl/library/spi_engine/spi_engine_execution.html#spi-engine-execution"]

set ip [ipl::add_interface -ip $ip \
    -inst_name spi_engine_ctrl \
    -display_name spi_engine_ctrl \
    -description spi_engine_ctrl \
    -master_slave slave \
    -portmap { \
        {"cmd_ready" "CMD_READY"} \
        {"cmd_valid" "CMD_VALID"} \
        {"cmd" "CMD_DATA"} \
        {"sdo_data_ready" "SDO_READY"} \
        {"sdo_data_valid" "SDO_VALID"} \
        {"sdo_data" "SDO_DATA"} \
        {"sdi_data_ready" "SDI_READY"} \
        {"sdi_data_valid" "SDI_VALID"} \
        {"sdi_data" "SDI_DATA"} \
        {"sync_ready" "SYNC_READY"} \
        {"sync_valid" "SYNC_VALID"} \
        {"sync" "SYNC_DATA"} \
    } \
    -vlnv {analog.com:ADI:spi_engine_ctrl:1.0}]
set ip [ipl::add_interface -ip $ip \
    -inst_name spi_master \
    -display_name spi_master \
    -description spi_master \
    -master_slave master \
    -portmap { \
        {"sclk" "SCLK"} \
        {"sdi" "SDI"} \
        {"sdo" "SDO"} \
        {"sdo_t" "SDO_T"} \
        {"three_wire" "THREE_WIRE"} \
        {"cs" "CS"} \
    } \
    -vlnv {analog.com:ADI:spi_master:1.0}]

set ip [ipl::add_ip_files -ip $ip -dpath rtl -flist [list \
    "spi_engine_execution.v" \
    "spi_engine_execution_shiftreg.v" ]]

set ip [ipl::set_parameter -ip $ip \
    -id DATA_WIDTH \
    -type param \
    -value_type int \
    -conn_mod spi_engine_execution \
    -title {Parallel data width} \
    -default 8 \
    -output_formatter nostr \
    -value_range {(8, 32)} \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id NUM_OF_CS \
    -type param \
    -value_type int \
    -conn_mod spi_engine_execution \
    -title {Number of CSN lines} \
    -default 1 \
    -output_formatter nostr \
    -value_range {(1, 8)} \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id NUM_OF_SDIO \
    -type param \
    -value_type int \
    -conn_mod spi_engine_execution \
    -title {Number of MISO/MOSI} \
    -default 1 \
    -output_formatter nostr \
    -value_range {(1, 8)} \
    -group1 {General Configuration} \
    -group2 Config]

set ip [ipl::set_parameter -ip $ip \
    -id DEFAULT_SPI_CFG \
    -type param \
    -value_type int \
    -conn_mod spi_engine_execution \
    -title {Default SPI mode} \
    -default 0 \
    -options {[0, 1, 2, 3]} \
    -output_formatter nostr \
    -group1 {SPI Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id DEFAULT_CLK_DIV \
    -type param \
    -value_type int \
    -conn_mod spi_engine_execution \
    -title {Default SCLK divider} \
    -default 0 \
    -output_formatter nostr \
    -value_range {(0, 255)} \
    -group1 {SPI Configuration} \
    -group2 Config]

set ip [ipl::set_parameter -ip $ip \
    -id SDI_DELAY \
    -type param \
    -value_type int \
    -conn_mod spi_engine_execution \
    -title {Delay MISO latching} \
    -default 0 \
    -options {[(True, 1), (False, 0)]} \
    -output_formatter nostr \
    -group1 {MOSI/MISO Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id SDO_DEFAULT \
    -type param \
    -value_type int \
    -conn_mod spi_engine_execution \
    -title {MOSI default level} \
    -default 0 \
    -options {[0, 1]} \
    -output_formatter nostr \
    -group1 {MOSI/MISO Configuration} \
    -group2 Config]

set ip [ipl::set_parameter -ip $ip \
    -id ECHO_SCLK \
    -type param \
    -value_type int \
    -conn_mod spi_engine_execution \
    -title {Echoed SCLK} \
    -default 0 \
    -options {[(True, 1), (False, 0)]} \
    -output_formatter nostr \
    -group1 {Custom clocking options} \
    -group2 Config]

set ip [ipl::ignore_ports -ip $ip \
    -portlist {echo_sclk} \
    -expression {(ECHO_SCLK != 1)}]

ipl::generate_ip $ip

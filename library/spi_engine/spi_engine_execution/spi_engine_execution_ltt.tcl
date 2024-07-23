###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::getmod ./spi_engine_execution.v]
set ip $::ipl::ip

set ip [ipl::addports -ip $ip -mod_data $mod_data]

set ip [ipl::general -ip $ip -name [dict get $mod_data mod_name]]
set ip [ipl::general -ip $ip -display_name "AXI SPI Engine execution ADI"]
set ip [ipl::general -ip $ip -supported_products {*}]
set ip [ipl::general -ip $ip -supported_platforms {esi radiant}]
set ip [ipl::general -ip $ip -href "https://analogdevicesinc.github.io/hdl/library/spi_engine/spi_engine_execution.html#spi-engine-execution"]
set ip [ipl::general  -vendor "analog.com" \
    -library "ip" \
    -version "1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2022.1" \
    -min_esi_version "2022.1" -ip $ip]

set if [ipl::createcif -vendor analog.com \
    -library ADI \
    -name spi_engine_ctrl \
    -version 1.0 \
    -directConnection true \
    -isAddressable false \
    -description "ADI SPI Engine Control Interface" \
    -ports {
        {-n CMD_READY -p required -w 1 -d in}
        {-n CMD_VALID -p required -w 1 -d out}
        {-n CMD_DATA -p required -w 16 -d out}
        {-n SDO_READY -p required -w 1 -d in}
        {-n SDO_VALID -p required -w 1 -d out}
        {-n SDO_DATA -p required -d out}
        {-n SDI_READY -p required -w 1 -d out}
        {-n SDI_VALID -p required -w 1 -d in}
        {-n SDI_DATA -p required -d in}
        {-n SYNC_READY -p required -w 1 -d out}
        {-n SYNC_VALID -p required -w 1 -d in}
        {-n SYNC_DATA -p required -w 8 -d in}
    }]
ipl::genif $if

set if [ipl::createcif -vendor analog.com \
    -library ADI \
    -name spi_master \
    -version 1.0 \
    -directConnection true \
    -isAddressable false \
    -description "SPI Master Interface" \
    -ports {
        {-n SCLK -p required -w 1 -d out}
        {-n SDI -p optional -d in}
        {-n SDO -p optional -w 1 -d out}
        {-n SDO_T -p optional -w 1 -d out}
        {-n THREE_WIRE -p optional -w 1 -d out}
        {-n CS -p required -d out}
    }]
ipl::genif $if

set ip [ipl::addif -ip $ip \
    -iname spi_engine_ctrl \
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
    -vendor analog.com -library ADI -name spi_engine_ctrl -version 1.0]
set ip [ipl::addif -ip $ip \
    -iname spi_master \
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
    -vendor analog.com -library ADI -name spi_master -version 1.0]

set ip [ipl::addfiles -spath ./ -dpath rtl -extl {*.v} -ip $ip]

set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
    -id NUM_OF_SDI \
    -type param \
    -value_type int \
    -conn_mod spi_engine_execution \
    -title {Number of MISO} \
    -default 1 \
    -output_formatter nostr \
    -value_range {(1, 8)} \
    -group1 {General Configuration} \
    -group2 Config]

set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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

set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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

set ip [ipl::settpar -ip $ip \
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

set ip [ipl::igports -ip $ip \
    -portlist {echo_sclk} \
    -expression {(ECHO_SCLK != 1)}]

ipl::genip $ip
ipl::genip $ip ./

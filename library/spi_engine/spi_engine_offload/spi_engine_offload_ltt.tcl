###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::getmod ./spi_engine_offload.v]
set ip $::ipl::ip

set ip [ipl::addports -ip $ip -mod_data $mod_data]

set ip [ipl::general -ip $ip -name [dict get $mod_data mod_name]]
set ip [ipl::general -ip $ip -display_name "AXI SPI Engine Offload ADI"]
set ip [ipl::general -ip $ip -supported_products {*}]
set ip [ipl::general -ip $ip -supported_platforms {esi radiant}]
set ip [ipl::general -ip $ip -href "https://analogdevicesinc.github.io/hdl/library/spi_engine/spi_engine_offload.html"]
set ip [ipl::general  -vendor "analog.com" \
    -library "ip" \
    -version "1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2022.1" \
    -min_esi_version "2022.1" -ip $ip]

set if [ipl::createcif -vendor analog.com \
    -library ADI \
    -name spi_engine_offload_ctrl \
    -version 1.0 \
    -directConnection true \
    -isAddressable false \
    -description "ADI SPI Engine Offload Control Interface" \
    -ports {
        {-n CMD_WR_EN -p required -w 1 -d out}
        {-n CMD_WR_DATA -p required -w 16 -d out}
        {-n SDO_WR_EN -p required -w 1 -d out}
        {-n SDO_WR_DATA -p required -d out}
        {-n ENABLE -p required -w 1 -d out}
        {-n MEM_RESET -p required -w 1 -d out}
        {-n ENABLED -p required -w 1 -d in}
        {-n SYNC_READY -p required -w 1 -d out}
        {-n SYNC_VALID -p required -w 1 -d in}
        {-n SYNC_DATA -p required -w 8 -d in}
    }]
ipl::genif $if

set ip [ipl::addif -ip $ip \
    -iname spi_engine_offload_ctrl \
    -display_name spi_engine_offload_ctrl \
    -description spi_engine_offload_ctrl \
    -master_slave slave \
    -portmap { \
        { "ctrl_cmd_wr_en" "CMD_WR_EN"} \
        { "ctrl_cmd_wr_data" "CMD_WR_DATA"} \
        { "ctrl_sdo_wr_en" "SDO_WR_EN"} \
        { "ctrl_sdo_wr_data" "SDO_WR_DATA"} \
        { "ctrl_enable" "ENABLE"} \
        { "ctrl_enabled" "ENABLED"} \
        { "ctrl_mem_reset" "MEM_RESET"} \
        { "status_sync_ready" "SYNC_READY"} \
        { "status_sync_valid" "SYNC_VALID"} \
        { "status_sync_data" "SYNC_DATA"} \
    } \
    -vendor analog.com -library ADI -name spi_engine_offload_ctrl -version 1.0]

set ip [ipl::addif -ip $ip \
    -iname spi_engine_ctrl \
    -display_name spi_engine_ctrl \
    -description spi_engine_ctrl \
    -master_slave master \
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
        {"sync_data" "SYNC_DATA"} \
    } \
    -vendor analog.com -library ADI -name spi_engine_ctrl -version 1.0]

set ip [ipl::addif -ip $ip \
    -iname offload_sdi \
    -display_name offload_sdi \
    -description offload_sdi \
    -master_slave master \
    -portmap { \
        {"offload_sdi_valid" "TVALID"} \
        {"offload_sdi_ready" "TREADY"} \
        {"offload_sdi_data" "TDATA"} \
    } \
    -vendor amba.com -library AMBA4 -name AXI4Stream -version r0p0]

set ip [ipl::addfiles -spath ./ -dpath rtl -extl {*.v} -ip $ip]
set ip [ipl::addfiles -spath ../../util_cdc -dpath rtl -extl {*.v} -ip $ip]

set ip [ipl::settpar -ip $ip \
    -id DATA_WIDTH \
    -type param \
    -value_type int \
    -conn_mod spi_engine_offload \
    -title {Shift register's data width} \
    -default 8 \
    -output_formatter nostr \
    -value_range {(8, 255)} \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::settpar -ip $ip \
    -id NUM_OF_SDI \
    -type param \
    -value_type int \
    -conn_mod spi_engine_offload \
    -title {Number of MISO lines} \
    -default 1 \
    -output_formatter nostr \
    -value_range {(1, 8)} \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::settpar -ip $ip \
    -id ASYNC_SPI_CLK \
    -type param \
    -value_type int \
    -conn_mod spi_engine_offload \
    -title {Asynchronous core clock} \
    -default 0 \
    -options {[(True, 1), (False, 0)]} \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::settpar -ip $ip \
    -id ASYNC_TRIG \
    -type param \
    -value_type int \
    -conn_mod spi_engine_offload \
    -title {Asynchronous trigger} \
    -default 0 \
    -options {[(True, 1), (False, 0)]} \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]

set ip [ipl::settpar -ip $ip \
    -id CMD_MEM_ADDRESS_WIDTH \
    -type param \
    -value_type int \
    -conn_mod spi_engine_offload \
    -title {Command FIFO address width} \
    -default 4 \
    -output_formatter nostr \
    -value_range {(1, 16)} \
    -group1 {Command stream FIFO configuration} \
    -group2 Config]
set ip [ipl::settpar -ip $ip \
    -id SDO_MEM_ADDRESS_WIDTH \
    -type param \
    -value_type int \
    -conn_mod spi_engine_offload \
    -title {MOSI FIFO address width} \
    -default 4 \
    -output_formatter nostr \
    -value_range {(1, 16)} \
    -group1 {Command stream FIFO configuration} \
    -group2 Config]

ipl::genip $ip
ipl::genip $ip ./

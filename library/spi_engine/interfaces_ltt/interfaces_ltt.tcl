###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

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
ipl::genif $if ./

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
ipl::genif $if ./

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
ipl::genif $if ./
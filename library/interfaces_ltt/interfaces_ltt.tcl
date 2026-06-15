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

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set if [ipl::create_interface \
    -vlnv {analog.com:ADI:fifo_wr:1.0} \
    -directConnection true \
    -isAddressable false \
    -description "ADI fifo wr interface" \
    -ports {
        {-n DATA -d out -p required}
        {-n EN -d out -p required -w 1}
        {-n OVERFLOW -w 1 -p optional -d in}
        {-n SYNC -p optional -w 1 -d out}
        {-n XFER_REQ -p optional -w 1 -d in}
    }]
ipl::generate_interface $if

set if [ipl::create_interface \
    -vlnv {analog.com:ADI:fifo_rd:1.0} \
    -directConnection true \
    -isAddressable false \
    -description "ADI fifo rd interface" \
    -ports {
        {-n DATA -d in -p required}
        {-n EN -d out -p required -w 1}
        {-n UNDERFLOW -d in -p optional -w 1}
        {-n VALID -d in -p optional -w 1}
        {-n XFER_REQ -d in -p optional -w 1}
    }]
ipl::generate_interface $if

set if [ipl::create_interface \
    -vlnv {analog.com:ADI:spi_engine_ctrl:1.0} \
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
ipl::generate_interface $if

set if [ipl::create_interface \
    -vlnv {analog.com:ADI:spi_engine_offload_ctrl:1.0} \
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
ipl::generate_interface $if

set if [ipl::create_interface \
    -vlnv {analog.com:ADI:spi_engine_interconnect_ctrl:1.0} \
    -directConnection true \
    -isAddressable false \
    -description "ADI SPI Engine Interconnect Control Interface" \
    -ports {
        {-n INTERCONNECT_DIR -p required -w 1 -d out}
    }]
ipl::generate_interface $if

set if [ipl::create_interface \
    -vlnv {analog.com:ADI:spi_master:1.0} \
    -directConnection true \
    -isAddressable false \
    -description "SPI Master Interface" \
    -ports {
        {-n SCLK -p optional -w 1 -d out}
        {-n SDI -p optional -d in}
        {-n SDO -p optional -w 1 -d out}
        {-n SDO_T -p optional -w 1 -d out}
        {-n THREE_WIRE -p optional -w 1 -d out}
        {-n CS -p optional -d out}
    }]
ipl::generate_interface $if

set if [ipl::create_interface \
    -vlnv {analog.com:ADI:if_framelock:1.0} \
    -directConnection true \
    -isAddressable false \
    -description "AXI DMA framelock Interface." \
    -ports {
        {-n s2m_framelock -p required -d in}
        {-n s2m_framelock_valid -p required -w 1 -d in}
        {-n m2s_framelock -p required -d out}
        {-n m2s_framelock_valid -p required -w 1 -d out}
    }]
ipl::generate_interface $if

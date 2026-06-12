###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

set ASYMMETRIC_A_B_MODE [ expr { [info exists ad_project_params(ASYMMETRIC_A_B_MODE)] \
                          ? $ad_project_params(ASYMMETRIC_A_B_MODE) : 0 } ]

if {$ASYMMETRIC_A_B_MODE == 1} {
  ## ADC B Side FIFO depth in samples per converter
  set adc_b_fifo_samples_per_converter [expr $ad_project_params(RX_B_KS_PER_CHANNEL)*1024]
  ## DAC B Side FIFO depth in samples per converter
  set dac_b_fifo_samples_per_converter [expr $ad_project_params(TX_B_KS_PER_CHANNEL)*1024]
}

source $ad_hdl_dir/projects/common/vpk180/vpk180_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

set ADI_PHY_SEL 0
set MAX_NUMBER_OF_QUADS 2
set TRANSCEIVER_TYPE GTYP
set HSCI_BANKS 1
set HSCI_ENABLE [ expr { [info exists ad_project_params(HSCI_ENABLE)] \
                          ? $ad_project_params(HSCI_ENABLE) : 1 } ]

source $ad_hdl_dir/projects/ad9084_ebz/common/ad9084_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

ad_ip_parameter axi_apollo_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2
ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1

if {$ASYMMETRIC_A_B_MODE == 1} {
  ad_ip_parameter axi_apollo_rx_b_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2
  ad_ip_parameter axi_apollo_tx_b_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1
}

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

# Second SPI controller
create_bd_port -dir O -from 7 -to 0 apollo_spi_csn_o
create_bd_port -dir I -from 7 -to 0 apollo_spi_csn_i
create_bd_port -dir I apollo_spi_clk_i
create_bd_port -dir O apollo_spi_clk_o
create_bd_port -dir I apollo_spi_sdo_i
create_bd_port -dir O apollo_spi_sdo_o
create_bd_port -dir I apollo_spi_sdi_i

ad_ip_instance axi_quad_spi axi_spi_2
ad_ip_parameter axi_spi_2 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_2 CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_2 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_2 CONFIG.Multiples16 1

ad_connect apollo_spi_csn_i axi_spi_2/ss_i
ad_connect apollo_spi_csn_o axi_spi_2/ss_o
ad_connect apollo_spi_clk_i axi_spi_2/sck_i
ad_connect apollo_spi_clk_o axi_spi_2/sck_o
ad_connect apollo_spi_sdo_i axi_spi_2/io0_i
ad_connect apollo_spi_sdo_o axi_spi_2/io0_o
ad_connect apollo_spi_sdi_i axi_spi_2/io1_i

ad_connect $sys_cpu_clk axi_spi_2/ext_spi_clk

ad_cpu_interrupt ps-9 mb-16 axi_spi_2/ip2intc_irpt

ad_cpu_interconnect 0x44A80000 axi_spi_2

if {$HSCI_ENABLE} {
  set_property range 256K [get_bd_addr_segs {sys_cips/M_AXI_FPD/SEG_data_axi_hsci_0}]
}

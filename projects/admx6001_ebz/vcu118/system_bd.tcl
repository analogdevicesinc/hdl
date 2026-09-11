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

## FIFO depth is 4Mb - 250k samples (65k samples per converter)
set adc_fifo_address_width 13

source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/admx6001_ebz/common/admx6001_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# Set SPI clock to 100/16 =  6.25 MHz
ad_ip_parameter axi_spi     CONFIG.C_SCK_RATIO 16
ad_ip_parameter hmc7044_spi CONFIG.C_SCK_RATIO 16
ad_ip_parameter ad4080_spi  CONFIG.C_SCK_RATIO 16
ad_ip_parameter adl5580_spi CONFIG.C_SCK_RATIO 16
ad_ip_parameter ltc2664_spi CONFIG.C_SCK_RATIO 16

#system ID

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0   CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0   CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_ip_parameter util_adc_xcvr CONFIG.RX_CLK25_DIV 30
ad_ip_parameter util_adc_xcvr CONFIG.CPLL_CFG0 0x1fa
ad_ip_parameter util_adc_xcvr CONFIG.CPLL_CFG1 0x2b
ad_ip_parameter util_adc_xcvr CONFIG.CPLL_CFG2 0x2
ad_ip_parameter util_adc_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_adc_xcvr CONFIG.CH_HSPMUX 0x4040
ad_ip_parameter util_adc_xcvr CONFIG.PREIQ_FREQ_BST 1
ad_ip_parameter util_adc_xcvr CONFIG.RTX_BUF_CML_CTRL 0x5
ad_ip_parameter util_adc_xcvr CONFIG.RXPI_CFG0 0x3002
ad_ip_parameter util_adc_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_adc_xcvr CONFIG.QPLL_CFG0 0x333c
ad_ip_parameter util_adc_xcvr CONFIG.QPLL_CFG4 0x2
ad_ip_parameter util_adc_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_adc_xcvr CONFIG.PPF0_CFG 0xB00

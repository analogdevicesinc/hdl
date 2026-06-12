###############################################################################
## Copyright (C) 2014-2023, 2026 Analog Devices, Inc. All rights reserved.
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

# ddr controller RevD

ad_ip_parameter axi_ddr_cntrl CONFIG.C0.ControllerType DDR4_SDRAM
ad_ip_parameter axi_ddr_cntrl CONFIG.C0.DDR4_TimePeriod 833
ad_ip_parameter axi_ddr_cntrl CONFIG.C0.DDR4_InputClockPeriod 3332
ad_ip_parameter axi_ddr_cntrl CONFIG.C0.DDR4_MemoryPart EDY4016AABG-DR-F
ad_ip_parameter axi_ddr_cntrl CONFIG.C0.DDR4_DataWidth 64
ad_ip_parameter axi_ddr_cntrl CONFIG.C0.DDR4_Mem_Add_Map ROW_COLUMN_BANK
ad_ip_parameter axi_ddr_cntrl CONFIG.C0.DDR4_CasWriteLatency 12
ad_ip_parameter axi_ddr_cntrl CONFIG.Debug_Signal Enable
ad_ip_parameter axi_ddr_cntrl CONFIG.C0.DDR4_AxiDataWidth 512

ad_ip_parameter axi_ddr_cntrl CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ 100
ad_ip_parameter axi_ddr_cntrl CONFIG.ADDN_UI_CLKOUT2_FREQ_HZ 200

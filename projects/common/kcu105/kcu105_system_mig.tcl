###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
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

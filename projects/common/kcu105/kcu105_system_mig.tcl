
# ddr controller RevD

set_property -dict [list CONFIG.C0.ControllerType {DDR4_SDRAM}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_TimePeriod {833}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_InputClockPeriod {3332}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_MemoryPart {EDY4016AABG-DR-F}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_DataWidth {64}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_Mem_Add_Map {ROW_COLUMN_BANK}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_CasWriteLatency {12}] $axi_ddr_cntrl
set_property -dict [list CONFIG.Debug_Signal {Enable}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_AxiDataWidth {512}] $axi_ddr_cntrl

set_property -dict [list CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {100}] $axi_ddr_cntrl
set_property -dict [list CONFIG.ADDN_UI_CLKOUT2_FREQ_HZ {200}] $axi_ddr_cntrl



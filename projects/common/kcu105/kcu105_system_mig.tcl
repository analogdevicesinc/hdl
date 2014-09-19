
# ddr controller

set_property -dict [list CONFIG.C0.ControllerType {DDR4_SDRAM}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_TimePeriod {833}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_InputClockPeriod {3333}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_MemoryPart {MT40A256M16HA-083}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_AxiSelection {true}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_DataWidth {64}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_Mem_Add_Map {ROW_BANK_COLUMN}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_CasWriteLatency {12}] $axi_ddr_cntrl
set_property -dict [list CONFIG.Debug_Signal {Enable}] $axi_ddr_cntrl
set_property -dict [list CONFIG.C0.DDR4_AxiDataWidth {512}] $axi_ddr_cntrl

set_property -dict [list CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {100}] $axi_ddr_cntrl
set_property -dict [list CONFIG.ADDN_UI_CLKOUT2_FREQ_HZ {200}] $axi_ddr_cntrl

set_property -dict [list CONFIG.c0_adr_0               {bank45.byte3.pin8}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_1               {bank45.byte2.pin1}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_2               {bank45.byte3.pin4}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_3               {bank45.byte2.pin6}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_4               {bank45.byte2.pin5}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_5               {bank45.byte1.pin7}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_6               {bank45.byte1.pin9}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_7               {bank45.byte2.pin4}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_8               {bank45.byte3.pin5}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_9               {bank45.byte2.pin9}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_10              {bank45.byte3.pin2}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_11              {bank45.byte3.pin0}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_12              {bank45.byte2.pin7}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_13              {bank45.byte2.pin8}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_14              {bank45.byte3.pin10}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_15              {bank45.byte2.pin11}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_adr_16              {bank45.byte3.pin3}]  $axi_ddr_cntrl  

set_property -dict [list CONFIG.c0_dq_0                {bank44.byte0.pin9}]  $axi_ddr_cntrl
set_property -dict [list CONFIG.c0_dq_1                {bank44.byte0.pin3}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_2                {bank44.byte0.pin10}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_3                {bank44.byte0.pin2}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_4                {bank44.byte0.pin8}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_5                {bank44.byte0.pin4}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_6                {bank44.byte0.pin11}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_7                {bank44.byte0.pin5}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dm_dbi_n_0          {bank44.byte0.pin0}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_t_0             {bank44.byte0.pin6}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_c_0             {bank44.byte0.pin7}]  $axi_ddr_cntrl

set_property -dict [list CONFIG.c0_dq_8                {bank44.byte1.pin9}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_9                {bank44.byte1.pin4}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_10               {bank44.byte1.pin8}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_11               {bank44.byte1.pin2}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_12               {bank44.byte1.pin11}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_13               {bank44.byte1.pin3}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_14               {bank44.byte1.pin10}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_15               {bank44.byte1.pin5}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dm_dbi_n_1          {bank44.byte1.pin0}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_t_1             {bank44.byte1.pin6}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_c_1             {bank44.byte1.pin7}]  $axi_ddr_cntrl

set_property -dict [list CONFIG.c0_dq_16               {bank44.byte2.pin8}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_17               {bank44.byte2.pin11}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_18               {bank44.byte2.pin5}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_19               {bank44.byte2.pin3}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_20               {bank44.byte2.pin2}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_21               {bank44.byte2.pin10}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_22               {bank44.byte2.pin4}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_23               {bank44.byte2.pin9}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dm_dbi_n_2          {bank44.byte2.pin0}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_t_2             {bank44.byte2.pin6}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_c_2             {bank44.byte2.pin7}]  $axi_ddr_cntrl

set_property -dict [list CONFIG.c0_dq_24               {bank44.byte3.pin4}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_25               {bank44.byte3.pin10}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_26               {bank44.byte3.pin5}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_27               {bank44.byte3.pin11}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_28               {bank44.byte3.pin9}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_29               {bank44.byte3.pin3}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_30               {bank44.byte3.pin8}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_31               {bank44.byte3.pin2}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dm_dbi_n_3          {bank44.byte3.pin0}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_t_3             {bank44.byte3.pin6}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_c_3             {bank44.byte3.pin7}]  $axi_ddr_cntrl

set_property -dict [list CONFIG.c0_dq_32               {bank46.byte0.pin9}]  $axi_ddr_cntrl
set_property -dict [list CONFIG.c0_dq_33               {bank46.byte0.pin4}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_34               {bank46.byte0.pin11}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_35               {bank46.byte0.pin3}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_36               {bank46.byte0.pin10}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_37               {bank46.byte0.pin8}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_38               {bank46.byte0.pin5}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_39               {bank46.byte0.pin2}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dm_dbi_n_4          {bank46.byte0.pin0}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_t_4             {bank46.byte0.pin6}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_c_4             {bank46.byte0.pin7}]  $axi_ddr_cntrl

set_property -dict [list CONFIG.c0_dq_40               {bank46.byte1.pin10}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_41               {bank46.byte1.pin3}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_42               {bank46.byte1.pin11}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_43               {bank46.byte1.pin5}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_44               {bank46.byte1.pin8}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_45               {bank46.byte1.pin2}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_46               {bank46.byte1.pin9}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_47               {bank46.byte1.pin4}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dm_dbi_n_5          {bank46.byte1.pin0}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_t_5             {bank46.byte1.pin6}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_c_5             {bank46.byte1.pin7}]  $axi_ddr_cntrl

set_property -dict [list CONFIG.c0_dq_48               {bank46.byte2.pin8}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_49               {bank46.byte2.pin9}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_50               {bank46.byte2.pin11}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_51               {bank46.byte2.pin2}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_52               {bank46.byte2.pin5}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_53               {bank46.byte2.pin4}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_54               {bank46.byte2.pin10}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_55               {bank46.byte2.pin3}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dm_dbi_n_6          {bank46.byte2.pin0}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_t_6             {bank46.byte2.pin6}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_c_6             {bank46.byte2.pin7}]  $axi_ddr_cntrl

set_property -dict [list CONFIG.c0_dq_56               {bank46.byte3.pin2}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_57               {bank46.byte3.pin3}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_58               {bank46.byte3.pin11}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_59               {bank46.byte3.pin5}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_60               {bank46.byte3.pin8}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_61               {bank46.byte3.pin4}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_62               {bank46.byte3.pin10}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dq_63               {bank46.byte3.pin9}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dm_dbi_n_7          {bank46.byte3.pin0}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_t_7             {bank46.byte3.pin6}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_dqs_c_7             {bank46.byte3.pin7}]  $axi_ddr_cntrl

set_property -dict [list CONFIG.c0_ba_0                {bank45.byte3.pin9}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_ba_1                {bank45.byte1.pin5}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_bg_0                {bank45.byte2.pin10}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_cke_0               {bank45.byte3.pin11}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_cs_n_0              {bank45.byte1.pin2}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_odt_0               {bank45.byte1.pin8}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_par                 {bank45.byte3.pin1}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_reset_n             {bank45.byte1.pin6}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_act_n               {bank45.byte2.pin12}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_ck_t                {bank45.byte3.pin6}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_ck_c                {bank45.byte3.pin7}]  $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_sys_clk_p           {bank45.byte1.pin10}] $axi_ddr_cntrl  
set_property -dict [list CONFIG.c0_sys_clk_n           {bank45.byte1.pin11}] $axi_ddr_cntrl  


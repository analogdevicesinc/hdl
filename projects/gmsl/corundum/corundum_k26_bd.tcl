#create_bd_port -dir I clk_125mhz

create_bd_port -dir I sfp0_rx_p
create_bd_port -dir I sfp0_rx_n
create_bd_port -dir O sfp0_tx_p
create_bd_port -dir O sfp0_tx_n
create_bd_port -dir I sfp1_rx_p
create_bd_port -dir I sfp1_rx_n
create_bd_port -dir O sfp1_tx_p
create_bd_port -dir O sfp1_tx_n
create_bd_port -dir I sfp2_rx_p
create_bd_port -dir I sfp2_rx_n
create_bd_port -dir O sfp2_tx_p
create_bd_port -dir O sfp2_tx_n
create_bd_port -dir I sfp3_rx_p
create_bd_port -dir I sfp3_rx_n
create_bd_port -dir O sfp3_tx_p
create_bd_port -dir O sfp3_tx_n

create_bd_port -dir I sfp_mgt_refclk_0_p
create_bd_port -dir I sfp_mgt_refclk_0_n

#create_bd_port -dir O ptp_mgt_refclk_out

create_bd_port -dir O sfp0_tx_disable_b
create_bd_port -dir O sfp1_tx_disable_b
create_bd_port -dir O sfp2_tx_disable_b
create_bd_port -dir O sfp3_tx_disable_b

set_property -dict [list \
  CONFIG.PSU__USE__M_AXI_GP0 {1} \
  CONFIG.PSU__USE__S_AXI_GP3 {1} \
  CONFIG.PSU__USE__S_AXI_GP4 {1} \
] [get_bd_cell sys_ps8]

#set_property -dict [list \
  CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
  CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
  CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
  CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS33} \
  CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN 1 \
  CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
  CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
  CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
  CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
  CONFIG.PSU__DDRC__T_RC {46.5} \
  CONFIG.PSU__DDRC__T_FAW {21.0} \
  CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
  CONFIG.PSU__DDRC__FREQ_MHZ {1067} \
  CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
  CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
  CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
  CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 20 .. 21} \
  CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
  CONFIG.PSU__SD1__GRP_WP__ENABLE {1} \
  CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
  CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
  CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
  CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
  CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
  CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
  CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
  CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
  CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {667} \
  CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
  CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {667} \
  CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
  CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {DPLL} \
  CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
  CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
  CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {DPLL} \
  CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {DPLL} \
  CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {DPLL} \
  CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
  CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {DPLL} \
  CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
  CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
  CONFIG.PSU__USE__S_AXI_GP3 {1} \
  CONFIG.PSU__USE__M_AXI_GP0 {1} \
] [get_bd_cell sys_ps8]

# FW and board IDs
set fpga_id [expr 0x4A49093]
set fw_id [expr 0x00000000]
set fw_ver 0.0.1
set board_vendor_id [expr 0x10ee]
set board_device_id [expr 0x9104]
set board_ver 1.0
set release_info [expr 0x00000000]
set build_date [clock seconds]
set git_hash 00000000
set git_tag ""

if { [catch {set git_hash [exec git rev-parse --short=8 HEAD]}] } {
    puts "Error running git or project not under version control"
}
if { [catch {set git_tag [exec git describe --tags HEAD]}] } {
    puts "Error running git, project not under version control, or no tag found"
}

ad_ip_instance nic_core nic_core
ad_ip_parameter nic_core CONFIG.CARRIER {1}
ad_ip_parameter nic_core CONFIG.TDMA_BER_ENABLE {0}
ad_ip_parameter nic_core CONFIG.FPGA_ID [format "32'h%08x" $fpga_id]
ad_ip_parameter nic_core CONFIG.FW_ID [format "32'h%08x" $fw_id]
ad_ip_parameter nic_core CONFIG.FW_VER [format "32'h%02x%02x%02x%02x" {*}[split $fw_ver .-] 0 0 0 0]
ad_ip_parameter nic_core CONFIG.BOARD_ID [format "32'h%04x%04x" $board_vendor_id $board_device_id]
ad_ip_parameter nic_core CONFIG.BOARD_VER [format "32'h%02x%02x%02x%02x" {*}[split $board_ver .-] 0 0 0 0]
ad_ip_parameter nic_core CONFIG.BUILD_DATE  "32'd${build_date}"
ad_ip_parameter nic_core CONFIG.GIT_HASH  "32'h${git_hash}"
ad_ip_parameter nic_core CONFIG.RELEASE_INFO  [format "32'h%08x" $release_info]
ad_ip_parameter nic_core CONFIG.TDMA_BER_ENABLE {0}
ad_ip_parameter nic_core CONFIG.IF_COUNT {1}
ad_ip_parameter nic_core CONFIG.PORTS_PER_IF {1}
ad_ip_parameter nic_core CONFIG.PORT_MASK {0}
ad_ip_parameter nic_core CONFIG.PTP_CLOCK_PIPELINE {0}
ad_ip_parameter nic_core CONFIG.PTP_CLOCK_CDC_PIPELINE {0}
ad_ip_parameter nic_core CONFIG.PTP_PORT_CDC_PIPELINE {0}
ad_ip_parameter nic_core CONFIG.PTP_PEROUT_ENABLE {1}
ad_ip_parameter nic_core CONFIG.PTP_PEROUT_COUNT {1}
ad_ip_parameter nic_core CONFIG.EVENT_QUEUE_OP_TABLE_SIZE {32}
ad_ip_parameter nic_core CONFIG.TX_QUEUE_OP_TABLE_SIZE {32}
ad_ip_parameter nic_core CONFIG.RX_QUEUE_OP_TABLE_SIZE {32}
ad_ip_parameter nic_core CONFIG.CQ_OP_TABLE_SIZE {32}
ad_ip_parameter nic_core CONFIG.EQN_WIDTH {2}
ad_ip_parameter nic_core CONFIG.TX_QUEUE_INDEX_WIDTH {5}
ad_ip_parameter nic_core CONFIG.RX_QUEUE_INDEX_WIDTH {5}
ad_ip_parameter nic_core CONFIG.EQ_PIPELINE {3}
ad_ip_parameter nic_core CONFIG.TX_DESC_TABLE_SIZE {32}
ad_ip_parameter nic_core CONFIG.RX_DESC_TABLE_SIZE {32}
ad_ip_parameter nic_core CONFIG.TDMA_INDEX_WIDTH {6}
ad_ip_parameter nic_core CONFIG.PTP_TS_ENABLE {1}
ad_ip_parameter nic_core CONFIG.TX_CPL_FIFO_DEPTH {32}
ad_ip_parameter nic_core CONFIG.TX_CHECKSUM_ENABLE {1}
ad_ip_parameter nic_core CONFIG.RX_HASH_ENABLE {1}
ad_ip_parameter nic_core CONFIG.RX_CHECKSUM_ENABLE {1}
ad_ip_parameter nic_core CONFIG.TX_FIFO_DEPTH {32768}
ad_ip_parameter nic_core CONFIG.RX_FIFO_DEPTH {32768}
ad_ip_parameter nic_core CONFIG.MAX_TX_SIZE {9214}
ad_ip_parameter nic_core CONFIG.MAX_RX_SIZE {9214}
ad_ip_parameter nic_core CONFIG.TX_RAM_SIZE {32768}
ad_ip_parameter nic_core CONFIG.RX_RAM_SIZE {32768}
ad_ip_parameter nic_core CONFIG.DDR_CH {1}
ad_ip_parameter nic_core CONFIG.DDR_ENABLE {0}
ad_ip_parameter nic_core CONFIG.AXI_DDR_ID_WIDTH {8}
ad_ip_parameter nic_core CONFIG.AXI_DDR_MAX_BURST_LEN {256}
ad_ip_parameter nic_core CONFIG.DMA_IMM_ENABLE {0}
ad_ip_parameter nic_core CONFIG.DMA_IMM_WIDTH {32}
ad_ip_parameter nic_core CONFIG.DMA_LEN_WIDTH {16}
ad_ip_parameter nic_core CONFIG.DMA_TAG_WIDTH {16}
ad_ip_parameter nic_core CONFIG.RAM_PIPELINE {2}
ad_ip_parameter nic_core CONFIG.AXI_DMA_MAX_BURST_LEN {16}
ad_ip_parameter nic_core CONFIG.APP_ENABLE {0}
ad_ip_parameter nic_core CONFIG.APP_CTRL_ENABLE {1}
ad_ip_parameter nic_core CONFIG.APP_DMA_ENABLE {1}
ad_ip_parameter nic_core CONFIG.APP_AXIS_DIRECT_ENABLE {1}
ad_ip_parameter nic_core CONFIG.APP_AXIS_SYNC_ENABLE {1}
ad_ip_parameter nic_core CONFIG.APP_AXIS_IF_ENABLE {1}
ad_ip_parameter nic_core CONFIG.APP_STAT_ENABLE {1}
ad_ip_parameter nic_core CONFIG.AXIS_ETH_TX_PIPELINE {0}
ad_ip_parameter nic_core CONFIG.AXIS_ETH_TX_FIFO_PIPELINE {2}
ad_ip_parameter nic_core CONFIG.AXIS_ETH_TX_TS_PIPELINE {0}
ad_ip_parameter nic_core CONFIG.AXIS_ETH_RX_PIPELINE {0}
ad_ip_parameter nic_core CONFIG.AXIS_ETH_RX_FIFO_PIPELINE {2}
ad_ip_parameter nic_core CONFIG.STAT_ENABLE {1}
ad_ip_parameter nic_core CONFIG.STAT_DMA_ENABLE {1}
ad_ip_parameter nic_core CONFIG.STAT_AXI_ENABLE {1}
ad_ip_parameter nic_core CONFIG.STAT_INC_WIDTH {24}
ad_ip_parameter nic_core CONFIG.STAT_ID_WIDTH {12}
ad_ip_parameter nic_core CONFIG.AXI_DATA_WIDTH {128}
ad_ip_parameter nic_core CONFIG.AXI_ADDR_WIDTH {64}
ad_ip_parameter nic_core CONFIG.AXI_ID_WIDTH {6}
ad_ip_parameter nic_core CONFIG.AXIL_CTRL_DATA_WIDTH {32}
ad_ip_parameter nic_core CONFIG.AXIL_CTRL_ADDR_WIDTH {24}
ad_ip_parameter nic_core CONFIG.AXIL_APP_CTRL_DATA_WIDTH {32}
ad_ip_parameter nic_core CONFIG.AXIL_APP_CTRL_ADDR_WIDTH {24}


ad_ip_instance nic_phy nic_phy

ad_ip_instance clk_wiz eth_clkgen
ad_ip_parameter eth_clkgen CONFIG.PRIM_IN_FREQ.VALUE_SRC USER
ad_ip_parameter eth_clkgen CONFIG.PRIM_SOURCE {Global_buffer}
ad_ip_parameter eth_clkgen CONFIG.PRIM_IN_FREQ {156.25}
ad_ip_parameter eth_clkgen CONFIG.CLKIN1_JITTER_PS {64.0}
ad_ip_parameter eth_clkgen CONFIG.CLKOUT1_JITTER {154.802}
ad_ip_parameter eth_clkgen CONFIG.CLKOUT1_PHASE_ERROR {181.604}
ad_ip_parameter eth_clkgen CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125.000}
ad_ip_parameter eth_clkgen CONFIG.MMCM_CLKFBOUT_MULT_F {38.500}
ad_ip_parameter eth_clkgen CONFIG.MMCM_CLKIN1_PERIOD {6.400}
ad_ip_parameter eth_clkgen CONFIG.MMCM_CLKOUT0_DIVIDE_F {9.625}
ad_ip_parameter eth_clkgen CONFIG.MMCM_DIVCLK_DIVIDE {5}

ad_connect eth_clkgen/reset sys_cpu_reset
ad_connect eth_clkgen/clk_in1 nic_phy/ptp_mgt_refclk

ad_connect eth_clkgen/clk_out1 nic_core/ptp_sample_clk
ad_connect eth_clkgen/clk_out1 nic_phy/ctrl_clk

ad_connect eth_clkgen/clk_out1 nic_core/sfp_drp_clk
ad_connect eth_clkgen/clk_out1 nic_phy/sfp_drp_clk

ad_connect nic_core/ptp_clk nic_phy/ptp_mgt_refclk

ad_connect nic_core/nic_drp nic_phy/nic_drp
ad_connect nic_core/nic_mac_0 nic_phy/nic_mac_0
ad_connect nic_core/nic_mac_1 nic_phy/nic_mac_1
ad_connect nic_core/nic_mac_2 nic_phy/nic_mac_2
ad_connect nic_core/nic_mac_3 nic_phy/nic_mac_3

ad_connect nic_core/core_clk sys_250m_clk
ad_connect nic_core/core_rst sys_250m_reset

ad_connect nic_phy/sfp0_rx_p sfp0_rx_p
ad_connect nic_phy/sfp0_rx_n sfp0_rx_n
ad_connect nic_phy/sfp0_tx_p sfp0_tx_p
ad_connect nic_phy/sfp0_tx_n sfp0_tx_n
ad_connect nic_phy/sfp1_rx_p sfp1_rx_p
ad_connect nic_phy/sfp1_rx_n sfp1_rx_n
ad_connect nic_phy/sfp1_tx_p sfp1_tx_p
ad_connect nic_phy/sfp1_tx_n sfp1_tx_n
ad_connect nic_phy/sfp2_rx_p sfp2_rx_p
ad_connect nic_phy/sfp2_rx_n sfp2_rx_n
ad_connect nic_phy/sfp2_tx_p sfp2_tx_p
ad_connect nic_phy/sfp2_tx_n sfp2_tx_n
ad_connect nic_phy/sfp3_rx_p sfp3_rx_p
ad_connect nic_phy/sfp3_rx_n sfp3_rx_n
ad_connect nic_phy/sfp3_tx_p sfp3_tx_p
ad_connect nic_phy/sfp3_tx_n sfp3_tx_n

ad_connect nic_phy/sfp_mgt_refclk_0_p sfp_mgt_refclk_0_p
ad_connect nic_phy/sfp_mgt_refclk_0_n sfp_mgt_refclk_0_n

ad_connect nic_core/sfp0_tx_disable_b sfp0_tx_disable_b
ad_connect nic_core/sfp1_tx_disable_b sfp1_tx_disable_b
ad_connect nic_core/sfp2_tx_disable_b sfp2_tx_disable_b
ad_connect nic_core/sfp3_tx_disable_b sfp3_tx_disable_b

ad_ip_instance proc_sys_reset nic_reset_dcm
ad_connect nic_reset_dcm/slowest_sync_clk eth_clkgen/clk_out1
ad_connect nic_reset_dcm/ext_reset_in sys_ps8/pl_resetn0
ad_connect nic_reset_dcm/dcm_locked eth_clkgen/locked

ad_ip_instance proc_sys_reset nic_reset_mgt
ad_connect nic_reset_mgt/slowest_sync_clk nic_phy/ptp_mgt_refclk
set_property CONFIG.FREQ_HZ 156250000 [get_bd_pins /nic_phy/ptp_mgt_refclk]
#ad_connect nic_phy/ptp_mgt_refclk ptp_mgt_refclk_out
ad_connect nic_reset_mgt/ext_reset_in nic_reset_dcm/peripheral_reset
ad_connect nic_reset_mgt/dcm_locked VCC

#resets active high
ad_connect nic_phy/ctrl_rst nic_reset_mgt/peripheral_reset
ad_connect nic_core/ptp_rst nic_reset_mgt/peripheral_reset
ad_connect nic_phy/sfp_drp_rst nic_reset_dcm/peripheral_reset
ad_connect nic_core/sfp_drp_rst nic_reset_dcm/peripheral_reset

set_property CONFIG.NUM_SI {2} [get_bd_cells axi_cpu_interconnect]
ad_connect sys_ps8/maxihpm0_fpd_aclk sys_cpu_clk
ad_connect sys_ps8/M_AXI_HPM0_FPD axi_cpu_interconnect/S01_AXI

ad_cpu_interconnect 0xA0000000 nic_core
set_property range 16M [get_bd_addr_segs {sys_ps8/Data/SEG_data_nic_core}]
set_property CONFIG.NUM_CLKS {2} [get_bd_cells axi_cpu_interconnect]
ad_connect axi_cpu_interconnect/aclk1 sys_250m_clk

ad_ip_instance util_reduced_logic util_reduced_logic_0
ad_ip_parameter util_reduced_logic_0 CONFIG.C_OPERATION {or}
ad_ip_parameter util_reduced_logic_0 CONFIG.C_SIZE {8}

ad_ip_instance xlconcat eth_irq_concat
ad_ip_parameter eth_irq_concat CONFIG.NUM_PORTS {8}

ad_connect util_reduced_logic_0/Op1 eth_irq_concat/dout

ad_connect eth_irq_concat/In7 nic_core/core_irq_7
ad_connect eth_irq_concat/In6 nic_core/core_irq_6
ad_connect eth_irq_concat/In5 nic_core/core_irq_5
ad_connect eth_irq_concat/In4 nic_core/core_irq_4
ad_connect eth_irq_concat/In3 nic_core/core_irq_3
ad_connect eth_irq_concat/In2 nic_core/core_irq_2
ad_connect eth_irq_concat/In1 nic_core/core_irq_1
ad_connect eth_irq_concat/In0 nic_core/core_irq_0

#ad_cpu_interrupt ps-7 mb-6 nic_core/core_irq_7
#ad_cpu_interrupt ps-6 mb-6 nic_core/core_irq_6
#ad_cpu_interrupt ps-5 mb-5 nic_core/core_irq_5
ad_cpu_interrupt ps-4 mb-4 util_reduced_logic_0/Res
#ad_cpu_interrupt ps-3 mb-3 nic_core/core_irq_3
#ad_cpu_interrupt ps-2 mb-2 nic_core/core_irq_2
#ad_cpu_interrupt ps-1 mb-1 nic_core/core_irq_1
#ad_cpu_interrupt ps-0 mb-0 nic_core/core_irq_0

ad_connect sys_ps8/S_AXI_HP2_FPD nic_core/axim_dma
ad_connect sys_250m_clk sys_ps8/saxihp2_fpd_aclk

source ../../../../corundum/fpga/mqnic/KR260/fpga/ip/eth_xcvr_gth.tcl

set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]

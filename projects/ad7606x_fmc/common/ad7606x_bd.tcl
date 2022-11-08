# system level parameters
set DEV_CONFIG $ad_project_params(DEV_CONFIG)
set SIMPLE_STATUS_CRC $ad_project_params(SIMPLE_STATUS_CRC)

puts "build parameters: DEV_CONFIG: $DEV_CONFIG"
puts "build parameters: SIMPLE_STATUS_CRC: $SIMPLE_STATUS_CRC"

# control lines

create_bd_port -dir O rx_cnvst_n
create_bd_port -dir I rx_busy
create_bd_port -dir I rx_first_data

# instantiation

# trigger to BUSY's negative edge
create_bd_cell -type module -reference sync_bits busy_sync
create_bd_cell -type module -reference ad_edge_detect busy_capture
set_property -dict [list CONFIG.EDGE 1] [get_bd_cells busy_capture]

# sync first data
create_bd_cell -type module -reference sync_bits first_data_sync

# spi engine
source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 ad7606_spi

set data_width    32
set async_spi_clk 1
set num_cs        1
set num_sdi       8
set sdi_delay     1
set hier_spi_engine spi_ad7606

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $sdi_delay

# clkgen
ad_ip_instance axi_clkgen spi_clkgen
ad_ip_parameter spi_clkgen CONFIG.CLK0_DIV 5
ad_ip_parameter spi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter spi_clkgen CONFIG.VCO_MUL 8

# pwmgen
ad_ip_instance axi_pwm_gen ad7606_pwm_gen
ad_ip_parameter ad7606_pwm_gen CONFIG.PULSE_0_PERIOD 160
ad_ip_parameter ad7606_pwm_gen CONFIG.PULSE_0_WIDTH 1

# dma
ad_ip_instance axi_dmac ad7606_dma
ad_ip_parameter ad7606_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter ad7606_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad7606_dma CONFIG.CYCLIC 0
ad_ip_parameter ad7606_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter ad7606_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad7606_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter ad7606_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad7606_dma CONFIG.DMA_DATA_WIDTH_SRC $data_width
ad_ip_parameter ad7606_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# interface connections

ad_connect spi_clk busy_capture/clk
ad_connect busy_capture/rst GND

ad_connect spi_clk busy_sync/out_clk
ad_connect busy_sync/in_bits rx_busy
ad_connect busy_sync/out_resetn spi_ad7606/axi_regmap/spi_resetn
ad_connect busy_sync/out_bits busy_capture/signal_in

ad_connect spi_clk first_data_sync/out_clk
ad_connect first_data_sync/out_resetn spi_ad7606/axi_regmap/spi_resetn
ad_connect first_data_sync/in_bits rx_first_data

ad_connect $sys_cpu_clk spi_clkgen/clk
ad_connect spi_clk spi_clkgen/clk_0

ad_connect spi_clk ad7606_pwm_gen/ext_clk
ad_connect $sys_cpu_clk ad7606_pwm_gen/s_axi_aclk
ad_connect sys_cpu_resetn ad7606_pwm_gen/s_axi_aresetn
ad_connect busy_capture/signal_out spi_ad7606/offload/trigger


ad_connect ad7606_dma/s_axis spi_ad7606/M_AXIS_SAMPLE
ad_connect spi_ad7606/m_spi ad7606_spi

ad_connect $sys_cpu_clk spi_ad7606/clk
ad_connect spi_clk spi_ad7606/spi_clk
ad_connect spi_clk ad7606_dma/s_axis_aclk
ad_connect sys_cpu_resetn spi_ad7606/resetn
ad_connect sys_cpu_resetn ad7606_dma/m_dest_axi_aresetn

ad_connect rx_cnvst_n ad7606_pwm_gen/pwm_0

# interconnect

ad_cpu_interconnect 0x44a00000 spi_ad7606/axi_regmap
ad_cpu_interconnect 0x44a30000 ad7606_dma
ad_cpu_interconnect 0x44a70000 spi_clkgen
ad_cpu_interconnect 0x44b00000 ad7606_pwm_gen

# memory interconnect

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk ad7606_dma/m_dest_axi

# interrupts

ad_cpu_interrupt "ps-13" "mb-13" ad7606_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" /spi_ad7606/irq

# ila

#create_bd_port -dir O -from 0 -to 0 ila_ad7606_cnvnt_n
#create_bd_port -dir O -from 0 -to 0 ila_ad7606_busy
#create_bd_port -dir O -from 7 -to 0 ila_ad7606_sdi
#create_bd_port -dir O -from 0 -to 0 ila_ad7606_sdo

#ad_connect rx_cnvst_n ila_ad7606_cnvnt_n
#ad_connect rx_busy ila_ad7606_busy
#ad_connect ad7606_spi_sdi ila_ad7606_sdi
#ad_connect ad7606_spi_sdo ila_ad7606_sdo

#ad_ip_instance ila ila_0
#ad_ip_parameter ila_0 CONFIG.C_MONITOR_TYPE Native
#ad_ip_parameter ila_0 CONFIG.C_TRIGIN_EN false
#ad_ip_parameter ila_0 CONFIG.C_EN_STRG_QUAL 1
#ad_ip_parameter ila_0 CONFIG.C_DATA_DEPTH 8192
#ad_ip_parameter ila_0 CONFIG.C_NUM_OF_PROBES 2

#ad_ip_parameter ila_0 CONFIG.C_PROBE0_WIDTH 1
#ad_ip_parameter ila_0 CONFIG.C_PROBE1_WIDTH 8
#ad_ip_parameter ila_0 CONFIG.C_PROBE2_WIDTH 8
#ad_ip_parameter ila_0 CONFIG.C_PROBE3_WIDTH 1

#ad_connect $sys_cpu_clk ila_0/clk
#ad_connect rx_cnvst_n ila_0/probe0
#ad_connect rx_busy ila_0/probe0

#ad_connect ad7606_spi_sdi execution_spi_sdi
#ad_connect ad7606_spi_sdo execution_spi_sdo

#ad_connect  ad7606_spi_sdi ila_0/probe1
#ad_connect  ad7606_spi_sdo ila_0/probe3
set data_width 64

#
# Port definitions
#

set clk   [create_bd_port -dir O clk]

# define ports for tx
set dma_dac_dunf      [create_bd_port -dir O dma_dac_dunf]
set core_dac_dunf     [create_bd_port -dir I core_dac_dunf]
set dma_dac_ddata     [create_bd_port -dir O -from $data_width -to 0 dma_dac_ddata]
set core_dac_ddata    [create_bd_port -dir I -from $data_width -to 0 core_dac_ddata]
set dma_dac_en        [create_bd_port -dir I dma_dac_en]
set core_dac_en       [create_bd_port -dir O core_dac_en]
set dma_dac_dvalid    [create_bd_port -dir O dma_dac_dvalid]
set core_dac_dvalid   [create_bd_port -dir I core_dac_dvalid]

# define ports for rx
set dma_adc_ovf       [create_bd_port -dir O dma_adc_ovf]
set core_adc_ovf      [create_bd_port -dir I core_adc_ovf]
set dma_adc_ddata     [create_bd_port -dir I -from $data_width -to 0 dma_adc_ddata]
set core_adc_ddata    [create_bd_port -dir O -from $data_width -to 0 core_adc_ddata]
set dma_adc_dwr       [create_bd_port -dir I dma_adc_dwr]
set core_adc_dwr      [create_bd_port -dir O core_adc_dwr]
set dma_adc_dsync     [create_bd_port -dir I dma_adc_dsync]
set core_adc_dsync    [create_bd_port -dir O core_adc_dsync]

# define gpio input/outpu ports
set up_dac_gpio_in    [create_bd_port -dir I -from 31 -to 0 up_dac_gpio_in]
set up_adc_gpio_in    [create_bd_port -dir I -from 31 -to 0 up_adc_gpio_in]
set up_dac_gpio_out   [create_bd_port -dir O -from 31 -to 0 up_dac_gpio_out]
set up_adc_gpio_out   [create_bd_port -dir O -from 31 -to 0 up_adc_gpio_out]

#
# Net definitions
#

# connect clock signal
connect_bd_net [get_bd_pins axi_ad9361/clk] [get_bd_ports clk]

# connections for tx path

# clear the existing datapath
delete_bd_objs [get_bd_nets axi_ad9361_dac_dunf] [get_bd_nets fifo_data] [get_bd_nets axi_ad9361_dac_drd] [get_bd_nets fifo_valid]

# connect pins to port
connect_bd_net -net rp_dma_unf_tx   [get_bd_pins axi_ad9361_dac_dma/fifo_rd_underflow]  [get_bd_ports dma_dac_dunf]
connect_bd_net -net rp_dma_data_tx  [get_bd_pins axi_ad9361_dac_dma/fifo_rd_dout]       [get_bd_ports dma_dac_ddata]
connect_bd_net -net rp_dma_rdy_tx   [get_bd_pins axi_ad9361_dac_dma/fifo_rd_en]         [get_bd_ports dma_dac_en]
connect_bd_net -net rp_dma_rdvalid  [get_bd_pins axi_ad9361_dac_dma/fifo_rd_valid]      [get_bd_ports dma_dac_dvalid]


connect_bd_net -net rp_core_unf_tx  [get_bd_pins axi_ad9361/dac_dunf]                   [get_bd_ports core_dac_dunf]
connect_bd_net -net rp_core_data_tx [get_bd_pins util_dac_unpack/dma_data]              [get_bd_ports core_dac_ddata]
connect_bd_net -net rp_core_rdy_tx  [get_bd_pins util_dac_unpack/dma_rd]                [get_bd_ports core_dac_en]
connect_bd_net -net rp_core_rdvalid [get_bd_pins util_dac_unpack/fifo_valid]            [get_bd_ports core_dac_dvalid]

# connections for rx path

# clear the existing datapath
delete_bd_objs [get_bd_nets axi_ad9361_adc_dovf] [get_bd_nets util_adc_pack_ddata] [get_bd_nets util_adc_pack_dvalid] [get_bd_nets util_adc_pack_dsync]

# connect pins to port
connect_bd_net -net rp_dma_ovf_rx   [get_bd_pins axi_ad9361_adc_dma/fifo_wr_overflow] [get_bd_ports dma_adc_ovf]
connect_bd_net -net rp_dma_data_rx  [get_bd_pins axi_ad9361_adc_dma/fifo_wr_din]      [get_bd_ports dma_adc_ddata]
connect_bd_net -net rp_dma_rdy_rx   [get_bd_pins axi_ad9361_adc_dma/fifo_wr_en]       [get_bd_ports dma_adc_dwr]
connect_bd_net -net rp_dma_sync_rx  [get_bd_pins axi_ad9361_adc_dma/fifo_wr_sync]     [get_bd_ports dma_adc_dsync]

connect_bd_net -net rp_core_ovf_rx  [get_bd_pins axi_ad9361/adc_dovf]                 [get_bd_ports core_adc_ovf]
connect_bd_net -net rp_core_data_rx [get_bd_pins util_adc_pack/ddata]                 [get_bd_ports core_adc_ddata]
connect_bd_net -net rp_core_rdy_rx  [get_bd_pins util_adc_pack/dvalid]                [get_bd_ports core_adc_dwr]
connect_bd_net -net rp_core_sync_rx [get_bd_pins util_adc_pack/dsync]                 [get_bd_ports core_adc_dsync]

connect_bd_net -net dac_gpio_in     [get_bd_pins axi_ad9361/up_dac_gpio_in]           [get_bd_ports up_dac_gpio_in]
connect_bd_net -net adc_gpio_in     [get_bd_pins axi_ad9361/up_adc_gpio_in]           [get_bd_ports up_adc_gpio_in]
connect_bd_net -net dac_gpio_out    [get_bd_pins axi_ad9361/up_dac_gpio_out]          [get_bd_ports up_dac_gpio_out]
connect_bd_net -net adc_gpio_out    [get_bd_pins axi_ad9361/up_adc_gpio_out]          [get_bd_ports up_adc_gpio_out]

set ila_adc_core [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:4.0 ila_adc_core]
set_property -dict [list CONFIG.Component_Name {"pr2adc_core_ila"}] $ila_adc_core
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}]            $ila_adc_core
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}]                $ila_adc_core
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}]                 $ila_adc_core
set_property -dict [list CONFIG.C_PROBE1_WIDTH {64}]                $ila_adc_core
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}]                 $ila_adc_core

set ila_dac_core [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:4.0 ila_dac_core]
set_property -dict [list CONFIG.Component_Name {"pr2dac_core_ila"}] $ila_dac_core
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}]            $ila_dac_core
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}]                $ila_dac_core
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}]                 $ila_dac_core
set_property -dict [list CONFIG.C_PROBE1_WIDTH {64}]                $ila_dac_core
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}]                 $ila_dac_core

set ila_adc_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:4.0 ila_adc_dma]
set_property -dict [list CONFIG.Component_Name {"pr2adc_dma_ila"}]  $ila_adc_dma
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}]            $ila_adc_dma
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}]                $ila_adc_dma
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}]                 $ila_adc_dma
set_property -dict [list CONFIG.C_PROBE1_WIDTH {64}]                $ila_adc_dma
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}]                 $ila_adc_dma

set ila_dac_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:4.0 ila_dac_dma]
set_property -dict [list CONFIG.Component_Name {"pr2dac_dma_ila"}]  $ila_dac_dma
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}]            $ila_dac_dma
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}]                $ila_dac_dma
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}]                 $ila_dac_dma
set_property -dict [list CONFIG.C_PROBE1_WIDTH {64}]                $ila_dac_dma
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}]                 $ila_dac_dma

connect_bd_net [get_bd_pins ila_adc_core/clk] [get_bd_ports clk]
connect_bd_net [get_bd_pins ila_dac_core/clk] [get_bd_ports clk]
connect_bd_net [get_bd_pins ila_adc_dma/clk]  [get_bd_ports clk]
connect_bd_net [get_bd_pins ila_dac_dma/clk]  [get_bd_ports clk]

connect_bd_net -net rp_core_rdy_rx      [get_bd_pins ila_adc_core/probe0]
connect_bd_net -net rp_core_data_rx     [get_bd_pins ila_adc_core/probe1]

connect_bd_net -net rp_core_rdvalid     [get_bd_pins ila_dac_core/probe0]
connect_bd_net -net rp_core_data_tx     [get_bd_pins ila_dac_core/probe1]

connect_bd_net -net rp_dma_rdy_rx       [get_bd_pins ila_adc_dma/probe0]
connect_bd_net -net rp_dma_data_rx      [get_bd_pins ila_adc_dma/probe1]

connect_bd_net -net rp_dma_rdy_tx       [get_bd_pins ila_dac_dma/probe0]
connect_bd_net -net rp_dma_data_tx      [get_bd_pins ila_dac_dma/probe1]



# spi interface

set spi_udc_clk_i       [create_bd_port -dir I spi_udc_clk_i]
set spi_udc_clk_o       [create_bd_port -dir O spi_udc_clk_o]
set spi_udc_csn_i       [create_bd_port -dir I spi_udc_csn_i]
set spi_udc_csn_tx_o    [create_bd_port -dir O spi_udc_csn_tx_o]
set spi_udc_csn_rx_o    [create_bd_port -dir O spi_udc_csn_rx_o]
set spi_udc_mosi_i      [create_bd_port -dir I spi_udc_mosi_i]
set spi_udc_mosi_o      [create_bd_port -dir O spi_udc_mosi_o]
set spi_udc_miso_i      [create_bd_port -dir I spi_udc_miso_i]

# additions to default configuration

set_property -dict [list CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_SPI1_IO {EMIO}] $sys_ps7

# spi connections

connect_bd_net -net spi_udc_csn_i       [get_bd_ports spi_udc_csn_i]      [get_bd_pins sys_ps7/SPI1_SS_I]
connect_bd_net -net spi_udc_csn_tx_o    [get_bd_ports spi_udc_csn_tx_o]   [get_bd_pins sys_ps7/SPI1_SS_O]
connect_bd_net -net spi_udc_csn_rx_o    [get_bd_ports spi_udc_csn_rx_o]   [get_bd_pins sys_ps7/SPI1_SS1_O]
connect_bd_net -net spi_udc_clk_i       [get_bd_ports spi_udc_clk_i]      [get_bd_pins sys_ps7/SPI1_SCLK_I]
connect_bd_net -net spi_udc_clk_o       [get_bd_ports spi_udc_clk_o]      [get_bd_pins sys_ps7/SPI1_SCLK_O]
connect_bd_net -net spi_udc_mosi_i      [get_bd_ports spi_udc_mosi_i]     [get_bd_pins sys_ps7/SPI1_MOSI_I]
connect_bd_net -net spi_udc_mosi_o      [get_bd_ports spi_udc_mosi_o]     [get_bd_pins sys_ps7/SPI1_MOSI_O]
connect_bd_net -net spi_udc_miso_i      [get_bd_ports spi_udc_miso_i]     [get_bd_pins sys_ps7/SPI1_MISO_I]



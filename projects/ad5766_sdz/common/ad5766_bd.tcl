
# create a SPI Engine architecture

create_bd_cell -type hier spi
current_bd_instance /spi

        create_bd_pin -dir I -type clk clk
        create_bd_pin -dir I -type rst resetn
        create_bd_pin -dir O irq
        create_bd_pin -dir O dma_clk
        create_bd_pin -dir I dma_enable
        create_bd_pin -dir O dma_valid
        create_bd_pin -dir I -from 15 -to 0 dma_data
        create_bd_pin -dir I dma_xfer_req
        create_bd_pin -dir I dma_underflow
        create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 m_spi

        set spi_engine [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_execution:1.0 execution]
        set axi_spi_engine [create_bd_cell -type ip -vlnv analog.com:user:axi_spi_engine:1.0 axi]
        set axi_ad5766_seq [create_bd_cell -type ip -vlnv analog.com:user:axi_ad5766:1.0 axi_ad5766]
        set spi_engine_interconnect [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_interconnect:1.0 interconnect]

        set_property -dict [list CONFIG.NUM_OF_CS 1] $spi_engine
        set_property -dict [list CONFIG.NUM_OFFLOAD 1] $axi_spi_engine
        set_property -dict [list CONFIG.NUM_OF_SDI 2] $spi_engine_interconnect

        ad_connect  axi/spi_engine_offload_ctrl0 axi_ad5766/spi_engine_offload_ctrl
        ad_connect  axi/spi_engine_ctrl interconnect/s0_ctrl
        ad_connect  axi_ad5766/spi_engine_ctrl interconnect/s1_ctrl
        ad_connect  interconnect/m_ctrl execution/ctrl
        ad_connect  m_spi execution/spi
        ad_connect  dma_data axi_ad5766/dma_data
        ad_connect  dma_enable axi_ad5766/dma_enable
        ad_connect  dma_valid axi_ad5766/dma_valid
        ad_connect  dma_xfer_req axi_ad5766/dma_xfer_req
        ad_connect  dma_underflow axi_ad5766/dma_underflow

        ad_connect  clk execution/clk
        ad_connect  clk axi/s_axi_aclk
        ad_connect  clk axi_ad5766/s_axi_aclk
        ad_connect  clk axi_ad5766/spi_clk
        ad_connect  clk axi_ad5766/ctrl_clk
        ad_connect  clk axi/spi_clk
        ad_connect  clk interconnect/clk
        ad_connect  dma_clk axi_ad5766/dma_clk

        ad_connect  axi/spi_resetn axi_ad5766/spi_resetn
        ad_connect  axi/spi_resetn execution/resetn
        ad_connect  axi/spi_resetn interconnect/resetn

        ad_connect  resetn axi/s_axi_aresetn
        ad_connect  resetn axi_ad5766/s_axi_aresetn
        ad_connect  irq axi/irq

current_bd_instance /

ad_connect  sys_cpu_clk spi/clk
ad_connect  sys_cpu_resetn spi/resetn

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 spi
ad_connect spi/m_spi spi

set axi_ad5766_dac_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad5766_dac_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {0}] $axi_ad5766_dac_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {2}] $axi_ad5766_dac_dma
set_property -dict [list CONFIG.CYCLIC {1}] $axi_ad5766_dac_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {0}] $axi_ad5766_dac_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_ad5766_dac_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {1}] $axi_ad5766_dac_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_ad5766_dac_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {16}] $axi_ad5766_dac_dma

ad_connect  spi/dma_clk axi_ad5766_dac_dma/fifo_rd_clk
ad_connect  spi/dma_valid axi_ad5766_dac_dma/fifo_rd_en
ad_connect  spi/dma_xfer_req axi_ad5766_dac_dma/fifo_rd_xfer_req
ad_connect  spi/dma_data axi_ad5766_dac_dma/fifo_rd_dout
ad_connect  spi/dma_underflow axi_ad5766_dac_dma/fifo_rd_underflow
ad_connect  spi/dma_enable VCC

ad_cpu_interconnect 0x44a00000 spi/axi
ad_cpu_interconnect 0x44a10000 spi/axi_ad5766
ad_cpu_interconnect 0x44a20000 axi_ad5766_dac_dma
ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad5766_dac_dma/m_src_axi

ad_connect  sys_cpu_resetn axi_ad5766_dac_dma/m_src_axi_aresetn

ad_cpu_interrupt ps-12 mb-13 spi/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad5766_dac_dma/irq


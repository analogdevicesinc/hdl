###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# RX parameters
set RX_NUM_OF_LANES 1        ; # L
set RX_NUM_OF_CONVERTERS 32  ; # M
set RX_SAMPLES_PER_FRAME 1   ; # S
set RX_SAMPLE_WIDTH 16       ; # N/NP

adi_project_files adi_vna_8ch_zcu102 [list \
  "$ad_hdl_dir/library/common/ad_edge_detect.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
]

source $ad_hdl_dir/projects/ad9083_evb/common/ad9083_evb_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

# DAC instances connections

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set TX_JESD_M    $ad_project_params(TX_JESD_M)
set TX_JESD_L    $ad_project_params(TX_JESD_L)
set TX_NUM_LINKS $ad_project_params(TX_NUM_LINKS)

puts "TX_JESD_M    $TX_JESD_M"
puts "TX_JESD_L    $TX_JESD_L"
puts "TX_NUM_LINKS $TX_NUM_LINKS"

set TX_NUM_OF_CONVERTERS [expr $TX_NUM_LINKS * $TX_JESD_M]
set TX_NUM_OF_LANES [expr $TX_NUM_LINKS * $TX_JESD_L]
set TX_SAMPLES_PER_FRAME $ad_project_params(TX_JESD_S)
set TX_SAMPLE_WIDTH $ad_project_params(TX_JESD_NP)

set DAC_DATA_WIDTH [expr $TX_NUM_OF_LANES * 32]
set TX_SAMPLES_PER_CHANNEL [expr $DAC_DATA_WIDTH / $TX_NUM_OF_CONVERTERS / $TX_SAMPLE_WIDTH]

set TX_MAX_NUM_OF_LANES 4
# Top level ports

create_bd_port -dir I dac_fifo_bypass

# dac peripherals

# JESD204 PHY layer peripheral
ad_ip_instance axi_adxcvr dac_jesd204_xcvr [list \
  NUM_OF_LANES $TX_NUM_OF_LANES \
  QPLL_ENABLE 1 \
  TX_OR_RX_N 1 \
]

# JESD204 link layer peripheral
adi_axi_jesd204_tx_create dac_jesd204_link $TX_NUM_OF_LANES $TX_NUM_LINKS

# JESD204 transport layer peripheral
adi_tpl_jesd204_tx_create dac_jesd204_transport $TX_NUM_OF_LANES \
                                                $TX_NUM_OF_CONVERTERS \
                                                $TX_SAMPLES_PER_FRAME \
                                                $TX_SAMPLE_WIDTH

ad_ip_instance util_upack2 dac_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

set dac_dma_data_width $DAC_DATA_WIDTH
ad_ip_instance axi_dmac dac_dma [list \
  DMA_TYPE_SRC 0 \
  DMA_TYPE_DEST 1 \
  DMA_DATA_WIDTH_SRC 64 \
  DMA_DATA_WIDTH_DEST $dac_dma_data_width \
  AXI_SLICE_DEST true \
  AXI_SLICE_SRC true \
]

ad_dacfifo_create axi_dac_fifo \
                  $DAC_DATA_WIDTH \
                  $dac_dma_data_width \
                  $dac_fifo_address_width

# shared transceiver core

ad_ip_instance util_adxcvr util_dac_jesd204_xcvr [list \
  RX_NUM_OF_LANES 0 \
  TX_NUM_OF_LANES $TX_MAX_NUM_OF_LANES \
  TX_LANE_INVERT [expr 0x0B] \
  QPLL_REFCLK_DIV 1 \
  QPLL_FBDIV_RATIO 1 \
  QPLL_FBDIV 0x80 \
  TX_OUT_DIV 1 \
]

ad_connect sys_cpu_resetn util_dac_jesd204_xcvr/up_rstn
ad_connect sys_cpu_clk util_dac_jesd204_xcvr/up_clk

# reference clocks & resets

for {set i 0} {$i < $TX_MAX_NUM_OF_LANES} {incr i} {
  if {$i % 4 == 0} {
    create_bd_port -dir I tx_ref_clk_${i}
    ad_xcvrpll tx_ref_clk_${i} util_dac_jesd204_xcvr/qpll_ref_clk_${i}
    set quad_ref_clk tx_ref_clk_${i}
  }
  ad_xcvrpll $quad_ref_clk util_dac_jesd204_xcvr/cpll_ref_clk_${i}
}

ad_xcvrpll dac_jesd204_xcvr/up_pll_rst util_dac_jesd204_xcvr/up_qpll_rst_*
ad_xcvrpll dac_jesd204_xcvr/up_pll_rst util_dac_jesd204_xcvr/up_cpll_rst_*

# connections (dac)

ad_xcvrcon util_dac_jesd204_xcvr dac_jesd204_xcvr dac_jesd204_link {} {} {} $TX_MAX_NUM_OF_LANES

ad_connect util_dac_jesd204_xcvr/tx_out_clk_0 dac_jesd204_transport/link_clk
ad_connect util_dac_jesd204_xcvr/tx_out_clk_0 dac_upack/clk
ad_connect dac_jesd204_link_rstgen/peripheral_reset dac_upack/reset

ad_connect dac_jesd204_link/tx_data dac_jesd204_transport/link

ad_connect dac_jesd204_transport/dac_valid_0 dac_upack/fifo_rd_en
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect dac_upack/fifo_rd_data_$i dac_jesd204_transport/dac_data_$i
  ad_connect dac_jesd204_transport/dac_enable_$i  dac_upack/enable_$i
}

ad_connect util_dac_jesd204_xcvr/tx_out_clk_0 axi_dac_fifo/dac_clk
ad_connect dac_jesd204_link_rstgen/peripheral_reset axi_dac_fifo/dac_rst
ad_connect dac_upack/s_axis_valid VCC
ad_connect dac_upack/s_axis_ready axi_dac_fifo/dac_valid
ad_connect dac_upack/s_axis_data axi_dac_fifo/dac_data
ad_connect dac_jesd204_transport/dac_dunf axi_dac_fifo/dac_dunf
ad_connect $sys_dma_clk axi_dac_fifo/dma_clk
ad_connect $sys_dma_resetn axi_dac_fifo/dma_rst
ad_connect $sys_dma_clk dac_dma/m_axis_aclk
ad_connect $sys_dma_resetn dac_dma/m_src_axi_aresetn
ad_connect axi_dac_fifo/dma_xfer_req dac_dma/m_axis_xfer_req
ad_connect axi_dac_fifo/dma_ready dac_dma/m_axis_ready
ad_connect axi_dac_fifo/dma_data dac_dma/m_axis_data
ad_connect axi_dac_fifo/dma_valid dac_dma/m_axis_valid
ad_connect axi_dac_fifo/dma_xfer_last dac_dma/m_axis_last

ad_connect axi_dac_fifo/bypass dac_fifo_bypass

# add spi interfaces

create_bd_port -dir O -from 1 -to 0 fpga_bus0_csn_o
create_bd_port -dir I -from 1 -to 0 fpga_bus0_csn_i
create_bd_port -dir I fpga_bus0_clk_i
create_bd_port -dir O fpga_bus0_clk_o
create_bd_port -dir I fpga_bus0_sdo_i
create_bd_port -dir O fpga_bus0_sdo_o
create_bd_port -dir I fpga_bus0_sdi_i

create_bd_port -dir O -from 3 -to 0 fpga_bus1_csn_o
create_bd_port -dir I -from 3 -to 0 fpga_bus1_csn_i
create_bd_port -dir I fpga_bus1_clk_i
create_bd_port -dir O fpga_bus1_clk_o
create_bd_port -dir I fpga_bus1_sdo_i
create_bd_port -dir O fpga_bus1_sdo_o
create_bd_port -dir I fpga_bus1_sdi_i

create_bd_port -dir O -from 1 -to 0 spim_csn_o
create_bd_port -dir I -from 1 -to 0 spim_csn_i
create_bd_port -dir I spim_clk_i
create_bd_port -dir O spim_clk_o
create_bd_port -dir I spim_miso_i
create_bd_port -dir O spim_miso_o
create_bd_port -dir I spim_sdi_i

create_bd_port -dir O -from 7 -to 0 spi_adl5960_csn_o
create_bd_port -dir I -from 7 -to 0 spi_adl5960_csn_i
create_bd_port -dir I spi_adl5960_clk_i
create_bd_port -dir O spi_adl5960_clk_o
create_bd_port -dir I spi_adl5960_sdo_i
create_bd_port -dir O spi_adl5960_sdo_o
create_bd_port -dir I spi_adl5960_sdi_i

create_bd_port -dir I spi_fpga_busf_csn_i
create_bd_port -dir O spi_fpga_busf_csn_o
create_bd_port -dir I spi_fpga_busf_clk_i
create_bd_port -dir O spi_fpga_busf_clk_o
create_bd_port -dir I spi_fpga_busf_sdo_i
create_bd_port -dir O spi_fpga_busf_sdo_o
create_bd_port -dir I spi_fpga_busf_sdi_i

create_bd_port -dir I spi_fmcdac_csn_i
create_bd_port -dir O spi_fmcdac_csn_o
create_bd_port -dir I spi_fmcdac_clk_i
create_bd_port -dir O spi_fmcdac_clk_o
create_bd_port -dir I spi_fmcdac_sdo_i
create_bd_port -dir O spi_fmcdac_sdo_o
create_bd_port -dir I spi_fmcdac_sdi_i

create_bd_port -dir I ndac_spi_csn_i
create_bd_port -dir O ndac_spi_csn_o
create_bd_port -dir I ndac_spi_clk_i
create_bd_port -dir O ndac_spi_clk_o
create_bd_port -dir I ndac_spi_sdo_i
create_bd_port -dir O ndac_spi_sdo_o
create_bd_port -dir I ndac_spi_sdi_i

# spi instances

ad_ip_instance axi_quad_spi axi_fpga_bus0
ad_ip_parameter axi_fpga_bus0 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_fpga_bus0 CONFIG.C_NUM_SS_BITS 2
ad_ip_parameter axi_fpga_bus0 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_fpga_bus0 CONFIG.Multiples16 4

ad_ip_instance axi_quad_spi axi_fpga_bus1
ad_ip_parameter axi_fpga_bus1 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_fpga_bus1 CONFIG.C_NUM_SS_BITS 4
ad_ip_parameter axi_fpga_bus1 CONFIG.C_SCK_RATIO 8

ad_ip_instance axi_quad_spi axi_spim
ad_ip_parameter axi_spim CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spim CONFIG.C_NUM_SS_BITS 2
ad_ip_parameter axi_spim CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spim CONFIG.Multiples16 2

ad_ip_instance axi_quad_spi axi_spi_adl5960
ad_ip_parameter axi_spi_adl5960 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_adl5960 CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_adl5960 CONFIG.C_SCK_RATIO 16

ad_ip_instance axi_quad_spi axi_spi_fpga_busf
ad_ip_parameter axi_spi_fpga_busf CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_fpga_busf CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter axi_spi_fpga_busf CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_fpga_busf CONFIG.Multiples16 4

ad_ip_instance axi_quad_spi axi_spi_fmcdac
ad_ip_parameter axi_spi_fmcdac CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_fmcdac CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter axi_spi_fmcdac CONFIG.C_SCK_RATIO 4

ad_ip_instance axi_quad_spi axi_spi_ndac
ad_ip_parameter axi_spi_ndac CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_ndac CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter axi_spi_ndac CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_ndac CONFIG.Multiples16 4

# spi connections

ad_connect  sys_cpu_clk  axi_fpga_bus0/ext_spi_clk
ad_connect  fpga_bus0_csn_i  axi_fpga_bus0/ss_i
ad_connect  fpga_bus0_csn_o  axi_fpga_bus0/ss_o
ad_connect  fpga_bus0_clk_i  axi_fpga_bus0/sck_i
ad_connect  fpga_bus0_clk_o  axi_fpga_bus0/sck_o
ad_connect  fpga_bus0_sdo_i  axi_fpga_bus0/io0_i
ad_connect  fpga_bus0_sdo_o  axi_fpga_bus0/io0_o
ad_connect  fpga_bus0_sdi_i  axi_fpga_bus0/io1_i

ad_connect  sys_cpu_clk  axi_fpga_bus1/ext_spi_clk
ad_connect  fpga_bus1_csn_i  axi_fpga_bus1/ss_i
ad_connect  fpga_bus1_csn_o  axi_fpga_bus1/ss_o
ad_connect  fpga_bus1_clk_i  axi_fpga_bus1/sck_i
ad_connect  fpga_bus1_clk_o  axi_fpga_bus1/sck_o
ad_connect  fpga_bus1_sdo_i  axi_fpga_bus1/io0_i
ad_connect  fpga_bus1_sdo_o  axi_fpga_bus1/io0_o
ad_connect  fpga_bus1_sdi_i  axi_fpga_bus1/io1_i

ad_connect  sys_cpu_clk  axi_spim/ext_spi_clk
ad_connect  spim_csn_i  axi_spim/ss_i
ad_connect  spim_csn_o  axi_spim/ss_o
ad_connect  spim_clk_i  axi_spim/sck_i
ad_connect  spim_clk_o  axi_spim/sck_o
ad_connect  spim_miso_i  axi_spim/io0_i
ad_connect  spim_miso_o  axi_spim/io0_o
ad_connect  spim_sdi_i  axi_spim/io1_i

ad_connect  sys_cpu_clk  axi_spi_adl5960/ext_spi_clk
ad_connect  spi_adl5960_csn_i  axi_spi_adl5960/ss_i
ad_connect  spi_adl5960_csn_o  axi_spi_adl5960/ss_o
ad_connect  spi_adl5960_clk_i  axi_spi_adl5960/sck_i
ad_connect  spi_adl5960_clk_o  axi_spi_adl5960/sck_o
ad_connect  spi_adl5960_sdo_i  axi_spi_adl5960/io0_i
ad_connect  spi_adl5960_sdo_o  axi_spi_adl5960/io0_o
ad_connect  spi_adl5960_sdi_i  axi_spi_adl5960/io1_i

ad_connect  sys_cpu_clk  axi_spi_fpga_busf/ext_spi_clk
ad_connect  spi_fpga_busf_csn_i  axi_spi_fpga_busf/ss_i
ad_connect  spi_fpga_busf_csn_o  axi_spi_fpga_busf/ss_o
ad_connect  spi_fpga_busf_clk_i  axi_spi_fpga_busf/sck_i
ad_connect  spi_fpga_busf_clk_o  axi_spi_fpga_busf/sck_o
ad_connect  spi_fpga_busf_sdo_i  axi_spi_fpga_busf/io0_i
ad_connect  spi_fpga_busf_sdo_o  axi_spi_fpga_busf/io0_o
ad_connect  spi_fpga_busf_sdi_i  axi_spi_fpga_busf/io1_i

ad_connect  sys_cpu_clk  axi_spi_fmcdac/ext_spi_clk
ad_connect  spi_fmcdac_csn_i  axi_spi_fmcdac/ss_i
ad_connect  spi_fmcdac_csn_o  axi_spi_fmcdac/ss_o
ad_connect  spi_fmcdac_clk_i  axi_spi_fmcdac/sck_i
ad_connect  spi_fmcdac_clk_o  axi_spi_fmcdac/sck_o
ad_connect  spi_fmcdac_sdo_i  axi_spi_fmcdac/io0_i
ad_connect  spi_fmcdac_sdo_o  axi_spi_fmcdac/io0_o
ad_connect  spi_fmcdac_sdi_i  axi_spi_fmcdac/io1_i

ad_connect  sys_cpu_clk  axi_spi_ndac/ext_spi_clk
ad_connect  ndac_spi_csn_i  axi_spi_ndac/ss_i
ad_connect  ndac_spi_csn_o  axi_spi_ndac/ss_o
ad_connect  ndac_spi_clk_i  axi_spi_ndac/sck_i
ad_connect  ndac_spi_clk_o  axi_spi_ndac/sck_o
ad_connect  ndac_spi_sdo_i  axi_spi_ndac/io0_i
ad_connect  ndac_spi_sdo_o  axi_spi_ndac/io0_o
ad_connect  ndac_spi_sdi_i  axi_spi_ndac/io1_i

# interconnect (cpu)
ad_cpu_interconnect 0x48000000 axi_fpga_bus0
ad_cpu_interconnect 0x48100000 axi_fpga_bus1
ad_cpu_interconnect 0x48200000 axi_spi_adl5960
ad_cpu_interconnect 0x48300000 axi_spi_fmcdac
ad_cpu_interconnect 0x48400000 axi_spi_fpga_busf
ad_cpu_interconnect 0x48500000 axi_spim
ad_cpu_interconnect 0x48600000 axi_spi_ndac

ad_cpu_interconnect 0x44B60000 dac_jesd204_xcvr
ad_cpu_interconnect 0x44B04000 dac_jesd204_transport
ad_cpu_interconnect 0x44B90000 dac_jesd204_link
ad_cpu_interconnect 0x7c420000 dac_dma

# interrupts
ad_cpu_interrupt ps-3  mb-12 axi_spi_fmcdac/ip2intc_irpt
ad_cpu_interrupt ps-4  mb-11 dac_jesd204_link/irq
ad_cpu_interrupt ps-5  mb-10 dac_dma/irq
ad_cpu_interrupt ps-6  mb-10 axi_spi_ndac/ip2intc_irpt

ad_cpu_interrupt ps-8  mb-7  axi_spi_adl5960/ip2intc_irpt
ad_cpu_interrupt ps-9  mb-6  axi_spi_fpga_busf/ip2intc_irpt
ad_cpu_interrupt ps-10 mb-5  axi_fpga_bus1/ip2intc_irpt
ad_cpu_interrupt ps-11 mb-4  axi_fpga_bus0/ip2intc_irpt
ad_cpu_interrupt ps-15 mb-14  axi_spim/ip2intc_irpt

# interconnect mem

ad_mem_hp3_interconnect $sys_dma_clk sys_ps8/S_AXI_HP3
ad_mem_hp3_interconnect $sys_dma_clk dac_dma/m_src_axi

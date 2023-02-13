
# RX parameters
set RX_NUM_OF_LANES 1        ; # L
set RX_NUM_OF_CONVERTERS 32  ; # M
set RX_SAMPLES_PER_FRAME 1   ; # S
set RX_SAMPLE_WIDTH 16       ; # N/NP

adi_project_files adi_vna_4ch_zcu102 [list \
  "$ad_hdl_dir/library/common/ad_edge_detect.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
]

source $ad_hdl_dir/projects/ad9083_evb/common/ad9083_evb_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

# ad4858 interface

create_bd_port -dir O scki
create_bd_port -dir I scko
create_bd_port -dir I adc_lane_0
create_bd_port -dir I adc_lane_1
create_bd_port -dir I adc_lane_2
create_bd_port -dir I adc_lane_3
create_bd_port -dir I adc_lane_4
create_bd_port -dir I adc_lane_5
create_bd_port -dir I adc_lane_6
create_bd_port -dir I adc_lane_7
create_bd_port -dir I busy
create_bd_port -dir O cnv
create_bd_port -dir O lvds_cmos_n
create_bd_port -dir O system_cpu_clk

# clkgen

ad_ip_instance axi_clkgen axi_ad4858_clkgen
ad_ip_parameter axi_ad4858_clkgen CONFIG.VCO_DIV 5
ad_ip_parameter axi_ad4858_clkgen CONFIG.VCO_MUL 48
ad_ip_parameter axi_ad4858_clkgen CONFIG.CLK0_DIV 10

# adc(ad4858-dma)

ad_ip_instance axi_dmac ad4858_dma
ad_ip_parameter ad4858_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad4858_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad4858_dma CONFIG.CYCLIC 0
ad_ip_parameter ad4858_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad4858_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad4858_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad4858_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad4858_dma CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter ad4858_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_connect  sys_cpu_resetn ad4858_dma/m_dest_axi_aresetn

ad_connect  sys_cpu_clk ad4858_dma/fifo_wr_clk

# axi pwm gen

ad_ip_instance axi_pwm_gen axi_pwm_gen
ad_ip_parameter axi_pwm_gen CONFIG.N_PWMS 1
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_PERIOD 8

ad_connect cnv             axi_pwm_gen/pwm_0
ad_connect sys_cpu_resetn  axi_pwm_gen/s_axi_aresetn
ad_connect sys_cpu_clk     axi_pwm_gen/s_axi_aclk

# axi_ad4858

ad_ip_instance axi_ad4858 axi_ad4858_adc
ad_ip_parameter axi_ad4858_adc CONFIG.LVDS_CMOS_N 0
ad_ip_parameter axi_ad4858_adc CONFIG.EXTERNAL_CLK 0
ad_ip_parameter axi_ad4858_adc CONFIG.OVERSMP_ENABLE 1
ad_ip_parameter axi_ad4858_adc CONFIG.LANE_1_ENABLE 0
ad_ip_parameter axi_ad4858_adc CONFIG.LANE_3_ENABLE 0
ad_ip_parameter axi_ad4858_adc CONFIG.LANE_5_ENABLE 0
ad_ip_parameter axi_ad4858_adc CONFIG.LANE_7_ENABLE 0

ad_connect  adc_lane_0  axi_ad4858_adc/lane_0
ad_connect  adc_lane_2  axi_ad4858_adc/lane_2
ad_connect  adc_lane_4  axi_ad4858_adc/lane_4
ad_connect  adc_lane_6  axi_ad4858_adc/lane_6
ad_connect  scko  axi_ad4858_adc/scko
ad_connect  scki  axi_ad4858_adc/scki
ad_connect  busy  axi_ad4858_adc/busy
ad_connect  lvds_cmos_n  axi_ad4858_adc/lvds_cmos_n
ad_connect  axi_ad4858_adc/cnvs  axi_pwm_gen/pwm_0

# adc-path channel pack

ad_ip_instance proc_sys_reset proc_adc_reset
ad_connect proc_adc_reset/ext_reset_in sys_rstgen/peripheral_reset
ad_connect proc_adc_reset/slowest_sync_clk sys_cpu_clk
ad_connect adc_cd_reset proc_adc_reset/peripheral_reset

ad_ip_instance util_cpack2 ad4858_adc_pack
ad_ip_parameter ad4858_adc_pack CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter ad4858_adc_pack CONFIG.SAMPLE_DATA_WIDTH 32

ad_connect sys_cpu_clk ad4858_adc_pack/clk
ad_connect adc_cd_reset ad4858_adc_pack/reset
ad_connect axi_ad4858_adc/adc_valid ad4858_adc_pack/fifo_wr_en
ad_connect ad4858_adc_pack/packed_fifo_wr ad4858_dma/fifo_wr
ad_connect ad4858_adc_pack/fifo_wr_overflow axi_ad4858_adc/adc_dovf

for {set i 0} {$i < 8} {incr i} {
  ad_connect axi_ad4858_adc/adc_data_$i ad4858_adc_pack/fifo_wr_data_$i
  ad_connect axi_ad4858_adc/adc_enable_$i ad4858_adc_pack/enable_$i
}

# end of ad4858 instantiations

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
ad_connect sys_cpu_clk axi_dac_fifo/dma_clk
ad_connect sys_cpu_reset axi_dac_fifo/dma_rst
ad_connect sys_cpu_clk dac_dma/m_axis_aclk
ad_connect sys_cpu_resetn dac_dma/m_src_axi_aresetn
ad_connect axi_dac_fifo/dma_xfer_req dac_dma/m_axis_xfer_req
ad_connect axi_dac_fifo/dma_ready dac_dma/m_axis_ready
ad_connect axi_dac_fifo/dma_data dac_dma/m_axis_data
ad_connect axi_dac_fifo/dma_valid dac_dma/m_axis_valid
ad_connect axi_dac_fifo/dma_xfer_last dac_dma/m_axis_last

ad_connect axi_dac_fifo/bypass dac_fifo_bypass

# end of DAC instances connections

# add spi interfaces

create_bd_port -dir O -from 3 -to 0 spi_bus0_csn_o
create_bd_port -dir I -from 3 -to 0 spi_bus0_csn_i
create_bd_port -dir I spi_bus0_clk_i
create_bd_port -dir O spi_bus0_clk_o
create_bd_port -dir I spi_bus0_sdo_i
create_bd_port -dir O spi_bus0_sdo_o
create_bd_port -dir I spi_bus0_sdi_i

create_bd_port -dir O -from 1 -to 0 spi_bus1_csn_o
create_bd_port -dir I -from 1 -to 0 spi_bus1_csn_i
create_bd_port -dir I spi_bus1_clk_i
create_bd_port -dir O spi_bus1_clk_o
create_bd_port -dir I spi_bus1_sdo_i
create_bd_port -dir O spi_bus1_sdo_o
create_bd_port -dir I spi_bus1_sdi_i

create_bd_port -dir O -from 3 -to 0 spi_adl5960_1_csn_o
create_bd_port -dir I -from 3 -to 0 spi_adl5960_1_csn_i
create_bd_port -dir I spi_adl5960_1_clk_i
create_bd_port -dir O spi_adl5960_1_clk_o
create_bd_port -dir I spi_adl5960_1_sdo_i
create_bd_port -dir O spi_adl5960_1_sdo_o
create_bd_port -dir I spi_adl5960_1_sdi_i

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

# spi instances

ad_ip_instance axi_quad_spi axi_spi_bus0
ad_ip_parameter axi_spi_bus0 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_bus0 CONFIG.C_NUM_SS_BITS 4
ad_ip_parameter axi_spi_bus0 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_bus0 CONFIG.Multiples16 8

ad_ip_instance axi_quad_spi axi_spi_bus1
ad_ip_parameter axi_spi_bus1 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_bus1 CONFIG.C_NUM_SS_BITS 2
ad_ip_parameter axi_spi_bus1 CONFIG.C_SCK_RATIO 8

ad_ip_instance axi_quad_spi axi_spi_adl5960_1
ad_ip_parameter axi_spi_adl5960_1 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_adl5960_1 CONFIG.C_NUM_SS_BITS 4
ad_ip_parameter axi_spi_adl5960_1 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_adl5960_1 CONFIG.Multiples16 8

ad_ip_instance axi_quad_spi axi_spi_fpga_busf
ad_ip_parameter axi_spi_fpga_busf CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_fpga_busf CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter axi_spi_fpga_busf CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_fpga_busf CONFIG.Multiples16 8

ad_ip_instance axi_quad_spi axi_spi_fmcdac
ad_ip_parameter axi_spi_fmcdac CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_fmcdac CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter axi_spi_fmcdac CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_fmcdac CONFIG.Multiples16 8

# spi connections

ad_connect  sys_cpu_clk  axi_spi_bus0/ext_spi_clk
ad_connect  spi_bus0_csn_i  axi_spi_bus0/ss_i
ad_connect  spi_bus0_csn_o  axi_spi_bus0/ss_o
ad_connect  spi_bus0_clk_i  axi_spi_bus0/sck_i
ad_connect  spi_bus0_clk_o  axi_spi_bus0/sck_o
ad_connect  spi_bus0_sdo_i  axi_spi_bus0/io0_i
ad_connect  spi_bus0_sdo_o  axi_spi_bus0/io0_o
ad_connect  spi_bus0_sdi_i  axi_spi_bus0/io1_i

ad_connect  sys_cpu_clk  axi_spi_bus1/ext_spi_clk
ad_connect  spi_bus1_csn_i  axi_spi_bus1/ss_i
ad_connect  spi_bus1_csn_o  axi_spi_bus1/ss_o
ad_connect  spi_bus1_clk_i  axi_spi_bus1/sck_i
ad_connect  spi_bus1_clk_o  axi_spi_bus1/sck_o
ad_connect  spi_bus1_sdo_i  axi_spi_bus1/io0_i
ad_connect  spi_bus1_sdo_o  axi_spi_bus1/io0_o
ad_connect  spi_bus1_sdi_i  axi_spi_bus1/io1_i

ad_connect  sys_cpu_clk  axi_spi_adl5960_1/ext_spi_clk
ad_connect  spi_adl5960_1_csn_i  axi_spi_adl5960_1/ss_i
ad_connect  spi_adl5960_1_csn_o  axi_spi_adl5960_1/ss_o
ad_connect  spi_adl5960_1_clk_i  axi_spi_adl5960_1/sck_i
ad_connect  spi_adl5960_1_clk_o  axi_spi_adl5960_1/sck_o
ad_connect  spi_adl5960_1_sdo_i  axi_spi_adl5960_1/io0_i
ad_connect  spi_adl5960_1_sdo_o  axi_spi_adl5960_1/io0_o
ad_connect  spi_adl5960_1_sdi_i  axi_spi_adl5960_1/io1_i

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

ad_connect  sys_cpu_clk axi_ad4858_clkgen/clk
ad_connect  sys_cpu_clk  axi_pwm_gen/ext_clk

# interconnect (cpu)

ad_cpu_interconnect 0x44c00000 axi_ad4858_adc
ad_cpu_interconnect 0x44c30000 ad4858_dma
ad_cpu_interconnect 0x44c40000 axi_ad4858_clkgen
ad_cpu_interconnect 0x44c50000 axi_pwm_gen

ad_cpu_interconnect 0x48000000 axi_spi_bus0
ad_cpu_interconnect 0x48100000 axi_spi_bus1
ad_cpu_interconnect 0x48200000 axi_spi_adl5960_1
ad_cpu_interconnect 0x48300000 axi_spi_fmcdac
ad_cpu_interconnect 0x48400000 axi_spi_fpga_busf

ad_cpu_interconnect 0x44B60000 dac_jesd204_xcvr
ad_cpu_interconnect 0x44B04000 dac_jesd204_transport
ad_cpu_interconnect 0x44B90000 dac_jesd204_link
ad_cpu_interconnect 0x7c420000 dac_dma

# interrupts

ad_cpu_interrupt ps-3  mb-12 axi_spi_fmcdac/ip2intc_irpt
ad_cpu_interrupt ps-4  mb-11 dac_jesd204_link/irq
ad_cpu_interrupt ps-5  mb-10 dac_dma/irq
ad_cpu_interrupt ps-6  mb-9  ad4858_dma/irq

ad_cpu_interrupt ps-8  mb-7  axi_spi_adl5960_1/ip2intc_irpt
ad_cpu_interrupt ps-9  mb-6  axi_spi_fpga_busf/ip2intc_irpt
ad_cpu_interrupt ps-10 mb-5  axi_spi_bus1/ip2intc_irpt
ad_cpu_interrupt ps-11 mb-4  axi_spi_bus0/ip2intc_irpt

# interconnect mem

ad_mem_hp2_interconnect sys_cpu_clk ad4858_dma/m_dest_axi
ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp3_interconnect sys_cpu_clk dac_dma/m_src_axi


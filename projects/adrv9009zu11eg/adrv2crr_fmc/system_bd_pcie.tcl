###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################


# Instead of using PS SPI controller, use a PL based SPI controller
# which will be connected to the XDMA

# Delete old SPI lines
delete_bd_objs [get_bd_nets sys_ps8_emio_spi0_sclk_o] [get_bd_nets sys_ps8_emio_spi0_m_o] [get_bd_nets sys_ps8_emio_spi0_ss2_o_n] [get_bd_nets sys_ps8_emio_spi0_ss_o_n] [get_bd_nets spi0_csn_concat_dout] [get_bd_nets sys_ps8_emio_spi0_ss1_o_n] [get_bd_nets spi0_miso_1]
delete_bd_objs [get_bd_cells spi0_csn_concat]

# Delete old GPIO lines
delete_bd_objs [get_bd_nets sys_ps8_emio_gpio_o] [get_bd_nets gpio_i_1] [get_bd_nets sys_ps8_emio_gpio_t]


# GPIO controller

# Create 3 Slice instances for breaking the [94:0] GPIO signals into 3 sub-arrays
# for GPIO_I signals

# first [31:0]
ad_ip_instance ilslice slice_gpio1
ad_ip_parameter slice_gpio1 CONFIG.DIN_WIDTH {95}
ad_ip_parameter slice_gpio1 CONFIG.DIN_FROM {31}
ad_ip_parameter slice_gpio1 CONFIG.DIN_TO {0}
ad_ip_parameter slice_gpio1 CONFIG.DOUT_WIDTH {32}

# second [63:32]
ad_ip_instance ilslice slice_gpio2
ad_ip_parameter slice_gpio2 CONFIG.DIN_WIDTH {95}
ad_ip_parameter slice_gpio2 CONFIG.DIN_FROM {63}
ad_ip_parameter slice_gpio2 CONFIG.DIN_TO {32}
ad_ip_parameter slice_gpio2 CONFIG.DOUT_WIDTH {32}

# third [94:64]
ad_ip_instance ilslice slice_gpio3
ad_ip_parameter slice_gpio3 CONFIG.DIN_WIDTH {95}
ad_ip_parameter slice_gpio3 CONFIG.DIN_FROM {94}
ad_ip_parameter slice_gpio3 CONFIG.DIN_TO {64}
ad_ip_parameter slice_gpio3 CONFIG.DOUT_WIDTH {31}

# Create 2 Concat instances for concatenating the 3 sub-arrays GPIO signals into an array [94:0]
# for GPIO_O and GPIO_T signals

# GPIO_O
ad_ip_instance ilconcat concat_gpio1
ad_ip_parameter concat_gpio1 CONFIG.NUM_PORTS {3}
ad_ip_parameter concat_gpio1 CONFIG.IN0_WIDTH {32}
ad_ip_parameter concat_gpio1 CONFIG.IN1_WIDTH {32}
ad_ip_parameter concat_gpio1 CONFIG.IN2_WIDTH {31}

# GPIO_T
ad_ip_instance ilconcat concat_gpio2
ad_ip_parameter concat_gpio2 CONFIG.NUM_PORTS {3}
ad_ip_parameter concat_gpio2 CONFIG.IN0_WIDTH {32}
ad_ip_parameter concat_gpio2 CONFIG.IN1_WIDTH {32}
ad_ip_parameter concat_gpio2 CONFIG.IN2_WIDTH {31}

# Create 2 GPIO controllers to fit the 95 GPIO signals
# first GPIO controller in dual mode
ad_ip_instance axi_gpio axi_gpio1
ad_ip_parameter axi_gpio1 CONFIG.C_INTERRUPT_PRESENT {1}
ad_ip_parameter axi_gpio1 CONFIG.C_IS_DUAL {1}

ad_ip_instance axi_gpio axi_gpio2
ad_ip_parameter axi_gpio2 CONFIG.C_INTERRUPT_PRESENT {1}
ad_ip_parameter axi_gpio2 CONFIG.C_GPIO_WIDTH {31}

# Connect the concat & slice modules to the AXI GPIOs
# GPIO_I
ad_connect gpio_i slice_gpio1/Din
ad_connect gpio_i slice_gpio2/Din
ad_connect gpio_i slice_gpio3/Din
ad_connect slice_gpio1/Dout axi_gpio1/gpio_io_i
ad_connect slice_gpio2/Dout axi_gpio1/gpio2_io_i
ad_connect slice_gpio3/Dout axi_gpio2/gpio_io_i

# GPIO_O
ad_connect concat_gpio1/In0 axi_gpio1/gpio_io_o
ad_connect concat_gpio1/In1 axi_gpio1/gpio2_io_o
ad_connect concat_gpio1/In2 axi_gpio2/gpio_io_o
ad_connect concat_gpio1/dout gpio_o

# GPIO_T
ad_connect concat_gpio2/In0 axi_gpio1/gpio_io_t
ad_connect concat_gpio2/In1 axi_gpio1/gpio2_io_t
ad_connect concat_gpio2/In2 axi_gpio2/gpio_io_t
ad_connect concat_gpio2/dout gpio_t

# PCIe XDMA in AXI Bridge mode.
create_bd_cell -type ip -vlnv xilinx.com:ip:xdma pcie_xdma

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt

create_bd_port -dir I pcie_ref_clk
create_bd_port -dir I pcie_ref_clk_div2
create_bd_port -dir I -type rst pcie_perstn
create_bd_port -dir O user_link_up

ad_ip_parameter pcie_xdma CONFIG.functional_mode {AXI_Bridge}
ad_ip_parameter pcie_xdma CONFIG.pl_link_cap_max_link_speed {8.0_GT/s}
ad_ip_parameter pcie_xdma CONFIG.pl_link_cap_max_link_width {X8}
ad_ip_parameter pcie_xdma CONFIG.axi_data_width {256_bit}
ad_ip_parameter pcie_xdma CONFIG.axisten_freq {250}
ad_ip_parameter pcie_xdma CONFIG.axi_addr_width {64}
ad_ip_parameter pcie_xdma CONFIG.pf0_device_id {9038}
ad_ip_parameter pcie_xdma CONFIG.pcie_blk_locn {X1Y0}
ad_ip_parameter pcie_xdma CONFIG.pf0_msi_enabled {true}

# M_AXI_B BAR: host accesses PL peripherals.
# Base the BAR at AXI 0x8400_0000 so the migrated IPs keep the same AXI
# addresses they used in the CPU-hosted design (0x84A0_xxxx TPL cores /
# xcvrs / JESD, 0x8500_0000 sysid). Size = 32 MB so BAR0 covers
# 0x8400_0000..0x85FF_FFFF -- the XDMA IP defaults to 128 KB which only
# reaches the SPI + GPIOs at the low end and leaves the RF chain
# unmapped from the host side.
ad_ip_parameter pcie_xdma CONFIG.pciebar2axibar_0 {0x0000000084000000}
ad_ip_parameter pcie_xdma CONFIG.pf0_bar0_scale {Megabytes}
ad_ip_parameter pcie_xdma CONFIG.pf0_bar0_size  {32}

# S_AXI_B: axi_dmac masters write/read host RAM via PCIe.
#
# The aperture must span every host physical address the axi-dmac driver can
# hand us. The XDMA IP defaults S_AXI_B/BAR0 to 2**20 = 1 MB at a base Vivado
# auto-assigns, which is far too small: host buffers then fall outside the
# decode window, the SG descriptor fetch never reaches host RAM, and the DMA
# walks garbage descriptors -- raising EOT on a fixed cadence and delivering
# zeros. That was the original zero-data symptom.
#
# 0x0 .. 0xF_FFFF_FFFF = 64 GB, with axibar2pciebar_0 = 0 for an identity map:
# AXI address == host physical address, which is what the driver assumes when
# it programs a dma_addr_t straight into SG_ADDRESS/DEST_ADDRESS.
#
# 64 GB rather than 4 GB because x86 physical memory maps are sparse -- PCI
# MMIO displaces RAM above the 4 GB line, so a host with 4 GB installed still
# has RAM up there. On this host: low RAM ends at ~3.22 GiB (cdff4000) and
# 510 MiB sits at 0x1_00000000-0x1_1fdfffff. A 4 GB aperture cannot reach that
# range at all, and the driver is free to allocate there.
# axi_addr_width=64 above is what makes an aperture this wide reachable.
#
# ad_pcie_saxi_interconnect derives its per-master segment range from
# axibar_highaddr_0, so this is the only place the aperture size is declared.
# It must be set before the ad_pcie_saxi_interconnect calls further down.
ad_ip_parameter pcie_xdma CONFIG.axibar_num {1}
ad_ip_parameter pcie_xdma CONFIG.axibar_0 {0x0000000000000000}
ad_ip_parameter pcie_xdma CONFIG.axibar_highaddr_0 {0x0000000FFFFFFFFF}
ad_ip_parameter pcie_xdma CONFIG.axibar2pciebar_0 {0x0000000000000000}

# PCIe lane connections
connect_bd_intf_net [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins pcie_xdma/pcie_mgt]

# Clock and reset
ad_connect pcie_ref_clk pcie_xdma/sys_clk_gt
ad_connect pcie_ref_clk_div2 pcie_xdma/sys_clk
ad_connect pcie_perstn pcie_xdma/sys_rst_n

ad_connect user_link_up pcie_xdma/user_lnk_up

# XDMA AXI clock domain reset generator
ad_ip_instance proc_sys_reset pcie_axi_rstgen
ad_ip_parameter pcie_axi_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect pcie_axi_clk pcie_xdma/axi_aclk
ad_connect pcie_axi_clk pcie_axi_rstgen/slowest_sync_clk
ad_connect pcie_xdma/axi_aresetn pcie_axi_rstgen/ext_reset_in
ad_connect pcie_axi_resetn pcie_axi_rstgen/peripheral_aresetn

# ---------------------------------------------------------------------------
# SPI CONTROLLER
# Standard-mode axi_quad_spi driving the SoM SPI chain (adrv9009 A/B,
# SoM/carrier/ext HMC7044). Placed here (after pcie_xdma) so its
# ext_spi_clk can attach to pcie_axi_clk, keeping the AXI-Lite side and
# the SPI shift-register in a single domain with no internal CDC.
# ---------------------------------------------------------------------------
ad_ip_instance axi_quad_spi axi_spi
ad_ip_parameter axi_spi CONFIG.C_SPI_MODE {0}
ad_ip_parameter axi_spi CONFIG.C_NUM_SS_BITS {6}
ad_ip_parameter axi_spi CONFIG.C_USE_STARTUP {0}
ad_ip_parameter axi_spi CONFIG.C_NUM_TRANSFER_BITS {8}
ad_ip_parameter axi_spi CONFIG.C_SCK_RATIO {16}

# Widen spi0_csn from the base BD's [2:0] to [5:0] so the axi_spi's 6-bit
# one-hot ss_o (C_NUM_SS_BITS=6) can drive six physical CS lines directly
# in system_top_pcie.v. Four are currently used (adrv9009_a, adrv9009_b,
# hmc7044, hmc7044_car); bits [5:4] are reserved for the xmwbr1 expansion
# path (hmc7044_ext + AD9545 via gpio_0_exp_n / gpio_2_exp_n) if that
# daughter card is ever populated on this project variant.
delete_bd_objs [get_bd_ports spi0_csn]
create_bd_port -dir O -from 5 -to 0 spi0_csn

ad_connect axi_spi/io0_o spi0_mosi
ad_connect axi_spi/io1_i spi0_miso
ad_connect axi_spi/sck_o spi0_sclk
ad_connect axi_spi/ss_o spi0_csn
ad_connect axi_spi/ext_spi_clk pcie_axi_clk

# ---------------------------------------------------------------------------
# Reconfigure the ADI DMAs for PCIe host DMA.
#
# Every AXI port that is not on the JESD streaming side lands on pcie_axi_clk
# (250 MHz): req (s_axi), SG (m_sg_axi), and the MM-side data-path master
# (m_dest_axi for RX/OBS, m_src_axi for TX). Only the streaming side stays on
# JESD core_clk_a/b (unrelated PLL). This lets us drop dma_clk_wiz +
# sys_dma_rstgen entirely from the PCIe variant.
#
# Bandwidth is preserved by widening the MM-side data path to 256 bit --
# 256 bit x 250 MHz = 8 GB/s, well above the JESD streaming ceiling of
# 128 bit x ~245.76 MHz = ~3.9 GB/s. axi_dmac supports asymmetric widths
# via its resize_src / resize_dest submodules.
#
# These parameter changes must run BEFORE ad_pcie_interconnect maps the s_axi
# register window (enabling SG grows the s_axi segment).
# ---------------------------------------------------------------------------

foreach dma {
  axi_adrv9009_som_rx_dma
  axi_adrv9009_som_obs_dma
  axi_adrv9009_som_tx_dma
} {
  # 64 to match the S_AXI_B aperture: the axi-dmac driver autodetects the DMA
  # mask by writing 0xffffffff to DEST_ADDRESS_HIGH and reading it back
  # (dma-axi-dmac.c, mask = 32 + fls(mask)), so this width is what lets the
  # kernel place buffers and the SG descriptor ring above the 4 GB line. It
  # must, because x86 physical maps are sparse -- observed SG ring at
  # 0x1_0e92e000 on a host whose low RAM ends at ~3.22 GiB with 510 MiB at
  # 0x1_00000000-0x1_1fdfffff. Verified in silicon: DEST/SRC_ADDRESS_HIGH
  # reads back 0xffffffff on the built design.
  ad_ip_parameter $dma CONFIG.DMA_AXI_ADDR_WIDTH 64
  ad_ip_parameter $dma CONFIG.DMA_SG_TRANSFER 1
  # PCIe DMA reaches host RAM through XDMA S_AXI_B; the x86 root complex
  # snoops CPU caches on every DMA transaction so the writes ARE coherent
  # from the software's point of view. Advertise DST_COHERENT so the
  # axi-dmac driver's `of_dma_is_coherent(np) && DST_COHERENT` probe check
  # (dma-axi-dmac.c: axi_dmac_read(AXI_DMAC_REG_COHERENCY_DESC)) passes,
  # and let the DMAC drive AxCACHE=0xF so downstream fabric can honor it.
  ad_ip_parameter $dma CONFIG.CACHE_COHERENT 1
}

# Widen the MM-side to 256 bit so 250 MHz still exceeds the JESD 128b/245.76M
# throughput. RX/OBS write MM (DEST), TX reads MM (SRC).
ad_ip_parameter axi_adrv9009_som_rx_dma  CONFIG.DMA_DATA_WIDTH_DEST 256
ad_ip_parameter axi_adrv9009_som_obs_dma CONFIG.DMA_DATA_WIDTH_DEST 256
ad_ip_parameter axi_adrv9009_som_tx_dma  CONFIG.DMA_DATA_WIDTH_SRC  256

# ASYNC_CLK_* flags: only crossings involving the JESD streaming side remain
# async. The rest all live on pcie_axi_clk.
#   RX/OBS  src = JESD streaming, dest = pcie_axi_clk MM,
#           req = pcie_axi_clk,   sg   = pcie_axi_clk.
#     -> async pairs: req/src (1), src/dest (1), src/sg (1);
#        sync pairs:  dest/req (0), req/sg (0),  dest/sg (0).
#   TX      src = pcie_axi_clk MM, dest = JESD streaming,
#           req = pcie_axi_clk,   sg   = pcie_axi_clk.
#     -> async pairs: src/dest (1), dest/req (1), dest/sg (1);
#        sync pairs:  req/src (0),  req/sg (0),   src/sg (0).
foreach dma { axi_adrv9009_som_rx_dma axi_adrv9009_som_obs_dma } {
  ad_ip_parameter $dma CONFIG.ASYNC_CLK_REQ_SRC  1
  ad_ip_parameter $dma CONFIG.ASYNC_CLK_SRC_DEST 1
  ad_ip_parameter $dma CONFIG.ASYNC_CLK_DEST_REQ 0
  ad_ip_parameter $dma CONFIG.ASYNC_CLK_REQ_SG   0
  ad_ip_parameter $dma CONFIG.ASYNC_CLK_SRC_SG   1
  ad_ip_parameter $dma CONFIG.ASYNC_CLK_DEST_SG  0
}
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.ASYNC_CLK_REQ_SRC  0
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.ASYNC_CLK_SRC_DEST 1
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.ASYNC_CLK_DEST_REQ 1
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.ASYNC_CLK_REQ_SG   0
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.ASYNC_CLK_SRC_SG   0
ad_ip_parameter axi_adrv9009_som_tx_dma CONFIG.ASYNC_CLK_DEST_SG  1

# M_AXI_B path: Host -> peripherals.
# ad_pcie_interconnect creates the pcie_ctrl_sc SmartConnect on the first call
# and grows it on each subsequent call, wiring clocks/resets and assigning the
# peripheral segment inside the pcie_xdma/M_AXI_B address space.

ad_pcie_interconnect 0x84000000 axi_spi   AXI_LITE
ad_pcie_interconnect 0x84010000 axi_gpio1 S_AXI
ad_pcie_interconnect 0x84020000 axi_gpio2 S_AXI

# XDMA user interrupts. ad_pcie_interrupt creates concat_xdma_int on the first
# call and wires its dout to pcie_xdma/usr_irq_req automatically.
ad_pcie_interrupt axi_spi/ip2intc_irpt
ad_pcie_interrupt axi_gpio1/ip2intc_irpt
ad_pcie_interrupt axi_gpio2/ip2intc_irpt

# ---------------------------------------------------------------------------
# Migrate the RF/JESD/DMA/SysID register-map slaves from the PS CPU
# (axi_hpm0_lpd_interconnect) to the PCIe bridge (pcie_ctrl_sc).
# ad_pcie_interconnect will detach each IP from its existing CPU-side net,
# drop the CPU address segment, free the associated clock/reset, and re-wire
# it into pcie_ctrl_sc / pcie_xdma/M_AXI_B in the PCIe axi clock domain.
# Offsets are within pcie_xdma/M_AXI_B and stay on 64 KB boundaries.
# ---------------------------------------------------------------------------

ad_pcie_interconnect 0x84A00000 rx_adrv9009_som_tpl_core
ad_pcie_interconnect 0x84A04000 tx_adrv9009_som_tpl_core
ad_pcie_interconnect 0x84A08000 obs_adrv9009_som_tpl_core
ad_pcie_interconnect 0x84A20000 axi_adrv9009_som_tx_xcvr
ad_pcie_interconnect 0x84A30000 axi_adrv9009_som_tx_jesd
ad_pcie_interconnect 0x84A40000 axi_adrv9009_som_rx_xcvr
ad_pcie_interconnect 0x84A50000 axi_adrv9009_som_rx_jesd
ad_pcie_interconnect 0x84A60000 axi_adrv9009_som_obs_xcvr
ad_pcie_interconnect 0x84A70000 axi_adrv9009_som_obs_jesd
ad_pcie_interconnect 0x84C00000 axi_adrv9009_som_tx_dma
ad_pcie_interconnect 0x84C10000 axi_adrv9009_som_rx_dma
ad_pcie_interconnect 0x84C20000 axi_adrv9009_som_obs_dma
ad_pcie_interconnect 0x85000000 axi_sysid_0

# Route the IRQs of the moved IPs to the PCIe bridge. ad_pcie_interrupt
# detaches each pin from its existing sys_concat_intc_* net before attaching
# to concat_xdma_int.
ad_pcie_interrupt axi_adrv9009_som_obs_dma/irq
ad_pcie_interrupt axi_adrv9009_som_tx_dma/irq
ad_pcie_interrupt axi_adrv9009_som_rx_dma/irq
ad_pcie_interrupt axi_adrv9009_som_obs_jesd/irq
ad_pcie_interrupt axi_adrv9009_som_tx_jesd/irq
ad_pcie_interrupt axi_adrv9009_som_rx_jesd/irq

# Redirect the axi_adxcvr eye-scan data path (m_axi) from PS DDR (HP0) to
# host RAM via pcie_saxi_sc / pcie_xdma/S_AXI_B, so the host driver can read
# eye-scan buffers directly from host memory. The xcvr m_axi shares s_axi_aclk
# (ASSOCIATED_BUSIF="s_axi:m_axi"), which ad_pcie_interconnect already moved
# to pcie_axi_clk, so pass that here. Note axi_adxcvr/m_axi is 32-bit-addressed
# even though S_AXI_B is 64, so eye-scan buffers specifically must land in the
# low 4 GB; the axi_dmac masters have no such restriction.
ad_pcie_saxi_interconnect pcie_axi_clk axi_adrv9009_som_rx_xcvr/m_axi
ad_pcie_saxi_interconnect pcie_axi_clk axi_adrv9009_som_obs_xcvr/m_axi

# Retarget pins that adrv9009zu11eg_bd.tcl / adrv2crr_fmc_bd.tcl wired to
# sys_cpu_{clk,resetn} but that must follow their newly-PCIe-hosted peer:
#
#   util_adrv9009_som_xcvr/up_clk,up_rstn - the up_* control bus between
#     axi_adxcvr and util_adxcvr has no CDC synchronizers (axi_adxcvr.v:
#     `assign up_clk = s_axi_aclk`), so both ends must share a domain.
#     axi_adxcvr moved to pcie_axi_clk / pcie_axi_resetn.
#
#   rom_sys_0/clk - axi_sysid captures rom_data on s_axi_aclk (up_clk =
#     s_axi_aclk), so the ROM must be clocked on the same domain to avoid a
#     hidden CDC on the data bus. axi_sysid_0/s_axi_aclk moved to pcie_axi_clk.
foreach {pin_path new_src} {
  util_adrv9009_som_xcvr/up_clk    pcie_axi_clk
  util_adrv9009_som_xcvr/up_rstn   pcie_axi_resetn
  rom_sys_0/clk                    pcie_axi_clk
} {
  set pin [get_bd_pins -quiet $pin_path]
  if {$pin eq ""} continue
  set net [get_bd_nets -quiet -of_objects $pin]
  if {$net ne ""} {
    ad_disconnect $net $pin
  }
  ad_connect $new_src $pin
}

# ---------------------------------------------------------------------------
# Point the ADI DMA data + SG paths at host RAM via the XDMA S_AXI_B slave.
# Everything MM-side runs on pcie_axi_clk so pcie_saxi_sc collapses to a
# single-clock SmartConnect (NUM_CLKS=1).
#
# All six MM/SG clock pins start floating: adrv9009zu11eg_bd.tcl skips its
# ad_mem_hpc0/hpc1_interconnect calls under PCIE_BUILD (which is what used to
# wire the MM aclks implicitly, via the CONFIG.ASSOCIATED_BUSIF match inside
# ad_mem_hpx_interconnect), and the SG ports only exist because
# DMA_SG_TRANSFER=1 was set above. So a plain ad_connect suffices throughout --
# no disconnect step, and no PS slave port left claimed behind us.
# ---------------------------------------------------------------------------

foreach {pin_path new_src} {
  axi_adrv9009_som_rx_dma/m_dest_axi_aclk     pcie_axi_clk
  axi_adrv9009_som_rx_dma/m_dest_axi_aresetn  pcie_axi_resetn
  axi_adrv9009_som_obs_dma/m_dest_axi_aclk    pcie_axi_clk
  axi_adrv9009_som_obs_dma/m_dest_axi_aresetn pcie_axi_resetn
  axi_adrv9009_som_tx_dma/m_src_axi_aclk      pcie_axi_clk
  axi_adrv9009_som_tx_dma/m_src_axi_aresetn   pcie_axi_resetn
  axi_adrv9009_som_rx_dma/m_sg_axi_aclk       pcie_axi_clk
  axi_adrv9009_som_rx_dma/m_sg_axi_aresetn    pcie_axi_resetn
  axi_adrv9009_som_obs_dma/m_sg_axi_aclk      pcie_axi_clk
  axi_adrv9009_som_obs_dma/m_sg_axi_aresetn   pcie_axi_resetn
  axi_adrv9009_som_tx_dma/m_sg_axi_aclk       pcie_axi_clk
  axi_adrv9009_som_tx_dma/m_sg_axi_aresetn    pcie_axi_resetn
} {
  ad_connect $new_src $pin_path
}

# ad_pcie_saxi_interconnect: creates pcie_saxi_sc on the first call, adds
# aclk slots on demand. Passing pcie_axi_clk everywhere keeps NUM_CLKS=1.
ad_pcie_saxi_interconnect pcie_axi_clk axi_adrv9009_som_rx_dma/m_dest_axi
ad_pcie_saxi_interconnect pcie_axi_clk axi_adrv9009_som_rx_dma/m_sg_axi
ad_pcie_saxi_interconnect pcie_axi_clk axi_adrv9009_som_obs_dma/m_dest_axi
ad_pcie_saxi_interconnect pcie_axi_clk axi_adrv9009_som_obs_dma/m_sg_axi
ad_pcie_saxi_interconnect pcie_axi_clk axi_adrv9009_som_tx_dma/m_src_axi
ad_pcie_saxi_interconnect pcie_axi_clk axi_adrv9009_som_tx_dma/m_sg_axi

.. _axi_hsci:

AXI HSCI
================================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI HSCI <library/axi_hsci>` core implements High Speed Serial
Control Interface (HSCI), used in devices like :adi:`AD9084` and :adi:`AD9088`
as an high speed alternative to SPI. It has an AXI-Lite slave interface and an
8-bit parallel PHY interface. HSCI uses four LVDS pairs (clock and data in each
direction) at up to 1.6 Gbps with an 800 MHz DDR clock.

Features
--------------------------------------------------------------------------------

* 32K x 32-bit dual-port transfer buffer
* Read, write and read-modify-write transactions
* 1 to 4 address bytes
* Manual and automatic link-up
* MOSI PN15 generator and MISO PN15 checker

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_hsci/axi_hsci.sv`
     - Top module.
   * - :git-hdl:`library/axi_hsci/hsci_master_top.sv`
     - Register map, transfer buffer and HSCI core.
   * - :git-hdl:`library/axi_hsci/hsci_master_axi_slave.sv`
     - AXI-Lite address decoder.
   * - :git-hdl:`library/axi_hsci/hsci_master_regs_regs.sv`
     - Register map.
   * - :git-hdl:`library/axi_hsci/hsci_mcore.v`
     - Encoder, decoder, frame detector and link-up controller.
   * - :git-hdl:`library/axi_hsci/axi_hsci_ip.tcl`
     - Vivado IP packaging script.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - AXI_ADDR_WIDTH
     - Transfer buffer address width.
   * - AXI_DATA_WIDTH
     - AXI data width.
   * - REGMAP_ADDR_WIDTH
     - Register DWORD address width.
   * - S_AXI_ADDR_WIDTH
     - AXI byte address width.

Keep the default parameter values; the internal AXI interface and buffer
widths are fixed.

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - s_axi_aclk
     - AXI clock.
   * - s_axi_aresetn
     - AXI reset, active low.
   * - s_axi
     - AXI-Lite slave interface.
   * - hsci_pclk
     - Parallel clock from the PHY.
   * - hsci_menc_clk
     - MOSI clock pattern to the PHY.
   * - hsci_mosi_data
     - MOSI data to the PHY.
   * - hsci_miso_data
     - MISO data from the PHY.
   * - hsci_pll_reset
     - PHY reset, driven by ``HSCI_PLL_RESET``.
   * - hsci_rst_seq_done
     - PHY reset sequence done.
   * - hsci_pll_locked
     - PHY PLL locked.
   * - hsci_vtc_rdy_bsc_tx
     - PHY TX VTC ready.
   * - hsci_dly_rdy_bsc_tx
     - PHY TX delay ready.
   * - hsci_vtc_rdy_bsc_rx
     - PHY RX VTC ready.
   * - hsci_dly_rdy_bsc_rx
     - PHY RX delay ready.

Operation
--------------------------------------------------------------------------------

The PHY is external to the core. In :ref:`ad9084_ebz`, it uses the
:git-hdl:`High Speed SelectIO Wizard <projects/ad9084_ebz/common/hsci_phy_top.sv>`
on UltraScale+ and the
:git-hdl:`Advanced IO Wizard <projects/ad9084_ebz/common/versal_hsci_phy.tcl>`
on Versal.

The register map and buffer port A use ``s_axi_aclk``. The HSCI logic and
buffer port B use ``hsci_pclk``. Clearing ``HSCI_MASTER_RSTN`` resets the
HSCI logic, not the PHY. Loss of ``hsci_pll_locked`` also resets the HSCI logic.

Enable link-up on the device through SPI, then use ``HSCI_AUTO_LINKUP`` or
``HSCI_MAN_LINKUP`` and ``HSCI_MAN_LINKUP_WORD`` on the master.
``HSCI_MASTER_LINKUP_STATUS`` and ``HSCI_MASTER_LINKUP_STATUS2`` report the
result; ``HSCI_MASTER_LINK_ERR_INFO`` captures link-up failures.

To start a transfer:

#. Wait for ``MASTER_DONE``.
#. Write the slave address and write data to the buffer, least significant
   byte first.
#. Set ``HSCI_MASTER_BRAM_ADDRESS`` to the DWORD address of the address word.
#. Set the transaction count, address size, byte count and command in
   registers 0x8002 to 0x8006.
#. Set ``HSCI_RUN`` and wait for ``MASTER_DONE``.

Read data starts at ``BRAM_0`` (DWORD address 0x0001). Place the read request
address outside the response area; the Linux driver uses DWORD address 0x1000.
For read-modify-write, interleave masks and data in the buffer;
``HSCI_BYTE_NUM`` counts both.

Register Map
--------------------------------------------------------------------------------

The AXI address range is 256 KiB. Register addresses below are DWORD offsets;
software byte offsets are four times these values.

.. hdl-regmap::
   :name: axi_hsci

Software Support
--------------------------------------------------------------------------------

* Linux controller driver: :git-linux:`drivers/misc/adi-axi-hsci.c`
* Linux device driver: :git-linux:`drivers/iio/trx-rf/ad9088/ad9088.c`

References
--------------------------------------------------------------------------------

* HDL source: :git-hdl:`library/axi_hsci`
* Reference project: :ref:`ad9084_ebz`
* :adi:`UG-1578, AD9084/AD9088 Device User Guide <media/en/technical-documentation/user-guides/ad9084-ad9088-ug.pdf>`

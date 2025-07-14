.. _ad_gmsl2eth_sl:

AD-GMSL2ETH-SL HDL project
===============================================================================

Overview
-------------------------------------------------------------------------------

The :adi:`AD-GMSL2ETH-SL` is an edge compute platform enabling low-latency
data transfer from eight Gigabit Multimedia Serial Link™ (GMSL) interfaces
on to a 10 Gb Ethernet link. The target applications include autonomous robots
and vehicles where machine vision and real-time sensor fusion is critical.

The system includes two :adi:`MAX96724` Quad Tunneling GMSL2/1 to CSI-2 Deserializers,
enabling connectivity to eight GMSL cameras. The video data from the cameras
is transferred from the :adi:`MAX96724` deserializers via MIPI CSI2 interfaces to
an AMD K26 System on Module which implements the logic to aggregate the video
data from all the GMSL cameras into a 10 Gb Ethernet link, so that it can be
sent to a central processing unit.

The IEEE 1588 Precision Time Protocol (PTP) with hardware timestamping is supported,
enabling accurate synchronization with host systems and other edge devices.
The :adi:`AD9545` Quad Input, 10-Output, Dual DPLL/IEEE 1588, 1 pps Synchronizer and
Jitter Cleaner is used to generate the required clocks for the 10 Gb Ethernet interface
and the PTP logic.

Supported boards
-------------------------------------------------------------------------------

- :adi:`AD-GMSL2ETH-SL`

Supported devices
-------------------------------------------------------------------------------

- :adi:`MAX96724`
- :adi:`MAX17573`
- :adi:`ADM7154`
- :adi:`MAX25206`
- :adi:`LTC3303`
- :adi:`LTC4355`
- :adi:`AD9545`

Supported carriers
-------------------------------------------------------------------------------

- :xilinx:`K26 SOM <en/products/system-on-modules/kria/k26/k26i-industrial.html>`

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path designed in this reference design is as follows:

- the virtual channel inputs of one CSI-2 output port of the deserializer are
  captured using Xilinx's `MIPI CSI-2 Rx Subsystem IP <https://docs.amd.com/r/en-US/pg232-mipi-csi2-rx>`_
- data is written into memory by using a Xilinx video-related DMA implementation
  `Video Framebuffer Write <https://docs.amd.com/r/en-US/pg278-v-frmbuf>`_
- the control of the camera modules is realized through I2C using Xilinx's
  `AXI IIC logic <https://docs.amd.com/v/u/en-US/pg090-axi-iic>`_
- data is transmitted to a 10G-capable node by using Corundum NIC implementation

The data path and elements of the video network, 10G NIC, are depicted in the below diagram:

.. image:: ad_gmsl2eth_hdl.svg
   :width: 1200
   :align: center
   :alt: AD-GMSL2ETH-SL Evaluation Kit HDL-related block design

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture cpu-intercon-addr`).

============================================      ===========
Instance                                          Address
============================================      ===========
mipi_csi2_rx_subsyst_0                            0x84A0_0000
mipi_csi2_rx_subsyst_1                            0x84A2_0000
axi_iic_mipi                                      0x84A4_0000
v_frmbuf_wr_0                                     0x84A6_0000
v_frmbuf_wr_1                                     0x84A8_0000
v_frmbuf_wr_2                                     0x84AA_0000
v_frmbuf_wr_3                                     0x84AC_0000
v_frmbuf_wr_4                                     0x84AE_0000
v_frmbuf_wr_5                                     0x84B0_0000
v_frmbuf_wr_6                                     0x84B2_0000
v_frmbuf_wr_7                                     0x84B4_0000
axi_pwm_gen_0                                     0x84B6_0000
corundum_hierarchy/corundum_core/s_axil_ctrl      0xA000_0000
============================================      ===========

I2C connections
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 20 20 20 20 20
   :header-rows: 1

   * - I2C type
     - I2C manager instance
     - Alias
     - Address
     - I2C subordinate
   * - PL
     - iic_main
     - axi_iic_mipi
     - 0x84A4_0000
     - ---

SPI connections
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 25 25 25 25
   :header-rows: 1

   * - SPI type
     - SPI manager instance
     - SPI subordinate
     - CS
   * - PS
     - SPI0
     - ad9545_spi
     - 0

GPIOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Software GPIO number is calculated as follows:

- ZynqMP: if PS8 EMIOs are used, then offset is 78

.. list-table::
   :widths: 25 25 25 25
   :header-rows: 2

   * - GPIO signal
     - Direction
     - HDL GPIO EMIO
     - Software GPIO
   * -
     - (from FPGA view)
     -
     - ZynqMP
   * - csirxss_rstn
     - OUT
     - 0
     - 78
   * - ap_rstn_frmbuf_0
     - OUT
     - 2
     - 80
   * - ap_rstn_frmbuf_1
     - OUT
     - 3
     - 81
   * - ap_rstn_frmbuf_2
     - OUT
     - 4
     - 82
   * - ap_rstn_frmbuf_3
     - OUT
     - 5
     - 83
   * - ap_rstn_frmbuf_4
     - OUT
     - 6
     - 84
   * - ap_rstn_frmbuf_5
     - OUT
     - 7
     - 85
   * - ap_rstn_frmbuf_6
     - OUT
     - 8
     - 86
   * - ap_rstn_frmbuf_7
     - OUT
     - 9
     - 87
   * - iic_rstn
     - OUT
     - 10
     - 88
   * - fan_pwm
     - INOUT
     - 22
     - 100
   * - fan_tach
     - INOUT
     - 23
     - 101

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

======================= === ============ =============
Instance name           HDL Linux ZynqMP Actual ZynqMP
======================= === ============ =============
mipi0_csirxss_csi_irq   15  111          143
mipi1_csirxss_csi_irq   14  110          142
iic2intc_irpt           13  109          141
v_frmbuf_wr0/interrupt  12  108          140
v_frmbuf_wr1/interrupt  11  107          139
v_frmbuf_wr2/interrupt  10  106          138
v_frmbuf_wr3/interrupt   9  105          137
v_frmbuf_wr4/interrupt   8  104          136
v_frmbuf_wr5/interrupt   7   96          128
v_frmbuf_wr6/interrupt   6   95          127
v_frmbuf_wr7/interrupt   5   94          126
corundum_hierarcy/irq    4   93          125
======================= === ============ =============

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI distributes the bit/elf files of these projects as part of the
:dokuwiki:`ADI Kuiper Linux <resources/tools-software/linux-software/kuiper-linux>`.
If you want to build the sources, ADI makes them available on the
:git-hdl:`HDL repository </>`. To get the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository, and then build the project as follows:.

This project uses `Corundum NIC <https://github.com/ucsdsysnet/corundum>`_
and it needs to be cloned alongside this repository.
Do a git checkout to the latest tested version (commit - 37f2607).
When the 10G-based implementation (e.g., in case of K26) is used,
apply the indicated patch.

**Linux/Cygwin/WSL**

.. shell::

   $git clone https://github.com/ucsdsysnet/corundum.git
   $cd corundum
   $git checkout 37f2607
   $git apply ../hdl/library/corundum/patch_axis_xgmii_rx_64.patch
   $cd ../hdl/projects/ad_gmsl2eth_sl/k26
   $make

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

.. admonition:: Publications

   The following papers pertain to the Corundum source code:

   - J- A. Forencich, A. C. Snoeren, G. Porter, G. Papen, Corundum: An Open-Source 100-Gbps NIC, in FCCM'20.
     (`FCCM Paper`_, `FCCM Presentation`_)
   - J- A. Forencich, System-Level Considerations for Optical Switching in Data Center Networks. (`Thesis`_)

.. _FCCM Paper: https://www.cse.ucsd.edu/~snoeren/papers/corundum-fccm20.pdf
.. _FCCM Presentation: https://www.fccm.org/past/2020/forums/topic/corundum-an-open-source-100-gbps-nic/
.. _Thesis: https://escholarship.org/uc/item/3mc9070t

Resources
-------------------------------------------------------------------------------

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheets:

  - :adi:`AD-GMSL2ETH-SL`
  - :adi:`MAX96724 <media/en/technical-documentation/data-sheets/max96724.pdf>`
  - :adi:`MAX17573 <media/en/technical-documentation/data-sheets/max17573.pdf>`
  - :adi:`ADM7154 <media/en/technical-documentation/data-sheets/adm7154.pdf>`
  - :adi:`MAX25206 <media/en/technical-documentation/data-sheets/MAX25206-MAX25208.pdf>`
  - :adi:`LTC3303 <media/en/technical-documentation/data-sheets/ltc3303.pdf>`
  - :adi:`LTC4355 <media/en/technical-documentation/data-sheets/4355ff.pdf>`
  - :adi:`AD9545 <media/en/technical-documentation/data-sheets/ad9545.pdf>`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-hdl:`AD-GMSL2ETH-SL HDL project source code <projects/ad_gmsl2eth_sl>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_CLKGEN
     - :git-hdl:`library/axi_clkgen`
     - :ref:`axi_clkgen`
   * - AXI_PWM_GEN
     - :git-hdl:`library/axi_pwm_gen`
     - :ref:`axi_pwm_gen`
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid`
     - :ref:`axi_sysid`
   * - CORUNDUM_NETSTACK
     - :git-hdl:`library/corundum`
     - :ref:`corundum`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom`
     - :ref:`axi_sysid`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- `GMSL-related repository <https://github.com/analogdevicesinc/gmsl>`_
- :git-linux:`GMSL drivers/dts <gmsl_k26/xilinx_v6.1_LTS>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

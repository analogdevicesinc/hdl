.. _adrv9009zu11eg:

ADRV9009ZU11EG HDL reference design
===============================================================================

The HDL reference design is built around the Zynq® Ultrascale+ four
Cortex™-A536 MPCore processors. A functional block diagram of the system is
shown below.

The PS8 provides a SDIO, UART, Ethernet, SPI, USB 3.0, QSPI and a Display Port
control modules.

The two ADRV9009's digital interface is handled by the JESD20B physical, data
link and transport layer IPs. The JESD204B lanes are shared among the
8 transmit, 4 receive and 4 observation/sniffer receive data paths by the same
set of transceivers within the IP. The cores are programmable through an
AXI-lite interface.

There are 2 PL DDR4 32 bit @1200MHz which can be used as OFFLOAD FIFOs in
the system.

There are additional transceiver lanes available that can be used to implement
PCIe Gen3 x8, 10Gb ethernet and 40Gb ethernet at the same time. On top of
those, another 10 transceiver lanes can be used to implement a full FMC HPC
connector, through which to extend the system with another two ADRV9009s.

Supported boards
-------------------------------------------------------------------------------

- :adi:`ADRV9009-ZU11EG RF-SOM <ADRV9009-ZU11EG>`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35
   :header-rows: 1

   * - Evaluation board
     - Carrier
   * - :adi:`ADRV9009-ZU11EG RF-SOM <ADRV9009-ZU11EG>`
     - :adi:`ADRV2CRR-FMC`

Block design
-------------------------------------------------------------------------------

.. image:: adrv9009_zu11eg_hdl.svg
   :width: 800
   :align: center
   :alt: ADRV9009ZU11EG block diagram

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagrams:

Example block design for Single link; M=8; L=8
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: adrv9009_zu11eg_jesd204b.svg
   :width: 800
   :align: center
   :alt: ADRV9009ZU11EG JESD204B M=8 L=8 block diagram

The Rx links (ADC Path) operate with the following parameters:

- Rx Deframer parameters: L=4, M=8, F=4, S=1, NP=16, N=16
- Sample Rate: 245.76 MSPS
- Dual link: No
- RX_DEVICE_CLK: 245.76 MHz (Lane Rate/40)
- REF_CLK: 245.76 MHz (Lane Rate/40)
- JESD204B Lane Rate: 9.83 Gbps
- QPLL0 or CPLL

The ORx links (ADC Path) operate with the following parameters:

- ORx Deframer parameters: L=4, M=4, F=2, S=1, NP=16, N=16
- Sample Rate: 491.52 MSPS
- Dual link: No
- ORX_DEVICE_CLK: 245.76 MHz (Lane Rate/40)
- REF_CLK: 245.76 MHz (Lane Rate/40)
- JESD204B Lane Rate: 9.83 Gbps
- QPLL0 or CPLL

The Tx links (DAC Path) operate with the following parameters:

- Tx Framer parameters: L=8, M=8, F=4, S=1, NP=16, N=16
- Sample Rate: 491.52 MSPS
- Dual link: No
- TX_DEVICE_CLK: 245.76 MHz (Lane Rate/40)
- REF_CLK: 245.76 MHz (Lane Rate/40)
- JESD204B Lane Rate: 9.83 Gbps
- QPLL0 or CPLL

Digital Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The digital interface consists of 8 transmit, 4 receive and 4
observation/sniffer lanes running up to 9.8Gbps. The transceivers then
interface to the cores at 256bits @245.76MHz in the transmit and
128bits @245.76MHz for the receive and sniffer/observation rates. The data is
sent or received based on the configuration (programmable) from separate
transmit, receive and observation chains.

DAC Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The DAC data may be sourced from an internal data generator (DDS or pattern)
or from the external DDR via DMA. The internal DDS phase and frequency are
programmable. :git-hdl:`DAC unpack IP <library/util_pack/util_upack2>` allows
to a reduced number of channels, at a higher rate.

ADC Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ADC data is sent to the DDR via DMA. The
:git-hdl:`ADC pack IP <library/util_pack/util_cpack2>` allows capturing only
part of the channels.

Control and SPI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The device control and monitor signals are interfaced to a GPIO module.
The SPI signals are controlled by a single PS8 SPI core.

Configuration modes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The block design supports configuration of parameters and scales.

We have listed a couple of examples at section
`Building the HDL project`_ and the default modes
for each project.

.. note::

   The parameters for Rx or Tx links can be changed from the
   **system_project.tcl** file, located in
   hdl/projects/adrv9009zu11eg/$CARRIER/system_project.tcl

.. math::
   Lane Rate = Sample Rate*\frac{M}{L}*N'* \frac{10}{8}

The following are the parameters of this project that can be configured:

- [RX/TX/RX_OS]_JESD_M: number of converters per link
- [RX/TX/RX_OS]_JESD_L: number of lanes per link
- [RX/TX/RX_OS]_JESD_S: number of samples per frame

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture cpu-intercon-addr`).

===================== ===========
Instance              ZynqMP
===================== ===========
rx_adrv9009_tpl_core  0x84A0_0000
tx_adrv9009_tpl_core  0x84A0_4000
obs_adrv9009_tpl_core 0x84A0_8000
axi_adrv9009_rx_xcvr  0x84A4_0000
axi_adrv9009_tx_xcvr  0x84A2_0000
axi_adrv9009_obs_xcvr 0x84A6_0000
axi_adrv9009_tx_jesd  0x84A3_0000
axi_adrv9009_rx_jesd  0x84A5_0000
axi_adrv9009_obs_jesd 0x84A7_0000
axi_adrv9009_rx_dma   0x9C42_0000
axi_adrv9009_tx_dma   0x9C40_0000
axi_adrv9009_obs_dma  0x9C44_0000
axi_sysid_0           0x8500_0000 
===================== ===========

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
     - spi0
     - ADRV9009-A
     - 0
   * -
     -
     - ADRV9009-B
     - 1
   * -
     -
     - HMC7044
     - 2
   * -
     -
     - HMC7044_CAR
     - 3

GPIOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 25 20 20 15
   :header-rows: 2

   * - GPIO signal
     - Direction
     - HDL GPIO EMIO
     - Software GPIO
   * -
     - (from FPGA view)
     -
     - Zynq MP
   * - gpio_4_exp_n
     - INOUT
     - 92
     - 170
   * - gpio_3_exp_n
     - INOUT
     - 91
     - 169
   * - gpio_3_exp_p
     - INOUT
     - 90
     - 168
   * - hmc7044_gpio_4
     - INOUT
     - 89
     - 167
   * - hmc7044_gpio_3
     - INOUT
     - 88
     - 166
   * - hmc7044_gpio_1
     - INOUT
     - 87
     - 165
   * - hmc7044_gpio_2
     - INOUT
     - 86
     - 164
   * - hmc7044_sync
     - INOUT
     - 85
     - 163
   * - hmc7044_reset
     - INOUT
     - 84
     - 162
   * - adrv9009_tx2_enable_b
     - INOUT
     - 83
     - 161
   * - adrv9009_tx1_enable_b
     - INOUT
     - 82
     - 160
   * - adrv9009_rx2_enable_b
     - INOUT
     - 81
     - 159
   * - adrv9009_rx1_enable_b
     - INOUT
     - 80
     - 158
   * - adrv9009_test_b
     - INOUT
     - 79
     - 157
   * - adrv9009_reset_b_b
     - INOUT
     - 78
     - 156
   * - adrv9009_gpint_b
     - INOUT
     - 77
     - 155
   * - adrv9009_gpio_{18:00}_b
     - INOUT
     - 76:58
     - 154:136
   * - adrv9009_tx2_enable_a
     - INOUT
     - 57
     - 135
   * - adrv9009_tx1_enable_a
     - INOUT
     - 56
     - 134
   * - adrv9009_rx2_enable_a
     - INOUT
     - 55
     - 133
   * - adrv9009_rx1_enable_a
     - INOUT
     - 54
     - 132
   * - adrv9009_test_a
     - INOUT
     - 53
     - 131
   * - adrv9009_reset_b_a
     - INOUT
     - 52
     - 130
   * - adrv9009_gpint_a
     - INOUT
     - 51
     - 129
   * - adrv9009_gpio_{18:00}_a
     - INOUT
     - 50:32
     - 128:110

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

========================== === ============ =============
Instance name              HDL Linux ZynqMP Actual ZynqMP
========================== === ============ =============
axi_adrv9009_fmc_obs_dma   8   104          136
axi_adrv9009_fmc_tx_dma    9   105          137
axi_adrv9009_fmc_rx_dma    10  106          138
axi_adrv9009_fmc_obs_jesd  11  107          139
axi_adrv9009_fmc_tx_jesd   12  108          140
axi_adrv9009_fmc_rx_jesd   13  109          141
========================== === ============ =============

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI distributes the bit/elf files of these projects as part of the
:dokuwiki:`ADI Kuiper Linux <resources/tools-software/linux-software/kuiper-linux>`.
If you want to build the sources, ADI makes them available on the
:git-hdl:`HDL repository </>`. To get the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the project location, choose your carrier and run the make command
by typing in your command prompt:

**Linux/Cygwin/WSL**

.. shell::

   $cd hdl/projects/adrv9009zu11eg/adrv2crr_fmc
   $make

The adrv2crr_fmcomms8 and adrv2crr_fmcxmwbr1 carriers are designed for
attaching an extra evaluation board (fmcomms8/fmcxmwbr1) to the fmc of the same
carrier (adrv2crr_fmc).

The following dropdowns contain tables with the parameters that can be used to
configure this project, depending on the carrier used.

.. collapsible:: Default values of the make parameters for ADRV9009ZU11EG

   +-------------------+------------------------------------------------------+
   | Parameter         | Default value of the parameters depending on carrier |
   +-------------------+----------------------------------+-------------------+
   |                   | ADRV2CRR_FMC/ADRV2CRR_FMCXMWBR1  | ADRV2CRR_FMCOMMS8 |
   +===================+==================================+===================+
   | RX_JESD_M         |                8                 |         16        |
   +-------------------+----------------------------------+-------------------+
   | RX_JESD_L         |                4                 |          8        |
   +-------------------+----------------------------------+-------------------+
   | RX_JESD_S         |                1                 |          1        |
   +-------------------+----------------------------------+-------------------+
   | TX_JESD_M         |                8                 |         16        |
   +-------------------+----------------------------------+-------------------+
   | TX_JESD_L         |                8                 |         16        |
   +-------------------+----------------------------------+-------------------+
   | TX_JESD_S         |                1                 |          1        |
   +-------------------+----------------------------------+-------------------+
   | RX_OS_JESD_M      |                4                 |          8        |
   +-------------------+----------------------------------+-------------------+
   | RX_OS_JESD_L      |                4                 |          8        |
   +-------------------+----------------------------------+-------------------+
   | RX_OS_JESD_S      |                1                 |          1        |
   +-------------------+----------------------------------+-------------------+

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Other considerations
-------------------------------------------------------------------------------

ADC - lane mapping
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Due to physical constraints, Rx lanes are reordered as described in the
following table.

=============== ===========================
ADC phy Lane    FPGA Rx lane / Logical Lane
=============== ===========================
0               0
1               1
2               4
3               5
=============== ===========================

================ ===========================
ADC OBS phy Lane FPGA Rx lane / Logical Lane
================ ===========================
0                2
1                3
2                6
3                7
================ ===========================

DAC - lane mapping
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Due to physical constraints, Tx lanes are reordered as described in the
following table.

============ ===========================
DAC phy lane FPGA Tx lane / Logical lane
============ ===========================
0            0
1            1
2            2
3            3
4            4
5            5
6            6
7            7
============ ===========================

Resources
-------------------------------------------------------------------------------

Systems related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :dokuwiki:`[Wiki] ADRV9009ZU11EG Prototyping Platform User Guide <resources/eval/user-guides/adrv9009-zu11eg>`

Here you can find the quick start guides available for these evaluation boards:

.. list-table::
   :widths: 20 10
   :header-rows: 1

   * - Evaluation board
     - Zynq UltraScale+ MP
   * - ADRV9009ZU11EG
     - :dokuwiki:`ADRV2CRR-FMC <resources/eval/user-guides/adrv9009-zu11eg/quick-start-guide>`

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheet: :adi:`ADRV9009`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-hdl:`ADRV9009ZU11EG HDL project source code <projects/adrv9009zu11eg>`

.. list-table::
   :widths: 30 40 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_DMAC
     - :git-hdl:`library/axi_dmac`
     - :ref:`axi_dmac`
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid`
     - :ref:`axi_sysid`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom`
     - :ref:`axi_sysid`
   * - UTIL_UPACK2
     - :git-hdl:`library/util_pack/util_upack2`
     - :ref:`util_upack2`
   * - UTIL_CPACK2
     - :git-hdl:`library/util_pack/util_cpack2`
     - :ref:`util_upack2`
   * - DATA_OFFLOAD
     - :git-hdl:`library/data_offload`
     - :ref:`data_offload`
   * - UTIL_DO_RAM
     - :git-hdl:`library/util_do_ram`
     - :ref:`data_offload`
   * - AXI_CLKGEN
     - :git-hdl:`library/axi_clkgen`
     - :ref:`axi_clkgen`
   * - UTIL_ADXCVR for AMD
     - :git-hdl:`library/xilinx/util_adxcvr`
     - :ref:`util_adxcvr`
   * - AXI_ADXCVR for Intel
     - :git-hdl:`library/intel/axi_adxcvr`
     - :ref:`axi_adxcvr intel`
   * - AXI_ADXCVR for AMD
     - :git-hdl:`library/xilinx/axi_adxcvr`
     - :ref:`axi_adxcvr amd`
   * - AXI_JESD204_RX
     - :git-hdl:`library/jesd204/axi_jesd204_rx`
     - :ref:`axi_jesd204_rx`
   * - AXI_JESD204_TX
     - :git-hdl:`library/jesd204/axi_jesd204_tx`
     - :ref:`axi_jesd204_tx`
   * - JESD204_TPL_ADC
     - :git-hdl:`library/jesd204/ad_ip_jesd204_tpl_adc`
     - :ref:`ad_ip_jesd204_tpl_adc`
   * - JESD204_TPL_DAC
     - :git-hdl:`library/jesd204/ad_ip_jesd204_tpl_dac`
     - :ref:`ad_ip_jesd204_tpl_dac`

- :dokuwiki:`[Wiki] Generic JESD204B block designs <resources/fpga/docs/hdl/generic_jesd_bds>`
- :ref:`jesd204`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :dokuwiki:`[Wiki] ADRV9009 Linux driver wiki page <resources/tools-software/linux-drivers/iio-transceiver/adrv9009>`

- :git-linux:`ADRV9009ZU11EG device tree <arch/arm64/boot/dts/xilinx/zynqmp-adrv9009-zu11eg-revb-adrv2crr-fmc-revb-jesd204-fsm.dts>`
- :git-linux:`ADRV9009ZU11EG + FMCOMMS8 device tree <arch/arm64/boot/dts/xilinx/zynqmp-adrv9009-zu11eg-revb-adrv2crr-fmc-revb-sync-fmcomms8-jesd204-fsm.dts>`
- :git-linux:`ADRV9009ZU11EG + FMCXMWBR1 device tree <arch/arm64/boot/dts/xilinx/zynqmp-adrv9009-zu11eg-revb-adrv2crr-fmc-revb-jesd204-fsm-xmicrowave.dts>`
- :git-no-os:`ADRV9009ZU11EG NO-OS PROJECT <projects/adrv9009>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

.. _adrv904x:

ADRV904x HDL reference design
===============================================================================

The ADRV904x is a highly integrated, system on chip (SoC) radio frequency (RF) 
agile transceiver with integrated digital front end (DFE). The SoC contains 
eight transmitters, two observation receivers for monitoring transmitter 
channels, eight receivers, integrated LO and clock synthesizers, and digital 
signal processing functions. The SoC meets the high radio performance and low
power consumption demanded by cellular infrastructure applications including
small cell basestation radios, macro 3G/4G/5G systems, and massive MIMO base
stations.

Supported boards
-------------------------------------------------------------------------------

-  EVAL-ADRV904x 

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - EVAL-ADRV904x 
     - :xilinx:`ZCU102`
     - FMC HPC0

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagrams:

Example block design for Single link; M=16; L=8
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: adrv904x_zcu102_jesd204c.svg
   :width: 800
   :align: center
   :alt: ADRV904x JESD204C M=16 L=8 block diagram

The Rx links (ADC Path) operate with the following parameters:

-  Rx Deframer parameters: L=8, M=16, F=4, S=1, NP=16, N=16 
-  Sample Rate: 491.52 MSPS
-  Dual link: No
-  RX_DEVICE_CLK: 245.76 MHz (Lane Rate/66)
-  REF_CLK: 491.52 MHz (Lane Rate/33)
-  JESD204C Lane Rate: 16.22 Gbps
-  QPLL0

The Tx links (DAC Path) operate with the following parameters:

-  Tx Deframer parameters: L=8, M=16, F=4, S=1, NP=16, N=16 
-  Sample Rate: 491.52 MSPS
-  Dual link: No
-  TX_DEVICE_CLK: 245.76 MHz (Lane Rate/66)
-  REF_CLK: 491.52 MHz (Lane Rate/33)
-  JESD204C Lane Rate: 16.22 Gbps
-  QPLL0

Configuration modes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The block design supports configuration of parameters and scales.

We have listed a couple of examples at section
`Building the HDL project`_ and the default modes
for each project.

.. note::

   The parameters for Rx or Tx links can be changed from the
   **system_project.tcl** file, located in
   hdl/projects/adrv904x/$CARRIER/system_project.tcl

.. warning::

   ``Lane Rate = I/Q Sample Rate x M x N' x (66 \ 64) \ L``

The following are the parameters of this project that can be configured:

-  JESD_MODE: used link layer encoder mode

   -  64B66B - 64b66b link layer defined in JESD204C
   -  8B10B  - 8b10b link layer defined in JESD204B

-  RX_LANE_RATE: lane rate of the Rx link 
-  TX_LANE_RATE: lane rate of the Tx link 
-  [RX/TX]_JESD_M: number of converters per link
-  [RX/TX]_JESD_L: number of lanes per link
-  [RX/TX]_JESD_S: number of samples per frame
-  [RX/TX]_JESD_NP: number of bits per sample
-  [RX/TX]_NUM_LINKS: number of links

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: adrv904x_zcu102_clocking.svg
   :width: 500
   :align: center
   :alt: ADRV904x ZCU102 clock scheme

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture`).

==================== ===========
Instance             ZynqMP     
==================== ===========
axi_adrv904x_tx_jesd 0x84A90000 
axi_adrv904x_rx_jesd 0x84AA0000
axi_adrv904x_tx_dma  0x9c420000
axi_adrv904x_rx_dma  0x9c400000
tx_adrv904x_tpl_core 0x84A04000
rx_adrv904x_tpl_core 0x84A00000
axi_adrv904x_tx_xcvr 0x84A80000
axi_adrv904x_rx_xcvr 0x84A60000
==================== ===========

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
     - ADRV904x
     - 0
   * - 
     - 
     - AD9528
     - 1

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
   * - ad9528_reset_b
     - INOUT
     - 69
     - 147
   * - ad9528_sysref_req
     - INOUT
     - 68
     - 146
   * - adrv904x_trx0_enable
     - INOUT
     - 67
     - 145
   * - adrv904x_trx1_enable
     - INOUT
     - 66
     - 144
   * - adrv904x_trx2_enable
     - INOUT
     - 65
     - 143
   * - adrv904x_trx3_enable
     - INOUT
     - 64
     - 142
   * - adrv904x_trx4_enable
     - INOUT
     - 63
     - 141
   * - adrv904x_trx5_enable
     - INOUT
     - 62
     - 140
   * - adrv904x_trx6_enable
     - INOUT
     - 61
     - 139
   * - adrv904x_trx7_enable
     - INOUT
     - 60
     - 138
   * - adrv904x_orx0_enable
     - INOUT
     - 59
     - 137
   * - adrv904x_orx1_enable
     - INOUT
     - 58
     - 136
   * - adrv904x_test
     - INOUT
     - 57
     - 135
   * - adrv904x_reset_b
     - INOUT
     - 56
     - 134
   * - adrv904x_gpio[0:23]
     - INOUT
     - 55:32
     - 133:110

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

==================== === ============ =============
Instance name        HDL Linux ZynqMP Actual ZynqMP
==================== === ============ =============
axi_adrv904x_tx_jesd 10  106          138
axi_adrv904x_rx_jesd 11  107          139
axi_adrv904x_tx_dma  13  108          140
axi_adrv904x_rx_dma  14  109          141
==================== === ============ =============

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here </>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the :git-hdl:`projects/adrv904x <projects/adrv904x>`
location and run the make command by typing in your command prompt:

**Linux/Cygwin/WSL**

.. code-block::
   :linenos:

   user@analog:~$ cd hdl/projects/adrv904x/zcu102
   user@analog:~/hdl/projects/adrv904x/zcu102$ make

The following dropdowns contain tables with the parameters that can be used to
configure this project, depending on the carrier used.
Where a cell contains a --- (dash) it means that the parameter doesn't exist
for that project (adrv904x/carrier or adrv904x/carrier).

.. collapsible:: Default values of the ``make`` parameters for ADRV904x

   +-------------------+------------------------------------------------------+
   | Parameter         | Default value of the parameters depending on carrier |
   +-------------------+---------------------------+--------------------------+
   |                   |                         ZCU102                       |
   +===================+===========================+==========================+
   | JESD_MODE         |                        64B66B                        |
   +-------------------+---------------------------+--------------------------+
   | RX_LANE_RATE      |                         16.22                        |
   +-------------------+---------------------------+--------------------------+
   | TX_LANE_RATE      |                         16.22                        |
   +-------------------+---------------------------+--------------------------+
   | RX_JESD_M         |                          16                          |
   +-------------------+---------------------------+--------------------------+
   | RX_JESD_L         |                           8                          |
   +-------------------+---------------------------+--------------------------+
   | RX_JESD_S         |                           1                          |
   +-------------------+---------------------------+--------------------------+
   | TX_JESD_M         |                          16                          |
   +-------------------+---------------------------+--------------------------+
   | TX_JESD_L         |                           8                          |
   +-------------------+---------------------------+--------------------------+
   | TX_JESD_S         |                           1                          |
   +-------------------+---------------------------+--------------------------+

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Other considerations
-------------------------------------------------------------------------------

ADC - lane mapping
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Due to physical constraints, Rx lanes are reordered as described in the
following table.

============ ===========================
ADC phy Lane FPGA Rx lane / Logical Lane
============ ===========================
0            5
1            6
2            4
3            7
4            2
5            3
6            1
7            0
============ ===========================

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
4            7
5            6
6            5
7            4
============ ===========================

Resources
-------------------------------------------------------------------------------

Systems related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :dokuwiki:`[Wiki] ADRV904x Prototyping Platform User Guide <resources/eval/user-guides/adrv904x>`

Here you can find the quick start guides available for these evaluation boards:

.. list-table::
   :widths: 10 10
   :header-rows: 1

   * - Evaluation board
     - Zynq UltraScale+ MP
   * - ADRV904x
     - :dokuwiki:`ZCU102 <resources/eval/user-guides/adrv904x/quickstart/zynqmp>`

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Product datasheets:

   - `<https://www.analog.com/media/radioverse-adrv9026/adrv9040.pdf>`__

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`ADRV904x HDL project source code <projects/adrv904x>`

.. list-table::
   :widths: 30 40 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_DMAC
     - :git-hdl:`library/axi_dmac`
     - :ref:`here <axi_dmac>`
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid`
     - :ref:`here <axi_sysid>`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom`
     - :ref:`here <axi_sysid>`
   * - UTIL_CPACK2
     - :git-hdl:`library/util_pack/util_cpack2`
     - :ref:`here <util_cpack2>`
   * - UTIL_UPACK2
     - :git-hdl:`library/util_pack/util_upack2`
     - :ref:`here <util_cpack2>`
   * - DATA_OFFLOAD
     - :git-hdl:`library/data_offload`
     - :ref:`here <data_offload>`
   * - UTIL_DO_RAM
     - :git-hdl:`library/util_do_ram`
     - :dokuwiki:`[Wiki] </resources/fpga/docs/data_offload>`
   * - UTIL_ADXCVR for AMD
     - :git-hdl:`library/xilinx/util_adxcvr`
     - :ref:`here <util_adxcvr>`
   * - AXI_ADXCVR for AMD
     - :git-hdl:`library/xilinx/axi_adxcvr`
     - :ref:`here <axi_adxcvr>`
   * - AXI_JESD204_RX
     - :git-hdl:`library/jesd204/axi_jesd204_rx`
     - :ref:`here <axi_jesd204_rx>`
   * - AXI_JESD204_TX
     - :git-hdl:`library/jesd204/axi_jesd204_tx`
     - :ref:`here <axi_jesd204_tx>`
   * - JESD204_TPL_ADC
     - :git-hdl:`library/jesd204/ad_ip_jesd204_tpl_adc`
     - :ref:`here <ad_ip_jesd204_tpl_dac>`
   * - JESD204_TPL_DAC
     - :git-hdl:`library/jesd204/ad_ip_jesd204_tpl_dac`
     - :ref:`here <ad_ip_jesd204_tpl_dac>`

-  :ref:`jesd204`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :dokuwiki:`[Wiki] ADRV904x Linux driver wiki page <resources/tools-software/linux-drivers/iio-transceiver/adrv904x>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst


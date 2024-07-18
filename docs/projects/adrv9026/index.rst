.. _adrv9026:

ADRV9026 HDL reference design
===============================================================================

The ADRV9026 is a highly integrated, radio frequency (RF) agile transceiver 
offering four independently controlled transmitters, dedicated observation 
receiver inputs for monitoring each transmitter channel, four independently 
controlled receivers, integrated synthesizers, and digital signal processing 
functions providing a complete transceiver solution. The device provides the 
performance demanded by cellular infrastructure applications, such as small 
cell base station radios, macro 3G/4G/5G systems, and massive multiple 
in/multiple out (MIMO) base stations.

Supported boards
-------------------------------------------------------------------------------

-  :adi:`ADRV9026/ADRV9029 <EVAL-ADRV9026>`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - :adi:`ADRV9026/ADRV9029 <EVAL-ADRV9026>`
     - `A10SoC`_
     - FMCA
   * -
     - :xilinx:`ZCU102`
     - FMC HPC1

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagrams:

Example block design for Single link; M=8; L=4
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: adrv9026_zcu102_jesd204b.svg
   :width: 800
   :align: center
   :alt: ADRV9026 JESD204B M=8 L=4 block diagram

The Rx links (ADC Path) operate with the following parameters:

-  Rx Deframer parameters: L=4, M=8, F=4, S=1, NP=16, N=16 
-  Sample Rate: 250 MSPS
-  Dual link: No
-  RX_DEVICE_CLK: 250 MHz (Lane Rate/40)
-  REF_CLK: 500MHz (Lane Rate/20)
-  JESD204B Lane Rate: 10Gbps
-  QPLL0 or CPLL

The Tx links (DAC Path) operate with the following parameters:

-  Tx Framer parameters: L=4, M=8, F=4, S=1, NP=16, N=16 
-  Sample Rate: 250 MSPS
-  Dual link: No
-  TX_DEVICE_CLK: 250 MHz (Lane Rate/40)
-  REF_CLK: 500MHz (Lane Rate/20)
-  JESD204B Lane Rate: 10Gbps
-  QPLL0 or CPLL

Configuration modes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The block design supports configuration of parameters and scales.

We have listed a couple of examples at section
`Building the HDL project`_ and the default modes
for each project.

.. note::

   The parameters for Rx or Tx links can be changed from the
   **system_project.tcl** file, located in
   hdl/projects/adrv9026/$CARRIER/system_project.tcl

.. warning::

   ``Lane Rate = I/Q Sample Rate x M x N' x (10 \ 8) \ L``

The following are the parameters of this project that can be configured:

-  JESD_MODE: used link layer encoder mode

   -  64B66B - 64b66b link layer defined in JESD204C
   -  8B10B  - 8b10b link layer defined in JESD204B

-  RX_LANE_RATE: lane rate of the Rx link 
-  TX_LANE_RATE: lane rate of the Tx link 
-  [RX/TX]_JESD_M: number of converters per link
-  [RX/TX]_JESD_L: number of lanes per link
-  [RX/TX]_JESD_S: number of samples per frame
-  [RX/TX]_NUM_LINKS: number of links

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: adrv9026_zcu102_clocking.svg
   :width: 500
   :align: center
   :alt: ADRV9026 ZCU102 clock scheme

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture`).

==================== ===========
Instance             ZynqMP     
==================== ===========
axi_adrv9026_tx_jesd 0x84A90000 
axi_adrv9026_rx_jesd 0x84AA0000
axi_adrv9026_tx_dma  0x9c420000
axi_adrv9026_rx_dma  0x9c400000
tx_adrv9026_tpl_core 0x84A04000
rx_adrv9026_tpl_core 0x84A00000
axi_adrv9026_tx_xcvr 0x84A80000
axi_adrv9026_rx_xcvr 0x84A60000
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
     - ADRV9026
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
     - 68
     - 146
   * - ad9528_reset_b
     - INOUT
     - 67
     - 145
   * - adrv9026_tx1_enable
     - INOUT
     - 66
     - 144
   * - adrv9026_tx2_enable
     - INOUT
     - 65
     - 143
   * - adrv9026_tx3_enable
     - INOUT
     - 64
     - 142
   * - adrv9026_tx4_enable
     - INOUT
     - 63
     - 141
   * - adrv9026_rx1_enable
     - INOUT
     - 62
     - 140
   * - adrv9026_rx2_enable
     - INOUT
     - 61
     - 139
   * - adrv9026_rx3_enable
     - INOUT
     - 60
     - 138
   * - adrv9026_rx4_enable
     - INOUT
     - 59
     - 137
   * - adrv9026_test
     - INOUT
     - 58
     - 136
   * - adrv9026_reset_b
     - INOUT
     - 57
     - 135
   * - adrv9026_gpint1
     - INOUT
     - 56
     - 134
   * - adrv9026_gpint2
     - INOUT
     - 55
     - 133
   * - adrv9026_orx_ctrl_a
     - INOUT
     - 54
     - 132
   * - adrv9026_orx_ctrl_b
     - INOUT
     - 53
     - 131
   * - adrv9026_orx_ctrl_c
     - INOUT
     - 52
     - 130
   * - adrv9026_orx_ctrl_d
     - INOUT
     - 51
     - 129
   * - adrv9026_gpio[0:18]
     - INOUT
     - 50:32
     - 128:110

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

==================== === ============ =============
Instance name        HDL Linux ZynqMP Actual ZynqMP
==================== === ============ =============
axi_adrv9026_tx_jesd 10  106          138
axi_adrv9026_rx_jesd 11  107          139
axi_adrv9026_tx_dma  13  108          140
axi_adrv9026_rx_dma  14  109          141
==================== === ============ =============

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here </>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the :git-hdl:`projects/adrv9026 <projects/adrv9026>`
location and run the make command by typing in your command prompt:

**Linux/Cygwin/WSL**

.. code-block::
   :linenos:

   user@analog:~$ cd hdl/projects/adrv9026/zcu102
   user@analog:~/hdl/projects/adrv9026/zcu102$ make

   user@analog:~$ cd hdl/projects/adrv9026/a10soc
   user@analog:~/hdl/projects/adrv9026/a10soc$ make

The following dropdowns contain tables with the parameters that can be used to
configure this project, depending on the carrier used.
Where a cell contains a --- (dash) it means that the parameter doesn't exist
for that project (adrv9026/carrier or adrv9026/carrier).

.. collapsible:: Default values of the ``make`` parameters for ADRV9026

   +-------------------+------------------------------------------------------+
   | Parameter         | Default value of the parameters depending on carrier |
   +-------------------+---------------------------+--------------------------+
   |                   |           A10SoC          |          ZCU102          |
   +===================+===========================+==========================+
   | JESD_MODE         |           8B10B           |          8B10B           |
   +-------------------+---------------------------+--------------------------+
   | RX_LANE_RATE      |             10            |            10            |
   +-------------------+---------------------------+--------------------------+
   | TX_LANE_RATE      |             10            |            10            |
   +-------------------+---------------------------+--------------------------+
   | RX_JESD_M         |              8            |             8            |
   +-------------------+---------------------------+--------------------------+
   | RX_JESD_L         |              4            |             4            |
   +-------------------+---------------------------+--------------------------+
   | RX_JESD_S         |              1            |             1            |
   +-------------------+---------------------------+--------------------------+
   | TX_JESD_M         |              8            |             8            |
   +-------------------+---------------------------+--------------------------+
   | TX_JESD_L         |              4            |             4            |
   +-------------------+---------------------------+--------------------------+
   | TX_JESD_S         |              1            |             1            |
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
0            0
1            1
2            2
3            3
============ ===========================

DAC - lane mapping
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Due to physical constraints, Tx lanes are reordered as described in the
following table.

============ ===========================
DAC phy lane FPGA Tx lane / Logical lane
============ ===========================
0            3
1            2
2            0
3            1
============ ===========================

Resources
-------------------------------------------------------------------------------

Systems related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :dokuwiki:`[Wiki] ADRV9026 & ADRV9029 Prototyping Platform User Guide <resources/eval/user-guides/adrv9025>`

Here you can find the quick start guides available for these evaluation boards:

.. list-table::
   :widths: 20 10
   :header-rows: 1

   * - Evaluation board
     - Zynq UltraScale+ MP
   * - ADRV9026/ADRV9029
     - :dokuwiki:`ZCU102 <resources/eval/user-guides/adrv9026/quickstart/zynqmp>`

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Product datasheets:

   -  :adi:`ADRV9026`
-  `UG-1578, Device User Guide <https://www.analog.com/media/radioverse-adrv9026/adrv9026-system-development-user-guide-ug-1727.pdf>`__

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`ADRV9026 HDL project source code <projects/adrv9026>`

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
   * - UTIL_UPACK2
     - :git-hdl:`library/util_pack/util_upack2`
     - :ref:`here <util_upack2>`
   * - UTIL_CPACK2
     - :git-hdl:`library/util_pack/util_cpack2`
     - :ref:`here <util_cpack2>`
   * - UTIL_ADXCVR for AMD
     - :git-hdl:`library/xilinx/util_adxcvr`
     - :ref:`here <util_adxcvr>`
   * - AXI_ADXCVR for Intel
     - :git-hdl:`library/intel/axi_adxcvr`
     - :ref:`here <axi_adxcvr>`
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
     - :ref:`here <ad_ip_jesd204_tpl_adc>`
   * - JESD204_TPL_DAC
     - :git-hdl:`library/jesd204/ad_ip_jesd204_tpl_dac`
     - :ref:`here <ad_ip_jesd204_tpl_dac>`

-  :dokuwiki:`[Wiki] Generic JESD204B block designs <resources/fpga/docs/hdl/generic_jesd_bds>`
-  :ref:`jesd204`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :dokuwiki:`[Wiki] ADRV9026 Linux driver wiki page <resources/tools-software/linux-drivers/iio-transceiver/adrv9025>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

.. _A10SoC: https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/arria/10-sx.html

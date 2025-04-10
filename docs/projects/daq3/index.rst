.. _daq3:

DAQ3 HDL Project
===============================================================================

Overview
-------------------------------------------------------------------------------

The :git-hdl:`DAQ3 <projects/daq3>` reference design showcases the
:adi:`EVAL-FMCDAQ3-EBZ` evaluation board, which is comprised of the
:adi:`AD9680` dual, 14-bit, 1.25 GSPS, JESD204B ADC, the :adi:`AD9152` dual,
16-bit, 2.5 GSPS, JESD204B DAC, the :adi:`AD9528` clock, and power management
components.

Supported boards
-------------------------------------------------------------------------------

- :adi:`EVAL-FMCDAQ3-EBZ`

Supported devices
-------------------------------------------------------------------------------

- :adi:`AD9152`
- :adi:`AD9680`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - :adi:`EVAL-FMCDAQ3-EBZ`
     - :xilinx:`KCU105`
     - FMC HPC
   * -
     - :xilinx:`VCU118`
     - FMC+
   * -
     - :xilinx:`ZCU102`
     - FMC HPC0
   * -
     - :xilinx:`ZC706`
     - FMC HPC

Block design
-------------------------------------------------------------------------------

The difference between the KCU105/VCU118/ZC706 design and the ZCU102 one, is
the use of :git-hdl:`AXI_ADCFIFO <librar/xilinx/axi_adcfifo>`:
in the Zynq UltraScale-based designs, it is not instantiated.

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

KCU105/VCU118/ZC706
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The data path and clock domains are depicted in the below diagram:

.. image:: daq3_block_diagram.svg
   :width: 1000
   :align: center
   :alt: EVAL-FMCDAQ3-EBZ block diagram

This configuration was built using the ``make`` command with the following
parameters:

.. shell:: bash

   /hdl/projects/daq3/zc706
   $make RX_JESD_M=2 \
   $     RX_JESD_L=4 \
   $     RX_JESD_S=1 \
   $     TX_JESD_M=2 \
   $     TX_JESD_L=4 \
   $     TX_JESD_S=1

.. collapsible:: Click here for details on the block diagram modules

   .. list-table::
      :widths: 10 20 35 35
      :header-rows: 1

      * - Block name
        - IP name
        - Documentation
        - Additional info
      * - AXI_ADCFIFO
        - :git-hdl:`axi_adcfifo <library/xilinx/axi_adcfifo>`
        - ---
        - ---
      * - AXI_ADXCVR
        - :git-hdl:`axi_adxcvr <library/xilinx/axi_adxcvr>`
        - :ref:`axi_adxcvr`
        - 2 instances, one for RX and one for TX
      * - AXI_DMAC
        - :git-hdl:`axi_dmac <library/axi_dmac>`
        - :ref:`axi_dmac`
        - 2 instances, one for RX and one for TX
      * - RX JESD LINK
        - axi_mxfe_rx_jesd
        - :ref:`axi_jesd204_rx`
        - Instantiaded by ``adi_axi_jesd204_rx_create`` procedure
      * - RX JESD TPL
        - axi_ad9680_tpl_core
        - :ref:`ad_ip_jesd204_tpl_adc`
        - Instantiated by ``adi_tpl_jesd204_rx_create`` procedure
      * - TX JESD LINK
        - axi_mxfe_tx_jesd
        - :ref:`axi_jesd204_tx`
        - Instantiaded by ``adi_axi_jesd204_tx_create`` procedure
      * - TX JESD TPL
        - axi_ad9152_tpl_core
        - :ref:`ad_ip_jesd204_tpl_dac`
        - Instantiated by ``adi_tpl_jesd204_tx_create`` procedure
      * - UTIL_ADXCVR
        - :git-hdl:`util_daq3_xcvr <library/xilinx/util_adxcvr>`
        - :ref:`util_adxcvr`
        - Used for both AXI ADXCVR instances
      * - UTIL_CPACK
        - :git-hdl:`axi_ad9680_cpack <library/util_pack/util_cpack2>`
        - :ref:`util_cpack2`
        - ---
      * - UTIL_DACFIFO
        - :git-hdl:`util_dacfifo <library/util_dacfifo>`
        - ---
        - ---
      * - UTIL_UPACK
        - :git-hdl:`axi_ad9152_upack <library/util_pack/util_upack2>`
        - :ref:`util_upack2`
        - ---

ZCU102
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The data path and clock domains are depicted in the below diagram.

.. image:: daq3_zcu102_block_diagram.svg
   :width: 1000
   :align: center
   :alt: EVAL-FMCDAQ3-EBZ/ZCU102 block diagram

This configuration was built using the ``make`` command with the following
parameters:

.. shell:: bash

   /hdl/projects/daq3/zcu102
   $make RX_JESD_M=2 \
   $     RX_JESD_L=4 \
   $     RX_JESD_S=1 \
   $     TX_JESD_M=2 \
   $     TX_JESD_L=4 \
   $     TX_JESD_S=1

.. collapsible:: Click here for details on the block diagram modules

   .. list-table::
      :widths: 10 20 35 35
      :header-rows: 1

      * - Block name
        - IP name
        - Documentation
        - Additional info
      * - AXI_ADXCVR
        - :git-hdl:`axi_adxcvr <library/xilinx/axi_adxcvr>`
        - :ref:`axi_adxcvr`
        - 2 instances, one for RX and one for TX
      * - AXI_DMAC
        - :git-hdl:`axi_dmac <library/axi_dmac>`
        - :ref:`axi_dmac`
        - 2 instances, one for RX and one for TX
      * - RX JESD LINK
        - axi_mxfe_rx_jesd
        - :ref:`axi_jesd204_rx`
        - Instantiaded by ``adi_axi_jesd204_rx_create`` procedure
      * - RX JESD TPL
        - axi_ad9680_tpl_core
        - :ref:`ad_ip_jesd204_tpl_adc`
        - Instantiated by ``adi_tpl_jesd204_rx_create`` procedure
      * - TX JESD LINK
        - axi_mxfe_tx_jesd
        - :ref:`axi_jesd204_tx`
        - Instantiaded by ``adi_axi_jesd204_tx_create`` procedure
      * - TX JESD TPL
        - axi_ad9152_tpl_core
        - :ref:`ad_ip_jesd204_tpl_dac`
        - Instantiated by ``adi_tpl_jesd204_tx_create`` procedure
      * - UTIL_ADXCVR
        - :git-hdl:`util_daq3_xcvr <library/xilinx/util_adxcvr>`
        - :ref:`util_adxcvr`
        - Used for both AXI ADXCVR instances
      * - UTIL_CPACK
        - :git-hdl:`axi_ad9680_cpack <library/util_pack/util_cpack2>`
        - :ref:`util_cpack2`
        - ---
      * - UTIL_DACFIFO
        - :git-hdl:`util_dacfifo <library/util_dacfifo>`
        - ---
        - ---
      * - UTIL_UPACK
        - :git-hdl:`axi_ad9152_upack <library/util_pack/util_upack2>`
        - :ref:`util_upack2`
        - ---

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- External clock source
  :dokuwiki:`AD-SYNCHRONA14-EBZ <resources/eval/user-guides/ad-synchrona14-ebz>`
- SYSREF clocks are LVDS
- ADCCLK and REFCLK are LVPECL

..
   ADD IMAGE IF APPLIES! MUST: Use SVG format

..
   DESCRIBE OTHER COMPONENTS FROM THE PROJECT, EX: SYNCHRONA

Only the channels presented in the clocking selection are relevant. For
the rest, you can either disable them or just put a divided frequency of
the source clock.

Configuration modes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The design has one JESD204B receive chain and one transmit chain, each with
4 lanes.

Each chain consists of a transport layer represented by a JESD TPL module, 
a link layer represented by a JESD LINK module, and a shared among chains
physical layer, represented by an XCVR module.

The HDL project in its current state, has the link operating in subclass 1.

- Rx/Tx device clock - 308.25 MHz
- Reference clock - 616.5 MHz
- JESD204B Rx/Tx Lane Rate - 12.33 Gbps

The following are the parameters of this project that can be configured:

- [RX/TX]_JESD_M: number of converters per link
- [RX/TX]_JESD_L: number of lanes per link
- [RX/TX]_JESD_S: number of samples per frame

Detailed description
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The digital interface consists of 4 transmit and 4 receive lanes running at
12.33 Gbps (default).

The devices' interfaces are shared by the same set of transceivers, followed
by the individual JESD204B and ADC/DAC pcores. The transceivers then interface
to the cores at 128 bits at 308.25MHz. The cores are programmable through
an AXI-lite interface.

The data path consists of independent :ref:`DMA <axi_dmac>` interfaces for
the transmit and receive paths. The data is sent or received based on the
configuration (programmable) from separate transmit and receive chains.

The DAC data may be sourced from an internal data generator (DDS, pattern or
PRBS) or from the external DDR via DMA. The internal DDS phase and frequency
are programmable.

The ADC data is sent to the DDR via DMA. The core also supports PN monitoring
at the sample level. This is different from the JESD204B-specific PN sequence
(though they both claim to be from the same equation).

The device control and monitor signals are interfaced to a GPIO module.
The SPI signals are controlled by a separate AXI based SPI core.

- JESD204B in subclass 1 with lane rate 12.33 Gbps
- RX, TX: L=2, M=4, S=1, NP=16

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture cpu-intercon-addr`).

==================== =============== =========== ============
Instance             Zynq/Microblaze ZynqMP      Versal
==================== =============== =========== ============
 axi_ad9152_tpl_core  0x44A0_4000    0x84A0_4000 0xA4A6_00000
 axi_ad9152_xcvr      0x44A6_0000    0x84A6_0000 0xA4A1_00000
 axi_ad9152_jesd      0x44A9_0000    0x84A9_0000 0xA4A9_00000
 axi_ad9152_dma       0x7C42_0000    0x9C42_0000 0xBC42_00000
 axi_ad9680_tpl_core  0x44A1_0000    0x84A1_0000 0xBC45_00000
 axi_ad9680_xcvr      0x44A5_0000    0x84A5_0000 0xA4B6_00000
 axi_ad9680_jesd      0x44AA_0000    0x84AA_0000 0xA4B1_00000
 axi_ad9680_dma       0x7C40_0000    0x9C40_0000 0xA4B9_00000
==================== =============== =========== ============

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
   * -
     -
     -
     -
     -

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
     - SPI 0
     - ADXYZT
     - 0
   * - PS
     - SPI 1
     - AD0000
     - 0
   * - PL
     - axi_spi_bus_1
     - AD23456
     - 0

GPIOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

..
   Add explanation depending on your case

.. list-table::
   :widths: 25 20 20 20 15
   :header-rows: 2

   * - GPIO signal
     - Direction
     - HDL GPIO EMIO
     - Software GPIO
     - Software GPIO
   * -
     - (from FPGA view)
     -
     - Zynq-7000
     - Zynq MP
   * - signal_name[31:0]
     - IN/OUT/INOUT
     - 127:96
     - 181:150
     - 205:174
   * - signal_name[31:0]
     - IN/OUT/INOUT
     - 95:64
     - 149:118
     - 173:142
   * - signal_name[31:0]
     - IN/OUT/INOUT
     - 63:32
     - 117:86
     - 141:110

..
   MUST: GPIOs should be listed in descending order and should have the number
   of bits specified next to their name

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

================ ====== ======= ========== =========== ============ =============
Instance name    HDL PS HDL MB  Linux Zynq Actual Zynq Linux ZynqMP Actual ZynqMP
================ ====== ======= ========== =========== ============ =============
axi_ad9680_dma   13     12      57         89          109          141          
axi_ad9152_dma   12     13      56         88          108          140          
axi_ad9680_jesd  11     14      55         87          107          139          
axi_ad9152_jesd  10     15      54         86          106          138          
================ ====== ======= ========== =========== ============ =============

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI distributes the bit/elf files of these projects as part of the
:dokuwiki:`ADI Kuiper Linux <resources/tools-software/linux-software/kuiper-linux>`.
If you want to build the sources, ADI makes them available on the
:git-hdl:`HDL repository </>`. To get the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the hdl/projects/$eval_board/$carrier location and run the make
command.

**Linux/Cygwin/WSL**

..
   Say which is the default configuration that's built when running
   ``make``, give examples of running with all parameters and also with
   just one. Say that it will create a folder with the name ... when
   running with the following parameters.

Example of running the ``make`` command without parameters (using the default
configuration):

.. shell:: bash

   $cd hdl/projects/ad9081_fmca_ebz/zcu102
   $make

Example of running the ``make`` command with parameters:

.. shell:: bash

   $cd hdl/projects/ad9081_fmca_ebz/a10soc
   $make RX_LANE_RATE=2.5 TX_LANE_RATE=2.5 RX_JESD_L=8 RX_JESD_M=4 RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_L=8 TX_JESD_M=4 TX_JESD_S=1 TX_JESD_NP=16

The following dropdowns contain tables with the parameters that can be used to
configure this project, depending on the carrier used.
Where a cell contains a --- (dash) it means that the parameter doesn't exist
for that project (ad9081_fmca_ebz/$carrier or ad9082_fmca_ebz/$carrier).

.. collapsible:: Default values of the make parameters for AD9082-FMCA-EBZ

   +-------------------+-----------------------------------------------+
   | Parameter         | Default value of the parameters               |
   |                   |            depending on carrier               |
   |                   +--------+--------+--------------+--------------+
   |                   | VCK190 | VCU118 |        ZC706 |       ZCU102 |
   +===================+========+========+==============+==============+
   | JESD_MODE         | 64B66B |  8B10B | :red:`8B10B*`| :red:`8B10B*`|
   +-------------------+--------+--------+--------------+--------------+
   | RX_LANE_RATE      |  24.75 |     15 |           10 |           15 |
   +-------------------+--------+--------+--------------+--------------+
   | TX_LANE_RATE      |  24.75 |     15 |           10 |           15 |
   +-------------------+--------+--------+--------------+--------------+
   | REF_CLK_RATE      |    375 |    --- |          --- |          --- |
   +-------------------+--------+--------+--------------+--------------+
   | RX_JESD_M         |      4 |      4 |            8 |            4 |
   +-------------------+--------+--------+--------------+--------------+
   | RX_JESD_L         |      8 |      8 |            4 |            8 |
   +-------------------+--------+--------+--------------+--------------+
   | RX_JESD_S         |      4 |      1 |            1 |            1 |
   +-------------------+--------+--------+--------------+--------------+
   | RX_JESD_NP        |     12 |     16 |           16 |           16 |
   +-------------------+--------+--------+--------------+--------------+
   | RX_NUM_LINKS      |      1 |      1 |            1 |            1 |
   +-------------------+--------+--------+--------------+--------------+
   | RX_TPL_WIDTH      |    --- |    --- |          --- |           {} |
   +-------------------+--------+--------+--------------+--------------+
   | TX_JESD_M         |      4 |      4 |            8 |            4 |
   +-------------------+--------+--------+--------------+--------------+
   | TX_JESD_L         |      8 |      8 |            4 |            8 |
   +-------------------+--------+--------+--------------+--------------+
   | TX_JESD_S         |      8 |      1 |            1 |            1 |
   +-------------------+--------+--------+--------------+--------------+
   | TX_JESD_NP        |     12 |     16 |           16 |           16 |
   +-------------------+--------+--------+--------------+--------------+
   | TX_NUM_LINKS      |      1 |      1 |            1 |            1 |
   +-------------------+--------+--------+--------------+--------------+
   | TX_TPL_WIDTH      |    --- |    --- |          --- |           {} |
   +-------------------+--------+--------+--------------+--------------+
   | RX_KS_PER_CHANNEL |     64 |     64 |          --- |          --- |
   +-------------------+--------+--------+--------------+--------------+
   | TX_KS_PER_CHANNEL |     64 |     64 |          --- |          --- |
   +-------------------+--------+--------+--------------+--------------+

   .. admonition:: Legend
      :class: note

      ``*`` --- for this carrier only the 8B10B mode is supported

The result of the build, if parameters were used, will be in a folder named
by the configuration used:

if the following command was run

``make RX_LANE_RATE=2.5 TX_LANE_RATE=2.5 RX_JESD_L=8 RX_JESD_M=4 RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_L=8 TX_JESD_M=4 TX_JESD_S=1 TX_JESD_NP=16``

then the folder name will be:

``RXRATE2_5_TXRATE2_5_RXL8_RXM4_RXS1_RXNP16_TXL8_TXM4_TXS1_TXNP16``
because of truncation of some keywords so the name will not exceed the limits
of the Operating System (``JESD``, ``LANE``, etc. are removed) of 260
characters.

..
   KEEP THIS LINE TOO

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Software considerations
-------------------------------------------------------------------------------

..
   MENTION THESE

ADC - crossbar config \**\* EXAMPLE \**\*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

..
   THIS SECTION IS JUST AN EXAMPLE

Due to physical constraints, Rx lanes are reordered as described in the
following table.

e.g physical lane 2 from ADC connects to logical lane 7
from the FPGA. Therefore the crossbar from the device must be set
accordingly.

============ ===========================
ADC phy Lane FPGA Rx lane / Logical Lane
============ ===========================
0            2
1            0
2            7
3            6
4            5
5            4
6            3
7            1
============ ===========================

DAC - crossbar config \**\* EXAMPLE \**\*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

..
   THIS SECTION IS JUST AN EXAMPLE

Due to physical constraints, Tx lanes are reordered as described in the
following table:

e.g physical lane 2 from DAC connects to logical lane 7
from the FPGA. Therefore the crossbar from the device must be set
accordingly.

============ ===========================
DAC phy Lane FPGA Tx lane / Logical Lane
============ ===========================
0            0
1            2
2            7
3            6
4            1
5            5
6            4
7            3
============ ===========================

Resources
-------------------------------------------------------------------------------

Systems related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Links to the Quick start guides, to the pages where the hardware changes are
  specified in detail, etc. in the form of a table as the one below

..
  THIS IS JUST AN EXAMPLE

- :dokuwiki:`[Wiki] AD9081 & AD9082 & AD9988 & AD9986 Prototyping Platform User Guide <resources/eval/user-guides/ad9081_fmca_ebz>`
- Here you can find all the quick start guides on wiki documentation :dokuwiki:`[Wiki] AD9081/AD9082/AD9986/AD9988 Quick Start Guides <resources/eval/user-guides/ad9081_fmca_ebz/quickstart>`

Here you can find the quick start guides available for these evaluation boards:

.. list-table::
   :widths: 20 10 20 20 20 10
   :header-rows: 1

   * - Evaluation board
     - Zynq-7000
     - Zynq UltraScale+ MP
     - Microblaze
     - Versal
     - Arria 10
   * - AD9081/AD9082-FMCA-EBZ
     - :dokuwiki:`ZC706 <resources/eval/user-guides/ad9081_fmca_ebz/quickstart/zynq>`
     - :dokuwiki:`ZCU102 <resources/eval/user-guides/ad9081_fmca_ebz/quickstart/zynqmp>`
     - :dokuwiki:`VCU118 <resources/eval/user-guides/ad9081_fmca_ebz/quickstart/microblaze>`
     - :dokuwiki:`VCK190/VMK180 <resources/eval/user-guides/ad9081_fmca_ebz/quickstart/versal>`
     - :dokuwiki:`A10SoC <resources/eval/user-guides/ad9081/quickstart/a10soc>`

- Other relevant information

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheets:

  - :adi:`AD9081`
  - :adi:`AD9082`
  - :adi:`AD9988`
  - :adi:`AD9986`
- `UG-1578, Device User Guide <https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf>`__
- `UG-1829, Evaluation Board User Guide <https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-fmca-ebz-9082-fmca-ebz-ug-1829.pdf>`__

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Link to the project source code
- Table like the one below. Must have as first IP (if it exists) the IP that
  was created with this project (i.e., axi_ad9783). If there isn't, then to
  be taken in the order they are written in the Makefile of the project,
  stating the source code link in a column and the documentation link in
  another column
- Other relevant information

..
   THIS IS JUST AN EXAMPLE

- :git-hdl:`AD9081_FMCA_EBZ HDL project source code <projects/ad9081_fmca_ebz>`
- :git-hdl:`AD9082_FMCA_EBZ HDL project source code <projects/ad9082_fmca_ebz>`

.. list-table::
   :widths: 30 35 35
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
   * - UTIL_CPACK2
     - :git-hdl:`library/util_pack/util_cpack2`
     - :ref:`util_cpack2`
   * - UTIL_UPACK2
     - :git-hdl:`library/util_pack/util_upack2`
     - :ref:`util_upack2`
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

..
   MENTION THESE for JESD reference designs

- :dokuwiki:`[Wiki] Generic JESD204B block designs <resources/fpga/docs/hdl/generic_jesd_bds>`
- :ref:`jesd204`

..
   MENTION THIS for SPI Engine reference designs

- :ref:`SPI Engine Framework documentation <spi_engine>`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

..
   THIS IS JUST AN EXAMPLE

- :dokuwiki:`[Wiki] AD9081-FMCA-EBZ Linux driver wiki page <resources/tools-software/linux-drivers/iio-mxfe/ad9081>`

If there is no Linux driver page, then insert a link to the code of the driver
and of the device tree.

- Python support (THIS IS JUST AN EXAMPLE):

  - `AD9081 class documentation <https://analogdevicesinc.github.io/pyadi-iio/devices/adi.ad9081.html>`__
  - `PyADI-IIO documentation <https://analogdevicesinc.github.io/pyadi-iio/>`__
  - `Example link`_

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

.. _Example link: https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/arria/10-sx.html
.. _AMD PG198: https://docs.amd.com/v/u/en-US/pg198-jesd204-phy
.. _AMD UG578: https://docs.amd.com/v/u/en-US/ug578-ultrascale-gty-transceivers

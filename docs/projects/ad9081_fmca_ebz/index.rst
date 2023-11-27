.. _ad9081_fmca_ebz:

AD9081-FMCA-EBZ/AD9082-FMCA-EBZ HDL project
===============================================================================

Overview
-------------------------------------------------------------------------------

The :adi:`AD9081-FMCA-EBZ <EVAL-AD9081>` / :adi:`AD9082-FMCA-EBZ <EVAL-AD9082>`
reference design (also known as Single MxFE) is a processor based
(e.g. Microblaze) embedded system.
The design consists from a receive and a transmit chain.

The receive chain transports the captured samples from ADC to the system
memory (DDR). Before transferring the data to DDR the samples are stored
in a buffer implemented on block rams from the FPGA fabric
(util_adc_fifo). The space allocated in the buffer for each channel
depends on the number of currently active channels. It goes up to M x
64k samples if a single channel is selected or 64k samples per channel
if all channels are selected.

The transmit chain transports samples from the system memory to the DAC
devices. Before streaming out the data to the DAC through the JESD link
the samples first are loaded into a buffer (util_dac_fifo) which will
cyclically stream the samples at the tx_device_clk data rate. The space
allocated in the transmit buffer for each channel depends on the number
of currently active channels. It goes up to M x 64k samples if a single
channel is selected or 64k samples per channel if all channels are
selected.

All cores from the receive and transmit chains are programmable through
an AXI-Lite interface.

The transmit and receive chains can operate at different data rates
having separate rx_device_clk/tx_device_clk and corresponding lane rates
but must share the same reference clock.

Supported boards
-------------------------------------------------------------------------------

-  :adi:`AD9081-FMCA-EBZ <EVAL-AD9081>`
-  :adi:`AD9082-FMCA-EBZ <EVAL-AD9082>`

Supported devices
-------------------------------------------------------------------------------

-  :adi:`AD9081`
-  :adi:`AD9082`
-  :adi:`AD9177`
-  :adi:`AD9207`
-  :adi:`AD9209`
-  :adi:`AD9986`
-  :adi:`AD9988`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - :adi:`AD9081-FMCA-EBZ <EVAL-AD9081>`
     - `A10SoC`_
     - FMCA
   * -
     - :xilinx:`VCK190`
     - FMC0
   * -
     - :xilinx:`VCU118`
     - FMC+
   * -
     - :xilinx:`VCU128`
     - FMC+
   * -
     - :xilinx:`ZCU102`
     - FMC HPC0
   * -
     - :xilinx:`ZC706`
     - FMC HPC

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - :adi:`AD9082-FMCA-EBZ <EVAL-AD9082>`
     - :xilinx:`VCK190`
     - FMC0
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

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagrams:

Example block design for Single link; M=8; L=4
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: ad9081_204b_M8L4.svg
   :width: 800
   :align: center
   :alt: AD9081-FMCA-EBZ JESD204B M=8 L=4 block diagram

The Rx links (ADC Path) operate with the following parameters:

-  Rx Deframer parameters: L=4, M=8, F=4, S=1, NP=16, N=16 (Quick
   Config 0x0A)
-  Sample Rate: 250 MSPS
-  Dual link: No
-  RX_DEVICE_CLK: 250 MHz (Lane Rate/40)
-  REF_CLK: 500MHz (Lane Rate/20)
-  JESD204B Lane Rate: 10Gbps
-  QPLL0 or CPLL

The Tx links (DAC Path) operate with the following parameters:

-  Tx Framer parameters: L=4, M=8, F=4, S=1, NP=16, N=16 (Quick Config
   0x09)
-  Sample Rate: 250 MSPS
-  Dual link: No
-  TX_DEVICE_CLK: 250 MHz (Lane Rate/40)
-  REF_CLK: 500MHz (Lane Rate/20)
-  JESD204B Lane Rate: 10Gbps
-  QPLL0 or CPLL

Example block design for Single link; M=4; L=8
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: ad9081_204b_M4L8.svg
   :width: 800
   :align: center
   :alt: AD9081-FMCA-EBZ JESD204B M=4 L=8 block diagram

The Rx links are set for full bandwidth mode and operate with the
following parameters:

-  Rx Deframer parameters: L=8, M=4, F=1, S=1, NP=16, N=16 (Quick
   Config 0x12)
-  Sample Rate: 1550 MSPS
-  Dual link: No
-  RX_DEVICE_CLK: 387.5 MHz (Lane Rate/40)
-  REF_CLK: 775MHz (Lane Rate/20)
-  JESD204B Lane Rate: 15.5Gbps
-  QPLL0

The Tx links are set for full bandwidth mode and operate with the
following parameters:

-  Tx Framer parameters: L=8, M=4, F=1, S=1, NP=16, N=16 (Quick Config
   0x11)
-  Sample Rate: 1550 MSPS
-  Dual link: No
-  TX_DEVICE_CLK: 387.5 MHz (Lane Rate/40)
-  REF_CLK: 775MHz (Lane Rate/20)
-  JESD204B Lane Rate: 15.5Gbps
-  QPLL0

Example block design for Single link; M=2; L=8; JESD204C
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. note::

   In 2019_R2 release, the AMD JESD Physical layer IP Core is used,
   however in newer versions it is replaced with ADI's util_adxcvr IP core.

.. image:: ad9081_204c_M2L8.svg
   :width: 800
   :align: center
   :alt: AD9081-FMCA-EBZ JESD204C M=2 L=8 block diagram

.. warning::

   **Build instructions:**

   The project must be built with the following parameters:

   .. code-block:: bash

      make JESD_MODE=64B66B \
      RX_RATE=16.5 \
      TX_RATE=16.5 \
      RX_JESD_M=2 \
      RX_JESD_L=8 \
      RX_JESD_S=2 \
      RX_JESD_NP=16 \
      TX_JESD_M=2 \
      TX_JESD_L=8 \
      TX_JESD_S=4 \
      TX_JESD_NP=8

The Rx link is operating with the following parameters:

-  Rx Deframer parameters: L=8, M=2, F=1, S=2, NP=16, N=16 (Quick Config
   0x13)
-  Sample Rate: 4000 MSPS
-  Dual link: No
-  RX_DEVICE_CLK: 250 MHz (Lane Rate/66)
-  REF_CLK: 500 MHz (Lane Rate/33)
-  JESD204C Lane Rate: 16.5Gbps
-  QPLL1

The Tx link is operating with the following parameters:

-  Tx Framer parameters: L=8, M=2, F=1, S=4, NP=8, N=8 (Quick Config
   0x13)
-  Sample Rate: 8000 MSPS
-  Dual link: No
-  TX_DEVICE_CLK: 250 MHz (Lane Rate/66)
-  REF_CLK: 500 MHz (Lane Rate/33)
-  JESD204C Lane Rate: 16.5Gbps
-  QPLL1

Configuration modes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The block design supports configuration of parameters and scales.

We have listed a couple of examples at section
`Building the HDL project`_ and the default modes
for each project.

.. note::

   The parameters for Rx or Tx links can be changed from the
   **system_project.tcl** file, located in
   hdl/projects/ad9081_fmca_ebz/$CARRIER/system_project.tcl

.. warning::

   ``Lane Rate = I/Q Sample Rate x M x N' x (10 \ 8) \ L``

The following are the parameters of this project that can be configured:

-  JESD_MODE: used link layer encoder mode

   -  64B66B - 64b66b link layer defined in JESD204C, uses AMD IP as Physical
      Layer
   -  8B10B  - 8b10b link layer defined in JESD204B, uses ADI IP as Physical
      Layer

-  RX_LANE_RATE: lane rate of the Rx link (MxFE to FPGA)
-  TX_LANE_RATE: lane rate of the Tx link (FPGA to MxFE)
-  REF_CLK_RATE: the rate of the reference clock
-  [RX/TX]_JESD_M: number of converters per link
-  [RX/TX]_JESD_L: number of lanes per link
-  [RX/TX]_JESD_S: number of samples per frame
-  [RX/TX]_JESD_NP: number of bits per sample
-  [RX/TX]_NUM_LINKS: number of links
-  [RX/TX]_TPL_WIDTH
-  TDD_SUPPORT: set to 1, adds the TDD; enables external synchronization through TDD. Must be set to 1 when SHARED_DEVCLK=1
-  SHARED_DEVCLK
-  TDD_CHANNEL_CNT
-  TDD_SYNC_WIDTH
-  TDD_SYNC_INT
-  TDD_SYNC_EXT
-  TDD_SYNC_EXT_CDC: if enabled, the CDC circuitry for the external sync signal is added
-  [RX/TX]_KS_PER_CHANNEL: Number of samples stored in internal buffers in
   kilosamples per converter (M)
-  [ADC/DAC]_DO_MEM_TYPE
-  Check out this guide on more details regarding these parameters:
   :dokuwiki:`resources/fpga/docs/axi_tdd`

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The clock sources depend on the carrier that is used:

:xilinx:`ZCU102`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: ad9081_clock_scheme_zcu102.svg
   :width: 800
   :align: center
   :alt: AD9081-FMCA-EBZ ZCU102 clock scheme

:xilinx:`VCU118`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: ad9081_clock_scheme_vcu118.svg
   :width: 800
   :align: center
   :alt: AD9081-FMCA-EBZ VCU118 clock scheme

Limitations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning::

   For the parameter selection, the following restrictions apply:

   -  NP = 8, 12, 16
   -  F = 1, 2, 3, 4, 6, 8
   -  https://wiki.analog.com/resources/fpga/peripherals/jesd204/axi_jesd204_rx#restrictions
   -  https://wiki.analog.com/resources/fpga/peripherals/jesd204/axi_jesd204_tx#restrictions

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture`).

Depending on the values of parameters $INTF_CFG, $ADI_PHY_SEL and $TDD_SUPPORT,
some IPs are instatiated and some are not.

Check-out the table below to find out the conditions.

==================== ================================= =============== =========== ============
Instance             Depends on parameter              Zynq/Microblaze ZynqMP      Versal
==================== ================================= =============== =========== ============
axi_mxfe_rx_xcvr     $INTF_CFG!="TX" & $ADI_PHY_SEL==1 0x44A6_0000     0x84A6_0000 0xA4A6_00000
rx_mxfe_tpl_core     $INTF_CFG!="TX"                   0x44A1_0000     0x84A1_0000 0xA4A1_00000
axi_mxfe_rx_jesd     $INTF_CFG!="TX"                   0x44A9_0000     0x84A9_0000 0xA4A9_00000
axi_mxfe_rx_dma      $INTF_CFG!="TX"                   0x7C42_0000     0x9C42_0000 0xBC42_00000
mxfe_rx_data_offload $INTF_CFG!="TX"                   0x7C45_0000     0x9C45_0000 0xBC45_00000
axi_mxfe_tx_xcvr     $INTF_CFG!="RX" & $ADI_PHY_SEL==1 0x44B6_0000     0x84B6_0000 0xA4B6_00000
tx_mxfe_tpl_core     $INTF_CFG!="RX"                   0x44B1_0000     0x84B1_0000 0xA4B1_00000
axi_mxfe_tx_jesd     $INTF_CFG!="RX"                   0x44B9_0000     0x84B9_0000 0xA4B9_00000
axi_mxfe_tx_dma      $INTF_CFG!="RX"                   0x7C43_0000     0x9C43_0000 0xBC43_00000
mxfe_tx_data_offload $INTF_CFG!="RX"                   0x7C44_0000     0x9C44_0000 0xBC44_00000
axi_tdd_0            $TDD_SUPPORT==1                   0x7C46_0000     0x9C46_0000 0xBC46_00000
==================== ================================= =============== =========== ============

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
     - AD9081
     - 0
   * - PS
     - spi1
     - HMC7044
     - 0

GPIOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
   * - txen[1:0]
     - OUT
     - 59:58
     - 113:112
     - 137:136
   * - rxen[1:0]
     - OUT
     - 57:56
     - 111:110
     - 135:134
   * - rstb
     - OUT
     - 55
     - 109
     - 133
   * - hmc_sync
     - OUT
     - 54
     - 108
     - 132
   * - irqb[1:0]
     - IN
     - 53:52
     - 107:106
     - 131:130
   * - agc3[1:0]
     - IN
     - 51:50
     - 105:104
     - 129:128
   * - agc2[1:0]
     - IN
     - 49:48
     - 103:102
     - 127:126
   * - agc1[1:0]
     - IN
     - 47:46
     - 101:100
     - 125:124
   * - agc0[1:0]
     - IN
     - 45:44
     - 99:98
     - 123:122
   * - hmc_gpio1
     - INOUT
     - 43
     - 97
     - 121
   * - gpio[10:0]
     - INOUT
     - 42:32
     - 96:86
     - 120:110

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

================ === ========== =========== ============ =============
Instance name    HDL Linux Zynq Actual Zynq Linux ZynqMP Actual ZynqMP
================ === ========== =========== ============ =============
axi_mxfe_rx_dma  13  57         89          109          141
axi_mxfe_tx_dma  12  56         88          108          140
axi_mxfe_rx_jesd 11  55         87          107          139
axi_mxfe_tx_jesd 10  54         86          106          138
================ === ========== =========== ============ =============

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here </>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the :git-hdl:`projects/ad9081_fmca_ebz <projects/ad9081_fmca_ebz>`
location and run the make command by typing in your command prompt:

**Linux/Cygwin/WSL**

.. code-block::
   :linenos:
   :emphasize-lines: 2, 6

   user@analog:~$ cd hdl/projects/ad9081_fmca_ebz/zcu102
   // these are just examples of how to write the *make* command with parameters
   user@analog:~/hdl/projects/ad9081_fmca_ebz/zcu102$ make parameter1=value parameter2=value

   user@analog:~$ cd hdl/projects/ad9081_fmca_ebz/a10soc
   // these are just examples of how to write the *make* command with parameters
   user@analog:~/hdl/projects/ad9081_fmca_ebz/a10soc$ make RX_LANE_RATE=2.5 TX_LANE_RATE=2.5 RX_JESD_L=8 RX_JESD_M=4 RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_L=8 TX_JESD_M=4 TX_JESD_S=1 TX_JESD_NP=16

The following dropdowns contain tables with the parameters that can be used to
configure this project, depending on the carrier used.
Where a cell contains a --- (dash) it means that the parameter doesn't exist
for that project (ad9081_fmca_ebz/carrier or ad9082_fmca_ebz/carrier).

.. warning::

   For the parameter selection, the following restrictions apply:

   -  NP = 8, 12, 16
   -  F = 1, 2, 3, 4, 6, 8
   -  https://wiki.analog.com/resources/fpga/peripherals/jesd204/axi_jesd204_rx#restrictions
   -  https://wiki.analog.com/resources/fpga/peripherals/jesd204/axi_jesd204_tx#restrictions

   ``NP`` notation is equivalent with ``N'``

.. collapsible:: Default values of the ``make`` parameters for AD9081-FMCA-EBZ

   +-------------------+------------------------------------------------------+
   | Parameter         | Default value of the parameters depending on carrier |
   |                   +----------+--------+--------+--------+-------+--------+
   |                   |   A10SoC | VCK190 | VCU118 | VCU128 | ZC706 | ZCU102 |
   +===================+==========+========+========+========+=======+========+
   | JESD_MODE         |      --- | 64B66B |  8B10B |  8B10B | 8B10B |   8B10B|
   +-------------------+----------+--------+--------+--------+-------+--------+
   | RX_LANE_RATE      |       10 |  24.75 |     10 |     10 |    10 |     10 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TX_LANE_RATE      |       10 |  24.75 |     10 |     10 |    10 |     10 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | REF_CLK_RATE      |      --- |    375 |    --- |    --- |   --- |    --- |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | RX_JESD_M         |        8 |      8 |      8 |      8 |     8 |      8 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | RX_JESD_L         |        4 |      8 |      4 |      4 |     4 |      4 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | RX_JESD_S         |        1 |      2 |      1 |      1 |     1 |      1 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | RX_JESD_NP        |       16 |     12 |     16 |     16 |    16 |     16 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | RX_NUM_LINKS      |        1 |      1 |      1 |      1 |     1 |      1 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | RX_TPL_WIDTH      |      --- |    --- |    --- |    --- |   --- |     {} |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TX_JESD_M         |        8 |      8 |      8 |      8 |     8 |      8 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TX_JESD_L         |        4 |      8 |      4 |      4 |     4 |      4 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TX_JESD_S         |        1 |      2 |      1 |      1 |     1 |      1 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TX_JESD_NP        |       16 |     12 |     16 |     16 |    16 |     16 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TX_NUM_LINKS      |        1 |      1 |      1 |      1 |     1 |      1 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TX_TPL_WIDTH      |      --- |    --- |    --- |    --- |   --- |     {} |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TDD_SUPPORT       |      --- |    --- |    --- |    --- |   --- |      0 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | SHARED_DEVCLK     |      --- |    --- |    --- |    --- |   --- |      0 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TDD_CHANNEL_CNT   |      --- |    --- |    --- |    --- |   --- |      2 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TDD_SYNC_WIDTH    |      --- |    --- |    --- |    --- |   --- |     32 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TDD_SYNC_INT      |      --- |    --- |    --- |    --- |   --- |      1 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TDD_SYNC_EXT      |      --- |    --- |    --- |    --- |   --- |      0 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TDD_SYNC_EXT_CDC  |      --- |    --- |    --- |    --- |   --- |      0 |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | RX_KS_PER_CHANNEL |       32 |     64 |     64 |  16384 |   --- |    --- |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | TX_KS_PER_CHANNEL |       32 |     64 |     64 |  16384 |   --- |    --- |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | ADC_DO_MEM_TYPE   |      --- |    --- |    --- |      2 |   --- |    --- |
   +-------------------+----------+--------+--------+--------+-------+--------+
   | DAC_DO_MEM_TYPE   |      --- |    --- |    --- |      2 |   --- |    --- |
   +-------------------+----------+--------+--------+--------+-------+--------+

.. collapsible:: Default values of the ``make`` parameters for AD9082-FMCA-EBZ

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

   .. warning::

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

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Software considerations
-------------------------------------------------------------------------------

ADC - crossbar config
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

DAC - crossbar config
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Due to physical constraints, Tx lanes are reordered as described in the
following table.

e.g physical lane 2 from DAC connects to logical lane 7
from the FPGA. Therefore the crossbar from the device must be set
accordingly.

============ ===========================
DAC phy lane FPGA Tx lane / Logical lane
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

-  :dokuwiki:`[Wiki] AD9081 & AD9082 & AD9988 & AD9986 Prototyping Platform User Guide <resources/eval/user-guides/ad9081_fmca_ebz>`
-  Here you can find all the quick start guides on wiki documentation:dokuwiki:`[Wiki] AD9081 Quick Start Guides <resources/eval/user-guides/ad9081_fmca_ebz/quickstart>`

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

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Product datasheets:

   -  :adi:`AD9081`
   -  :adi:`AD9082`
   -  :adi:`AD9988`
   -  :adi:`AD9986`
-  `UG-1578, Device User Guide <https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf>`__
-  `UG-1829, Evaluation Board User Guide <https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-fmca-ebz-9082-fmca-ebz-ug-1829.pdf>`__

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`AD9081_FMCA_EBZ HDL project source code <projects/ad9081_fmca_ebz>`
-  :git-hdl:`AD9082_FMCA_EBZ HDL project source code <projects/ad9082_fmca_ebz>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_DMAC
     - :git-hdl:`library/axi_dmac`
     - :ref:`here <axi_dmac>`
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`
   * - UTIL_CPACK2
     - :git-hdl:`library/util_pack/util_cpack2`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/util_cpack>`
   * - UTIL_UPACK2
     - :git-hdl:`library/util_pack/util_upack2`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/util_upack>`
   * - UTIL_ADXCVR for AMD
     - :git-hdl:`library/xilinx/util_adxcvr`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/util_xcvr>`
   * - AXI_ADXCVR for Intel
     - :git-hdl:`library/intel/axi_adxcvr`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_adxcvr>`
   * - AXI_ADXCVR for AMD
     - :git-hdl:`library/xilinx/axi_adxcvr`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_adxcvr>`
   * - AXI_JESD204_RX
     - :git-hdl:`library/jesd204/axi_jesd204_rx`
     - :dokuwiki:`[Wiki] <resources/fpga/peripherals/jesd204/axi_jesd204_rx>`
   * - AXI_JESD204_TX
     - :git-hdl:`library/jesd204/axi_jesd204_tx`
     - :dokuwiki:`[Wiki] <resources/fpga/peripherals/jesd204/axi_jesd204_tx>`
   * - JESD204_TPL_ADC
     - :git-hdl:`library/jesd204/ad_ip_jesd204_tpl_adc`
     - :dokuwiki:`[Wiki] <resources/fpga/peripherals/jesd204/jesd204_tpl_adc>`
   * - JESD204_TPL_DAC
     - :git-hdl:`library/jesd204/ad_ip_jesd204_tpl_dac`
     - :dokuwiki:`[Wiki] <resources/fpga/peripherals/jesd204/jesd204_tpl_dac>`

-  :dokuwiki:`[Wiki] Generic JESD204B block designs <resources/fpga/docs/hdl/generic_jesd_bds>`
-  :dokuwiki:`[Wiki] JESD204B High-Speed Serial Interface Support <resources/fpga/peripherals/jesd204>`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :dokuwiki:`[Wiki] AD9081-FMCA-EBZ Linux driver wiki page <resources/tools-software/linux-drivers/iio-mxfe/ad9081>`
-  Python support:

   -  `AD9081 class documentation <https://analogdevicesinc.github.io/pyadi-iio/devices/adi.ad9081.html>`__
   -  `PyADI-IIO documentation <https://analogdevicesinc.github.io/pyadi-iio/>`__

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

.. _A10SoC: https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/arria/10-sx.html

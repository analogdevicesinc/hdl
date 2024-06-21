.. _cn0577:

CN0577 HDL project
================================================================================

Overview
-------------------------------------------------------------------------------

The :adi:`EVALCN0577-FMCZ <CN0577>` provides an analog front-end and an FMC 
digital interface for :adi:`LTC2387-18`, its core. It is a low noise, high 
speed successive approximation register (SAR) ADC with a resolution of 18 bits 
and sampling rate up to 15MSPS. :adi:`EVALCN0577-FMCZ <CN0577>` includes an 
on-board reference oscillator and a retiming circuit to minimize signal-to-noise 
ratio (SNR) degradation due to the FPGA additive jitter. In order to support 
high speed operations while minimizing the number of data lines, a serial LVDS 
digital interface is used. It has a one-lane and two-lane output modes, 
allowing the user to optimize the interface data rate for each application, 
through setting a parameter.
Current revision of :adi:`EVALCN0577-FMCZ <CN0577>` is Rev A.
:adi:`EVALCN0577-FMCZ <CN0577>` and :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>` 
are connected together to build a development system setup.

Supported boards
-------------------------------------------------------------------------------

-  :adi:`CN0577 <CN0577>`
-  :adi:`LTC2387-18 chip <LTC2387-18>`

Supported devices
-------------------------------------------------------------------------------

-  :adi:`ADAQ23876`
-  :adi:`ADA4945-1`
-  :adi:`ADG3241`
-  :adi:`ADN4661`
-  :adi:`ADR4520`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - :adi:`CN0577 <CN0577>`
     - :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`
     - FMC-LPC

Block design
-------------------------------------------------------------------------------

The architecture is composed from one :adi:`ADA4945-1` fully differential 
analog-to-digital driver interface IP that is driving the :adi:`LTC2387-18` 
which is an 18 bits analog-to-digital converter interface IP. All these IPs 
utilize an 120MHz reference clock, which is produced by an axi_clkgen IP.

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagram:

.. image:: ../cn0577/cn0577_zed_block_diagram.svg
   :width: 800
   :align: center
   :alt: CN0577/ZedBoard block diagram

Jumper setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Depending on what configuration of pins is chosen on the jumpers P1, P2 and P3, 
the device can act in different modes, as described below. Of course, the PD 
jumper overrides the PD signal from the FPGA. It is controlled by a 
one-bit-adc-dac, in software.

.. list-table::
   :widths: 35 35 35 35
   :header-rows: 1

   * - Jumper/Solder link
     - Description
     - Pins
     - Configuration
   * - P1
     - configures PD_N
     - Shorting pins 1 and 2
     - PD_N = 1, device is not powered down
   * - P1
     - ---
     - Shorting pins 2 and 3
     - PD_N = 0, device is powered down
   * - P2
     - configures TESTPAT
     - Shorting pins 1 and 2
     - TESTPAT = 1, pattern testing is active
   * - P2
     - ---
     - Shorting pins 2 and 3
     - TESTPAT = 0, pattern testing is inactive
   * - P3
     - configures TWOLANES parameter
     - Shorting pins 1 and 2
     - TWOLANES = 1 (TWO LANES mode)
   * - P3
     - ---
     - Shorting pins 2 and 3
     - TWOLANES = 0 (ONE LANE mode)

The FMC connector connects to the LPC connector of the carrier board. For more 
detalis, check :adi:`EVALCN0577-FMCZ <CN0577>` datasheet.

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  The clock architecture of the :adi:`EVALCN0577-FMCZ <CN0577>` is designed 
   with careful consideration to ensure low jitter and low phase noise

-  An on-board 120 MHz voltage controlled crystal oscillator (VCXO) is used to 
   provide the clock for the :adi:`EVALCN0577-FMCZ <CN0577>` board and the FPGA. 
   It is further named as reference clock. This clock is gated and fed back to 
   the device as the sampling clock, on which the data was sampled

-  The DMA runs on the ZynqPS clock FCLK_CLK0 which has a frequency of 100MHz

For more detalis, check :adi:`EVALCN0577-FMCZ <CN0577>` datasheet.

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture`).

==================== ===============
Instance             Zynq/Microblaze
==================== ===============
axi_ltc2387          0x44A0_0000    
axi_ltc2387_dma      0x44A3_0000    
axi_pwm_gen          0x44A6_0000 
==================== ===============

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

THESE ARE JUST EXAMPLES!!!
USE WHICHEVER FITS BEST YOUR CASE

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

**Add explanation depending on your case**

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

\*\* MUST: GPIOs should be listed in descending order and should have the number
of bits specified next to their name \*\*

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

You have many ways of writing this table: as a list-table or really to draw
it. Take a look in the .rst of this page to see how they're written and
which suits best your case.

.. list-table::
   :widths: 30 10 15 15 15 15
   :header-rows: 1

   * - Instance name
     - HDL
     - Linux Zynq
     - Actual Zynq
     - Linux ZynqMP
     - Actual ZynqMP
   * - ---
     - 15
     - 59
     - 91
     - 111
     - 143
   * - ---
     - 14
     - 58
     - 90
     - 110
     - 142
   * - ---
     - 13
     - 57
     - 89
     - 109
     - 141
   * - ---
     - 12
     - 56
     - 88
     - 108
     - 140
   * - ---
     - 11
     - 55
     - 87
     - 107
     - 139
   * - ---
     - 10
     - 54
     - 86
     - 106
     - 138
   * - ---
     - 9
     - 53
     - 85
     - 105
     - 137
   * - ---
     - 8
     - 52
     - 84
     - 104
     - 136
   * - ---
     - 7
     - 36
     - 68
     - 96
     - 128
   * - ---
     - 6
     - 35
     - 67
     - 95
     - 127
   * - ---
     - 5
     - 34
     - 66
     - 94
     - 126
   * - ---
     - 4
     - 33
     - 65
     - 93
     - 125
   * - ---
     - 3
     - 32
     - 64
     - 92
     - 124
   * - ---
     - 2
     - 31
     - 63
     - 91
     - 123
   * - ---
     - 1
     - 30
     - 62
     - 90
     - 122
   * - ---
     - 0
     - 29
     - 61
     - 89
     - 121

================ === ========== =========== ============ ============= ====== =============== ================
Instance name    HDL Linux Zynq Actual Zynq Linux ZynqMP Actual ZynqMP S10SoC Linux Cyclone V Actual Cyclone V
================ === ========== =========== ============ ============= ====== =============== ================
---              15  59         91          111          143           32     55              87
---              14  58         90          110          142           31     54              86
---              13  57         89          109          141           30     53              85
---              12  56         88          108          140           29     52              84
---              11  55         87          107          139           28     51              83
---              10  54         86          106          138           27     50              82
---              9   53         85          105          137           26     49              81
---              8   52         84          104          136           25     48              80
---              7   36         68          96           128           24     47              79
---              6   35         67          95           127           23     46              78
---              5   34         66          94           126           22     45              77
---              4   33         65          93           125           21     44              76
---              3   32         64          92           124           20     43              75
---              2   31         63          91           123           19     42              74
---              1   30         62          90           122           18     41              73
---              0   29         61          89           121           17     40              72
================ === ========== =========== ============ ============= ====== =============== ================

!!!! These are the project-specific interrupts (usually found in
/project_name/common/Project_name_bd,tcl).
Add the name of the component that uses that interrupt.
Delete the dropdown section when you insert the table in your page

NOTE THAT FOR ULTRASCALE\+ DEVICES, THE PS I2C IS NOT SUPPORTED IN LINUX!!
ALWAYS USE PL I2C FOR THESE DESIGNS!!

Building the HDL project
-------------------------------------------------------------------------------

**\*YOU CAN KEEP THE FIRST PARAGRAPH SINCE IT IS GENERIC**\ \*

The design is built upon ADI's generic HDL reference design framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here <>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the **\*PROJECT LOCATION WITHIN HDL (EX:
projects/ad9695/zcu102)**\ \* location and run the make command by
typing in your command prompt:

**Linux/Cygwin/WSL**

**\*Say which is the default configuration that's built when running
``make``, give examples of running with all parameters and also with
just one. Say that it will create a folder with the name ... when
running with the following parameters.**\ \*

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

**\*KEEP THIS LINE TOO**\ \*
A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Software considerations
-------------------------------------------------------------------------------

\**\* MENTION THESE \**\*

ADC - crossbar config \**\* THIS IS JUST AN EXAMPLE \**\*
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

DAC - crossbar config \**\* THIS IS JUST AN EXAMPLE \**\*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

-  Links to the Quick start guides, to the pages where the hardware changes are
   specified in detail, etc. in the form of a table as the one below

**THIS IS JUST AN EXAMPLE**

-  :dokuwiki:`[Wiki] AD9081 & AD9082 & AD9988 & AD9986 Prototyping Platform User Guide <resources/eval/user-guides/ad9081_fmca_ebz>`
-  Here you can find all the quick start guides on wiki documentation :dokuwiki:`[Wiki] AD9081/AD9082/AD9986/AD9988 Quick Start Guides <resources/eval/user-guides/ad9081_fmca_ebz/quickstart>`

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

-  Other relevant information

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

-  Link to the project source code
-  Table like the one below. Must have as first IP (if it exists) the IP that
   was created with this project (i.e., axi_ad9783). If there isn't, then to
   be taken in the order they are written in the Makefile of the project,
   stating the source code link in a column and the documentation link in
   another column
-  Other relevant information

**THIS IS JUST AN EXAMPLE**

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

\**\* MENTION THESE for JESD reference designs \**\*

-  :dokuwiki:`[Wiki] Generic JESD204B block designs <resources/fpga/docs/hdl/generic_jesd_bds>`
-  :ref:`jesd204`

\**\* MENTION THIS for SPI Engine reference designs \**\*

-  :ref:`SPI Engine Framework documentation <spi_engine>`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**THIS IS JUST AN EXAMPLE**

-  :dokuwiki:`[Wiki] AD9081-FMCA-EBZ Linux driver wiki page <resources/tools-software/linux-drivers/iio-mxfe/ad9081>`

If there is no Linux driver page, then insert a link to the code of the driver
and of the device tree.

-  Python support (THIS IS JUST AN EXAMPLE):

   -  `AD9081 class documentation <https://analogdevicesinc.github.io/pyadi-iio/devices/adi.ad9081.html>`__
   -  `PyADI-IIO documentation <https://analogdevicesinc.github.io/pyadi-iio/>`__

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

.. _A10SoC: https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/arria/10-sx.html
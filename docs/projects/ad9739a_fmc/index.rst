.. _ad9739a_fmc:

AD9739A-FMC HDL project
================================================================================

Overview
-------------------------------------------------------------------------------

The :adi:`AD9739A <AD9739A>` is a 14-bit, 2.5 GSPS high performance RF DAC
capable of synthesizing wideband signals with up to 1.25GHz of bandwidth, from
DC up to 3 GHz.

This reference design includes a single tone sine generator (DDS) and allows
programming the device and monitoring its internal status registers. It also
programs the ADF4350 clock chip which can generate a 1.6G Hz to 2.5 GHz clock
for the :adi:`AD9739A <AD9739A>` from the on-board 25MHz crystal. An alternate
clock path using an ADCLK914 is available for driving the clock externally.

Supported boards
-------------------------------------------------------------------------------

-  :adi:`EVAL-AD9739A <EVAL-AD9739A>`

Supported devices
-------------------------------------------------------------------------------

-  :adi:`ADS7-V2EBZ <EVAL-ADS7-V2>`

Supported carriers
-------------------------------------------------------------------------------

-  :xilinx:`ZC706` on FMC LPC slot

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The reference design consists of two functional modules, a DDS/LVDS interface
and a SPI interface. It is part of an AXI based microblaze system as shown in
the block diagram below. It is designed to support linux running on microblaze.
All other peripherals are available from Xilinx as IP cores.

The data path and clock domains are depicted in the below diagrams:

Xilinx block diagram
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: ../ad9739a_fmc/ad9739a_fmc_xilinx.svg
   :width: 800
   :align: center
   :alt: AD9739A-FMC/ZC706 xlilinx block diagram

AD9739A FMC Card block diagram
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: ../ad9739a_fmc/ad9739a_fmc_card_1.svg
   :width: 800
   :align: center
   :alt: AD9739A-FMC/ZC706 xlilinx block diagram

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Two clock paths are available to drive the clock input on the
:adi:`AD9739A <AD9739A>`:

-  The factory default option connects the :adi:`ADF4350 <ADF4350>` to
   the :adi:`AD9739A <AD9739A>`. The :adi:`ADF4350 <ADF4350>` is able to
   synthesize a clock over the entire specified range of 
   the :adi:`AD9739A <AD9739A>` (1.6GHz to 2.5GHz)

    -  Jumper CLOCK SOURCE (S1) must be moved to the :adi:`ADF4350 <ADF4350>` 
       position

-  Alternatively, an external clock can be provided via the SMA CLKIN (J3) jack

    -  Jumper CLOCK SOURCE (S1) must be moved to the :adi:`ADCLK914 <ADCLK914>` 
       position. C102 and C99 on the back of the board also need to be removed
       from their default position, and then soldered into the vertical position
       from the large square pad they were previously soldered to and the narrow
       pads closer to the :adi:`ADCLK914 <ADCLK914>` (U3). Observe the 
       orientation of the caps before removing them; they must be soldered with
       their narrow edge against the PCB, and not the wide side as is common
       with most components.

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

==================== ===============
Instance             Zynq/Microblaze
==================== ===============
axi_ad9739a          0x7420_0000    
axi_ad9739a_dma      0x7c42_0000    
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
   * - PL
     - iic_fmc
     - axi_iic_fmc
     - 0x4162_0000
     - ---
   * - PL
     - iic_main
     - axi_iic_main
     - 0x4160_0000
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
     - SPI 0
     - ADXYZT
     - 0
   * - PS
     - SPI 1
     - AD0000
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

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here <>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

.. code-block::
   :linenos:

   user@analog:~$ cd hdl/projects/ad9739a_fmc/zc706
   user@analog:~/hdl/projects/ad9739a_fmc/zc706$ make

A more comprehensive build guide can be found in the :ref:`build_hdl` user 
guide.

Resources
-------------------------------------------------------------------------------

Systems related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :dokuwiki:`[Wiki] AD9737A-EBZ/AD9739A-EBZ Quick Start Guide <resources/eval/dpg/ad9739a-ebz>`
-  :dokuwiki:`[Wiki] AD9739A Native FMC Card/Xilinx Reference Designs <resources/fpga/xilinx/fmc/ad9739a>`
-  :dokuwiki:`[Wiki] EVALUATING THE AD9739A/AD9737A RF DIGITAL-TO-ANALOG CONVERTER <resources/eval/dpg/eval-ad9739a>`

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Product datasheets:

   -  :adi:`ADCLK914`
   -  :adi:`ADCLK946`
   -  :adi:`ADF4150`
   -  :adi:`ADF4350`
-  `AD9737A/AD9739A Data sheet <https://www.analog.com/media/en/technical-documentation/data-sheets/AD9737A_9739A.pdf>`__

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`AD9739A-FMC HDL project source code <projects/ad9739a_fmc>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_AD9739A
     - :git-hdl:`library/axi_ad9739a`
     - :ref:`here <axi_dmac>`
   * - AXI_DMAC
     - :git-hdl:`library/axi_dmac`
     - :ref:`here <axi_dmac>`
   * - AXI_CLKGEN
     - :git-hdl:`library/axi_clkgen`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_clkgen>`
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`
   * - AXI_HDMI_TX
     - :git-hdl:`library/axi_hdmi_tx`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_hdmi_tx>`
   * - AXI_SPDIF_TX
     - :git-hdl:`library/axi_spdif_tx`
     - 	—
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`


Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-linux:`AD9739A-FMC Linux driver <drivers/iio/frequency/ad9739a.c>`
-  :git-linux:`AD9739A-FMC Linux device tree <arch/arm/boot/dts/zynq-zc706-adv7511-ad9739a-fmc.dts>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

.. _A10SoC: https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/arria/10-sx.html
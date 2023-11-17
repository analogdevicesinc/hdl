.. _ad9434_fmc:

AD9434-FMC HDL project
================================================================================

Overview
-------------------------------------------------------------------------------

The :part:`AD9434` is a 12-bit monolithic sampling analog-to-digital converter (ADC) optimized for high performance, 
low power, and ease of use. The part operates at up to a 500 MSPS conversion rate and is optimized for 
outstanding dynamic performance in wideband carrier and broadband systems. All necessary functions, including 
a sample-and-hold and voltage reference, are included on the chip to provide a complete signal conversion solution. 
This reference design includes a data capture interface and the external DDR-DRAM interface for sample storage. 
It allows programming the device and monitoring its internal status registers. The board also provides other options 
to drive the clock and analog inputs of the ADC.

Supported boards
-------------------------------------------------------------------------------

-  :part:`EVAL-AD9434`
-  :part:`SDP-H1`

Supported devices
-------------------------------------------------------------------------------

-  :part:`AD9434`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - :part:`EVAL-AD9434-FMC-500EBZ <EVAL-AD9434>`
     - :xilinx:`ZC706`
     - FMC LPC
   * -
     - `ZEDBOARD`_
     - FMC LPC

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ../images/ad9434_fmc/ad9434_fmc_block_diagram.svg
   :width: 800
   :align: center
   :alt: AD9783-EBZ/ZCU102 block diagram

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  An external clock source can be connected to CLKIN input of the EVAL-AD9434

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL.

==================== ===============
Instance             Zynq/Microblaze
==================== ===============
axi_ad9434_dma       0x44A0_0000    
axi_ad9434_dma       0x44A3_0000    
==================== ===============

SPI connections
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 25 25 25 25
   :header-rows: 1

   * - SPI type
     - SPI manager instance
     - SPI subordinate
     - CSB
   * - PS
     - SPI 0
     - AD9517
     - 1
   * - PS
     - SPI 0
     - AD9434BCPZ
     - 0

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

================ === ========== ===========
Instance name    HDL Linux Zynq Actual Zynq
================ === ========== ===========
axi_ad9783_dma   13  57         89             
================ === ========== ===========

These are the project-specific interrupts (usually found in
/ad9434_fmc/common/ad9434_fmc_bd.tcl).

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here <master:/>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the project location(**projects/ad9434_fmc/carrier**) and run the make command by
typing in your command prompt(this example is for zc706):

**Linux/Cygwin/WSL**

.. code-block::

   user@analog:~$ cd hdl/projects/ad9434_fmc/zc706
   user@analog:~/hdl/projects/ad9434_fmc/zc706$ make

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Resources
-------------------------------------------------------------------------------

Systems related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
   * - AD9434-FMC
     - :dokuwiki:`ZC706 <resources/fpga/xilinx/fmc/ad9434>`
     - ---
     - ---
     - ---
     - ---

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Product datasheets:

   -  :part:`AD9434`
   -  :part:`EVAL-AD9434`
   -  :part:`SDP-H1`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`AD9434-FMC HDL project source code <master:projects/ad9434_fmc>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_DMAC
     - :git-hdl:`library/axi_dmac <master:library/axi_dmac>`
     - :ref:`here <axi_dmac>`
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid <master:library/axi_sysid>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom <master:library/sysid_rom>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`
   * - axi_ad9434
     - :git-hdl:`library/axi_ad9434 <master:library/axi_ad9434>`
     - \-
   * - axi_clkgen
     - :git-hdl:`library/axi_clkgen <master:library/axi_clkgen>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_clkgen>`
   * - axi_hdmi_tx
     - :git-hdl:`library/axi_hdmi_tx <master:library/axi_ad9434>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_hdmi_tx>`
   * - axi_spdif_tx
     - :git-hdl:`library/axi_spdif_tx <master:library/axi_spdif_tx>`
     - \-

-  :dokuwiki:`[Wiki] AD9434 Native FMC Card <resources/fpga/xilinx/fmc/ad9434>`
-  :dokuwiki:`[Wiki] Ecaluating the AD9434 analog-to-digital converter <resources/eval/ad9434fmc-500ebz>`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-linux:`Devicetree <master:arch/arm/boot/dts/zynq-zc706-adv7511-ad9434-fmc-500ebz.dts>`
-  :git-linux:`Driver <master:drivers/iio/adc/ad9467.c>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

.. _ZEDBOARD: https://digilent.com/reference/programmable-logic/zedboard/start

.. _ad9434_fmc:

AD9434-FMC HDL project
================================================================================

Overview
-------------------------------------------------------------------------------

The :adi:`AD9434` is a 12-bit monolithic sampling analog-to-digital converter
(ADC) optimized for high performance, low power, and ease of use. The part
operates at up to a 500 MSPS conversion rate and is optimized for outstanding
dynamic performance in wideband carrier and broadband systems. All necessary
functions, including a sample-and-hold and voltage reference, are included on
the chip to provide a complete signal conversion solution. This reference 
design includes a data capture interface and the external DDR-DRAM interface
for sample storage. It allows programming the device and monitoring its internal
status registers. The board also provides other options to drive the clock and
analog inputs of the ADC.

Supported boards
-------------------------------------------------------------------------------

- :adi:`EVAL-AD9434`

Supported devices
-------------------------------------------------------------------------------

- :adi:`AD9434`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - :adi:`EVAL-AD9434-FMC-500EBZ <EVAL-AD9434>`
     - :xilinx:`ZC706`
     - FMC LPC
   * -
     - :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`
     - FMC LPC

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ad9434_fmc_block_diagram.svg
   :width: 800
   :align: center
   :alt: AD9434-FMC/ZC706/ZED block diagram

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are multiple ways to configure the clock source for :adi:`AD9434`.
In this section is presented a guide on how to rework the board to the desired
user clock circuitry. Below is a table on what components are needed to install
or uninstall on the evaluation board.

==================== ======================================== ================
Clock Configuration  Install                                  Uninstall
==================== ======================================== ================
Ext. Signal Gen.     as it is                                 as it is
Oscillator           R209, P1(shunt)                          ---
LVPECL               R208, R307, R308, C300, C311, C304, C305 C209, C210
LVDS                 R208, C306, C307                         C209, C210, R311
==================== ======================================== ================

For LVPECL and LVDS configurations, appropriate charge pump filter circuit
values are necessary to have an optimized clock buffer performance from
:adi:`AD9517-4`.

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL(see more at :ref:`architecture`).

==================== ===============
Instance             Zynq/Microblaze
==================== ===============
axi_ad9434           0x44A0_0000
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
     - CS
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

These are the board-specific interrupts
(found in :git-hdl:`here <projects/ad9434_fmc/common/ad9434_bd.tcl>`).

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here </>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the project location (**projects/ad9434_fmc/carrier**) and run the
make command by typing in your command prompt (this example is for
:xilinx:`ZC706`):

**Linux/Cygwin/WSL**

.. code-block::

   user@analog:~$ cd hdl/projects/ad9434_fmc/zc706
   user@analog:~/hdl/projects/ad9434_fmc/zc706$ make

A more comprehensive build guide can be found in the :ref:`build_hdl` user
guide.

Resources
-------------------------------------------------------------------------------

Systems related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here you can find the quick start guides available for these evaluation boards:

.. list-table::
   :widths: 20 10
   :header-rows: 1

   * - Evaluation board
     - Zynq-7000
   * - AD9434-FMC
     - :dokuwiki:`ZC706 <resources/fpga/xilinx/fmc/ad9434>`

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheets: :adi:`AD9434`
- :dokuwiki:`EVAL-AD9434 user guide <resources/eval/ad9434fmc-500ebz>`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`AD9434-FMC HDL project source code <projects/ad9434_fmc>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_AD9434
     - :git-hdl:`library/axi_ad9434 <library/axi_ad9434>`
     - ---
   * - AXI_DMAC
     - :git-hdl:`library/axi_dmac <library/axi_dmac>`
     - :ref:`here <axi_dmac>`
   * - AXI_CLKGEN
     - :git-hdl:`library/axi_clkgen <library/axi_clkgen>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_clkgen>`
   * - AXI_HDMI_TX
     - :git-hdl:`library/axi_hdmi_tx <library/axi_hdmi_tx>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_hdmi_tx>`
   * - AXI_SPDIF_TX
     - :git-hdl:`library/axi_spdif_tx <library/axi_spdif_tx>`
     - ---
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid <library/axi_sysid>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom <library/sysid_rom>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-linux:`Linux device tree zynq-zc706-adv7511-ad9434-fmc-500ebz.dts <arch/arm/boot/dts/zynq-zc706-adv7511-ad9434-fmc-500ebz.dts>`
- :git-linux:`Linux driver ad9467.c <drivers/iio/adc/ad9467.c>`
  (used for AD9434-FMC as well)

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

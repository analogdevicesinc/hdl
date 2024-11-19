.. _ad485x_fmc:

AD485x_FMCZ HDL project
================================================================================

Overview
-------------------------------------------------------------------------------

This design is meant to support the AD485x family.
For example, :adi:`EVAL-AD4858` board contains :adi:`AD4858` chip, which is a 20-bit, low
noise 8-channel simultaneous sampling successive approximation register (SAR)
ADC, with buffered differential, wide common range picoamp inputs.

Supported boards
-------------------------------------------------------------------------------

- :adi:`EVAL-AD4858`
- :adi:`EVAL-AD4857`
- :adi:`EVAL-AD4856`
- :adi:`EVAL-AD4855`
- :adi:`EVAL-AD4854`
- :adi:`EVAL-AD4853`
- :adi:`EVAL-AD4852`
- :adi:`EVAL-AD4851`

Supported devices
-------------------------------------------------------------------------------

- :adi:`AD4858`
- :adi:`AD4857`
- :adi:`AD4856`
- :adi:`AD4855`
- :adi:`AD4854`
- :adi:`AD4853`
- :adi:`AD4852`
- :adi:`AD4851`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - :adi:`EVAL-AD4858 <EVAL-AD4858>`
     - :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`
     - FMC LPC
   * - :adi:`EVAL-AD4857 <EVAL-AD4857>`
     - :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`
     - FMC LPC
   * - :adi:`EVAL-AD4856 <EVAL-AD4856>`
     - :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`
     - FMC LPC
   * - :adi:`EVAL-AD4855 <EVAL-AD4855>`
     - :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`
     - FMC LPC
   * - :adi:`EVAL-AD4854 <EVAL-AD4854>`
     - :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`
     - FMC LPC
   * - :adi:`EVAL-AD4853 <EVAL-AD4853>`
     - :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`
     - FMC LPC
   * - :adi:`EVAL-AD4852 <EVAL-AD4852>`
     - :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`
     - FMC LPC
   * - :adi:`EVAL-AD4851 <EVAL-AD4851>`
     - :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`
     - FMC LPC

Block design
-------------------------------------------------------------------------------

AD4858_FMCZ Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ad4858_fmcz_block_diagram.svg
   :width: 800
   :align: center
   :alt: AD4858_FMCZ/ZED block diagram

AD4857_FMCZ Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ad4857_fmcz_block_diagram.svg
   :width: 800
   :align: center
   :alt: AD4857_FMCZ/ZED block diagram

AD4854_FMCZ Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ad4854_fmcz_block_diagram.svg
   :width: 800
   :align: center
   :alt: AD4854_FMCZ/ZED block diagram

AD4851_FMCZ Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ad4851_fmcz_block_diagram.svg
   :width: 800
   :align: center
   :alt: AD4851_FMCZ/ZED block diagram

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Depending on the configuration used (CMOS or LVDS), the scheme differs a
little bit. In the sense that there is an extra clock 'external_fast_clk', see
the details in the diagram below.

For these evaluation boards, we used an internal clock of the FPGA.
Therefore, the external clocks given to AXI_AD485x IP are:

- in LVDS mode:

  - external_clk = 200 MHz
  - external_fast_clk = 400 MHz

- in CMOS mode:

  - external_clk = 100MHz

.. image:: ad485x_fmcz_clock_path.svg
   :width: 800
   :align: center
   :alt: AD4851_FMCZ clock path

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL(see more at :ref:`architecture cpu-intercon-addr`).

============== ===========
Instance       Zynq
============== ===========
axi_ad485x     0x43C0_0000
axi_pwm_gen    0x43D0_0000
ad485x_dma     0x43E0_0000
adc_clkgen     0x4400_0000
============== ===========

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
     - AD485x
     - 0

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

================ === ========== ===========
Instance name    HDL Linux Zynq Actual Zynq
================ === ========== ===========
axi_ad485x_dma   10  54         86
================ === ========== ===========

These are the board-specific interrupts
(found in :git-hdl:`here <projects/ad485x_fmc/common/ad485x_bd.tcl>`).

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI distributes the bit/elf files of these projects as part of the
:dokuwiki:`ADI Kuiper Linux <resources/tools-software/linux-software/kuiper-linux>`.
If you want to build the sources, ADI makes them available on the
:git-hdl:`HDL repository </>`. To get the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the project location (**projects/ad485x_fmc/carrier**) and run the
make command by typing in your command prompt (this example is for
:xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`):

**Linux/Cygwin/WSL**

.. code-block::

   user@analog:~$ cd hdl/projects/ad485x_fmc/zed
   user@analog:~$ make

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
   * - AD485x_FMCZ
     - :dokuwiki:`zed <resources/fpga/xilinx/fmc/ad485x>`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`AD485x_FMCZ HDL project source code <projects/ad485x_fmc>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_AD485x
     - :git-hdl:`library/axi_ad485x <library/axi_ad485x>`
     - ---
   * - AXI_DMAC
     - :git-hdl:`library/axi_dmac <library/axi_dmac>`
     - :ref:`here <axi_dmac>`
   * - AXI_CLKGEN
     - :git-hdl:`library/axi_clkgen <library/axi_clkgen>`
     - :ref:`here <axi_clkgen>`
   * - AXI_PWM_GEN
     - :git-hdl:`library/axi_pwm_gen <library/axi_pwm_gen>`
     - :ref:`here <axi_pwm_gen>`
   * - AXI_HDMI_TX
     - :git-hdl:`library/axi_hdmi_tx <library/axi_hdmi_tx>`
     - :ref:`here <axi_hdmi_tx>`
   * - AXI_SPDIF_TX
     - :git-hdl:`library/axi_spdif_tx <library/axi_spdif_tx>`
     - ---
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid <library/axi_sysid>`
     - :ref:`here <axi_sysid>`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom <library/sysid_rom>`
     - :ref:`here <axi_sysid>`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-linux:`Linux device tree zynq-zed-adv7511-ad4858-fmcz.dts <arch/arm/boot/dts/zynq-zed-adv7511-ad4858-fmcz.dts>`
- :git-linux:`Linux device tree zynq-zed-adv7511-ad4857-fmcz.dts <arch/arm/boot/dts/zynq-zed-adv7511-ad4857-fmcz.dts>`
- :git-linux:`Linux device tree zynq-zed-adv7511-ad4856-fmcz.dts <arch/arm/boot/dts/zynq-zed-adv7511-ad4856-fmcz.dts>`
- :git-linux:`Linux device tree zynq-zed-adv7511-ad4855-fmcz.dts <arch/arm/boot/dts/zynq-zed-adv7511-ad4855-fmcz.dts>`
- :git-linux:`Linux device tree zynq-zed-adv7511-ad4854-fmcz.dts <arch/arm/boot/dts/zynq-zed-adv7511-ad4854-fmcz.dts>`
- :git-linux:`Linux device tree zynq-zed-adv7511-ad4853-fmcz.dts <arch/arm/boot/dts/zynq-zed-adv7511-ad4853-fmcz.dts>`
- :git-linux:`Linux device tree zynq-zed-adv7511-ad4852-fmcz.dts <arch/arm/boot/dts/zynq-zed-adv7511-ad4852-fmcz.dts>`
- :git-linux:`Linux device tree zynq-zed-adv7511-ad4851-fmcz.dts <arch/arm/boot/dts/zynq-zed-adv7511-ad4851-fmcz.dts>`
- :git-linux:`Linux driver ad485x.c <drivers/iio/adc/ad485x.c>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

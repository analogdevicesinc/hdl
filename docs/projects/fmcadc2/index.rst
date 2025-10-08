.. _fmcadc2:

FMCADC2 HDL Project (OBSOLETE)
===============================================================================

.. warning::

   The support for :git-hdl:`FMCADC2 <hdl_2021_r2:projects/fmcadc2>` HDL project
   has been discontinued, the latest release branch where it can be found is
   ``hdl_2021_r2``. This page is left for legacy purposes only.

Overview
-------------------------------------------------------------------------------

The :adi:`AD-FMCADC2-EBZ <EVAL-AD-FMCADC2-EBZ>` is a high-speed data
acquisition (1 ADC channel at 2500 MSPS), in an FMC form factor, which has one
high-speed JESD204B Analog to Digital converter (:adi:`AD9625`) on it.

The :adi:`AD9625` is a 12-bit monolithic sampling ADC that operates at
conversion rates of up to 2.5 GSPS. This product is designed for sampling wide
bandwidth analog signals up to the second Nyquist zone. The combination of wide
input bandwidth, high sampling rate, and excellent linearity of the
:adi:`AD9625` is ideally suited for spectrum analyzers, data acquisition
systems, and a wide assortment of military electronics applications, such as
radar and jamming/antijamming measures.

The card is mechanically (width/depth, but not height) and electrically
compliant to the FMC standard (ANSI/VITA 57.1).

The reference design includes the device data capture via the JESD204B serial
interface and the SPI interface. The samples are written to the external
DDR-DRAM. It allows programming the device and monitoring it's internal
registers via SPI.

Supported boards
-------------------------------------------------------------------------------

- :adi:`AD-FMCADC2-EBZ <EVAL-AD-FMCADC2-EBZ>`

.. note::

   Note for rev. C:

   If you have a revision C board as indicated in etch next to the white
   scratch pad area of the PCB, we recommend writing to the Serial Output
   Adjust Register. If you are using the reference design this is done for you.
   Otherwise, when you configure the AD9625 it is suggested that you increase
   the serial output emphasis by writing to register 0x015 bits 5:4 either
   10 or 11.

Supported devices
-------------------------------------------------------------------------------

- :adi:`AD9625`

Supported carriers
-------------------------------------------------------------------------------

- :xilinx:`VC707` on FMC HPC1
- :xilinx:`ZC706` on FMC HPC

Block design
-------------------------------------------------------------------------------

Clock configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :adi:`AD-FMCADC2-EBZ <EVAL-AD-FMCADC2-EBZ>` provides multiple options for
clocking the :adi:`AD9625`.
The default configuration of the board clocks the ADC using an on-board 2.5 GHz,
low noise, crystal oscillator. This oscillator is then routed through a wide
band transformer producing the differential clock for the ADC.

Alternatively, the oscillator can be disconnected and an external clock source
connected by only changing two components on the board. A single ended clock
connected to the CLK+ input would then be routed through the transformer in
the same way.

Finally, the option exists to connect a differential clock to the board using
both the CLK+ and CLK- inputs. Then referencing the schematic make the
component changes to directly route the differential input bypassing the
transformer.

The :adi:`AD-FMCADC2-EBZ <EVAL-AD-FMCADC2-EBZ>` uses a passive front end
designed for very wide bandwidth.
A single ended input needs to be provided to "Ain". A 500 kHz to 6 GHz broadband
balun then converts the input signal to differential.

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture cpu-intercon-addr`).

==================== ===============
Instance             Zynq/Microblaze
==================== ===============
axi_ad9625_core      0x44A1_0000
axi_ad9625_xcvr      0x44A6_0000
axi_ad9625_jesd      0x44AA_0000
axi_ad9625_dma       0x7C42_0000
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
     - AD9625
     - 0
   * - PS
     - SPI 1
     - ADF4355
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
   * - adc_irq
     - INOUT
     - 33
     - 87
     - 111
   * - adc_fd
     - INOUT
     - 32
     - 86
     - 110

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

================ === ========== =========== ============ ============= ====== =============== ================
Instance name    HDL Linux Zynq Actual Zynq Linux ZynqMP Actual ZynqMP S10SoC Linux Cyclone V Actual Cyclone V
================ === ========== =========== ============ ============= ====== =============== ================
axi_ad9625_dma   13  57         89          109          141           30     53              85
axi_ad9625_jesd  12  56         88          108          140           29     52              84
================ === ========== =========== ============ ============= ====== =============== ================

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI distributed the bit/elf files of this project as part of the
:dokuwiki:`ADI Kuiper Linux <resources/tools-software/linux-software/kuiper-linux>`
until the 2021_R2 release. The prebuilt files can be found in the previous link.
Afterwards, it was discontinued.

But, if you want to build the sources, ADI makes them available on the
:git-hdl:`HDL repository </>`. To get the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository and checkout the last release branch where this project
still exists, ``hdl_2021_r2``.

Then go to the hdl/projects/fmcadc5/$carrier location and run the make
command.

**Linux/Cygwin/WSL**

.. shell::

   /hdl
   $git checkout hdl_2021_r2
   $cd projects/fmcadc2/zc706
   $make

Resources
-------------------------------------------------------------------------------

Systems related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :dokuwiki:`AD-FMCADC2 Microblaze Quick start guide <resources/eval/user-guides/ad-fmcadc2-ebz/quickstart/microblaze>`

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheet: :adi:`AD9625`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-hdl:`FMCADC2 HDL project source code <hdl_2021_r2:projects/fmcadc2>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_DMAC
     - :git-hdl:`hdl_2021_r2:library/axi_dmac`
     - :ref:`axi_dmac`
   * - AXI_CLKGEN
     - :git-hdl:`hdl_2021_r2:library/axi_clkgen`
     - :ref:`axi_clkgen`
   * - AXI_HDMI_TX
     - :git-hdl:`hdl_2021_r2:library/axi_hdmi_tx`
     - :ref:`axi_hdmi_tx`
   * - AXI_HDMI_RX
     - :git-hdl:`hdl_2021_r2:library/axi_hdmi_rx`
     - :ref:`axi_hdmi_rx`
   * - AXI_ADCFIFO
     - :git-hdl:`hdl_2021_r2:library/axi_adcfifo`
     - ---
   * - AXI_SYSID
     - :git-hdl:`hdl_2021_r2:library/axi_sysid`
     - :ref:`axi_sysid`
   * - SYSID_ROM
     - :git-hdl:`hdl_2021_r2:library/sysid_rom`
     - :ref:`axi_sysid`
   * - UTIL_ADXCVR for AMD
     - :git-hdl:`hdl_2021_r2:library/xilinx/util_adxcvr`
     - :ref:`util_adxcvr`
   * - AXI_ADXCVR for AMD
     - :git-hdl:`hdl_2021_r2:library/xilinx/axi_adxcvr`
     - :ref:`axi_adxcvr amd`
   * - AXI_JESD204_RX
     - :git-hdl:`hdl_2021_r2:library/jesd204/axi_jesd204_rx`
     - :ref:`axi_jesd204_rx`
   * - JESD204_TPL_ADC
     - :git-hdl:`hdl_2021_r2:library/jesd204/ad_ip_jesd204_tpl_adc`
     - :ref:`ad_ip_jesd204_tpl_adc`

- :dokuwiki:`[Wiki] Generic JESD204B block designs <resources/fpga/docs/hdl/generic_jesd_bds>`
- :ref:`jesd204`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-linux:`FMCADC2/VC707 Linux device tree <2021_R2:arch/microblaze/boot/dts/vc707_fmcadc2.dts>`
- :git-linux:`FMCADC2/ZC706 Linux device tree <2021_R2:arch/arm/boot/dts/xilinx/zynq-zc706-adv7511-ad9625-fmcadc2.dts>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

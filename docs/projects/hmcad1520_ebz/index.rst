.. _hmcad1520_ebz:

HMCAD1520-FMC-EVB HDL project
================================================================================

Overview
-------------------------------------------------------------------------------
The :adi:`HMCAD1520-EBZ` HDL design supports the following
:adi:`HMCAD1520` features:

* Single/Dual/Quad Channel modes
* 8/12/14 bit resolution configurations
* Sampling rates between 105 - 1000 MSPS

The :adi:`HMCAD1520-EBZ` evaluation board was designed for
use with the Digilent ZedBoard via the field programmable gate array(FPGA)
mezzanine card (FMC) connector.

Supported boards
-------------------------------------------------------------------------------

- :adi:`HMCAD1511-EBZ`
- :adi:`HMCAD1520-EBZ`

Supported devices
-------------------------------------------------------------------------------

- :adi:`HMCAD1511`
- :adi:`HMCAD1520`
- :adi:`ADN4661`
- :adi:`ADM7154`
- :adi:`MAX3013`
- :adi:`LTC6419`
- :adi:`LTM8078`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - :adi:`HMCAD1511-EBZ`
     - `ZedBoard <https://digilent.com/shop/zedboard-zynq-7000-arm-fpga-soc-development-board>`__
     - FMC-LPC
   * - :adi:`HMCAD1520-EBZ`
     - `ZedBoard <https://digilent.com/shop/zedboard-zynq-7000-arm-fpga-soc-development-board>`__
     - FMC-LPC

Block design
-------------------------------------------------------------------------------

.. warning::
    The VADJ for the Zedboard must be set to 2.5V.

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagram:

.. image:: ../hmcad1520_ebz/hmcad1520_ebz_zed_block_diagram.svg
   :width: 800
   :align: center
   :alt: HMCAD1520_EBZ/ZedBoard block diagram

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ../hmcad1520_ebz/hmcad1520_ebz_clock_scheme.svg
   :width: 800
   :align: center
   :alt: HMCAD1520_EBZ/ZedBoard clock scheme

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture cpu-intercon-addr`).

==================== ===============
Instance             Zynq/Microblaze
==================== ===============
axi_hmcad1520_adc      0x44A00000
hmcad1520_dma          0x44A30000
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
     - HMCAD1520
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
   * - fmc_rstn
     - INOUT
     - 33
     - 88
     - 112
   * - fmc_pd
     - INOUT
     - 32
     - 87
     - 111

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

================ === ========== ===========
Instance name    HDL Linux Zynq Actual Zynq
================ === ========== ===========
hmcad1520_dma    13  57         89
================ === ========== ===========

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI distributes the bit/elf files of these projects as part of the
:dokuwiki:`ADI Kuiper Linux <resources/tools-software/linux-software/kuiper-linux>`.
If you want to build the sources, ADI makes them available on the
:git-hdl:`HDL repository </>`. To get the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository, and then build the project as follows:

**Linux/Cygwin/WSL**

Example of building the project with ``make``

.. shell::

   $cd hdl/projects/hmcad1520/zed
   $make


A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Resources
-------------------------------------------------------------------------------

Systems related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- `EVAL01-HMCAD15xx User Guide <https://wiki.analog.com/_media/resources/eval/eval01-hmcad15xx_user_guide_analog_devices_wiki_.pdf>`__

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheets:

  - :adi:`HMCAD1511`
  - :adi:`HMCAD1520`
  - :adi:`ADN4661`
  - :adi:`ADM7154`
  - :adi:`MAX3013`
  - :adi:`LTC6419`
  - :adi:`LTM8078`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-hdl:`HMCAD1520_EBZ HDL project source code <projects/hmcad1520_ebz>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_HMCAD15XX
     - :git-hdl:`library/axi_hmcad15xx`
     - :ref:`axi_hmcad15xx`
   * - AXI_CLKGEN
     - :git-hdl:`library/axi_clkgen`
     - :ref:`axi_clkgen`
   * - AXI_DMAC
     - :git-hdl:`library/axi_dmac`
     - :ref:`axi_dmac`
   * - AXI_HDMI_TX
     - :git-hdl:`library/axi_hdmi_tx`
     - :ref:`axi_hdmi_tx`
   * - AXI_I2S_ADI
     - :git-hdl:`library/axi_i2s_adi`
     - ---
   * - AXI_SPDIF_TX
     - :git-hdl:`library/axi_spdif_tx`
     - ---
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid`
     - ---
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom`
     - :ref:`axi_sysid`
   * - UTIL_I2C_MIXER
     - :git-hdl:`library/util_i2c_mixer`
     - ---
   * - UTIL_CPACK2
     - :git-hdl:`library/util_pack/util_cpack2`
     - ---

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

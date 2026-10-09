.. _ad559xr:

AD559XR HDL project
================================================================================

Overview
-------------------------------------------------------------------------------

The :adi:`AD5596R` and :adi:`AD5597R` are 8-channel, 12-bit combined ADC/DAC
devices with an on-chip 2.5 V reference. They are designed for applications
requiring both analog-to-digital conversion and digital-to-analog conversion on
a single chip.

Key features:

- 8 channels configurable as ADC inputs or DAC outputs
- 12-bit resolution
- On-chip 2.5 V reference
- Single 2.7 V to 5.5 V supply
- :adi:`AD5596R` — SPI interface (up to 50 MHz)
- :adi:`AD5597R` — I2C interface (400 kHz Fast Mode, 3.4 MHz High Speed Mode)

This HDL project uses the Processing System's native SPI peripheral (for the
AD5596R variant) or a dedicated AXI IIC controller (for the AD5597R variant)
connected through the PMOD JA connector of the Cora Z7-07S board.

Supported boards
-------------------------------------------------------------------------------

- :adi:`EVAL-AD5596R`
- :adi:`EVAL-AD5597R`

Supported devices
-------------------------------------------------------------------------------

- :adi:`AD5596R`
- :adi:`AD5597R`

Supported carriers
-------------------------------------------------------------------------------

- `Cora Z7-07S <https://digilent.com/shop/cora-z7-zynq-7000-single-core-for-arm-fpga-soc-development>`__
  (XC7Z007S) on PMOD JA

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The design supports two configurations selected at build time via the ``INTF``
parameter:

- **SPI** (default) — targets the :adi:`AD5596R`, routes PS7 SPI0 signals to
  PMOD JA
- **I2C** — targets the :adi:`AD5597R`, instantiates a dedicated AXI IIC
  controller and routes its signals to PMOD JA

..
  TODO: Add block diagram SVG for both SPI and I2C configurations.
  File to create: docs/projects/ad559xr/ad559xr_coraz7s_hdl.svg
  Use Inkscape, starting from a similar project (e.g. ad5529_coraz7s_hdl.svg).
  The diagram should show:
    SPI config: PS7 (SPI0 + GPIO) -> PMOD JA -> AD5596R; AXI SYSID
    I2C config: PS7 (GPIO) + AXI IIC -> PMOD JA -> AD5597R; AXI SYSID
  Once the SVG is ready, replace this comment with:
  .. image:: ad559xr_coraz7s_hdl.svg
     :width: 800
     :align: center
     :alt: AD559XR/CoraZ7S HDL block diagram

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture cpu-intercon-addr`).

**SPI configuration**

==============================  ===========
Instance                        Zynq
==============================  ===========
axi_sysid_0                     0x4500_0000
==============================  ===========

**I2C configuration**

==============================  ===========
Instance                        Zynq
==============================  ===========
axi_iic_ad559xr                 0x4162_0000
axi_sysid_0                     0x4500_0000
==============================  ===========

SPI connections
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Applies to the **SPI** (AD5596R) configuration only. The PS7 SPI0 peripheral
is used.

.. list-table::
   :widths: 25 25 25 25
   :header-rows: 1

   * - SPI type
     - SPI manager instance
     - SPI subordinate
     - CS
   * - PS (SPI0)
     - sys_ps7
     - AD5596R
     - 0

PMOD JA pin mapping
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**SPI configuration (AD5596R)**

============== ================ ========================= ================
Signal         FPGA pin         PMOD JA position          IOSTANDARD
============== ================ ========================= ================
spi_csn        Y18              JA_P[1]                   LVCMOS33
spi_mosi       Y19              JA_N[1]                   LVCMOS33
spi_miso       Y16              JA_P[2]                   LVCMOS33
spi_sclk       Y17              JA_N[2]                   LVCMOS33
resetb         U18              JA_P[3]                   LVCMOS33
============== ================ ========================= ================

**I2C configuration (AD5597R)**

============== ================ ========================= ================
Signal         FPGA pin         PMOD JA position          IOSTANDARD
============== ================ ========================= ================
iic_scl        Y18              JA_P[1]                   LVCMOS33
iic_sda        Y16              JA_P[2]                   LVCMOS33
resetb         U18              JA_P[3]                   LVCMOS33
============== ================ ========================= ================

GPIOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Software GPIO number is calculated as follows:

- Zynq-7000: if PS7 is used, then offset is 54

.. list-table::
   :widths: 25 25 25 25
   :header-rows: 2

   * - GPIO signal
     - Direction
     - HDL GPIO EMIO
     - Software GPIO
   * -
     - (from FPGA view)
     -
     - Zynq-7000
   * - resetb
     - OUT
     - 32
     - 86

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

..
  IRQ assignments defined in: projects/ad559xr/coraz7s/system_bd.tcl
  IRQ_F2P mode (REVERSE) set in: projects/common/coraz7s/coraz7s_system_bd.tcl

**SPI configuration** — no PL interrupts (SPI is handled by the PS7 peripheral).

**I2C configuration**

====================== === ========== ===========
Instance name          HDL Linux Zynq Actual Zynq
====================== === ========== ===========
axi_iic_ad559xr        10  54         86
====================== === ========== ===========

.. warning::
  IRQ_F2P mode is REVERSE (bit 15 = highest priority).

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

.. shell::

   $cd hdl/projects/ad559xr/coraz7s
   $make

The ``INTF`` parameter selects the communication interface and the target
device:

.. list-table::
   :widths: 20 20 60
   :header-rows: 1

   * - Parameter
     - Values
     - Description
   * - INTF
     - SPI (default)
     - SPI interface, targets AD5596R
   * - INTF
     - I2C
     - I2C interface, targets AD5597R

Example:

.. shell::

   $cd hdl/projects/ad559xr/coraz7s
   $make INTF=I2C

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Resources
-------------------------------------------------------------------------------

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheets:

  - :adi:`AD5596R`
  - :adi:`AD5597R`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-hdl:`AD559XR HDL project source code <projects/ad559xr>`

.. list-table::
   :widths: 30 40 30
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_IIC
     - Xilinx IP
     - `PG090 <https://www.xilinx.com/support/documentation/ip_documentation/axi_iic/v2_0/pg090-axi-iic.pdf>`__
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid`
     - :ref:`axi_sysid`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom`
     - :ref:`axi_sysid`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst
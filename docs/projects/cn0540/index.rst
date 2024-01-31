.. _cn0540:

CN0540 HDL project
================================================================================

Overview
--------------------------------------------------------------------------------

The HDL reference design for the :adi:`CN0540` provides a high resolution,
wide-bandwidth, high dynamic range, Integrated Electronics Piezoelectric (IEPE)
compatible interface data acquisition system (DAQ) for interfacing with
Integrated Circuit Piezo (ICP)/IEPE piezo vibration sensors. Most solutions
which interface with piezo sensors in the market are AC coupled, lacking DC and
sub-hertz measurement capability. This reference design is a DC coupled solution
in which DC and sub-hertz precision are achieved. By looking at the complete
data set from the vibration sensor in the frequency domain (DC - 50 kHz), the
type and source of a machine fault can be better predicted using the; position,
amplitude and number of harmonics found in the FFT spectrum.

The data acquisition board incorporates a precision 24-bit, 1024kSPS Sigma-delta
ADC :adi:`AD7768-1` and a 16-bit voltage output DAC :adi:`LTC2606`. Used as the
ADC driver is a high linearity FDA :adi:`ADA4945-1` and a 200mA programmable
2-terminal current source :adi:`LT3092`. Analog input protection is provided by
the switch :adi:`ADG5421F`.

This project has a SPI Engine instance to control and acquire data from the
:adi:`AD7768-1` 24-bit precision ADC. This instance provides support for
capturing continuous samples at the maximum sample rate.

Supported boards
-------------------------------------------------------------------------------

-  :adi:`EVAL-CN0540-ARDZ <CN0540>`

Supported devices
-------------------------------------------------------------------------------

-  :adi:`AD7768-1`
-  :adi:`ADA4945-1`
-  :adi:`LT3092`
-  :adi:`LTC2606`

Supported carriers
-------------------------------------------------------------------------------

-  :xilinx:`Cora Z7-07S <products/boards-and-kits/1-1qlaz7n.html>` Arduino shield connector
-  :intel:`De10-Nano <content/www/us/en/developer/topic-technology/edge-5g/hardware/fpga-de10-nano.html>` Arduino shield connector

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagram:

.. image:: cn0540_hdl.svg
   :width: 800
   :align: center
   :alt: CN0540_ARDZ block diagram

Jumper setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

================== ================= ==========================================
Jumper/Solder link Default Position  Description
================== ================= ==========================================
P10                Inserted          Connects the power source to the circuit
                                     and may be removed for testing without a
                                     power source
================== ================= ==========================================

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture`).

========================  ===========
Instance                  Address
========================  ===========
spi_cn0540_axi_regmap*    0x44A0_0000
axi_cn0540_dma*           0x44A3_0000
axi_iic_cn0540*           0x44A4_0000
xadc_in*                  0x44A5_0000
spi_clkgen*               0x44A7_0000
axi_dmac_0**              0x0002_0000
axi_spi_engine_0**        0x0003_0000
========================  ===========

.. admonition:: Legend
   :class: note

   -   ``*`` instantiated only for Cora Z7S
   -   ``**`` instantiated only for De10-Nano

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
     - axi_iic
     - axi_iic_cn0540
     - 0x44A4_0000
     - ---
   * - PS
     - i2c1
     - sys_hps_i2c1
     - ---
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
   * - PL
     - axi_spi_engine
     - cn0540
     - 0

GPIOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Software GPIO number is calculated as follows:

-  Cora Z7S: the offset is 54

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
   * - cn0540_shutdown
     - INOUT
     - 40
     - 94
   * - cn0540_reset_adc
     - INOUT
     - 39
     - 93
   * - cn0540_csb_aux
     - INOUT
     - 38
     - 92
   * - cn0540_sw_ff
     - INOUT
     - 37
     - 91
   * - cn0540_drdy_aux
     - INOUT
     - 36
     - 90
   * - cn0540_blue_led
     - INOUT
     - 35
     - 89
   * - cn0540_yellow_led
     - INOUT
     - 34
     - 88
   * - cn0540_sync_in
     - INOUT
     - 33
     - 87
   * - cn0540_drdy
     - INOUT
     - 32
     - 86

-  De10-Nano: the offset is 32

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
     - De10-Nano
   * - ltc2308_cs
     - OUT
     - 41
     - 9
   * - cn0540_blue_led
     - OUT
     - 40
     - 8
   * - cn0540_yellow_led
     - OUT
     - 39
     - 7
   * - cn0540_sw_ff
     - IN
     - 38
     - 6
   * - cn0540_shutdown
     - OUT
     - 36
     - 4
   * - cn0540_drdy_aux
     - OUT
     - 35
     - 3
   * - cn0540_csb_aux
     - OUT
     - 34
     - 2
   * - cn0540_sync_in
     - OUT
     - 33
     - 1
   * - cn0540_reset_adc
     - OUT
     - 32
     - 0

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

=================== === ========== ===========
Instance name       HDL Linux Zynq Actual Zynq
=================== === ========== ===========
axi_cn0540_dma      13  57         89
axi_iic_cn0540      12  56         88
spi_cn0540          11  55         87
=================== === ========== ===========

================ === =============== ================
Instance name    HDL Linux De10-Nano Actual De10-Nano
================ === =============== ================
axi_spi_engine_0 5   45               77
axi_dmac_0       4   44               76
================ === =============== ================

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here </>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository, and then build the project as follows:

**Linux/Cygwin/WSL**

.. code-block::
   :linenos:

   user@analog:~$ cd hdl/projects/cn0540/coraz7s
   user@analog:~/hdl/projects/cn0540/coraz7s$ make

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Resources
-------------------------------------------------------------------------------

Systems related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here you can find the quick start guides available for these evaluation boards:

- :dokuwiki:`[Wiki] CN0540 with Cora Z7S quick start guide <resources/eval/user-guides/circuits-from-the-lab/cn0540/coraz7s>`
- :dokuwiki:`[Wiki] CN0540 with DE10-Nano quick start quide <resources/eval/user-guides/circuits-from-the-lab/cn0540/de10-nano>`

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheets:

  - :adi:`CN0540`
  - :adi:`AD7768-1`
  - :adi:`ADA4945-1`
  - :adi:`LT3092`
  - :adi:`LTC2606`
- :dokuwiki:`Evaluation Board User Guide <resources/eval/user-guides/circuits-from-the-lab/cn0540>`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`CN0540_ARDZ HDL project source code <projects/cn0540>`
-  :dokuwiki:`[Wiki] CN0540 HDL project documentation <resources/eval/user-guides/circuits-from-the-lab/cn0540/hdl>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_CLKGEN
     - :git-hdl:`library/axi_dmac <library/axi_clkgen>` *
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_clkgen>`
   * - AXI_DMAC
     - :git-hdl:`library/axi_dmac <library/axi_dmac>`
     - :ref:`here <axi_dmac>`
   * - AXI_HDMI_TX
     - :git-hdl:`library/axi_hdmi_tx <library/axi_hdmi_tx>` **
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_hdmi_tx>`
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid <library/axi_sysid>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`
   * - AXI_SPI_ENGINE
     - :git-hdl:`library/spi_engine/axi_spi_engine <library/spi_engine/axi_spi_engine>`
     - :ref:`here <spi_engine axi>`
   * - SPI_ENGINE_EXECUTION
     - :git-hdl:`library/spi_engine/spi_engine_execution <library/spi_engine/spi_engine_execution>`
     - :ref:`here <spi_engine execution>`
   * - SPI_ENGINE_INTERCONNECT
     - :git-hdl:`library/spi_engine/spi_engine_interconnect <library/spi_engine/spi_engine_interconnect>`
     - :ref:`here <spi_engine interconnect>`
   * - SPI_ENGINE_OFFLOAD
     - :git-hdl:`library/spi_engine/spi_engine_offload`
     - :ref:`here <spi_engine offload>`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom <library/sysid_rom>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`

.. admonition:: Legend
   :class: note

   -   ``*`` instantiated only for Cora Z7S
   -   ``**`` instantiated only for De10-Nano

-  :ref:`SPI Engine Framework documentation <spi_engine>`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-linux:`CN0540 Linux driver source code <analogdevicesinc/linux/blob/main/drivers/iio/adc/ad7768-1.c>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

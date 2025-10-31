.. _ad7606x_fmc:

AD7606X-FMCZ HDL project
===============================================================================

Overview
-------------------------------------------------------------------------------

The :adi:`AD7606` is a 8-/6-/4-Channel DAS with 16-Bit, Bipolar Input,
Simultaneous Sampling ADC. Each part contains analog input clamp protection, a
second-order antialiasing filter, a track-and-hold amplifier, a 16-bit charge
redistribution successive approximation analog-to-digital converter (ADC), a
flexible digital filter, a 2.5 V reference and reference buffer, and high speed
serial and parallel interfaces. The :adi:`AD7606` operate from a single 5 V
supply and can accommodate ±10 V and ±5 V true bipolar input signals while
sampling at throughput rates up to 200 kSPS for all channels. The input clamp
protection circuitry can tolerate voltages up to ±16.5 V. The AD7606 has 1 MΩ
analog input impedance regardless of sampling frequency. The single supply
operation, on-chip filtering, and high input impedance eliminate the need for
driver op amps and external bipolar supplies.

The :adi:`AD7606C` is a directly pin replacement (software and hardware) for
both AD7608 and AD7609, with higher input impedance, throughput rate and
extended temperature range with additional features such as 16/18-bit sample
size, system gain/offset/phase calibration, sensor disconnect detection,
lower Vdrive operation, diagnostics, additional oversampling ratios and per
channel analog input range selection with bipolar differential, bipolar
single-ended and unipolar single-ended options.

The :adi:`EVAL-AD7606B-FMCZ` and :adi:`EVAL-AD7606C-18` evaluation boards
are designed to help users to easily evaluate the features of :adi:`AD7606B`,
:adi:`AD7606C-16` and :adi:`AD7606C-18` analog-to-digital converters (ADCs).

Supported boards
-------------------------------------------------------------------------------

- :adi:`EVAL-AD7606B`
- :adi:`EVAL-AD7606C-16`
- :adi:`EVAL-AD7606C-18`
- :adi:`EVAL-AD7605-4`
- :adi:`EVAL-AD7606-8`
- :adi:`EVAL-AD7606-6`
- :adi:`EVAL-AD7606-4`
- :adi:`EVAL-AD7607`
- :adi:`EVAL-AD7608`
- :adi:`EVAL-AD7609`

Supported devices
-------------------------------------------------------------------------------

- :adi:`AD7606B`
- :adi:`AD7606C-16`
- :adi:`AD7606C-18`
- :adi:`AD7606`
- :adi:`AD7606-6`
- :adi:`AD7606-4`
- :adi:`AD7607`
- :adi:`AD7608`
- :adi:`AD7609`
- :adi:`ADP7118`
- :adi:`ADR4525`

Supported carriers
-------------------------------------------------------------------------------

- `ZedBoard <https://digilent.com/shop/zedboard-zynq-7000-arm-fpga-soc-development-board>`__ on FMC slot

Block design
-------------------------------------------------------------------------------

The data path of the HDL design is simple as follows:

- the parallel interface is controlled by the
  :ref:`axi_ad7606x IP core <axi_ad7606x>`
- the serial interface is controlled by the :ref:`SPI_Engine <spi_engine>`
  Framework
- data is written into memory by a DMA (:ref:`axi_dmac core <axi_dmac>`)
- all the control pins of the device are driven by GPIOs

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagrams:

AD7606x_FMCZ serial interface
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: ad7606x_serial_hdl.svg
   :width: 800
   :align: center
   :alt: AD7606X_FMC using the serial interface block diagram

AD7606x_FMCZ parallel interface
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: ad7606x_parallel_hdl.svg
   :width: 800
   :align: center
   :alt: AD7606X_FMC using the parallel interface block diagram

Configuration modes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The INTF configuration parameter defines the interface type (Serial or Parallel).
By default it is set to 0. Depending on the required interface mode, some
hardware modifications need to be done on the board and/or ``make`` command:

In case of the **PARALLEL** interface:

.. shell:: bash

   $make INTF=0

In case of the **SERIAL** interface:

.. shell:: bash

   $make INTF=1

.. note::

   This switch is a **hardware** switch. Please rebuild the design if the
   variable has been changed.

   - JP5 - Position A - Serial interface
   - JP5 - Position B - Parallel interface

The NUM_OF_SDI configuration parameter defines the number of SDI lines used:
**{1, 2, 4, 8}**. By default is set to 8.

The ADC_N_BITS configuration parameter specifies the ADC resolution:
**{16, 18}**. By default it is set to 16.

Jumper setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

================== ================ =============================================
Jumper/Solder link Default Position Description
================== ================ =============================================
JP1                A                The STBY pin is tied to VDRIVE
JP2                A                12V supply from the carrier
JP3                A                3.3V supply from the ADP7118
JP4                A                ±10V range is selected
JP5                A                Serial interface
JP6                B                The internal reference is disabled, and
                                    the external reference is selected.
                                    P5 must be inserted if using the on-board
                                    U1 device
JP7                B                Connects the V1- line to the J5 SMB connector
JP8,JP10           A                Bypasses the amplifier mezzanine card
JP9,JP11           A                Bypasses the amplifier mezzanine card
JP12               B                Connects the V2- line to the J6 SMB connector
JP13               B                Connects the V3- line to the J7 SMB connector
JP14               B                Connects the V4- line to the J8 SMB connector
P13                Inserted         Connects the V5- line to ground
P14                Inserted         Connects the V8- line to ground
P15                Inserted         Connects the V6- line to ground
P16                Inserted         Connects the V7- line to ground
S1                 On               Controls the OS0, OS1, and OS2 pins
================== ================ =============================================

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture cpu-intercon-addr`).

========================  ===========
Instance                  Zynq
========================  ===========
axi_ad7606x_dma           0x44A3_0000
spi_clkgen                0x44A7_0000
ad7606_pwm_gen            0x44B0_0000
spi_ad7616_axi_regmap **  0x44A0_0000
axi_ad7606x *             0x44A0_0000
========================  ===========

.. admonition:: Legend
   :class: note

   - ``*`` instantiated only for INTF=0 (parallel interface)
   - ``**`` instantiated only for INTF=1 (serial interface)

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
   * - PL
     - axi_spi_engine
     - AD7606
     - 0

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
   * - adc_serpar
     - OUT
     - 39
     - 93
   * - adc_refsel *
     - OUT
     - 38
     - 92
   * - adc_first_data **
     - IN
     - 38
     - 92
   * - adc_reset
     - OUT
     - 37
     - 91
   * - adc_stby
     - OUT
     - 36
     - 90
   * - adc_range
     - OUT
     - 35
     - 89
   * - adc_os
     - OUT
     - 34-32
     - 88-86

.. admonition:: Legend
   :class: note

   - ``*`` instantiated only for INTF=0 (parallel interface)
   - ``**`` instantiated only for INTF=1 (serial interface)

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

=============== === ========== ===========
Instance name   HDL Linux Zynq Actual Zynq
=============== === ========== ===========
axi_ad7606_dma  13  57         89
spi_ad7606 **   12  56         88
=============== === ========== ===========

.. admonition:: Legend
   :class: note

   - ``**`` instantiated only for INTF=1 (serial interface)

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI distributes the bit/elf files of these projects as part of the
:dokuwiki:`ADI Kuiper Linux <resources/tools-software/linux-software/kuiper-linux>`.
If you want to build the sources, ADI makes them available on the
:git-hdl:`HDL repository </>`. To get the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository, and then build the project as follows:.

**Linux/Cygwin/WSL**

.. shell::

   $cd hdl/projects/ad7606x_fmc/zed
   $make INTF=0 ADC_N_BITS=16

The result of the build, if parameters were used, will be in a folder named
by the configuration used:

if the following command was run

``make INTF=0 ADC_N_BITS=16``

then the folder name will be:

``INTF0_ADC_N_BITS16``

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Connections and hardware changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. warning::

   **The following hardware changes are required:**

   Depending on the required interface mode, some hardware modifications need to
   be done.

   - **JP5** - A - Serial interface
   - **JP5** - B - Parallel interface
   - **JP7, JP12, JP13, JP14** - B - Differential operation

Resources
-------------------------------------------------------------------------------

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheets:

  - :adi:`AD7606`
  - :adi:`AD7606B`
  - :adi:`AD7606C-16`
  - :adi:`AD7606C-18`
  - :adi:`AD7605-4`
  - :adi:`AD7606`
  - :adi:`AD7606-6`
  - :adi:`AD7606-4`
  - :adi:`AD7607`
  - :adi:`AD7608`
  - :adi:`AD7609`
  - :adi:`ADP7118`
  - :adi:`ADR4525`
  - :adi:`UG-1870, Evaluation Board User Guide <media/en/technical-documentation/user-guides/eval-ad7606c-fmcz-ug-1870.pdf>`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-hdl:`AD7606X_FMC HDL project source code <projects/ad7606x_fmc>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - SYNC_BITS
     - :git-hdl:`library/util_cdc/sync_bits.v <library/util_cdc/sync_bits.v>` **
     - ---
   * - AD_EDGE_DETECT
     - :git-hdl:`library/common/ad_edge_detect.v`
     - ---
   * - AXI_AD7606x
     - :git-hdl:`library/axi_ad7606x` *
     - :ref:`axi_ad7606x`
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
   * - AXI_PWM_GEN
     - :git-hdl:`library/axi_pwm_gen`
     - :ref:`axi_pwm_gen`
   * - AXI_SPDIF_TX
     - :git-hdl:`library/axi_spdif_tx`
     - ---
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid`
     - :ref:`axi_sysid`
   * - AXI_SPI_ENGINE
     - :git-hdl:`library/spi_engine/axi_spi_engine`  **
     - :ref:`spi_engine axi`
   * - SPI_ENGINE_EXECUTION
     - :git-hdl:`library/spi_engine/spi_engine_execution` **
     - :ref:`spi_engine execution`
   * - SPI_ENGINE_INTERCONNECT
     - :git-hdl:`library/spi_engine/spi_engine_interconnect` **
     - :ref:`spi_engine interconnect`
   * - SPI_ENGINE_OFFLOAD
     - :git-hdl:`library/spi_engine/spi_engine_offload` **
     - :ref:`spi_engine offload`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom`
     - :ref:`axi_sysid`
   * - UTIL_I2C_MIXER
     - :git-hdl:`library/util_i2c_mixer`
     - ---
   * - UTIL_CPACK2
     - :git-hdl:`library/util_pack/util_cpack2 <library/util_pack/util_cpack2>` *
     - :ref:`util_cpack2`

.. admonition:: Legend
   :class: note

   - ``*`` instantiated only for INTF=0 (parallel interface)
   - ``**`` instantiated only for INTF=1 (serial interface)

- :ref:`SPI Engine Framework documentation <spi_engine>`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-no-os:`AD7606_FMC No-OS driver source code <drivers/adc/ad7606>`
- :dokuwiki:`AD7606 - No-OS Driver [Wiki] <resources/tools-software/uc-drivers/ad7606>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

.. _pulsar_lvds_adc:

PULSAR-LVDS-ADC HDL project
==================================================================================

Overview
----------------------------------------------------------------------------------

The :adi:`AD7625`, :adi:`AD7626`, :adi:`AD7960`, :adi:`AD7961` devices are parts
from ADC LVDS PulSAR family.
The :adi:`AD7625` / :adi:`AD7626` is a 16-bit, 6 MSPS / 10 MSPS, charge
redistribution successive approximation register (SAR) architecture,
analog to-digital converter (ADC). SAR architecture allows unmatched performance
both in noise (92dB SNR) and in linearity (±1 LSB INL / ±0.45 LSB INL). The
AD7626 contains a high speed 16-bit sampling ADC, an internal conversion clock,
and an internal buffered reference. On the CNV edge, it samples the voltage
difference between IN+ and IN- pins. The voltages on these pins swing in opposite
phase between 0 V and REF.

The 4.096V reference voltage, REF, can be generated internally or applied
externally. All converted results are available on a single LVDS self-clocked or
echoed-clock serial interface reducing external hardware connections. The
:adi:`AD7625` / :adi:`AD7626` is available in a 32-lead LFCSP (5mm by 5mm) with
operation specified from -40°C to +85°C.

The :adi:`AD7960` / :adi:`AD7961` is an 18-bit/16-bit, 5 MSPS, charge
redistribution successive approximation (SAR), analog-to-digital converter (ADC).
The SAR architecture allows unmatched performance both in noise and in linearity.
The :adi:`AD7960` / :adi:`AD7961` contains a low power, high speed, 18-bit/16-bit
sampling ADC, an internal conversion clock, and an internal reference buffer.

On the CNV± edge, the :adi:`AD7960` / :adi:`AD7961` samples the voltage
difference between the IN+ and IN− pins. The voltages on these pins swing in
opposite phase between 0 V and 4.096 V and between 0 V and 5 V. The reference
voltage is applied to the part externally. All conversion results are available
on a single LVDS self clocked or echoed clock serial interface. The AD7960 is
available in a 32-lead LFCSP (QFN) with operation specified from −40°C to +85°C.

Applications:

* Digital imaging systems
* High speed data acquisition
* High dynamic range telecommunications receivers
* Spectrum analysis
* Test equipment

Supported boards
-------------------------------------------------------------------------------

- :adi:`EVAL-AD7625`
- :adi:`EVAL-AD7626`
- :adi:`EVAL-AD7960`
- :adi:`EVAL-AD7961`

Supported devices
-------------------------------------------------------------------------------

- :adi:`AD7625`
- :adi:`AD7626`
- :adi:`AD7960`
- :adi:`AD7961`
- :adi:`ADR3412`
- :adi:`ADR4520`
- :adi:`AD74540`
- :adi:`AD4550`
- :adi:`AD8031`
- :adi:`ADA4899-1`
- :adi:`ADA4897-1`
- :adi:`ADP7102`
- :adi:`ADP7104`
- :adi:`ADP124`
- :adi:`ADP2300`

Supported carriers
-------------------------------------------------------------------------------

- `ZedBoard <https://digilent.com/shop/zedboard-zynq-7000-arm-fpga-soc-development-board>`__ on FMC slot

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagram:

.. image:: pulsar_lvds_adc_block_diagram.svg
   :width: 800
   :align: center
   :alt: PulSAR LVDS ADC block diagram

Configuration modes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The RESOLUTION_16_18N configuration parameter defines the resolution of the ADC
(16 or 18  bits). By default it is set to 0. Depending of the project, some
hardware modifications need to be done on the board and/or make command:

In case of the **AD7960** project:

.. shell:: bash

   $make RESOLUTION_16_18N=0

In case of the **AD7625/AD7626/AD7961** project:

.. shell:: bash

   $make RESOLUTION_16_18N=1

Jumper setup AD7625/AD7626
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

================== ================= ===========================================
Jumper/Solder link Default Position  Description
================== ================= ===========================================
LK2                Inserted          Connects REFIN to the 1.2V external
                                     reference.
LK3                Inserted          Connects the 4.096 V output from the
                                     :adi:`ADR4540` after buffer :adi:`AD8031`
                                     solution.
LK6                B                 Connects the output of the VCM buffer to
                                     the VCM of the amplifier.
LK9                A                 Connects to the 7 V supply coming from
                                     the :adi:`ADP7102`.
LK10               A                 Connects to the −2.5 V coming from the
                                     :adi:`ADP2300`.
JP1,JP2            B                 Connects CNV+ and CNV− from the FPGA.
JP6                B                 Connects 7 V to amplifier +VS.
JP10               B                 Connects −2.5 V to amplifier −VS.
JP11,JP12          B                 Connect outputs from the :adi:`ADA4899-1`
                                     to the inputs of the ADC.
JP13,JP14          B                 Connect outputs from the :adi:`ADA4899-1`
                                     to the inputs of the ADC.
================== ================= ===========================================

Jumper setup AD7960/AD7961
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

================== ================= ============================================
Jumper/Solder link Default Position  Description
================== ================= ============================================
LK2,LK3            Inserted          Option to use external amplifier supplies
                                     + VS and – VS.
LK4                Inserted          Connects to +7 V coming from :adi:`ADP7102`.
LK5                B                 Connects to −2.5 V coming from
                                     :adi:`ADP2300`.
LK6                B                 Connects the output of VCM buffer to VCM
                                     of amplifier.
LK7                B                 Connects the +5 V output from
                                     :adi:`ADR4550` to REF buffer AD8031.
JP1,JP2            B                 Connects analog inputs VIN+ and VIN− to
                                     the inputs of the ADC driver.
                                     :adi:`ADA4899-1` or :adi:`ADA4897-1`.
JP3,JP4            B                 Connect outputs from :adi:`ADA4899-1`
                                     to inputs of :adi:`AD7960`.
JP5                A                 Connect the VCM output from :adi:`AD7960`
                                     to :adi:`AD8031`.
JP7                A                 Connects REFIN to 2.048 V external
                                     reference.
JP8                B                 Connects +7 V to amplifier +VS.
JP9                B                 Connects −2.5 V to amplifier −VS.
================== ================= ============================================

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture cpu-intercon-addr`).

========================  ===========
Instance                  Zynq
========================  ===========
axi_pulsar_lvds           0x44A0_0000
axi_pulsar_lvds_dma       0x44A3_0000
axi_pwm_gen               0x44A6_0000
reference_clkgen          0x44A8_0000
========================  ===========

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
   * - en3_fmc **
     - INOUT
     - 35
     - 89
   * - en2_fmc **
     - INOUT
     - 34
     - 88
   * - en1_fmc
     - INOUT
     - 33
     - 87
   * - en0_fmc
     - INOUT
     - 32
     - 86

.. admonition:: Legend
   :class: note

   - ``**`` instantiated only for AD7960/AD7961

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

=============== === ========== ===========
Instance name   HDL Linux Zynq Actual Zynq
=============== === ========== ===========
axi_ad7616_dma  13  57         89
=============== === ========== ===========

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

.. shell:: bash

   $cd hdl/projects/pulsar_lvds_adc/zed
   $make RESOLUTION_16_18N=0

The result of the build, if parameters were used, will be in a folder named
by the configuration used:

if the following command was run

``make RESOLUTION_16_18N=0``

then the folder name will be:

``RESOLUTION_16_18N0``

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Resources
-------------------------------------------------------------------------------

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheets:

  - :adi:`AD7625`
  - :adi:`AD7626`
  - :adi:`AD7960`
  - :adi:`AD7961`
  - :adi:`UG-745, Evaluation Board User Guide <media/en/technical-documentation/user-guides/EVAL-AD7625FMCZ_7626FMCZ_UG-745.pdf>`
  - :adi:`UG-490, Evaluation Board User Guide <media/en/technical-documentation/user-guides/UG-490.pdf>`
  - :adi:`UG-581, Evaluation Board User Guide <media/en/technical-documentation/user-guides/ug-581.pdf>`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-hdl:`PULSAR_LVDS_ADC HDL project source code <projects/pulsar_lvds_adc>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_PULSAR_LVDS
     - :git-hdl:`library/axi_pulsar_lvds`
     - ---
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
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom`
     - :ref:`axi_sysid`
   * - UTIL_I2C_MIXER
     - :git-hdl:`library/util_i2c_mixer`
     - ---

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Linux support:

- :git-linux:`AD796X IIO ADC Linux Driver <drivers/iio/adc/ad7625.c>`

No-OS support:

- :git-no-os:`AD796X-FMCZ No-OS project source code <projects/ad796x_fmcz>`
- :git-no-os:`AD796X No-OS Driver source code <drivers/adc/ad796x/ad796x.c>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

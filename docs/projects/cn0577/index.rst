.. _cn0577:

CN0577 HDL project
================================================================================

Overview
-------------------------------------------------------------------------------

The :adi:`EVALCN0577-FMCZ <CN0577>` provides an analog front-end and an FMC 
digital interface for :adi:`LTC2387-18`, its core. It is a low noise, high 
speed successive approximation register (SAR) ADC with a resolution of 18 bits 
and sampling rate up to 15MSPS. :adi:`EVALCN0577-FMCZ <CN0577>` includes an 
on-board reference oscillator and a retiming circuit to minimize signal-to-noise 
ratio (SNR) degradation due to the FPGA additive jitter. In order to support 
high speed operations while minimizing the number of data lines, a serial LVDS 
digital interface is used. It has a one-lane and two-lane output modes, 
allowing the user to optimize the interface data rate for each application, 
through setting a parameter.
Current revision of :adi:`EVALCN0577-FMCZ <CN0577>` is Rev A.
:adi:`EVALCN0577-FMCZ <CN0577>` and :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>` 
are connected together to build a development system setup.

Supported boards
-------------------------------------------------------------------------------

-  :adi:`CN0577 <CN0577>`
-  :adi:`LTC2387-18 chip <LTC2387-18>`

Supported devices
-------------------------------------------------------------------------------

-  :adi:`ADAQ23876`
-  :adi:`ADA4945-1`
-  :adi:`ADG3241`
-  :adi:`ADN4661`
-  :adi:`ADR4520`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - :adi:`CN0577 <CN0577>`
     - :xilinx:`ZedBoard <products/boards-and-kits/1-8dyf-11.html>`
     - FMC-LPC

Block design
-------------------------------------------------------------------------------

The architecture is composed from one :adi:`ADA4945-1` fully differential 
analog-to-digital driver interface IP that is driving the :adi:`LTC2387-18` 
which is an 18 bits analog-to-digital converter interface IP. All these IPs 
utilize an 120MHz reference clock, which is produced by an axi_clkgen IP.

Before proceeding with the project, please pay attettion to this pieces of
infomation related to the HDL project.

.. note::
    In the main version, the TWOLANES parameter is set to 1, so it works 
    only in two-lane output mode.

.. warning::
    The VADJ for the Zedboard must be set to 2.5V.

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagram:

.. image:: ../cn0577/cn0577_zed_block_diagram.svg
   :width: 800
   :align: center
   :alt: CN0577/ZedBoard block diagram

Jumper setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Depending on what configuration of pins is chosen on the jumpers P1, P2 and P3, 
the device can act in different modes, as described below. Of course, the PD 
jumper overrides the PD signal from the FPGA. It is controlled by a 
one-bit-adc-dac, in software.

.. list-table::
   :widths: 35 35 35 35
   :header-rows: 1

   * - Jumper/Solder link
     - Description
     - Pins
     - Configuration
   * - P1
     - configures PD_N
     - Shorting pins 1 and 2
     - PD_N = 1, device is not powered down
   * - P1
     - ---
     - Shorting pins 2 and 3
     - PD_N = 0, device is powered down
   * - P2
     - configures TESTPAT
     - Shorting pins 1 and 2
     - TESTPAT = 1, pattern testing is active
   * - P2
     - ---
     - Shorting pins 2 and 3
     - TESTPAT = 0, pattern testing is inactive
   * - P3
     - configures TWOLANES parameter
     - Shorting pins 1 and 2
     - TWOLANES = 1 (TWO LANES mode)
   * - P3
     - ---
     - Shorting pins 2 and 3
     - TWOLANES = 0 (ONE LANE mode)

The FMC connector connects to the LPC connector of the carrier board. For more 
detalis, check :adi:`EVALCN0577-FMCZ <CN0577>` datasheet.

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  The clock architecture of the :adi:`EVALCN0577-FMCZ <CN0577>` is designed 
   with careful consideration to ensure low jitter and low phase noise

-  An on-board 120 MHz voltage controlled crystal oscillator (VCXO) is used to 
   provide the clock for the :adi:`EVALCN0577-FMCZ <CN0577>` board and the FPGA. 
   It is further named as reference clock. This clock is gated and fed back to 
   the device as the sampling clock, on which the data was sampled

-  The DMA runs on the ZynqPS clock FCLK_CLK0 which has a frequency of 100MHz

For more detalis, check :adi:`EVALCN0577-FMCZ <CN0577>` datasheet.

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture`).

==================== ===============
Instance             Zynq/Microblaze
==================== ===============
axi_ltc2387          0x44A0_0000    
axi_ltc2387_dma      0x44A3_0000    
axi_pwm_gen          0x44A6_0000 
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
   * - pd_cntrl
     - IN
     - 32
     - 86
     - 110
   * - testpat_cntrl
     - IN
     - 33
     - 87
     - 111


Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

================ === ========== ===========
Instance name    HDL Linux Zynq Actual Zynq
================ === ========== ===========
ad_cpu_interrupt 13  57         89
================ === ========== ===========

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

   user@analog:~$ cd hdl/projects/cn0577/zed
   user@analog:~/hdl/projects/cn0577/zed$ make

A more comprehensive build guide can be found in the :ref:`build_hdl` user
guide.

Resources
-------------------------------------------------------------------------------

Systems related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :dokuwiki:`[Wiki] EVAL-CN0577-FMCZ User Guide <resources/eval/user-guides/circuits-from-the-lab/cn0577>`
-  :dokuwiki:`[Wiki] CN0577 HDL Reference Design <resources/eval/user-guides/circuits-from-the-lab/cn0577/hdl>`

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Product datasheets:

   -  :adi:`ADAQ23876`
   -  :adi:`ADR4520`
   -  :adi:`ADA4945-1`
   -  :adi:`ADN4661`
-  `Circuit Note CN-0577 <https://www.analog.com/media/en/reference-design-documentation/reference-designs/cn0577.pdf>`__

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`CN0577 HDL project source code <projects/cn0577>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_LTC2387
     - :git-hdl:`library/axi_ltc2387`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_ltc2387>`
   * - AXI_DMAC
     - :git-hdl:`library/axi_dmac`
     - :ref:`here <axi_dmac>`
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`
   * - AXI_CLKGEN
     - :git-hdl:`library/axi_clkgen`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_clkgen>`
   * - AXI_PWM_GEN
     - :git-hdl:`library/axi_pwm_gen`
     - :ref:`here <axi_pwm_gen>`
   * - AXI_HDMI_TX
     - :git-hdl:`library/axi_hdmi_tx`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_hdmi_tx>`
   * - AXI_I2S_ADI
     - :git-hdl:`library/axi_i2s_adi`
     - —
   * - AXI_SPDIF_TX
     - :git-hdl:`library/axi_spdif_tx`
     - 	—
   * - UTIL_I2C_MIXER
     - :git-hdl:`library/util_i2c_mixer`
     - 	—

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :dokuwiki:`[Wiki] LTC2387 SAR ADC IIO Linux driver page <resources/tools-software/linux-drivers/iio-adc/ltc2387>`

-  Python support (THIS IS JUST AN EXAMPLE):

   -  `PyADI-IIO documentation <https://analogdevicesinc.github.io/pyadi-iio/>`__

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

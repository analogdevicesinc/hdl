.. _ad9213_evb:

AD9213-EVB HDL project
===============================================================================

Overview
-------------------------------------------------------------------------------

The :adi:`AD9213-EVB <EVAL-AD9213>` reference design is a processor based
(e.g. Microblaze) embedded system.

The design implements a high-speed receive chain using JESD204B.

The receive chain transports the captured samples from ADC to the system
memory (DDR). Before transferring the data to DDR the samples are stored
in a buffer implemented on block rams from the FPGA fabric
(:git-hdl:`data_offload <library/data_offload>`).

All cores from the receive chain are programmable through
an AXI-Lite interface.

Supported boards
-------------------------------------------------------------------------------

- :adi:`AD9213-EVB <EVAL-AD9213>`

Supported devices
-------------------------------------------------------------------------------

- :adi:`AD9213`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - FMC slot
   * - :adi:`AD9213-EVB <EVAL-AD9213>`
     - :xilinx:`VCU118`
     - FMC+

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagrams:

.. image:: ad9213_jesd_diagram.svg
   :width: 800
   :align: center
   :alt: AD9213-EVB JESD204B M=1 L=16 block diagram

.. important::

   The Rx links (ADC Path) operate with the following parameters:

   - Rx parameters: L=16, M=1, F=2, S=16, NP=16, N=16
   - Sample Rate: 10 GSPS
   - Dual link: No
   - RX_DEVICE_CLK: 312.25 MHz (Lane Rate/40)
   - REF_CLK: 625 MHz (Lane Rate/20)
   - JESD204B Lane Rate: 12.5 Gbps
   - QPLL0

.. math::
   Lane Rate = Sample Rate*\frac{M}{L}*N'* \frac{10}{8}

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ad9213_clocks.svg
   :width: 500
   :align: center
   :alt: AD9213-EVB/VCU118 clock scheme

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The addresses are dependent on the architecture of the FPGA, having an offset
added to the base address from HDL (see more at :ref:`architecture cpu-intercon-addr`).

Check-out the table below to find out the conditions.

====================  ===============
Instance              Zynq/Microblaze
====================  ===============
axi_ad9213_xcvr       0x44A6_0000
rx_ad9213_tpl_core    0x44A1_0000
axi_ad9213_jesd       0x44A9_0000
axi_ad9213_dma        0x7C42_0000
ad9213_data_offload   0x7C43_0000
====================  ===============

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
     - spi0
     - axi_spi
     - 0
   * - PL
     - hmc7044_spi
     - HMC7044
     - 0
   * -
     -
     - ADF4371
     - 1

GPIOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 25 20 20
   :header-rows: 2

   * - GPIO signal
     - Direction
     - HDL GPIO EMIO
   * -
     - (from FPGA view)
     -
   * - rstb
     - OUT
     - 38
   * - hmc_sync_req
     - OUT
     - 37
   * - gpio[4:0]
     - INOUT
     - 36:32

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

================ ===========
Instance name    IRQ number
================ ===========
hmc7044_spi      5
axi_ad9213_dma   12
axi_ad9213_jesd  13
================ ===========

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI distributes the bit/elf files of these projects as part of the
:dokuwiki:`ADI Kuiper Linux <resources/tools-software/linux-software/kuiper-linux>`.
If you want to build the sources, ADI makes them available on the
:git-hdl:`HDL repository </>`. To get the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the :git-hdl:`projects/ad9213_evb` location and run the make
command by typing in your command prompt:

**Linux/Cygwin/WSL**

.. shell::

   $cd hdl/projects/ad9213_evb/vcu118
   $make

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Resources
-------------------------------------------------------------------------------

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheet: :adi:`AD9213`
- :adi:`Device data sheet <media/en/technical-documentation/data-sheets/AD9213.pdf>`
- :adi:`Evaluation Board <en/resources/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad9213.html>`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-hdl:`AD9213_EVB HDL project source code <projects/ad9213_evb>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - AXI_DMAC
     - :git-hdl:`library/axi_dmac`
     - :ref:`axi_dmac`
   * - DATA_OFFLOAD
     - :git-hdl:`library/data_offload`
     - :ref:`data_offload`
   * - AXI_SYSID
     - :git-hdl:`library/axi_sysid`
     - :ref:`axi_sysid`
   * - SYSID_ROM
     - :git-hdl:`library/sysid_rom`
     - :ref:`axi_sysid`
   * - UTIL_ADXCVR
     - :git-hdl:`library/xilinx/util_adxcvr`
     - :ref:`util_adxcvr`
   * - AXI_ADXCVR
     - :git-hdl:`library/xilinx/axi_adxcvr`
     - :ref:`axi_adxcvr amd`
   * - AXI_JESD204_RX
     - :git-hdl:`library/jesd204/axi_jesd204_rx`
     - :ref:`axi_jesd204_rx`
   * - JESD204_TPL_ADC
     - :git-hdl:`library/jesd204/ad_ip_jesd204_tpl_adc`
     - :ref:`ad_ip_jesd204_tpl_adc`

- :dokuwiki:`[Wiki] Generic JESD204B block designs <resources/fpga/docs/hdl/generic_jesd_bds>`
- :ref:`jesd204`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

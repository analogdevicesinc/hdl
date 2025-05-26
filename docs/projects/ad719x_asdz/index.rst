.. _ad719x_asdz:

AD719X-ASDZ HDL project
================================================================================

Overview
-------------------------------------------------------------------------------

The AD719x-ASDZ HDL project supports the EVAL-AD719xASDZ family, comprised of
:adi:`EVAL-AD7190ASDZ`, :adi:`EVAL-AD7193ASDZ` and :adi:`EVAL-AD7195ASDZ`, each
evaluation kit featuring its own chip, the :adi:`AD7190`, :adi:`AD7193` and
:adi:`AD7195` respectively - 4.8 kHz ultralow noise 24-bit sigma-delta ADC,
each with its own particularities.

The on-chip low noise gain stage means that signals of small amplitude can
interface directly to the ADC. The internal clock option provides a compact
solution for low BW requirements.

Supported boards
-------------------------------------------------------------------------------

- :adi:`EVAL-AD7190ASDZ`
- :adi:`EVAL-AD7192ASDZ`
- :adi:`EVAL-AD7193ASDZ`
- :adi:`EVAL-AD7194ASDZ`
- :adi:`EVAL-AD7195ASDZ`

Supported devices
-------------------------------------------------------------------------------

- :adi:`AD7190`
- :adi:`AD7192`
- :adi:`AD7193`
- :adi:`AD7194`
- :adi:`AD7195`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - Connector
   * - :adi:`EVAL-AD7190ASDZ`
     - `Cora Z7S <https://digilent.com/shop/cora-z7-zynq-7000-single-core-for-arm-fpga-soc-development>`__
     - PMOD JA/Arduino shield
   * -
     - :intel:`DE10-Nano <content/www/us/en/developer/topic-technology/edge-5g/hardware/fpga-de10-nano.html>`
     - Arduino shield
   * - :adi:`EVAL-AD7192ASDZ`
     - `Cora Z7S <https://digilent.com/shop/cora-z7-zynq-7000-single-core-for-arm-fpga-soc-development>`__
     - PMOD JA/Arduino shield
   * -
     - :intel:`DE10-Nano <content/www/us/en/developer/topic-technology/edge-5g/hardware/fpga-de10-nano.html>`
     - Arduino shield
   * - :adi:`EVAL-AD7193ASDZ`
     - `Cora Z7S <https://digilent.com/shop/cora-z7-zynq-7000-single-core-for-arm-fpga-soc-development>`__
     - PMOD JA/Arduino shield
   * -
     - :intel:`DE10-Nano <content/www/us/en/developer/topic-technology/edge-5g/hardware/fpga-de10-nano.html>`
     - Arduino shield
   * - :adi:`EVAL-AD7194ASDZ`
     - `Cora Z7S <https://digilent.com/shop/cora-z7-zynq-7000-single-core-for-arm-fpga-soc-development>`__
     - PMOD JA/Arduino shield
   * -
     - :intel:`DE10-Nano <content/www/us/en/developer/topic-technology/edge-5g/hardware/fpga-de10-nano.html>`
     - Arduino shield
   * - :adi:`EVAL-AD7195ASDZ`
     - `Cora Z7S <https://digilent.com/shop/cora-z7-zynq-7000-single-core-for-arm-fpga-soc-development>`__
     - PMOD JA/Arduino shield
   * -
     - :intel:`DE10-Nano <content/www/us/en/developer/topic-technology/edge-5g/hardware/fpga-de10-nano.html>`
     - Arduino shield

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagram:

.. image:: ad719x_block_diagram.png
   :width: 1000
   :align: center
   :alt: AD719x/CoraZ7S block diagram

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
     - AD719x
     - 0

GPIOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 25 25 25 25
   :header-rows: 2

   * - GPIO signal
     - Direction (from FPGA view)
     - HDL GPIO EMIO
     - Software GPIO (for Zynq-7000)
   * - adc_syncn *
     - OUT
     - 33
     - 87
   * - adc_spi_miso_rdyn
     - OUT
     - 32
     - 86

.. admonition:: Legend
   :class: note

   ``*`` - ``adc_syncn`` exists all the time on the DE10-Nano project, **but**
   on the Cora Z7S project it exists only when the project was built with
   ``ARDZ_PMOD_N=1`` parameter (used when connecting the eval. board through
   the Arduino header)

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI distributes the bit/elf files of these projects as part of the
:dokuwiki:`ADI Kuiper Linux <resources/tools-software/linux-software/kuiper-linux>`.
If you want to build the sources, ADI makes them available on the
:git-hdl:`HDL repository </>`. To get the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Cora Z7S
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Linux/Cygwin/WSL**

The default build configuration (``ARDZ_PMOD_N=0``) features the eval. boards
connected to Cora Z7S through PMOD JA:

.. shell::

   $cd hdl/projects/ad719x_asdz/coraz7s
   $make

The other possible way to connect the supported boards to CoraZ7S, is through
the Arduino header, for which the project needs to be built with the parameter
``ARDZ_PMOD_N=1``.

The built project will be located at hdl/projects/ad719x_asdz/coraz7s/**ARDZPMODN1**.

.. shell::

   $cd hdl/projects/ad719x_asdz/coraz7s
   $make ARDZ_PMOD_N=1

DE10-Nano
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Linux/Cygwin/WSL**

The only configuration available is through the Arduino header, so this project
is not parameterizable:

.. shell::

   $cd hdl/projects/ad719x_asdz/de10nano
   $make

A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Software considerations
-------------------------------------------------------------------------------

The reference design when using the Arduino header, has an extra GPIO, compared
to the other one --- the SYNCN, which is used for synchronizing multiple devices.

Resources
-------------------------------------------------------------------------------

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Product datasheets:

  - :adi:`AD7190`
  - :adi:`AD7192`
  - :adi:`AD7193`
  - :adi:`AD7194`
  - :adi:`AD7195`
  - :adi:`EVAL-AD7190ASDZ`
  - :adi:`EVAL-AD7192ASDZ`
  - :adi:`EVAL-AD7193ASDZ`
  - :adi:`EVAL-AD7194ASDZ`
  - :adi:`EVAL-AD7195ASDZ`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-hdl:`ad719x_asdz HDL project source code <projects/ad719x_asdz>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - axi_sysid
     - :git-hdl:`library/axi_sysid`
     - :ref:`axi_sysid`
   * - sysid_rom
     - :git-hdl:`library/sysid_rom`
     - :ref:`axi_sysid`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-linux:`AD719x Linux driver <drivers/iio/adc/ad7192.c>`
- :git-linux:`AD7190/CoraZ7S Linux device tree <arch/arm/boot/dts/zynq-coraz7s-ad7190.dts>`
- :git-linux:`AD7192/CoraZ7S Linux device tree <arch/arm/boot/dts/zynq-coraz7s-ad7192.dts>`
- :git-linux:`AD7193/CoraZ7S Linux device tree <arch/arm/boot/dts/zynq-coraz7s-ad7193.dts>`
- :git-linux:`AD7194/CoraZ7S Linux device tree <arch/arm/boot/dts/zynq-coraz7s-ad7194.dts>`
- :git-linux:`AD7195/CoraZ7S Linux device tree <arch/arm/boot/dts/zynq-coraz7s-ad7195.dts>`
- :git-no-os:`AD719x no-OS project <projects/ad719x>`
- :git-no-os:`AD719x no-OS driver <drivers/adc/ad719x>`
- :dokuwiki:`AD7190 - Microcontroller No-OS Driver <resources/tools-software/uc-drivers/renesas/ad7190>`
- :dokuwiki:`Supported devices <resources/tools-software/uc-drivers/ad7193>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

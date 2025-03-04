.. _ad719x_asdz:

AD719X-ASDZ HDL project
================================================================================

Overview
-------------------------------------------------------------------------------

The AD719x family uses a low noise, higher speed, high precision ADC. They 
can be used in a wide range of applications where the input signals can vary 
from the milli-volt to volt level. The parts also operate with a wide range of 
output data rates while still maintaining excellent noise performance over the 
complete rate of output data ranges.

Supported boards
-------------------------------------------------------------------------------

- :adi:`EVAL-AD7190 <EVAL-AD7190>`
- :adi:`EVAL-AD7193 <EVAL-AD7193>`
- :adi:`EVAL-AD7195 <EVAL-AD7195>`

Supported devices
-------------------------------------------------------------------------------

- :adi:`AD7190`
- :adi:`AD7193`
- :adi:`AD7195`

Supported carriers
-------------------------------------------------------------------------------

.. list-table::
   :widths: 35 35 30
   :header-rows: 1

   * - Evaluation board
     - Carrier
     - Slot
   * - :adi:`EVAL-AD7190 <EVAL-AD7190>`
     - Cora-Z7S_ 
     - PMOD JA
   * - :adi:`EVAL-AD7193 <EVAL-AD7193>`
     - Cora-Z7S_
     - PMOD JA
   * - :adi:`EVAL-AD7195 <EVAL-AD7195>`
     - Cora-Z7S_
     - PMOD JA

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagram:

.. image:: ad719x_block_diagram.png
   :width: 800
   :align: center
   :alt: AD719x/CORAZ7S block diagram

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

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here </>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the project location(**projects/ad719x/coraz7s**) and run the make 
command by typing in your command prompt:

**Linux/Cygwin/WSL**

.. code-block::

   user@analog:~$ cd hdl/projects/ad719x_asdz/coraz7s
   user@analog:~/hdl/projects/ad719x_asdz/coraz7s$ make

Check `this guide <resources/tools-software/linux-software/kuiper-linux>`__ on
how to prepare your SD card with the proper boot files.
A more comprehensive build guide can be found in the :ref:`build_hdl` user 
guide.

Software considerations 
-------------------------------------------------------------------------------

The SPI communication is changed because of hardware modifications, so the 
connection looks like this:

.. image:: ad7190_asdz_pmod_diagram.svg
   :width: 800
   :align: center
   :alt: AD719x/CORAZ7S pmod diagram

Resources
-------------------------------------------------------------------------------

Hardware related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Product datasheets:

   -  :adi:`AD7190`
   -  :adi:`AD7193`
   -  :adi:`AD7195`
   -  :adi:`EVAL-AD7190`
   -  :adi:`EVAL-AD7193`
   -  :adi:`EVAL-AD7195`

HDL related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`AD719x-FMC HDL project source code <projects/ad719x_asdz>`

.. list-table::
   :widths: 30 35 35
   :header-rows: 1

   * - IP name
     - Source code link
     - Documentation link
   * - axi_sysid
     - :git-hdl:`library/axi_sysid <library/axi_sysid>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`
   * - sysid_rom
     - :git-hdl:`library/sysid_rom <library/sysid_rom>`
     - :dokuwiki:`[Wiki] <resources/fpga/docs/axi_sysid>`

- :dokuwiki:`AD7193 Pmod Xilinx FPGA Reference Design <resources/fpga/xilinx/pmod/ad7193>`

Software related
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- :git-linux:`Driver <drivers/iio/adc/ad7192.c>`
- :dokuwiki:`AD7190 - Microcontroller No-OS Driver <resources/tools-software/uc-drivers/renesas/ad7190>`
- :dokuwiki:`Supported devices <resources/tools-software/uc-drivers/ad7193>`

.. include:: ../common/more_information.rst

.. include:: ../common/support.rst

.. _Cora-Z7S: https://digilent.com/reference/programmable-logic/cora-z7/start
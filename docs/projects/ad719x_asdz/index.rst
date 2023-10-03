.. _ad719x_asdz_ebz:

AD719x EBZ/ASDZ HDL project
================================================================================

Overview
-------------------------------------------------------------------------------

The :part:`EVAL-AD719x` boards are a fully featured evaluation Board for 
:part:`AD719x` family. They can be operated in standalone mode or connected
directly to the PC(7190 EBZ) or connected via PMOD connector to a carrier(7193 
and 7195 ASDZ). The AD719x chips are low noise, complete analog front end for 
high precision measurement applications.

**Some specifications about the board, the chip, etc. Typically the
information found on the** https://www.analog.com/en/products/
**website**

Supported boards
-------------------------------------------------------------------------------

- :part:`EVAL-AD7190-EBZ`
- :part:`EVAL-AD7193-ASDZ`
- :part:`EVAL-AD7195-ASDZ`

Supported devices
-------------------------------------------------------------------------------

- :part:`AD7190`
- :part:`AD7193`
- :part:`AD7195`

Supported carriers
-------------------------------------------------------------------------------

- CORAZ7S_

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in
the below diagram:

.. image:: ../images/ad719x_asdz/ad719x_block_diagram.png
   :width: 800
   :align: center
   :alt: AD719x/CORAZ7S block diagram

IP list
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`AXI_SYSID <master:library/axi_sysid>`
-  :git-hdl:`SYSID_ROM <master:library/sysid_rom>`

SPI connections
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The SPI communication between CORAZ7S_ and the EVAL-AD719x will be realized
using the PMOD ports. See the diagram below:

.. image:: ../images/ad719x_asdz/ad7190_asdz_pmod_diagram.svg
   :width: 800
   :align: center
   :alt: AD719x/CORAZ7S pmod diagram

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For :part:`EVAL-AD719x`, given the simplicity of the project, we have don't have
to use any interface to connect to the CPU.

=========== ==========
Instance    Address
=========== ==========
\-          \-
=========== ==========

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here <master:/>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository.

Then go to the **projects/ad719x/coraz7s** location and run the make command by
typing in your command prompt:

**Linux/Cygwin/WSL**

.. code-block::

   user@analog:~$ cd hdl/projects/ad719x_asdz/coraz7s
   user@analog:~/hdl/projects/cn0577/zed$ make

Check `this
guide <resources/tools-software/linux-software/kuiper-linux>`__ on
how to prepare your SD card with the proper boot files.
A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Resources
-------------------------------------------------------------------------------

-  Link to the project source code:

   - :git-hdl:`AD719x_ASDZ <master:projects/ad719x_asdz>`

-  Links to the wiki documentation of the IPs that are used in this
   project:

   - :dokuwiki:`AXI_SYSID & SYSID_ROM </resources/fpga/docs/axi_sysid>`

-  Links to the Linux driver and devicetree source code and wiki
   documentation:

   - :dokuwiki:`Linux Drivers </resources/tools-software/linux-drivers-all>`


More information
-------------------------------------------------------------------------------

-  :ref:`ADI HDL User guide <user_guide>`
-  :ref:`ADI HDL project architecture <architecture>`
-  :ref:`ADI HDL project build guide <build_hdl>`
  
Other relevant information:

-  :dokuwiki:`AD719x IIO Application </resources/tools-software/product-support-software/ad719x_mbed_iio_application>`
-  :dokuwiki:`AD7193 Pmod Xilinx FPGA Reference Design </resources/fpga/xilinx/pmod/ad7193>`
-  :dokuwiki:`How to prepare an SD
   card <resources/tools-software/linux-software/kuiper-linux>` with
   boot files
-  :dokuwiki:`ADI reference designs HDL user guide <resources/fpga/docs/hdl>`
-  :dokuwiki:`ADI HDL architecture <resources/fpga/docs/arch>` wiki page
-  :dokuwiki:`How to build an ADI HDL project <resources/fpga/docs/build>`
-  :ref:`ADI HDL User guide <user_guide>`
-  :ref:`ADI HDL project architecture <architecture>`
-  :ref:`ADI HDL project build guide <build_hdl>`

Support
-------------------------------------------------------------------------------

Analog Devices will provide **limited** online support for anyone using
the reference design with Analog Devices components via the
:ez:`fpga` FPGA reference designs forum.

It should be noted, that the older the tools' versions and release
branches are, the lower the chances to receive support from ADI
engineers.

.. |ad9783_zcu102_spi_pmod.svg| image:: ../images/ad971x_zcu102_spi_pmod.svg
   :width: 600
   :align: top
   :alt: AD971x-EBZ/ZCU102 SPI Pmod connection

.. _CORAZ7S: https://digilent.com/reference/programmable-logic/cora-z7/start
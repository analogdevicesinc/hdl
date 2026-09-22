.. _axi_sysid:

AXI System ID
================================================================================

.. hdl-component-diagram::

The System ID solution is comprised of 2 IP cores: the
:git-hdl:`AXI System ID <library/axi_sysid>`
which provides the AXI Lite interface and
:git-hdl:`System ID ROM <library/sysid_rom>`
which acts as a ROM and contains the data. Together, they provide the user with
information regarding the conditions in which the hardware system was built.
The System ID information is used to provide information about the system’s
bit file, to facilitate future debugging actions. This information will be
stored internally in a ROM and will be made available to the system via the
AXI Lite interface.

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_sysid/axi_sysid.v`
     - Verilog source for the peripheral.

Block Diagram
--------------------------------------------------------------------------------

.. image:: block_diagram.svg
   :alt: AXI System ID block diagram
   :align: center

Configuration Parameters
--------------------------------------------------------------------------------

AXI System ID
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. hdl-parameters::

   * - ROM_WIDTH
     - ROM width.
   * - ROM_ADDR_BITS
     - Number of address bits.

System ID ROM
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. hdl-parameters::
   :path: library/sysid_rom

   * - ROM_WIDTH
     - ROM width.
   * - ROM_ADDR_BITS
     - Number of address bits.
   * - PATH_TO_FILE
     - Location of ROM init file.

Interface
--------------------------------------------------------------------------------

AXI System ID
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. hdl-interfaces::

   * - sys_rom_data
     - Data input from System ROM.
   * - pr_rom_data
     - Data input from PR ROM.
   * - rom_addr
     - ROM address output.
   * - s_axi
     - AXI Slave Memory Map interface.

System ID ROM
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. hdl-interfaces::
   :path: library/sysid_rom

   * - clk
     - Input clock.
   * - rom_addr
     - Address input.
   * - rom_data
     - Data output.

Clocking
--------------------------------------------------------------------------------

The IP core runs on the AXI clock and requires a frequency of 100MHz.

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: AXI_SYSTEM_ID

Theory of Operation
--------------------------------------------------------------------------------

The System ID consists of a system of 2 or more IP cores where one provides
access to the AXI Lite interface, and the other behaves as a ROM. There can be
more than one ROM IP cores if required. The information contained by the ROM
will be generated and written at synthesis and will provide details as revealed
further in this document.

Once written, these contents cannot be changed, only read. These ROMs will be 32
bits wide with a fixed length of 512 lines for the System ROM (2KiB). The
secondary PR ROM will generally be smaller.

Data Format
--------------------------------------------------------------------------------

Common Header
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1

   * - Field size
     - Field
     - Value
     - Data format
   * - 4B \*
     - Common Header Format Version
     - 31:16 - reserved, write as 0000h ; 15:0 - format version number
     - hex
   * - 4B \*
     - Internal Use Area Starting Offset
     - 00000000h indicates that this area is not present
     - hex
   * - 4B \*
     - Board Area Starting Offset
     - 00000000h indicates that this area is not present
     - hex
   * - 4B \*
     - Product Info Area Starting Offset
     - 00000000h indicates that this area is not present
     - hex
   * - 4B \*
     - System Custom String Area Starting Offset
     - 00000000h indicates that this area is not present
     - hex
   * - 4B
     - PR custom string area (ROM2)
     - 00000000h indicates that this area is not present
     - hex
   * - 9 x 4B
     - Padding
     - 00000000h
     - hex
   * - 4B \*
     - Checksum
     -
     - hex

Internal Use Area
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1

   * - Field size
     - Field
     - Data format
   * - 28B \*
     - Git branch
     - hex
   * - 44B \*
     - Git tag (sha)
     - hex
   * - 4B \*
     - Git clean check
     - hex
   * - 4B \*
     - Vadj check
     - hex
   * - 12B \*
     - Build date/time as seconds since 1970-01-01_00:00:00 (UTC)
     - hex
   * - 4B \*
     - Padding (00000000h)
     - hex
   * - 4B \*
     - Checksum
     - hex

\* = These fields are MANDATORY

**Common Header:** The Common Header is mandatory for all System ID Information
Device implementations. It holds version information for the overall information
format specification and offsets to the other information areas. The other areas
may or may not be present based on the application of the device. A field is
specified as ‘Null’ or ‘not present’ when the Common Header has a value of 00h
for the starting offset for that area.

**Common Header Format Version:** This area version information regarding the
Common Header.

**Internal Use Area:** This area contains information describing the
circumstances in which the project was built.

**Product Info Area:** Contains the name of the targeted product. Data converted
from ASCII to hex. Size: Variable, 32 Bytes default.

**System Custom String:** Character string written by the user. Data converted
from ASCII to hex. Size: Variable, 32 Bytes default.

**Board Info Area:** This area provides the name of the platform that the
project is targeting. Data converted from ASCII to hex. Size: 32 Bytes.

**System Custom String Area**: This area provides a region where a custom
string supplied by the user will be written to. This will be stored in ROM1,
inside the system bit. Data converted from ASCII to hex.
Size: Variable, 32 Bytes default.

**PR Custom String Area:** This area provides a region where a custom string
provided by the user will be written to. This will be stored in ROM2, inside the
PR bit where available. Data converted from ASCII to hex.

Working with the Core
-------------------------------------------------------------------------------

The System ID solution is automatically placed into a project by the Tcl code
ADI uses to build projects. It is instantiated in two stages, first in the
"Common" bd.tcl of each of the supported FPGA boards and second in the
system_bd.tcl of each project.

The information written to the System ID ROM(s) is obtained from Vivado in the
early stages of project building. It is at this point that the user can choose
the information that will be written to the "Custom String" areas.

.. code:: tcl

   set sys_cstring "sys rom custom string placeholder"
   sysid_gen_sys_init_file $sys_cstring

Software Support
--------------------------------------------------------------------------------

* No-OS project at :git-no-OS:`drivers/axi_core/axi_sysid`
* No-OS device driver at  :git-no-OS:`drivers/axi_core/axi_sysid/axi_sysid.c`

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/axi_sysid` and :git-hdl:`library/sysid_rom`
* :dokuwiki:`System ID on wiki <resources/fpga/docs/axi_sysid>`

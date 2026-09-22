.. _debugging_xsdb:

Debugging with XSDB
================================================================================

XSDB (:xilinx:`Xilinx System Debugger
<support/documentation/sw_manuals/xilinx2014_3/SDK_Doc/concepts/sdk_c_xsd_over.htm>`)
is a user-friendly, interactive and scriptable command line interface, mainly
used for debugging.

Quick start guide
--------------------------------------------------------------------------------

An XSDB (or XSCT) console can be opened from the Vivado/Vitis SDK GUI
(**Tools**), or by running ``xsdb`` (Linux) / ``xsdb.bat`` (Windows) from the
command line.

Connect to the hw_server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

   xsdb> connect

List available targets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

   xsdb> targets

Connect to one of the targets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For example, target 3:

::

   xsdb> targets 3

Read data from a memory location
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reads a core's register map:

::

   xsdb> mrd -force 0x(base address + (common register)*4)
   xsdb> mrd -force 0x(base address + (channel offset + channel register)*4)

Write data to a memory location
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

   xsdb> mwr -force 0x(base address + (channel offset + channel register)*4) 0x(value)

Example
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Changing the :git-hdl:`axi_ad9361 <library/axi_ad9361>` TX data select, by
writing to ``REG_CHAN_CNTRL_7`` on all four channels (see the IP's register
map for the channel offsets and register addresses):

::

   xsdb> mwr -force 0x79024418 0x2
   xsdb> mwr -force 0x79024458 0x2
   xsdb> mwr -force 0x79024498 0x2
   xsdb> mwr -force 0x790244D8 0x2

More examples can be found in the no-OS
:git-no-os:`capture script <tools/scripts/platform/xilinx/capture.tcl>` and
:git-no-os:`Vitis utility script <tools/scripts/platform/xilinx/util.py>`.

References
--------------------------------------------------------------------------------

* :xilinx:`Xilinx System Debugger overview
  <support/documentation/sw_manuals/xilinx2014_3/SDK_Doc/concepts/sdk_c_xsd_over.htm>`

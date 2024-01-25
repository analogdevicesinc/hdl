.. _i3c_controller core:

I3C Controller Core
================================================================================

.. hdl-component-diagram::

The I3C Controller Core peripheral forms the heart of the I3C Controller.
It is responsible for handling a I3C Controller commands and translates it into
low-level I3C bus transactions.

Files
-------------------------------------------------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`master:library/i3c_controller/i3c_controller_core/i3c_controller_core.v`
     - Verilog source for the peripheral.
   * - :git-hdl:`master:library/i3c_controller/i3c_controller_core/i3c_controller_core.tcl`
     - TCL script to generate the Vivado IP-integrator project for the peripheral.


Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - CLK_MOD
     - | Clock cycles per bus bit at maximun speed (12.5MHz), set to:
       | * 8 clock cycles at 100MHz input clock.
       | * 4 clock cycles at 50MHz input clock.

Signal and Interface Pins
--------------------------------------------------------------------------------

.. hdl-interfaces::

Theory of Operation
--------------------------------------------------------------------------------


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
   * - :git-hdl:`library/i3c_controller/i3c_controller_core/i3c_controller_core.v`
     - Verilog source for the peripheral.
   * - :git-hdl:`library/i3c_controller/i3c_controller_core/i3c_controller_core.tcl`
     - TCL script to generate the Vivado IP-integrator project for the peripheral.
   * - :git-hdl:`library/i3c_controller/i3c_controller_core/i3c_controller_core_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project for the peripheral.
   * - :git-hdl:`library/i3c_controller/i3c_controller_core/i3c_controller_core_hw.tcl`
     - TCL script to generate the Quartus IP-integrator project for the peripheral.


Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - I2C_MOD
     - Further divide open drain speed by power of two,
       to support slow I2C devices.

       For example, with input clock 100MHz:

       * 0: 1.5626MHz (no division).
       * 2 390.6kHz.
       * 4 97.6kHz.


Signal and Interface Pins
--------------------------------------------------------------------------------

.. hdl-interfaces::

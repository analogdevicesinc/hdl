.. _i3c_controller host_interface:

I3C Controller Host Interface
================================================================================

.. symbolator:: ../../../library/i3c_controller/i3c_controller_host_interface/i3c_controller_host_interface.v
   :caption: i3c_controller_host_interface

The I3C Controller Host Interface peripheral allows asynchronous interrupt-driven memory-mapped
access to a I3C Controller Control Interface.
This is typically used in combination with a software program to dynamically
generate I3C transactions.

The peripheral has also support for providing memory-mapped access to one or more
:ref:`i3c_controller offload-control-interface` cores and change its content
dynamically at runtime.

Files
--------------------------------------------------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`master:library/i3c_controller/i3c_controller_host_interface/i3c_controller_host_interface.v`
     - Verilog source for the peripheral.
   * - :git-hdl:`master:library/i3c_controller/i3c_controller_host_interface/i3c_controller_host_interface.tcl`
     - TCL script to generate the Vivado IP-integrator project for the peripheral.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

Signal and Interface Pins
--------------------------------------------------------------------------------

.. hdl-interfaces::

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: i3c_controller_host_interface

Theory of Operation
--------------------------------------------------------------------------------

FIFOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Synchronization Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Interrupts
--------------------------------------------------------------------------------


FIFO Threshold Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SYNC_EVENT Interrupt
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

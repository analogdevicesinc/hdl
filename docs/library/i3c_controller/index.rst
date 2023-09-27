.. _i3c_controller:

I3C Controller
================================================================================

.. toctree::
   :hidden:

   Host Interface<i3c_controller_host_interface>
   Core Module<i3c_controller_core>
   Interface<interface>

I3C Controller is subset of the I3C specification to interface peripheral such
as ADCs through I3C.

Sub-modules
--------------------------------------------------------------------------------

* :ref:`i3c_controller host_interface`: Memory mapped software accessible
  interface to a I3C Controller command stream and/or offload cores.
* :ref:`i3c_controller core`: Main module which executes a I3C Controller command
  stream and implements the I3C bus interface logic.

Interfaces
--------------------------------------------------------------------------------

* :ref:`i3c_controller control-interface`: SPI Engine command stream.
* :ref:`i3c_controller offload-control-interface`: Program the command stream
  stored in a offload module.

Software
--------------------------------------------------------------------------------

* :ref:`i3c_controller instruction-format`: Overview of the I3C Controller
  instruction format.

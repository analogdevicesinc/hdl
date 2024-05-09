.. _i3c_controller host_interface:

I3C Controller Host Interface
================================================================================

.. hdl-component-diagram::

The I3C Controller Host Interface peripheral allows asynchronous interrupt-driven memory-mapped
access to a I3C Controller Control Interface.
This is typically used in combination with a software program to dynamically
generate I3C transactions.

The peripheral also has support for providing memory-mapped access to one or more
:ref:`i3c_controller offload-interface` cores and change its content dynamically at
runtime.

Files
--------------------------------------------------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/i3c_controller/i3c_controller_host_interface/i3c_controller_host_interface.v`
     - Verilog source for the peripheral.
   * - :git-hdl:`library/i3c_controller/i3c_controller_host_interface/i3c_controller_host_interface_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project for the peripheral.
   * - :git-hdl:`library/i3c_controller/i3c_controller_host_interface/i3c_controller_host_interface_hw.tcl`
     - TCL script to generate the Quartus IP-integrator project for the peripheral.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

Signal and Interface Pins
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - s_axi_aclk
     - All ``s_axi`` signals and ``irq`` are synchronous to this clock.
   * - s_axi_aresetn
     - Synchronous active-low reset.
       Resets the internal state of the peripheral.
   * - s_axi
     - AXI-Lite bus subordinate.
       Memory-mapped AXI-lite bus that provides access to modules register map.
   * - irq
     - Level-High Interrupt.
       Interrupt output of the module. Is asserted when at least one of the
       modules interrupt is pending and unmasked.
   * - offload_trigger
     - On offload operation, assert to start a burst.
   * - sdio
     - Group of byte stream interfaces (``SDI``, ``SDO``, and ``IBI``),
       internally connected to thei respective FIFOs.
   * - offload_sdi
     - SDI output of the :ref:`i3c_controller offload-interface`,
       generally consumed to a DMA.
   * - cmdp
     - Parsed :ref:`i3c_controller command_descriptors` to instruct the
       :ref:`i3c_controller core`.
   * - rmap
     - Interface give the :ref:`i3c_controller core` access to some register map
       addresses.

.. _i3c_controller regmap:

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: i3c_controller_host_interface

.. _i3c_controller interrupts:

Interrupts
--------------------------------------------------------------------------------

The I3C Controller Host Interface peripheral has 8 internal interrupts, which are
asserted when:

* ``CMD_ALMOST_EMPTY``: the level falls bellow the almost empty level.
* ``CMDR_ALMOST_FULL``: the level rises above the almost full level.
* ``SDO_ALMOST_EMPTY``: the level falls bellow the almost empty level.
* ``SDI_ALMOST_FULL``: the level rises above the almost full level.
* ``IBI_ALMOST_FULL``: the level rises above the almost full level.
* ``CMDR_PENDING``: a new :ref:`i3c_controller cmdr` event arrives.
* ``IBI_PENDING``: a new IBI event arrives.
* ``DAA_PENDING``: a peripheral requested an address during the DAA.

The peripheral has 1 external interrupt which is supposed to be connected to the
upstream interrupt controller.
The external interrupt is a logical OR-operation over the internal interrupts,
meaning if at least one of the internal interrupts is asserted the external
interrupt is asserted and only if all internal interrupts are de-asserted the
external interrupt is de-asserted.

In addition, each interrupt has a mask bit which can be used to stop the propagation
of the internal interrupt to the external interrupt.
If an interrupt is masked it will count towards the external interrupt state as if
it were not asserted.

The mask bits can be modified by writing to the ``IRQ_MASK`` register.
The raw interrupt status can be read from the ``IRQ_SOURCE`` register and the
combined state of the ``IRQ_MASK`` and raw interrupt state can be read from the
``IRQ_PENDING`` register:

.. code::

   IRQ_PENDING = IRQ_SOURCE & IRQ_MASK;
   IRQ = |IRQ_PENDING;

FIFO Threshold Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The FIFO threshold interrupts can be used by software for flow control of the
streams, for example,
listen to the FIFO level interrupts during data transfer to and from the FIFOs
to avoid data loss.

The FIFO threshold interrupt is asserted when then FIFO level rises above the
watermark and is automatically de-asserted when the level drops below the
watermark.

Pending Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The pending interrupt ``*_PENDING`` is asserted when a new sync event is received
from a stream.
For information about the ``CMDR`` see :ref:`i3c_controller cmdr`, and about the
``IBI`` see :ref:`i3c_controller ibi`.

An application that generated a pending interrupt instruction can use this interrupt
to be notified when the instruction has been completed.
For example, for a ``cmd`` instruction, it has completed when the ``CMDR_PENDING``
is received.

To de-assert the interrupt, the application needs to acknowledge its reception
by writing 1 to the associated bit at the ``IRQ_PENDING`` register.

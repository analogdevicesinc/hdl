.. _spi_engine axi:

AXI SPI Engine Module
================================================================================

.. hdl-component-diagram::

The AXI SPI Engine peripheral allows asynchronous interrupt-driven memory-mapped
access to a SPI Engine Control Interface.
This is typically used in combination with a software program to dynamically
generate SPI transactions.

The peripheral has also support for providing memory-mapped access to one or more
:ref:`spi_engine offload` cores and change its content dynamically at runtime.

Files
--------------------------------------------------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/spi_engine/axi_spi_engine/axi_spi_engine.v`
     - Verilog source for the peripheral.
   * - :git-hdl:`library/spi_engine/axi_spi_engine/axi_spi_engine_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project for the peripheral.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - ASYNC_SPI_CLK
     - If set to 1 the ``s_axi_aclk`` and ``spi_clk`` clocks are assumed
       to be asynchronous.
   * - CMD_FIFO_ADDRESS_WIDTH
     - Configures the size of the command FIFO.
   * - SDO_FIFO_ADDRESS_WIDTH
     - Configures the size of the serial-data out FIFO.
   * - SDI_FIFO_ADDRESS_WIDTH
     - Configures the size of the serial-data in FIFO.
   * - NUM_OFFLOAD
     - The number of offload control interfaces.

Signal and Interface Pins
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - s_axi_aclk
     - All ``s_axi`` signals and ``irq`` are synchronous to this clock.
   * - s_axi_aresetn
     - Synchronous active-low reset.
       Resets the internal state of the peripheral.
   * - s_axi
     - AXI-Lite bus slave.
       Memory-mapped AXI-lite bus that provides access to modules register map.
   * - irq
     - Level-High Interrupt.
       Interrupt output of the module. Is asserted when at least one of the
       modules interrupt is pending and unmasked.
   * - spi_clk
     - ``spi_resetn`` is synchronous to this clock.
   * - spi_engine_ctrl
     - :ref:`spi_engine control-interface` slave.
       SPI Engine Control stream that contains commands and data for the
       execution module.
   * - spi_resetn
     - This signal is asserted when the module is disabled through the ENABLE
       register. Typically used as the reset for the SPI Engine modules
       connected to these modules.

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: axi_spi_engine

Theory of Operation
--------------------------------------------------------------------------------

Typically a software application running on a CPU will be able to execute much
faster than the SPI engine command will be processed.
In order to allow the software to execute other tasks while the SPI engine is
busy processing commands the AXI SPI Engine peripheral offers interrupt-driven
notification which can be used to notify the software when a SPI command has
been executed.
In order to reduce the necessary context switches the AXI SPI Engine peripheral
incorporates FIFOs to buffer the command as well as the data streams.

FIFOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The AXI SPI Engine peripheral has three FIFOs, one for each of the command, SDO
and SDI streams.
The size of the FIFOs can be configured by setting the CMD_FIFO_ADDRESS_WIDTH,
SDO_FIFO_ADDRESS_WIDTH and SDI_FIFO_ADDRESS_WIDTH parameters.

One end of the FIFOs are connected to a memory-mapped register and can be
accessed via the AXI-Lite interface.
The other end is directly connected to the matching stream of the
:ref:`spi_engine control-interface`.

Data can be inserted into the command FIFO by writing to the CMD_FIFO register
and new data can be inserted into the SDO_FIFO register.
If an application attempts to write to a FIFO while the FIFO is already full the
data is discarded and the state of the FIFO remains unmodified.
The number of empty entries in the command and SDO FIFO can be queried by
reading the CMD_FIFO_ROOM or SDO_FIFO_ROOM register.

Data can be removed from the SDI FIFO by reading from the SDI_FIFO register.
If an application attempts to read data while the FIFO is empty undefined data
is returned and the state of the FIFO remains unmodified.
It is possible to read the first entry in the SDI FIFO without removing it by
reading from the SDI_FIFO_PEEK register.
The number of valid entries in the SDI FIFO register can be queried by reading
the SDI_FIFO_LEVEL register.

If the peripheral is disabled by setting the ENABLE register to 0 any data
stored in the FIFOs is discarded and the state of the FIFO is reset.

Synchronization Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Synchronization events can be used to notify the software application about the
progress of the command stream.
An application can insert a SYNC instruction at any point in the command stream.
If the execution module reaches the SYNC instruction it will generate an event
on the SYNC stream.
When this event is received by the AXI SPI Engine peripheral it will update the
SYNC_ID register with the received event ID and will assert the SYNC_EVENT
interrupt.

Typically the SYNC instruction should be inserted after the last instruction in
a SPI transaction.
This will allow the application to be notified about the completion of the
transaction and allows it to do further processing based on the result of the
transaction.

It is recommended that synchronization IDs are generated in a monotonic
incrementing or decrementing manner.
This makes it possible to easily check if an event has completed by checking if
it is less or equal (incrementing IDs) or more or equal (decrementing IDs) to
the ID of the last completed event.

Interrupts
--------------------------------------------------------------------------------

The SPI Engine AXI peripheral has 4 internal interrupts, which are
asserted when:

* ``CMD_ALMOST_EMPTY``: the level falls bellow the almost empty level.
* ``SDO_ALMOST_EMPTY``: the level falls bellow the almost empty level.
* ``SDI_ALMOST_FULL``: the level rises above the almost full level.
* ``SYNC_EVENT``: a new synchronization event arrives.

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
command, ``SDI`` and ``SDO`` streams.

If an application wants to send more data than what fits into the FIFO can write
samples into the FIFO until it is full then suspend operation wait for the almost
empty interrupt and continue writing data to the FIFO.
Similarly, when the application wants to read more data than what fits into FIFO
it should listen for the almost full interrupt and read data from the FIFO when
it occurs.

The FIFO threshold interrupt is asserted when then FIFO level rises above the
watermark and is automatically de-asserted when the level drops below the
watermark.

SYNC_EVENT Interrupt
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``SYNC_EVENT`` interrupt is asserted when a new sync event is received from
the sync stream.
An application that generated a ``SYNC`` instruction on the command stream can
use this interrupt to be notified when the sync instruction has been completed.

To de-assert the ``SYNC_EVENT`` interrupt, the application needs to acknowledge its
reception by writing 1 to the ``SYNC_EVENT`` bit in the ``IRQ_PENDING`` register.

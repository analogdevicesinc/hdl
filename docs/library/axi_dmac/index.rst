.. _axi_dmac:

High-Speed DMA Controller
================================================================================

.. hdl-component-diagram::

The AXI DMAC is a high-speed, high-throughput, general purpose DMA controller
intended to be used to transfer data between system memory and other peripherals
like high-speed converters.

Features
--------------------------------------------------------------------------------

- Supports multiple interface types

  -  AXI3/4 memory mapped
  -  AXI4 Streaming
  -  ADI FIFO interface

- Zero-latency transfer switch-over architecture

  -  Allows **continuous** high-speed streaming

- Cyclic transfers
- 2D transfers
- Scatter-Gather transfers

Utilization
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Device Family
     - LUTs
     - FFs
   * - Intel Arria 10
     - TBD
     - TBD
   * - Xilinx Artix 7
     - TBD
     - TBD
   * - Xilinx Kintex 7
     - TBD
     - TBD
   * - Xilinx Virtex 7
     - TBD
     - TBD

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_dmac/axi_dmac.v`
     - Verilog source for the peripheral.

Block Diagram
--------------------------------------------------------------------------------

.. image:: block_diagram.svg
   :alt: AXI DMAC block diagram
   :align: center

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - ID
     - Instance identification number.
   * - DMA_DATA_WIDTH_SRC
     - Data path width of the source interface in bits.
   * - DMA_DATA_WIDTH_DEST
     - Data path width of the destination interface in bits.
   * - DMA_DATA_WIDTH_SG
     - Data path width of the scatter-gather interface in bits.
   * - DMA_LENGTH_WIDTH
     - Width of transfer length control register in bits.
       Limits length of the transfers to 2*\*\ ``DMA_LENGTH_WIDTH``.
   * - DMA_2D_TRANSFER
     - Enable support for 2D transfers.
   * - DMA_SG_TRANSFER
     - Enable support for scatter-gather transfers.
   * - ASYNC_CLK_REQ_SRC
     - Whether the request and source clock domains are asynchronous.
   * - ASYNC_CLK_SRC_DEST
     - Whether the source and destination clock domains are asynchronous.
   * - ASYNC_CLK_DEST_REQ
     - Whether the destination and request clock domains are asynchronous.
   * - ASYNC_CLK_REQ_SG
     - Whether the request and scatter-gather clock domains are asynchronous.
   * - ASYNC_CLK_SRC_SG
     - Whether the source and scatter-gather clock domains are asynchronous.
   * - ASYNC_CLK_DEST_SG
     - Whether the destination and scatter-gather clock domains are asynchronous.
   * - AXI_SLICE_DEST
     - Whether to insert an extra register slice on the source data path.
   * - AXI_SLICE_SRC
     - Whether to insert an extra register slice on the destination data path.
   * - SYNC_TRANSFER_START
     - Enable the transfer start synchronization feature.
   * - CYCLIC
     - Enable support for Cyclic transfers.
   * - DMA_AXI_PROTOCOL_SRC
     - AXI protocol version of the source interface (0 = AXI4, 1 = AXI3).
   * - DMA_AXI_PROTOCOL_DEST
     - AXI protocol version of the destination interface (0 = AXI4, 1 = AXI3).
   * - DMA_AXI_PROTOCOL_SG
     - AXI protocol version of the scatter-gather interface (0 = AXI4, 1 = AXI3).
   * - DMA_TYPE_SRC
     - Interface type for the source interface
       (0 = AXI-MM, 1 = AXI-Streaming, 2 = ADI-FIFO).
   * - DMA_TYPE_DEST
     - Interface type for the destination interface
       (0 = AXI-MM, 1 = AXI-Streaming, 2 = ADI-FIFO).
   * - DMA_AXI_ADDR_WIDTH
     - Maximum address width for AXI interfaces.
   * - MAX_BYTES_PER_BURST
     - Maximum size of bursts in bytes. Must be power of 2 in a range of 2
       beats to 4096 bytes
       The size of the burst is limited by the largest burst that both source
       and destination supports. This depends on the selected protocol.
       For AXI3 the maximum beats per burst is 16, while for AXI4 is 256. For
       non AXI interfaces the maximum beats per burst is in theory unlimited
       but it is set to 1024 to provide a reasonable upper threshold.
       This limitation is done internally in the core.
   * - FIFO_SIZE
     - Size of the store-and-forward memory in bursts. Size of a burst is
       defined by the ``MAX_BYTES_PER_BURST`` parameter. Must be power of 2 in
       the range of 2 to 32.
   * - DISABLE_DEBUG_REGISTERS
     - Disable debug registers.
   * - ENABLE_DIAGNOSTICS_IF
     - Add insight into internal operation of the core, for debug purposes
       only.

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - s_axi_aclk
     - All ``s_axi`` signals and ``irq`` are synchronous to this clock.
   * - s_axi_aresetn
     - Resets the internal state of the peripheral.
   * - s_axi
     - Memory mapped AXI-lite bus that provides access to modules register map.
   * - irq
     - Interrupt output of the module. Is asserted when at least one of the
       modules interrupt is pending and enabled.
   * - m_src_axi_aclk
     - The m_src_axi interface is synchronous to this clock.
       Only present when ``DMA_TYPE_SRC`` parameter is set to AXI-MM (0).
   * - m_src_axi_aresetn
     - Reset for the ``m_src_axi`` interface.
       Only present when ``DMA_TYPE_SRC`` parameter is set to AXI-MM (0).
   * - m_src_axi
     - Only present when ``DMA_TYPE_SRC`` parameter is set to AXI-MM (0).
   * - m_dest_axi_aclk
     - The ``m_src_axi`` interface is synchronous to this clock.
       Only present when ``DMA_TYPE_DEST`` parameter is set to AXI-MM (0).
   * - m_dest_axi_aresetn
     - Reset for the ``m_dest_axi`` interface.
       Only present when ``DMA_TYPE_DEST`` parameter is set to AXI-MM (0).
   * - m_dest_axi
     - Only present when ``DMA_TYPE_DEST`` parameter is set to AXI-MM (0).
   * - m_sg_axi_aclk
     - The ``m_sg_axi`` interface is synchronous to this clock.
       Only present when ``DMA_SG_TRANSFER`` parameter is set.
   * - m_sg_axi_aresetn
     - Reset for the ``m_sg_axi`` interface.
       Only present when ``DMA_SG_TRANSFER`` parameter is set.
   * - m_sg_axi
     - Only present when ``DMA_SG_TRANSFER`` parameter is set.
   * - s_axis_aclk
     - The ``s_axis`` interface is synchronous to this clock.
       Only present when ``DMA_TYPE_SRC`` parameter is set to AXI-Streaming
       (1).
   * - s_axis
     - Only present when ``DMA_TYPE_SRC`` parameter is set to AXI-Streaming
       (1).
   * - m_axis_aclk
     - The ``m_axis`` interface is synchronous to this clock.
       Only present when ``DMA_TYPE_DEST`` parameter is set to AXI-Streaming
       (1).
   * - m_axis
     - Only present when ``DMA_TYPE_DEST`` parameter is set to AXI-Streaming
       (1).
   * - fifo_wr_clk
     - The fifo_wr interface is synchronous to this clock.
       Only present when ``DMA_TYPE_SRC`` parameter is set to FIFO (2).
   * - fifo_wr
     - Only present when ``DMA_TYPE_SRC`` parameter is set to FIFO (2).
   * - fifo_rd_clk
     - The ``fifo_rd`` interface is synchronous to this clock.
       Only present when ``DMA_TYPE_DEST`` parameter is set to FIFO (2).
   * - fifo_rd
     - Only present when ``DMA_TYPE_DEST`` parameter is set to FIFO (2).
   * - dest_diag_level_bursts
     - Only present when ``ENABLE_DIAGNOSTICS_IF`` parameter is set.

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: DMAC

Theory of Operation
--------------------------------------------------------------------------------

HDL Synthesis Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sizing of the internal store-and-forward data buffer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An internal buffer is used to store data from the source interface before it is
forwarded to the destination once that can accept it. The purpose of the buffer
is to even out the rate mismatches between the source and destination. e.g if
the destination is a FIFO interface with a fixed data rate and the source is a
MM interface, the intent is to keep the buffer as full as possible so in case of
the MM interface is not ready data can be still provided to the destination
without risking an underflow. Similarly in case the destination is a MM
interface and the source a FIFO interface with a fixed data rate, the intent is
to keep the buffer as empty as possible so in case the MM interface is not ready
data can be still accepted from the source without risking an overflow.

The size of the buffer in bytes is determined by the synthesis parameters of the
module and it is equal to ``FIFO_SIZE`` \* ``MAX_BYTES_PER_BURST``

The width of the buffer is sized to be the largest width from the source and
destination interfaces.

-  BUFFER_WIDTH_IN_BYTES =
   MAX(``DMA_DATA_WIDTH_SRC``,\ ``DMA_DATA_WIDTH_DEST``)/8
-  BUFFER_DEPTH = ``FIFO_SIZE``\ \*\ ``MAX_BYTES_PER_BURST`` /
   BUFFER_WIDTH_IN_BYTES

Interfaces and Signals
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Register Map Configuration Interface
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The register map configuration interface can be accessed through the AXI4-Lite
``S_AXI`` interface. The interface is synchronous to the ``s_axi_aclk``. The
``s_axi_aresetn`` signal is used to reset the peripheral and should be asserted
during system startup until the ``s_axi_aclk`` is active and stable.
De-assertion of the reset signal should by synchronous to ``s_axi_aclk``.

Data Interfaces
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

AXI-Streaming slave
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

The interface back-pressures through the ``s_axis_ready`` signal. If the core is
in the idle state the ``s_axis_ready`` signal will stay low until a descriptor
is submitted. The ``s_axis_ready`` will go low once the internal buffer of the
core is full. It will go high only after enough space is available to store at
least a burst (``MAX_BYTES_PER_BURST`` bytes); Once the current transfer is
finished and a new descriptor was not submitted the ``s_axis_ready`` will go
low. The ``s_axis_ready`` will go low also when the TLAST is used that asserts
unexpectedly. Unexpectedly means that the transfer length defined by TLAST is
shorter than the transfer length programmed in the descriptor (``X_LENGTH``
register). If the next descriptor was already submitted the ``s_axis_ready``
will assert within few cycles, in other hand will stay low until a new
descriptor is submitted.

The ``xfer_req`` is asserted once a transfer is submitted to the descriptor
queue and stays high until all data from the current transfer is received/send
through the AXI Stream/FIFO interface. If during the current transfer another
descriptor is queued (submitted) it will stay high and so on.

Configuration Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The peripheral features a register map configuration interface that can be
accessed through the AXI4-Lite ``S_AXI`` port. The register map can be used to
configure the peripherals operational parameters, query the current status of
the device and query the features supported by the device.

Peripheral Identification
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The peripheral contains multiple registers that allow the identification of the
peripheral as well as discovery of features that were configured at HDL
synthesis time. Apart from the ``SCRATCH`` register all registers in this
section are read only and writes to them will be ignored.

The ``VERSION`` (``0x000``) register contains the version of the peripheral. The
version determines the register map layout and general features supported by the
peripheral. The version number follows `semantic versioning <http://semver.org/>`_.
Increments in the major number indicate backwards incompatible changes, increments
in the minor number indicate backwards compatible changes, patch letter increments
indicate fixed incorrect behavior.

The ``PERIPHERAL_ID`` (``0x004``) register contains the value of the ``ID`` HDL
configuration parameter that was set during synthesis. Its primary function is
to allow to distinguish between multiple instances of the peripheral in the same
design.

The ``SCRATCH`` (``0x008``) register is a general purpose 32-bit register that
can be set to an arbitrary values. Reading the register will yield the value
previously written (The value will be cleared when the peripheral is reset).
It's content does not affect the operation of the peripheral. It can be used by
software to test whether the register map is accessible or store custom
peripheral associated data.

The ``IDENTIFICATION`` (``0x00c``) register contains the value of ``"DMAC"``.
This value is unique to this type of peripheral and can be used to ensure that
the peripheral exists at the expected location in the memory mapped IO register
space.

Interrupt Handling
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Interrupt processing is handled by three closely related registers. All three
registers follow the same layout, each bit in the register corresponds to one
particular interrupt.

When an interrupt event occurs it is recorded in the ``IRQ_SOURCE`` (``0x088``)
register. For a recorded interrupt event the corresponding bit is set to 1. If
an interrupt event occurs while the bit is already set to 1 it will stay set to
1.

The ``IRQ_MASK`` (``0x080``) register controls how recorded interrupt events
propagate. An interrupt is considered to be enabled if the corresponding bit in
the ``IRQ_MASK`` register is set to 0, it is considered to be disabled if the
bit is set to 1.

Disabling an interrupt will not prevent it from being recorded, but only its
propagation. This means if an interrupt event was previously recorded while the
interrupt was disabled and the interrupt is being enabled the interrupt event
will then propagate.

An interrupt event that has been recorded and is enabled propagates to the
``IRQ_PENDING`` (``0x084``) register. The corresponding bit for such an
interrupt will read as 1. Disabled or interrupts for which no events have been
recorded will read as 0. Also if at least one interrupt has been recorded and is
enabled the external ``irq`` signal will be asserted to signal the IRQ event to
the upstream IRQ controller.

A recorded interrupt event can be cleared (or acknowledged) by writing a 1 to
the corresponding bit to either the ``IRQ_SOURCE`` or ``IRQ_PENDING`` register.
It is possible to clear multiple interrupt events at the same time by setting
multiple bits in a single write operation.

For more details regarding interrupt operation see the :ref:`axi_dmac interrupts`.

Transfer Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``DEST_ADDRESS`` (``0x410``) register contains the destination address of
the transfer. The address must be aligned to the destination bus width.
Non-aligned addresses will be automatically aligned internally by setting the
LSBs to 0. This register is only valid if the DMA channel has been configured
for write to memory support.

The ``SRC_ADDRESS`` (``0x414``) register contains the source address of the
transfer. The address must be aligned to the source bus width. Non-aligned
addresses will be automatically aligned internally by setting the LSBs to 0.
This register is only valid if the DMA channel has been configured for write
from memory support.

The ``X_LENGTH`` (``0x418``) register contains the number of bytes to transfer
per row. The number of bytes is equal to the value of the register + 1 (E.g. a
value of 0x3ff means 0x400 bytes).

The ``Y_LENGTH`` (``0x41C``) register contains the number of rows to transfer.
The number of rows is equal to the value of the register + 1 (E.g. a value of
1079 means 1080 rows). This register is only valid if the DMA channel has been
configured with 2D transfer support. If 2D transfer support is disabled the
number of rows is always 1 per transfer.

The ``SRC_STRIDE`` (``0x424``) and ``DEST_STRIDE`` (``0x420``) registers contain
the number of bytes between the start of one row and the next row. Needs to be
aligned to the bus width. This field is only valid if the DMA channel has been
configured with 2D transfer support.

The total number of bytes transferred is equal to (``X_LENGTH`` + ``1``) \*
(``Y_LENGTH`` + ``1``).

The ``FLAGS`` (``0x40C``) register controls the behavior of the transfer.

- If the ``CYCLIC`` (``[0]``) bit is set the transfer will run in
  :ref:`axi_dmac cyclic-transfers`.
- If the ``TLAST`` (``[1]``) bit is set the TLAST signal will be asserted
  during the last beat of the AXI Stream transfer.

Transfer Submission
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Writing a 1 to the ``TRANSFER_SUBMIT`` (``0x408``) register queues a new
transfer. If the internal transfer queue is full the ``TRANSFER_SUBMIT`` bit
will stay asserted until room becomes available, the bit transitions back to 0
once the transfer has been queued. Writing a 0 to this register has no effect.
Writing a 1 to the register while it is already 1 will also have no effect. When
submitting a new transfer software should always check that the
``TRANSFER_SUBMIT`` [0] bit is 0 before setting it, otherwise the transfer will
not be queued.

If the DMA channel is disabled (``ENABLE`` control bit is set to 0) while a
queuing operation is in progress it will be aborted and the ``TRANSFER_SUBMIT``
bit will de-assert.

The ``TRANSFER_ID`` (``0x404``) register contains the ID of the next transfer.
The ID is generated by the DMA controller and can be used to check if a transfer
has been completed by checking the corresponding bit in the ``TRANSFER_DONE``
(``0x428``) register. The contents of this register is only valid if
``TRANSFER_SUBMIT`` is 0. Software should read this register before asserting
the ``TRANSFER_SUBMIT`` bit.

Transfer Status
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``TRANSFER_DONE`` (``0x428``) register indicates whether a submitted
transfer has been completed. Each bit in the register corresponds to transfer
ID. When a new transfer is submitted the corresponding bit in the register is
cleared, once the the transfer has been completed the corresponding bit will be
set.

The ``ACTIVE_TRANSFER_ID`` (``0x42C``) register holds the ID of the currently
active transfer. When no transfer is active the value of register will be equal
to the value of the ``TRANSFER_ID`` (``0x404``) register.

Transfer length reporting
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When using MM or FIFO source interfaces the amount of data which the core will
transfer is defined by ``X_LENGTH`` and ``Y_LENGTH`` registers in the moment of
the transfer submission. Once the corresponding bit from the ``TRANSFER_DONE``
is set the programmed amount of data is transferred.

When using streaming interface (AXIS) as source, the length of transfers will be
defined by the assertion of ``TLAST`` signal which is unknown at the moment of
transfer submission. In this case ``X_LENGTH`` and ``Y_LENGTH`` specified during
the transfer submission will act as upper limits for the transfer. Transfers
where the TLAST occurs ahead of programmed length will be noted as partial
transfers. If ``PARTIAL_REPORTING_EN`` bit from the ``FLAGS`` register is set,
the length of partial transfers will be recorded and exposed through the
``PARTIAL_TRANSFER_LENGTH`` and ``PARTIAL_TRANSFER_ID`` registers. The
availability of information regarding partial transfers is done through the
``PARTIAL_TRANSFER_DONE`` field of ``TRANSFER_DONE`` register.

During operation the ``TRANSFER_PROGRESS`` register can be consulted to check
the progress of the current transfer. The register presents the number of bytes
the destination accepted during the in progress transfer. This register will be
cleared once the transfer completes. This register should be used for debugging
purposes only.

Transfer Tear-down
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Non-cyclic transfers stop once the programmed amount of data is transferred to
the destination. Cyclic transfers needs to be stopped with software intervention
by setting the ``ENABLE`` control bit to 0. In case if required, non cyclic
transfers can be interrupted in the same way. The transfer tear down is done
gracefully and is done at a burst resolution on MM interfaces and beat
resolution on non-MM interfaces. DMAC shuts down gracefully as fast as possible
while completing all in-progress MM transactions.

Source side: For MM interface once the ``ENABLE`` bit de-asserts the DMAC won't
issue new requests towards the source interface but will wait until all pending
requests are fulfilled by the source. For non-MM interfaces, once the ``ENABLE``
bit de-asserts the DMAC will stop to accept new data. This will lead to partial
bursts in the internal buffer but this data will be cleared/lost once the
destination side completes all pending bursts.

Destination side: For MM interface the DMAC will complete all pending requests
that have been started by issuing the address. For non-MM interfaces once the
``ENABLE`` bit de-asserts the DMAC will stop to drive new data. All the data
from the internal buffer will be cleared/lost. In case of AXIS the DMAC will
wait for data to be accepted if valid is high since it can't just de-assert
valid without breaking the interface semantics

.. _axi_dmac interrupts:

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The DMA controller supports interrupts to allow asynchronous notification of
certain events to the CPU. This can be used as an alternative to busy-polling
the status registers. Two types of interrupt events are implemented by the DMA
controller.

The ``TRANSFER_QUEUED`` interrupt is asserted when a transfer is moved from the
register map to the internal transfer queue. This is equivalent to the
``TRANSFER_SUBMIT`` register transitioning from 1 to 0. Software can use this
interrupt as an indication that the next transfer can be submitted.

Note that a transfer being queued does not mean that it has been started yet. If
other transfers are already queued those will be processed first.

The ``TRANSFER_COMPLETED`` interrupt is asserted when a previously submitted
transfer has been completed. To find out which transfer has been completed the
``TRANSFER_DONE`` register should be checked.

Note that depending on the transfer size and interrupt latency it is possible
for multiple transfers to complete before the interrupt handler runs. In that
case the interrupt handler will only run once. Software should always check all
submitted transfers for completion.

2D Transfers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the ``DMA_2D_TRANSFER`` HDL synthesis configuration parameter is set the DMA
controller has support for 2D transfers.

A 2D transfer is composed of a number of rows with each row containing a certain
number of bytes. Between each row there might be a certain amount of padding
bytes that are skipped by the DMA.

For 2D transfers the ``X_LENGTH`` register configures the number of bytes per
row and the ``Y_LENGTH`` register configures the number of rows. The
``SRC_STRIDE`` and ``DEST_STRIDE`` registers configure the number of bytes in
between start of two rows.

E.g. the first row will start at the configured source or destination address,
the second row will start at the configured source or destination address plus
the stride and so on.

.. math::

   ROW\_SRC\_ADDRESS = SRC\_ADDRESS + SRC\_STRIDE * N

.. math::

   ROW\_DEST\_ADDRESS = DEST\_ADDRESS + DEST\_STRIDE * N

If support for 2D transfers is disabled only the X_LENGTH register is
considered and the number of rows per transfer is fixed to 1.

.. _axi_dmac cyclic-transfers:

Cyclic Transfers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the ``CYCLIC`` HDL synthesis configuration parameter is set the DMA
controller has support for cyclic transfers.

A cyclic transfer once completed will restart automatically with the same
configuration. The behavior of cyclic transfer is equivalent to submitting the
same transfer over and over again, but generates less software management
overhead.

A transfer is cyclic if the ``CYCLIC`` (``[0]``) bit of the ``FLAGS``
(``0x40C``) is set to 1 during transfer submission.

For cyclic transfers no end-of-transfer interrupts will be generated. To stop a
cyclic transfer the DMA channel must be disabled.

Any additional transfers that are submitted after the submission of a cyclic
transfer (and before stopping the cyclic transfer) will never be executed.

Scatter-Gather Transfers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the ``DMA_SG_TRANSFER`` HDL synthesis configuration parameter is set the DMA
controller has support for scatter-gather transfers.

The scatter-gather optional feature allows the DMA to access noncontiguous areas
of memory within a single transfer.

The DMA can read from or write to different memory addresses in one transaction
by using a list of vectors called *descriptors*. Each descriptor provides the
starting address and the length of the current memory block to be accessed, as
well as the next address of the following descriptor to be processed. By chaining
these descriptors, the DMA can *gather* the data into a contiguous transfer from
the *scattered* memory data from multiple addresses.

The scatter-gather has its own dedicated AXI3/4 memory mapped interface
``m_sg_axi`` through which it receives the descriptor data.

Descriptor Structure
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The scatter-gather interface fetches the descriptor information from memory in
the following order:

.. list-table::
   :header-rows: 1

   * - Size
     - Name
     - Description
   * - 32‑bit
     - flags
     - | This field includes 2 control bits:

       * bit0: if set, the transfer will complete after this last descriptor is
         processed and the DMA core will go back to idle state; if cleared, the
         next DMA descriptor pointed to by ``next_sg_addr`` will be loaded.
       * bit1: if set, an end-of-transfer interrupt will be raised after the
         memory segment pointed to by this descriptor has been transferred.
   * - 32‑bit
     - id
     - This field corresponds to an identifier of the descriptor.
   * - 64‑bit
     - dest_addr 
     - This field contains the destination address of the transfer.
   * - 64‑bit
     - src_addr
     - This field contains the source address of the transfer.
   * - 64‑bit
     - next_sg_addr
     - This field contains the address of the next descriptor.
   * - 32‑bit
     - y_len
     - This field contains the number of rows to transfer, minus one.
   * - 32‑bit
     - x_len
     - This field contains the number of bytes to transfer, minus one.
   * - 32‑bit
     - src_stride 
     - This field contains the number of bytes between the start of one row and
       the next row for the source address.
   * - 32-bit
     - dst_stride
     - This field contains the number of bytes between the start of one row and
       the next row for the destination address.

The ``y_len``, ``src_stride`` and ``dst_stride`` fields are only useful for 2D
transfers and should be set to 0 if 2D transfers are not required.

Transfer Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The scatter-gather transfers are enabled through the ``HWDESC`` bit from the
``CONTROL`` (``0x400``) register. Once this bit is set, cyclic transfers are
disabled, since the same cyclic behavior can be replicated using a descriptor
chain loop.

To start a scatter-gather transfer, the address of the first DMA descriptor must
be written to the register pair [``SG_ADDRESS_HIGH`` (``0x4BC``), ``SG_ADDRESS``
(``0x47C``)].

To end a scatter-gather transfer, the last descriptor of the transfer must have
the ``flags[0]`` bit set.

The scatter-gather transfer is queued in a similar way to the simple transfers,
through the ``TRANSFER_SUBMIT``. Software should always poll this bit to be 0
before setting it, otherwise the scatter-gather transfer will not be queued.

The scatter-gather transfers support the generation of the same two types of
interrupt events as the simple transfers. However, the scatter-gather transfers
have the distinct advantage of generating fewer interrupts by treating the
chained descriptor transfers as a single transfer, thus improving the performance
of the application.

Transfer Start Synchronization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the transfer start synchronization feature of the DMA controller is enabled
the start of a transfer is synchronized to a flag in the data stream. This is
primarily useful if the data stream does not have any back-pressure and one unit
of data spans multiple beats (e.g. packetized data). This ensures that the data
is properly aligned to the beginning of the memory buffer.

Data that is received before the synchronization flag is asserted will be
ignored by the DMA controller.

For the FIFO write interface the ``fifo_wr_sync`` signal is the synchronization
flag signal. For the AXI-Streaming interface the synchronization flag is carried
in ``s_axis_user[0]``. In both cases the synchronization flag is qualified by
the same control signal as the data.

Diagnostics interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For debug purposes a diagnostics interface is added to the core.
The ``dest_diag_level_bursts`` signal adds insight into the fullness of the
internal memory buffer during operation. The information is exposed in number
of bursts where the size of a burst is defined by the ``MAX_BYTES_PER_BURST``
parameter. The value of ``dest_diag_level_bursts`` increments for each burst
accumulated in the DMACs internal buffer. It decrements once the burst leaves
the DMAC on its destination port. The signal is synchronous to the destination
clock domain (``m_dest_axi_aclk`` or ``m_axis_aclk`` depending on ``DMA_TYPE_DEST``).

Limitations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

AXI 4kByte Address Boundary
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Software must program the ``SRC_ADDRESS`` and ``DEST_ADDRESS`` registers in such
way that AXI burst won't cross the 4kB address boundary. The following condition
must hold:

* ``MAX_BYTES_PER_BURST`` ≤ 4096;
* ``MAX_BYTES_PER_BURST`` is power of 2;
* ``SRC/DEST_ADDRESS`` mod ``MAX_BYTES_PER_BURST`` == 0
* ``SRC/DEST_ADDRESS[11:0]`` + MIN(``X_LENGTH``\ +1,\ ``MAX_BYTES_PER_BURST``) ≤ 4096

Address Alignment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Software must program the ``SRC_ADDRESS`` and ``DEST_ADDRESS``\ registers to be
multiple of the corresponding MM data bus. The following conditions must hold:

* ``SRC_ADDRESS`` MOD (``DMA_DATA_WIDTH_SRC``/8) == 0
* ``DEST_ADDRESS`` MOD (``DMA_DATA_WIDTH_DEST``/8) == 0

Transfer Length Alignment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Software must program the ``X_LENGTH`` register to be multiple of the widest
data bus. The following condition must hold:

-  (``X_LENGTH``\ +1) MOD MAX(``DMA_DATA_WIDTH_SRC``, ``DMA_DATA_WIDTH_DEST``)/8
   == 0

This restriction can be relaxed for the memory mapped interfaces. This is done
by partially ignoring data of a beat from/to the MM interface:

-  For write access the strobe bits are used to mask out bytes that do not
   contain valid data.
-  For read access a full beat is read but part of the data is discarded. This
   works fine as long as the read access is side effect free. I.e. this method
   should not be used to access data from memory mapped peripherals like a FIFO.

E.g. the length alignment requirement of a DMA configured for a 64-bit memory
mapped interface and a 16-bit streaming interface is only 2 bytes instead of 8
bytes.

Note that the address alignment requirement is not affected by this. The address
still needs to be aligned to the width of the MM interface that it belongs to.

Scatter-Gather Datapath Width
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The scatter-gather dedicated interface ``m_sg_axi`` currently supports only
64-bit transfers. ``DMA_DATA_WIDTH_SG`` can only be set to 64.

Software Support
--------------------------------------------------------------------------------

Analog Devices recommends to use the provided software drivers.

- :dokuwiki:`Analog Device AXI-DMAC DMA Controller Linux Driver
  <resources/tools-software/linux-drivers/axi-dmac>`

Known Issues
--------------------------------------------------------------------------------

1. When max bytes per burst matches the data width of destination interface an
erroneous extra beat is inserted after every valid beat on the destination side.
Example configuration:

* axi mm -> axi stream
* max bytes per burst = 128
* destination width = 1024 bits

Workaround: increase the max bytes per burst to larger than 128

Technical Support
--------------------------------------------------------------------------------

Analog Devices will provide limited online support for anyone using the core
with Analog Devices components (ADC, DAC, Video, Audio, etc) via the :ez:`fpga`.

Glossary
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Term
     - Description
   * - beat
     - Represents the amount of data that is transferred in one clock cycle.
   * - burst
     - Represents the amount of data that is transferred in a group of
       consecutive beats.
   * - partial transfer
     - Represents a transfer which is shorter than the programmed length that
       is based on the ``X_LENGTH`` and ``Y_LENGTH`` registers. This can occur
       on AXIS source interfaces when TLAST asserts earlier than the programmed
       length.

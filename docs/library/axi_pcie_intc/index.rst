.. _axi_pcie_intc:

AXI Custom Interrupt Controller for PCIe
================================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI PCIe Interrupt Controller <library/axi_pcie_intc>` is a
MSI/MSI-X request gate for PCIe endpoints. It sits between the level-sensitive
interrupt pins of the fabric peripherals and the endpoint, and delivers each
source to the host as an MSI/MSI-X message. Two endpoints are supported,
selected by ``PCIE_TYPE``:

* ``PCIE_TYPE = 0`` — Xilinx XDMA / AXI-Bridge. The core drives the
  ``usr_irq_req`` / ``usr_irq_ack`` handshake required by the
  `XDMA (DMA/Bridge Subsystem for PCI Express) <https://docs.amd.com/r/en-US/pg195-pcie-dma/Introduction>`__
  product guide (PG195), and the hard block emits the message.
* ``PCIE_TYPE = 1`` — any endpoint that offers no such request path, or where
  the MSI-X table belongs in the fabric. The core owns the MSI-X table and PBA
  and emits the message itself, as a single 32-bit AXI4 write of the vector's
  message data to its message address, through an AXI master that reaches the
  host.

The peripheral interrupt pins are **levels**. Wiring them straight to
``usr_irq_req`` loses any interrupt that arrives while an earlier one is still
asserted, because the endpoint only issues a message on the rising edge of a
request line. This core solves that: it latches a per-source pending bit, and
holds the vector's request until the host says it has finished with the vector,
keeps it low for a programmable number of cycles, and only then samples the
pending set again.

The pending bit belongs to the source and the request belongs to the vector, and
that split is what makes a shared vector work. A source is resampled as soon as
the host acknowledges it, so several sources can go pending under one asserted
request; the request drops when the host closes the vector, not when the pending
set happens to empty. A source that goes pending after the host has read the
pending set is therefore still delivered — it is what the next assertion of the
request carries.

Sources are **flat**. The core takes one ``intr[NUM_SOURCES-1:0]`` array,
samples each bit independently, and carries a writable route table saying which
vector each source is delivered on. Which sources share a vector is a runtime
decision, not a property of the bitstream: the source index is the whole
hardware contract, fixed by the concat order feeding ``intr``, and is what a
host driver uses as its hwirq.

.. note::

   This IP is used by the ADRV9009-ZU11EG/ADRV2CRR-FMC PCIe reference design
   to aggregate every fabric interrupt onto the XDMA user-interrupt bus. See
   :ref:`pcie-block-design` for the source map of that project.

Features
--------------------------------------------------------------------------------

* Bridges level-sensitive fabric interrupts to MSI/MSI-X, either through the
  PG195 ``usr_irq_req`` / ``usr_irq_ack`` handshake or by issuing the MSI write
  itself
* Up to 16 MSI/MSI-X vectors, up to 32 interrupt sources, each source with its
  own enable bit and its own pending bit
* Runtime-writable source-to-vector route table, writable while sources are
  enabled and pending, with no ordering requirement against the enable register
* Route table also readable per vector: which sources a vector owns, and which
  of them are pending
* Host write-1-to-clear acknowledge per source, and a separate per-vector
  register the host writes to release the request line
* MSI-X table and Pending Bit Array in the core's own aperture at
  ``PCIE_TYPE = 1``, the only storage for the message address and data
* Programmable re-arm low time on the request line, so the endpoint always sees
  a real edge on the next assertion
* Optional two-flop synchronization of asynchronous interrupt sources
* ``DELIVERED`` / ``ERROR`` / per-vector ``STATUS`` registers for diagnostics
* AXI4-Lite register interface

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_pcie_intc/axi_pcie_intc.v`
     - Verilog source for the peripheral.
   * - :git-hdl:`library/axi_pcie_intc/axi_pcie_intc_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - NUM_VECTORS
     - Number of MSI/MSI-X vectors, and the size of the MSI-X table. At
       ``PCIE_TYPE = 0`` it is also the width of ``usr_irq_req`` and must match
       the endpoint's ``xdma_num_usr_irq``. This is the ceiling on how finely
       sources can be separated, not a grouping.
   * - NUM_SOURCES
     - Width of the ``intr`` port, i.e. how many interrupt sources the core
       samples. Every source in the array is routed, tie-offs included, so this
       is the number of sources that exist.
   * - ASYNC_INTR
     - Whether the ``intr`` port is asynchronous to ``s_axi_aclk`` and must be
       synchronized internally.
   * - REARM_CYCLES
     - Cycles a vector's request is held low after it is released, before the
       pending set is sampled again. Must be at least 1. ``PCIE_TYPE = 0`` only;
       there is no request line to re-arm at ``PCIE_TYPE = 1``.
   * - PCIE_TYPE
     - How a message is delivered. 0 drives the endpoint's
       ``usr_irq_req`` / ``usr_irq_ack`` handshake and lets it emit the message;
       1 owns the MSI-X table and PBA and issues the MSI write through
       ``m_axi``.
   * - M_AXI_ADDR_WIDTH
     - Width of the MSI write master's address, for when the master feeds an
       address bridge whose aperture is narrower than the host address space it
       maps into. The message address is programmed as a full 64-bit pair
       whatever this is; bits at or above this width are dropped, so an address
       that does not fit the aperture is a configuration error.

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - s_axi_aclk
     - AXI clock. The whole core, including the register file, the request gate
       and the MSI write master, runs in this domain.
   * - s_axi_aresetn
     - AXI reset, synchronous active low reset.
   * - s_axi
     - AXI-Lite bus slave, memory mapped bus that provides access to the
       module's register map.
   * - intr
     - Level-sensitive interrupt sources, ``NUM_SOURCES`` bits wide. Bit ``s``
       is source ``s``, and that index is what ``SRC_ENABLE``, ``SRC_PENDING``
       and ``SRC_ROUTE`` are indexed by. Which vector a source is delivered on
       is not visible here at all. Unused bits need no tie-off; the IP-XACT
       packaging gives the port a driver value of 0.
   * - m_axi
     - MSI write master, ``PCIE_TYPE = 1`` only. Write-only, one 32-bit beat at
       a time, one outstanding write. Tied off and hidden by the packaging at
       ``PCIE_TYPE = 0``.
   * - usr_irq_req
     - User interrupt request bus to the PCIe endpoint, one bit per vector.
       ``PCIE_TYPE = 0`` only.
   * - usr_irq_ack
     - User interrupt acknowledge from the endpoint, one bit per vector. It is
       one of the two conditions that release a request, so it must be
       connected: a vector whose acknowledge never arrives stays asserted and
       delivers nothing further. It also sets the sticky ``DELIVERED`` bits.
       ``PCIE_TYPE = 0`` only.

Clocking
--------------------------------------------------------------------------------

The core is single-clock: the register file, the request gate, the MSI write
master and the synchronizers are all clocked by ``s_axi_aclk``. In the XDMA
reference design this is the 250 MHz PCIe AXI clock generated by the endpoint.
When the interrupt sources come from another clock domain, set
``ASYNC_INTR = 1`` so the ``intr`` inputs pass through a two-flop synchronizer
before they are sampled.

Register Map
--------------------------------------------------------------------------------

The AXI address bus is 16 bits wide, so the core claims a full 64 KiB window.
That window holds four blocks: the global registers, one read-only block per
vector, the route table, and the MSI-X table with its Pending Bit Array.

The driver reaches every register by offset, with nothing in the device tree to
correct, so reserved words stay reserved rather than being compacted away. All
reserved offsets read back zero, including the per-vector ``+0x00``, ``+0x04``
and ``+0x08``, which earlier carried per-vector ``ENABLE``, ``PENDING`` and
``RAW`` registers and are not recycled.

Global registers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 12 18 12 58
   :header-rows: 1

   * - Address
     - Name
     - Access
     - Description
   * - 0x0000
     - VERSION
     - R
     - Core version, ``{MAJOR[15:0], MINOR[7:0], PATCH[7:0]}`` (0x0001_0000).
       The register map is not versioned field by field, so a mismatch means
       refuse, not degrade.
   * - 0x0008
     - SCRATCH
     - RW
     - Scratch register, no hardware effect. Useful as a read/write presence
       check.
   * - 0x000C
     - MAGIC
     - R
     - Identification constant ``0x494E_5443`` (ASCII ``"INTC"``).
   * - 0x0010
     - CONFIG
     - R
     - Build-time configuration: bits [23:16] = ``PCIE_TYPE``, bits [15:8] =
       ``NUM_SOURCES``, bits [7:0] = ``NUM_VECTORS``.
   * - 0x0018
     - DELIVERED
     - R/W1C
     - Sticky, one bit per vector, set when the message reached the host: by
       ``usr_irq_ack`` at ``PCIE_TYPE = 0``, by an ``OKAY`` write response at
       ``PCIE_TYPE = 1``. Diagnostic only.
   * - 0x001C
     - ERROR
     - R/W1C
     - Sticky, one bit per vector, set when an MSI write returned a response
       other than ``OKAY``. ``PCIE_TYPE = 1`` only; reads zero otherwise.
   * - 0x0040
     - SRC_ENABLE
     - RW
     - One bit per source. A source is only sampled while its enable bit is
       set. Clearing a bit also drops that source's pending bit, so a teardown
       leaves nothing behind.
   * - 0x0044
     - SRC_PENDING
     - R/W1C
     - One bit per source, the set the host owes acknowledges for. The host
       reads it to identify the sources, then writes 1 to the bits it handled.
   * - 0x0048
     - VEC_SVC
     - R
     - One bit per vector, set when the host has claimed vector ``v`` and
       cleared when the request is released, so the readback is the set of
       vectors whose pass the host has opened and not yet finished.
       ``PCIE_TYPE = 0`` only.
   * - 0x004C
     - VEC_CLEAR
     - W
     - One bit per vector. Writing 1 to bit ``v`` releases vector ``v``
       regardless of the acknowledge. Reads zero. ``PCIE_TYPE = 0`` only.
   * - 0x0050
     - SRC_CLAIM
     - R
     - Returns what ``SRC_PENDING`` returns, and the read announces every bit
       it returned. The only read in the map with a side effect. Because the
       word covers every source, the read claims every vector.

Per-vector registers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each vector ``v`` (``0 … NUM_VECTORS-1``) has a read-only 32-byte block at base
address ``0x0200 + v * 0x20``. The offsets below are relative to that base.

.. list-table::
   :widths: 12 18 12 58
   :header-rows: 1

   * - Offset
     - Name
     - Access
     - Description
   * - +0x10
     - STATUS
     - R
     - Bit [0] ``req`` (the request line is asserted), bit [1] ``rearming``
       (the request is in its re-arm low time), bit [2] ``delivered`` (mirror of
       this vector's ``DELIVERED`` bit), bit [3] ``outstanding`` (a message is
       owed to the host, waiting for the bus or on it), bit [4] ``error``
       (mirror of this vector's ``ERROR`` bit), bit [5] ``acked``
       (``usr_irq_ack`` has been seen for this assertion), bit [6] ``serviced``
       (the host has claimed this vector). Bits [4:3] are
       ``PCIE_TYPE = 1`` only, bits [6:5] and bit [1] are ``PCIE_TYPE = 0``
       only, and each reads zero in the other mode. Bits [6:5] are the wedge
       diagnostic on a request that will not fall: neither set means the host
       has not been reached, [6] clear alone means it has not read, and both set
       mean it has read and not finished acknowledging, in which case
       ``VEC_PENDING`` says what it still owes.
   * - +0x14
     - VEC_PENDING
     - R
     - One bit per source: routed to this vector **and** pending. This is the
       set of sources the vector owes acknowledges for, correct across a
       re-route with no ordering rule to observe.
   * - +0x18
     - VEC_MEMB
     - R
     - One bit per source: routed to this vector.
   * - +0x1C
     - VEC_CLAIM
     - R
     - Returns what ``VEC_PENDING`` returns, and the read announces every bit
       it returned. This is the read a handler dispatches from; ``VEC_PENDING``
       is the same data with no side effect, for polling and for debug.

``VEC_PENDING`` and ``VEC_MEMB`` are the route table read the other way round,
per vector instead of per source, so a dispatcher needs no copy of the route
table on the host side to keep in step across a move.

Route table
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 22 18 12 48
   :header-rows: 1

   * - Address
     - Name
     - Access
     - Description
   * - 0x0400 + s * 4
     - SRC_ROUTE[s]
     - RW
     - Which vector source ``s`` is delivered on. Only
       ``clog2(NUM_VECTORS)`` bits are stored; the rest read zero. Resets to 0,
       so an unprogrammed controller puts every source on vector 0, which is a
       working configuration.

An entry may be written at any time, including on a source that is enabled and
pending: a pending bit that moves leaves the destination vector owing a
message, so nothing has to be quiesced and ``SRC_ROUTE`` and ``SRC_ENABLE``
writes have no ordering requirement between them. Rewriting the same value is a
no-op and does not disturb a delivery in flight. When ``NUM_VECTORS`` is not a
power of two, a value at or above ``NUM_VECTORS`` matches no vector and is
never delivered.

MSI-X table and PBA
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This block exists at ``PCIE_TYPE = 1`` only; at ``PCIE_TYPE = 0`` the
endpoint's own table is what the host programs, and this region reads zero and
ignores writes.

The MSI-X table is at ``0x8000``, 16 bytes per vector, in the layout the PCIe
specification fixes. The Pending Bit Array is one read-only dword at
``0x8FE0``, one bit per vector. Both offsets are fixed in the core, so they are
constants on the host side and what the endpoint advertises is these plus
wherever the design maps this slave inside the BAR.

.. list-table::
   :widths: 22 18 12 48
   :header-rows: 1

   * - Address
     - Name
     - Access
     - Description
   * - 0x8000 + v * 0x10
     - MSG_ADDR_LO[v]
     - RW
     - Message address, low 32 bits. This is the **host** address and is issued
       verbatim; the core applies no translation, so any PL-to-host window
       offset belongs on the path from ``m_axi`` to the endpoint.
   * - +0x04
     - MSG_ADDR_HI[v]
     - RW
     - Message address, high 32 bits.
   * - +0x08
     - MSG_DATA[v]
     - RW
     - Message data, written as the single 32-bit beat.
   * - +0x0C
     - VEC_CTRL[v]
     - RW
     - Bit [0] mask, resets to 1. Bits [31:1] read zero.
   * - 0x8FE0
     - PBA
     - R
     - One bit per vector: a message is owed and the mask is why it has not
       been sent.

This is the only storage and the only address for the message address and data,
whether the host runs the vector as MSI-X or as MSI: in MSI-X the host writes it
over the BAR, in MSI whoever mirrors config space writes it over AXI. The two
writers are mutually exclusive because the modes are. A mirror driving MSI must
also clear vector control, since it resets masked.

Theory of Operation
--------------------------------------------------------------------------------

Sampling is **per source**, so acknowledging one source neither delays nor
disturbs another sharing its vector. Each source has three mutually exclusive
arms, and nothing delays any of them:

#. **Resample** — while the pending bit is zero, the core samples
   ``intr[s] & SRC_ENABLE[s]`` into it. A level the host acknowledged and has
   not cleared at its source goes pending again the cycle after, which is what
   it should do: the device still wants service.
#. **Active** — while the pending bit is set, only the host clears it, by
   writing 1 to that bit of ``SRC_PENDING``. The bit is a snapshot, not a live
   view: a level that rose meanwhile is picked up by the next resample as a
   fresh request.
#. **Teardown** — a write that clears ``SRC_ENABLE[s]`` drops the pending bit.
   Safe because a source is a level held until its driver clears the condition,
   so re-enabling resamples a level that is still asserted. This defers an
   interrupt rather than losing it, and it is the only way a request is ever
   discarded.

A vector's request is *not* simply "some source routed here is pending". That
would be a wedge on any shared vector: a source going pending after the host has
read the pending set gets no handler in that pass, so its ``SRC_PENDING`` bit is
never written back, the request never falls, and the vector stops delivering for
every source on it. What the request tracks instead is the set the host has *not
yet been told about*, and the host's dispatch read is what draws that line: a
read of ``VEC_CLAIM`` or ``SRC_CLAIM`` returns the pending set and announces
exactly the word it returned, so a source arriving after it is still unannounced
and still owed a message. How that becomes a message depends on ``PCIE_TYPE``.

Delivery through usr_irq_req (PCIE_TYPE = 0)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``usr_irq_req[v]`` is a gate the vector owns, with three edges:

#. **Assert** — while the request is low and out of its re-arm delay, it goes
   high if any source routed to the vector is pending and unannounced. Pending
   alone is not enough: a source the host has already been told about is the
   host's to finish, and asserting on it again is a second doorbell for work in
   progress.
#. **Release** — the request drops once ``usr_irq_ack[v]`` has been asserted,
   the host has claimed the vector, and every source that claim covered has been
   acknowledged. This is exactly what PG195 requires of a level-based user
   interrupt: a request bit must stay asserted until both the corresponding
   acknowledge has been asserted and the interrupt has been serviced and cleared
   by the host. The acknowledge and the claim are latched, so their order does
   not matter and neither has to be caught in the cycle it happens, and they are
   latched only while the request is asserted, so an acknowledge left over from
   the previous assertion cannot close the next one. The drain is not latched: it
   is a level, and the point is that it is still true at the release. A vector
   holding nothing counts as claimed and drained — there is nothing to hand over
   — which is what releases one emptied behind the host's back.

   The drain is *pending and announced*, not all pending. A source that goes
   pending after the claim is not announced, so it does not hold the request:
   the request covers the one pass the host claimed, and the late source is the
   next pass's, delivered by a new edge rather than by extending this one. Over
   all pending it would be the wedge above. What this costs is the falling edge:
   it waits for the host's last acknowledge of the pass rather than its first
   read, so a source sharing the vector waits out the pass. What it buys is that
   the host is never handed a set it is already working on, so no pass ever
   re-dispatches another pass's source.
#. **Re-arm** — the request then stays low for ``REARM_CYCLES`` before it can
   assert again, so the hard block sees a real edge. One cycle is a legitimate
   falling edge, but the width the hard block needs to re-trigger is
   unspecified, so the default is 4.

A request can outlive the sources that raised it: ``VEC_PENDING`` reads zero
under a request that is still waiting on its acknowledge. Two host actions on a
pending source empty a vector that way — clearing ``SRC_ENABLE[s]`` drops the
pending bit, and moving ``SRC_ROUTE[s]`` hands it to another vector. Neither
loses an interrupt, and neither leaves the host anything to do: after a re-route
the destination vector owes the message, and the vector left behind has nothing
left to drain, so it releases on the acknowledge alone.

``VEC_CLEAR`` is the release that waits on nothing, and the one release the host
has to ask for. It exists for the vector whose acknowledge never arrived, which
is the only state neither the endpoint nor a claim can get out of. A reset
routine should write it for every vector before enabling anything, and bits [6:5]
of a vector's ``STATUS`` say which of the two conditions a stuck request is
waiting on.

Delivery by the core (PCIE_TYPE = 1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When the endpoint cannot be asked to emit a message from the fabric, the core
issues it itself, and the write response takes over the role ``usr_irq_ack``
played — ``OKAY`` sets ``DELIVERED``, anything else sets ``ERROR``.

What arms a write is the same per-source announcement bit the gate uses, "the
host has been told about this source on the vector it is currently routed to". A
vector asks for a message whenever it holds a pending source that is not yet
announced. Two things set an announcement, and both mean *told*: a message
launched for the source, and a claim read that covered it. Three things clear
one, and each is a case a level-based doorbell has to cover:

* the source stops being pending — the ordinary end of a request
* a fresh source goes pending — a second source joining a vector that is
  already asserted still owes a message, because a level has no second edge
* ``SRC_ROUTE[s]`` changes — the pending bit moved to another vector, which now
  owes the message

Announcement is set on **launch**, not on the write response, because a posted
write's response can return after the host has already acknowledged. The cost
is bounded and one-sided: a source going pending between the launch and the
host's dispatch read is serviced by that read but never announced, so it draws
one extra message the host finds nothing for. This spends a spurious interrupt,
it never loses one.

A vector issues only once a non-zero message address has been programmed and
its vector control says unmasked. Until then the request is **held**, not
dropped, so an interrupt that predates that setup is late rather than lost —
which is what makes mask, rewrite, unmask a safe update order. A masked vector
with a message owed shows in the PBA. Arbitration is lowest vector index first,
one outstanding write; the ``outstanding`` bit of a vector's ``STATUS`` says a
message is still owed.

Working with the Core
--------------------------------------------------------------------------------

Software identifies the core by reading ``MAGIC`` and ``VERSION``, then
``CONFIG`` for ``NUM_SOURCES``, ``NUM_VECTORS`` and ``PCIE_TYPE``. Bringing up
a source is: write ``SRC_ROUTE[s]`` with the vector to deliver it on, then set
bit ``s`` of ``SRC_ENABLE``.

On an interrupt, read ``VEC_CLAIM`` of the vector that fired — or ``SRC_CLAIM``,
when the delivery mechanism does not say which vector it was — then service the
sources that read returned and write their bits back to ``SRC_PENDING``. That is
the whole of the handler: the claim read opens the pass and the last of those
writes closes it, and there is nothing extra to write at the end, and nothing to
close after tearing a source down. A source that went pending during the pass is
delivered by the next assertion rather than by looping the read.

Both halves matter at ``PCIE_TYPE = 0``. The claim is what tells the controller
where the snapshot ended, and the acknowledges are what release the request, so a
handler that defers them — a threaded EOI, for instance — holds the vector for
every source on it until they land.

Read ``VEC_PENDING`` or ``SRC_PENDING`` instead wherever the point is to look
rather than to dispatch — a poll, a diagnostic, an ``/proc`` dump. Those reads
announce nothing, so they neither release a live request nor suppress a message
the host has not really taken.

Moving a source to another vector, for instance when the host moves an
interrupt to another CPU, is a single ``SRC_ROUTE[s]`` write with no quiesce
and no ordering against ``SRC_ENABLE``.

In an ADI PCIe project the controller is instantiated and wired by the
``ad_pcie_interrupt`` Tcl procedure. The first call creates the ``pcie_intc``
instance, takes ``NUM_VECTORS`` from the endpoint's ``xdma_num_usr_irq``
configuration and connects ``usr_irq_req`` and ``usr_irq_ack`` to it; each
subsequent call attaches one more peripheral interrupt pin to the ``intr`` port
and grows ``NUM_SOURCES`` to match.

.. code:: tcl

   ad_pcie_interrupt axi_spi/ip2intc_irpt
   ad_pcie_interrupt axi_gpio1/ip2intc_irpt
   ad_pcie_interrupt axi_adrv9009_som_rx_dma/irq

Sources are assigned in call order, so the ``intr`` index of a source is its
position in the sequence of ``ad_pcie_interrupt`` calls. That index is the source
number the register map uses and the value the corresponding device-tree node
must place in its ``interrupts`` property, so adding or reordering calls shifts
every source below it and the device tree has to be kept in sync. It is not a
vector number: which vector delivers a source is the driver's ``SRC_ROUTE``
write, made after enumeration.

For more information regarding the custom ``.tcl`` procedures, like ``ad_pcie_interrupt``,
used in the PCIe implementation, please check the :git-hdl:`projects/scripts/adi_board.tcl`
file.

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/axi_pcie_intc`
* :ref:`pcie-block-design` — usage in the ADRV9009-ZU11EG / ADRV2CRR-FMC PCIe
  reference design
* `XDMA product guide (PG195)
  <https://docs.amd.com/r/en-US/pg195-pcie-dma/Introduction>`__

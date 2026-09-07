.. _axi_pcie_intc:

AXI Custom Interrupt Controller for PCIe
================================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI PCIe Interrupt Controller <library/axi_pcie_intc>` is a
MSI/MSI-X request gate for Xilinx PCIe endpoints (XDMA). It sits between the
level-sensitive interrupt pins of the fabric peripherals and the ``usr_irq_req``
user-interrupt bus of the endpoint, implementing the handshake required by the
`XDMA (DMA/Bridge Subsystem for PCI Express) <https://docs.amd.com/r/en-US/pg195-pcie-dma/Introduction>`__
product guide (PG195) so that each source can drive its own MSI/MSI-X vector to
the host.

The peripheral interrupt pins are **levels**. Wiring them straight to
``usr_irq_req`` loses any interrupt that arrives while an earlier one is still
asserted, because the endpoint only issues a message on the rising edge of a
request line. This core solves that: it holds ``usr_irq_req[v]`` asserted until
the host acknowledges the vector by clearing its ``PENDING`` register, keeps the
line low for a programmable number of cycles, and only then resamples the
sources. It also exposes per-vector enable masks and a set of read-only
diagnostic registers over an AXI4-Lite interface.

.. note::

   This IP is used by the ADRV9009-ZU11EG/ADRV2CRR-FMC PCIe reference design
   to aggregate every fabric interrupt onto the XDMA user-interrupt bus. See
   :ref:`pcie-block-design` for the source-to-vector map of that project.

Features
--------------------------------------------------------------------------------

* Bridges level-sensitive fabric interrupts to the endpoint ``usr_irq_req`` /
  ``usr_irq_ack`` handshake, per the PG195 contract
* Up to 16 MSI/MSI-X vectors (``usr_irq_req`` lines)
* Up to 32 interrupt sources aggregated per vector, each with its own enable bit
* Per-vector ``PENDING`` snapshot with host write-1-to-clear acknowledge
* Programmable re-arm delay before the sources are resampled
* Optional two-flop synchronization of asynchronous interrupt sources
* Read-only ``RAW`` / ``STATUS`` / ``DELIVERED`` registers for diagnostics
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
     - Number of ``usr_irq_req`` lines, i.e. MSI/MSI-X vectors. Must match the
       endpoint's ``xdma_num_usr_irq``. Also the number of ``intr_<v>`` ports in
       use.
   * - SRC_PER_VEC
     - Interrupt sources aggregated onto each vector, i.e. the width of every
       ``intr_<v>`` port. 1 means no aggregation.
   * - ASYNC_INTR
     - Whether the ``intr_<v>`` ports are asynchronous to ``s_axi_aclk`` and must
       be synchronized internally.
   * - REARM_CYCLES
     - Number of cycles ``usr_irq_req[v]`` is held low after an acknowledge,
       before the sources are resampled.

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - s_axi_aclk
     - AXI clock. The whole core, including the register file and the request
       gate, runs in this domain.
   * - s_axi_aresetn
     - AXI reset, synchronous active low reset.
   * - s_axi
     - AXI-Lite bus slave, memory mapped bus that provides access to the
       module's register map.
   * - intr_0
     - Level-sensitive interrupt source port for vector 0, ``SRC_PER_VEC`` bits
       wide.
   * - intr_1
     - Level-sensitive interrupt source port for vector 1.
   * - intr_2
     - Level-sensitive interrupt source port for vector 2.
   * - intr_3
     - Level-sensitive interrupt source port for vector 3.
   * - intr_4
     - Level-sensitive interrupt source port for vector 4.
   * - intr_5
     - Level-sensitive interrupt source port for vector 5.
   * - intr_6
     - Level-sensitive interrupt source port for vector 6.
   * - intr_7
     - Level-sensitive interrupt source port for vector 7.
   * - intr_8
     - Level-sensitive interrupt source port for vector 8.
   * - intr_9
     - Level-sensitive interrupt source port for vector 9.
   * - intr_10
     - Level-sensitive interrupt source port for vector 10.
   * - intr_11
     - Level-sensitive interrupt source port for vector 11.
   * - intr_12
     - Level-sensitive interrupt source port for vector 12.
   * - intr_13
     - Level-sensitive interrupt source port for vector 13.
   * - intr_14
     - Level-sensitive interrupt source port for vector 14.
   * - intr_15
     - Level-sensitive interrupt source port for vector 15. All sixteen source
       ports are declared, but those at or above ``NUM_VECTORS`` are hidden by
       the IP-XACT packaging and tie low.
   * - usr_irq_req
     - User interrupt request bus to the PCIe endpoint, one bit per vector.
   * - usr_irq_ack
     - User interrupt acknowledge from the endpoint. Feeds the ``DELIVERED``
       diagnostic register only; it is not required for correct operation and
       may be left unconnected.

Clocking
--------------------------------------------------------------------------------

The core is single-clock: the register file, the request gate and the
synchronizers are all clocked by ``s_axi_aclk``. In the PCIe reference design
this is the 250 MHz PCIe AXI clock generated by the XDMA endpoint. When the
interrupt sources come from another clock domain, set ``ASYNC_INTR = 1`` so the
``intr_<v>`` inputs pass through a two-flop synchronizer before they are sampled.

Register Map
--------------------------------------------------------------------------------

The register file is split into a global block at the bottom of the address
space and one identical block per vector. The AXI address bus is 16 bits wide
(64 KiB), which is why the core claims a full 64 KiB window when it is mapped
into the endpoint's ``M_AXI_B`` BAR.

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
   * - 0x0008
     - SCRATCH
     - RW
     - Scratch register, no hardware effect. Useful as a read/write presence
       check.
   * - 0x000C
     - MAGIC
     - R
     - Identification constant ``0x5049_4E54`` (ASCII ``"PINT"``).
   * - 0x0010
     - CONFIG
     - R
     - Build-time configuration: bits [15:8] = ``SRC_PER_VEC``, bits [7:0] =
       ``NUM_VECTORS``.
   * - 0x0018
     - DELIVERED
     - R/W1C
     - Sticky, one bit per vector, set when the endpoint asserts
       ``usr_irq_ack``. Diagnostic only; write 1 to a bit to clear it.

Per-vector registers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each vector ``v`` (``0 … NUM_VECTORS-1``) has a 32-byte block at base address
``0x0200 + v * 0x20``. The offsets below are relative to that base. All fields
are ``SRC_PER_VEC`` bits wide unless noted.

.. list-table::
   :widths: 12 18 12 58
   :header-rows: 1

   * - Offset
     - Name
     - Access
     - Description
   * - +0x00
     - ENABLE
     - RW
     - Per-source enable mask. A source only contributes to the vector when its
       enable bit is set.
   * - +0x04
     - PENDING
     - R/W1C
     - Latched snapshot of the enabled sources that raised the current request.
       The host reads it to identify the source, then writes 1 to the
       corresponding bit(s) to acknowledge. When it clears to zero the re-arm
       delay starts.
   * - +0x0C
     - RAW
     - R
     - Live, post-synchronization level of the sources on this vector,
       independent of the enable mask.
   * - +0x10
     - STATUS
     - R
     - Bit [0] ``req`` (this vector's ``usr_irq_req`` output), bit [1]
       ``rearming`` (holding low before resample), bit [2] ``delivered``
       (mirror of this vector's ``DELIVERED`` bit).

Theory of Operation
--------------------------------------------------------------------------------

Each vector owns an independent request gate; there is no central delivery
state machine. For a given vector, the ``PENDING`` register is a **snapshot**
rather than a live accumulator, which is what prevents the vector from wedging
when sources keep toggling under load. The gate moves through three mutually
exclusive phases:

#. **Resample** — while ``PENDING`` is zero and the re-arm counter has elapsed,
   the core samples the enabled sources (``intr_<v> & ENABLE``) into
   ``PENDING``. If any enabled source is high, ``PENDING`` becomes non-zero.
#. **Active** — as soon as ``PENDING`` is non-zero, ``usr_irq_req[v]`` is
   asserted and stays asserted. The host services the interrupt and writes 1 to
   the ``PENDING`` bits it handled (write-1-to-clear). New sources are **not**
   folded in while a request is active.
#. **Re-arm** — when the last ``PENDING`` bit is cleared, ``usr_irq_req[v]``
   deasserts and the core holds it low for ``REARM_CYCLES`` before returning to
   the resample phase. This guarantees the endpoint sees a clean low-to-high
   edge for the next message.

Holding the request until the host clears ``PENDING`` is the behavior PG195
requires for level-based user interrupts; the deliberate low time on re-arm
guarantees the next assertion is seen as a new edge, so no interrupt is missed
even when a source re-asserts immediately.

The ``usr_irq_ack`` input is not part of this loop. It only sets the sticky
``DELIVERED`` bits, which — together with ``RAW`` and the ``STATUS`` flags — let
software confirm that a vector was actually delivered to the host without
disturbing the request logic.

Working with the Core
--------------------------------------------------------------------------------

In an ADI PCIe project the controller is instantiated and wired by the
``ad_pcie_interrupt`` Tcl procedure. The first call creates the ``pcie_intc``
instance and connects its ``usr_irq_req`` bus to the XDMA endpoint; each
subsequent call attaches one more peripheral interrupt pin to the next
``intr_<v>`` port and grows the endpoint's user-interrupt vector count to match.

.. code:: tcl

   ad_pcie_interrupt axi_spi/ip2intc_irpt
   ad_pcie_interrupt axi_gpio1/ip2intc_irpt
   ad_pcie_interrupt axi_adrv9009_som_rx_dma/irq

Because vectors are assigned in call order, the ``intr_<v>`` index of a source
is simply its position in the sequence of ``ad_pcie_interrupt`` calls. That same
index is the MSI/MSI-X vector the host sees and the value the corresponding
device-tree node must place in its ``interrupts`` property, so adding or
reordering calls shifts every vector below it and the device tree has to be kept
in sync.

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

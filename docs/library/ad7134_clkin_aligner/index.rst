.. _ad7134_clkin_aligner:

AD7134 CLKIN Aligner
===============================================================================

.. hdl-component-diagram::
   :path: library/clkin_aligner

The :git-hdl:`AD7134 CLKIN Aligner <library/clkin_aligner>` is a custom IP that gates a
free-running clock (the 48 MHz XTAL2_CLKIN for the AD7134) through a Xilinx
``BUFGCE`` and starts, stops and counts its edges deterministically. It provides
the hardware infrastructure required by the
``AD7134_Startup_Sequence_Deterministic_Phase_Alignment`` protocol to
obtain a deterministic ``dig_clk`` phase across power-mode changes, so that the
two ADCs of a dual-AD7134 setup align to the same conversion phase.

The gate output (``clk_out``) drives both the FMC XTAL2_CLKIN pin and the ODR
pulse generator, so stopping the gate also stops ODR generation. The AXI-Lite
configuration clock is fully independent of ``clk_in``, so SPI register access
to the ADC keeps working while XTAL2_CLKIN is held stopped.

Features
-------------------------------------------------------------------------------

- Glitch-free clock gating using a ``BUFGCE`` with a negedge-registered enable
  (the gated clock always stops LOW).
- One-time startup procedure delivering an exact number of pulses (default 36).
- Deterministic stop on a divide-by-32 boundary.
- Edge counter with a programmable target that raises an interrupt at a chosen
  edge (default edge 146).
- ODR re-registration onto the gated clock domain to align ODR transitions to
  XTAL2_CLKIN.
- Force on / force off controls for multi-device simultaneous restart.
- Three maskable interrupt sources (startup done, stop-at-align done, edge
  target reached).
- AXI-Lite based configuration; clock-domain crossing handled internally.

Files
-------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/clkin_aligner/clkin_aligner.v`
     - Verilog top module: FSM, /32 phase counter, edge counter and ``BUFGCE``
       gate.
   * - :git-hdl:`library/clkin_aligner/clkin_aligner_regmap.v`
     - AXI register map and clock-domain crossing between the AXI clock and
       ``clk_in``.
   * - :git-hdl:`library/clkin_aligner/clkin_aligner_ip.tcl`
     - Tcl source describing the instance for Vivado.
   * - :git-hdl:`library/clkin_aligner/clkin_aligner_constr.sdc`
     - Timing constraints for the IP.

Configuration Parameters
-------------------------------------------------------------------------------

.. hdl-parameters::
   :path: library/clkin_aligner

   * - ID
     - Core ID, reported in the ``PERIPHERAL_ID`` register; should be unique for
       each instance in the system.
   * - STARTUP_CYCLES_DEFAULT
     - Reset value of the ``STARTUP_CYCLES`` register: number of pulses delivered
       during the startup procedure. Software can override it at runtime.
   * - EDGE_TARGET_DEFAULT
     - Reset value of the ``EDGE_TARGET`` register: delivered-edge index after
       ``RESUME`` at which the edge-target interrupt fires.

Interface
-------------------------------------------------------------------------------

.. hdl-interfaces::
   :path: library/clkin_aligner

Detailed Description
-------------------------------------------------------------------------------

The IP consists of two modules. ``clkin_aligner_regmap`` implements the AXI
register map and all clock-domain crossing: control strobes and levels are
synchronized from the AXI clock into ``clk_in``, while status, counters and
event pulses are synchronized back. ``clkin_aligner`` contains the datapath in
the ``clk_in`` domain: the gating FSM, the divide-by-32 phase counter, the
delivered-edge counter and the ``BUFGCE`` instance.

Clock path
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

   axi_sdpclk_clkgen (48 MHz)
       |
       v  clk_in
   clkin_aligner --- BUFGCE (gate) --- clk_out --+--> XTAL2_CLKIN (FMC pin)
       |  (AXI regs)                              +--> ODR generator ext_clk
       v
   irq --> PS interrupt

The enable of the ``BUFGCE`` is registered on the **falling** edge of ``clk_in``
(``gate_en_neg``). This is the Xilinx-recommended way to change ``CE`` and
guarantees that ``clk_out`` always stops while ``clk_in`` is LOW, with no runt
pulses and without any software timing care.

Finite state machine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

                 STARTUP_FIRE
   ST_IDLE ---------------------> ST_STARTUP --(cycles done)--> ST_STOPPED_LOW
     |                                                                 ^
     | ARM_STOP_AT_ALIGN                                       RESUME   |
     v                                                                  v
   ST_ARMED --(clk_div32 negedge)-------------------------------> ST_RUNNING
                 (also from RUNNING)                                    |
                                                       ARM_STOP_AT_ALIGN|
                                                            ^-----------+

The gate is ON in ``IDLE``, ``STARTUP``, ``ARMED`` and ``RUNNING``, and OFF in
``STOPPED_LOW``. The default state after reset is ``IDLE`` with the gate ON, so
an un-configured system still gets a free-running clock to the ADC.

- **Startup:** writing ``STARTUP_FIRE`` loads ``STARTUP_CYCLES`` into the
  down-counter and opens the gate. The counter advances only on delivered
  pulses, so exactly ``STARTUP_CYCLES`` edges reach the ADC before the gate
  stops LOW and the startup-done event fires. The /32 phase counter is primed
  so that the post-startup phase is deterministic.
- **Stop at align:** writing ``ARM_STOP_AT_ALIGN`` waits for the next falling
  edge of the divide-by-32 output, then stops the gate LOW and raises the
  stop-at-align event. The clock is now parked at a known phase for an SPI
  power-mode write.
- **Resume:** writing ``RESUME`` restarts the gate and clears the edge counter.
  When the delivered-edge count reaches ``EDGE_TARGET`` the edge-target event
  fires (edge 146 = first ``dig_clk`` rising edge).
- **Multi-device restart:** ``GATE_FORCE_OFF`` holds the gate stopped on every
  device; writing ``RESUME`` to each then restarts them together.

ODR re-registration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``odr_in`` input is re-registered onto the ``clk_in`` domain and driven out
on ``odr_out`` so that ODR transitions are aligned to XTAL2_CLKIN. The
registration edge sets where the chip-internal CLKIN-vs-ODR boundary lands and
therefore the inter-chip phase distribution of a dual-AD7134 setup.

Each of the three events (startup done, stop-at-align done, edge target
reached) latches a bit in ``IRQ_PENDING``; the ``irq`` output is the OR of the
pending bits masked by ``IRQ_MASK``.

Register Map
-------------------------------------------------------------------------------

.. hdl-regmap::
   :name: ad7134_clkin_aligner
   :no-type-info:

Software Guidelines
-------------------------------------------------------------------------------

The one-time startup and a power-mode change are driven over AXI as follows
(byte address = word offset x 4):

#. Write ``CONTROL`` ``STARTUP_FIRE`` (``0x44`` bit 0). The IP delivers the
   startup pulses and stops the clock LOW.
#. Wait for ``IRQ_PENDING`` ``STARTUP_DONE`` (``0x5C`` bit 2), then write 1 to
   clear it.
#. Wait ~20 us, then write ``CONTROL`` ``RESUME`` (``0x44`` bit 2) to start the
   clock.

   *normal capture runs here*

#. Write ``CONTROL`` ``ARM_STOP_AT_ALIGN`` (``0x44`` bit 1) and wait for
   ``IRQ_PENDING`` ``STOP_AT_ALIGN_DONE`` (``0x5C`` bit 1). The clock is now
   stopped LOW at a known phase.
#. Write the new SPI power mode to the ADC and wait for it to settle.
#. Write ``CONTROL`` ``RESUME`` (``0x44`` bit 2). Wait for ``IRQ_PENDING``
   ``EDGE_TARGET_REACHED`` (``0x5C`` bit 0): the edge target (default 146) marks
   the first ``dig_clk`` rising edge.

Enable the interrupt sources of interest in ``IRQ_MASK`` (``0x60``) before
relying on the ``irq`` output.

Software Support
-------------------------------------------------------------------------------

- Linux device driver at :git-linux:`drivers/iio/adc/ad4134.c` — parses the
  ``adi,clkin-aligner`` phandle, maps the AXI block, requests the interrupt and
  drives the startup and power-mode-change sequences.

References
-------------------------------------------------------------------------------

- HDL IP core at :git-hdl:`library/clkin_aligner`
- HDL project at :git-hdl:`projects/ad7134_fmc`
- :adi:`AD7134`
- :adi:`EVAL-AD7134FMCZ`

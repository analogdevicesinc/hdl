.. _axi_adf4030:

AXI ADF4030
================================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI ADF4030 Controller <library/axi_adf4030>` IP core provides
AXI-Lite control of the :adi:`ADF4030` fractional-N PLL and its associated
bidirectional BSYNC signal. It generates up to 8 independently phase-adjusted
trigger outputs, each synchronized to the BSYNC clock recovered from the
ADF4030 device. The BSYNC signal can be either received from the ADF4030
(as a timing reference) or driven by the FPGA toward an external device,
selectable at runtime.

Features
--------------------------------------------------------------------------------

- Bidirectional differential BSYNC interface (``IOBUFDS_DCIEN``) with runtime
  direction control
- BSYNC receiver with automatic period calibration (no external configuration
  required)
- Internal BSYNC regeneration after calibration, with optional suppression
- Optional BSYNC misalignment detection with latched error flag
- Up to 8 independently phase-configurable trigger output channels
- Per-channel enable and phase offset, adjustable while running
- Optional trigger stretcher: aligns narrow trigger pulses to the next BSYNC
  edge before distributing to channels
- Dual trigger source: external pin (synchronized) or software-generated
- Full debug override: force all channel outputs to a known state via register
- AXI4-Lite slave interface with 10-bit address space
- All cross-clock-domain paths covered by explicit ``set_false_path`` constraints

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_adf4030/axi_adf4030.sv`
     - Top-level module; wires all submodules and the IOBUFDS primitive.
   * - :git-hdl:`library/axi_adf4030/axi_adf4030_regmap.sv`
     - AXI register map with all CDC synchronizers.
   * - :git-hdl:`library/axi_adf4030/bsync_generator.sv`
     - FSM that captures, calibrates, and regenerates the BSYNC signal.
   * - :git-hdl:`library/axi_adf4030/trigger_channel.sv`
     - Per-channel FSM that phase-delays the trigger output relative to BSYNC.
   * - :git-hdl:`library/axi_adf4030/trigger_bsync_stretcher.sv`
     - Stretches a narrow trigger pulse to the next BSYNC rising edge.
   * - :git-hdl:`library/axi_adf4030/axi_adf4030_ip.tcl`
     - Vivado IP-integrator packaging script.
   * - :git-hdl:`library/axi_adf4030/axi_adf4030_constr.ttcl`
     - Template XDC with timing constraints for all CDC paths.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - ID
     - Instance identification number. Readable from the PERIPHERAL_ID register.
   * - FPGA_FAMILY
     - Selects the ``SIM_DEVICE`` attribute for the ``IOBUFDS_DCIEN`` primitive.
       0 = UltraScale/UltraScale+, 6 = Versal AI Core, 7 = Versal Premium.
   * - CHANNEL_COUNT
     - Number of active trigger output channels. Range: 1 to 8.
   * - TRIGGER_STRETCH
     - When set to 1, inserts a ``trigger_bsync_stretcher`` between the trigger
       source and the channel array. This aligns any narrow trigger pulse to the
       next rising BSYNC edge before it is distributed to all channels.

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - bsync_p
     - Positive leg of the differential BSYNC signal. Direction controlled at
       runtime by the DIRECTION control register bit.
   * - bsync_n
     - Negative leg of the differential BSYNC signal.
   * - device_clk
     - Device clock. All functional logic (bsync_generator, trigger channels)
       is synchronous to this clock.
   * - trigger
     - External trigger input. Asynchronous; synchronized to ``device_clk``
       internally. Only used when SELECT_TRIG=1.
   * - sysref
     - SYSREF output. Wired directly to the received ``bsync_p/n`` signal; can
       be used as a JESD204 SYSREF.
   * - trig_channel
     - Phase-aligned trigger outputs, one per enabled channel. Width equals
       ``CHANNEL_COUNT``.
   * - trig_request_out
     - Pre-channel trigger signal, after the optional stretcher. Asserted when
       the active trigger source fires, before per-channel phase adjustment.
   * - s_axi_aclk
     - AXI interface clock. The register map is synchronous to this clock.
   * - s_axi_aresetn
     - AXI interface reset, active low.
   * - s_axi
     - AXI4-Lite slave. Provides access to the register map.

Register Map
--------------------------------------------------------------------------------

The register map occupies a single 10-bit AXI4-Lite address space. All
registers are 32-bit wide and word-addressed; bits [1:0] of the AXI byte
address are ignored by the decoder. The TRIG_CHANNEL registers
(``0x07``–``0x0E``) are always present regardless of ``CHANNEL_COUNT``;
registers beyond the instantiated channel count read as zero and writes to
their ``TRIG_PHASE`` fields are silently ignored. The ``TRIG_CHANNEL_EN``
field in the CONTROL register also silently ignores writes to bits above
``CHANNEL_COUNT-1``.

.. hdl-regmap::
   :name: AXI_ADF4030

Theory of Operation
--------------------------------------------------------------------------------

BSYNC Signal Handling
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``bsync_p`` / ``bsync_n`` differential pair can either be received from the
ADF4030 or driven out toward an external device, selected by the DIRECTION bit
in the CONTROL register (default: receive). The ``IOBUFDS_DCIEN`` Xilinx
primitive is used for the bidirectional I/O; its ``IBUFDISABLE`` input gates
the receiver when the FPGA is in drive mode.

When receiving (DIRECTION=1), the ``bsync_generator`` module operates as
follows:

1. **IDLE** — waits for the first rising edge on the ``bsync_p/n`` input. A
   3-stage pipeline on the registered signal reduces the probability of
   metastability propagating into the rest of the design.

2. **BSYNC_EDGE** — waits for a confirmed stable rising edge.

3. **CALIB** — measures the BSYNC half-period by counting ``device_clk`` cycles
   while the signal is high, recording the result in ``ratio_counter``. Once
   calibration completes, ``BSYNC_READY`` is asserted and the measured
   half-period is visible in the ``BSYNC_RATIO`` debug field.

4. **BSYNC_GEN** — regenerates a local copy of the BSYNC clock using the
   calibrated ratio. The regenerated signal is driven back out through the
   ``IOBUFDS_DCIEN`` when DIRECTION=0 and ``DISABLE_INTERNAL_BSYNC``\ =0.

5. **BSYNC_ALIGNMENT_ERROR** — entered (and latched) if
   ``ENABLE_MISALIGN_CHECK``\ =1 and a subsequent BSYNC edge arrives at a
   different phase than the reference. A ``SW_RESET`` is required to recover.

The ``bsync_event`` pulse is generated on every rising edge of the BSYNC signal,
regardless of FSM state. Trigger channels use this pulse to synchronize their
phase counting.

Trigger Path
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The active trigger source is selected by the SELECT_TRIG bit:

- **SELECT_TRIG=0** — a software trigger is issued by writing 1 to the
  MANUAL_TRIGGER register. The pulse crosses to ``device_clk`` via
  ``sync_event``.
- **SELECT_TRIG=1** — the external ``trigger`` pin is used, synchronized to
  ``device_clk`` by a two-flop synchronizer (``ad_rst``).

When ``TRIGGER_STRETCH``\ =1, the active source first passes through the
``trigger_bsync_stretcher``, which uses a set/reset latch to hold the trigger
asserted until the next BSYNC rising edge acknowledges it. This ensures channels
never miss a narrow pulse.

When ``ENABLE_DEBUG_TRIG``\ =1, both the trigger source and the stretcher are
bypassed. All enabled channel outputs are driven with the value of the
``DEBUG_TRIG`` bit.

Per-Channel Phase Adjustment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each ``trigger_channel`` instance runs a 4-state FSM on ``device_clk``:

- **IDLE** — waits until the channel is enabled (``ch_en``\ =1) and
  ``BSYNC_READY``\ =1.
- **TRIG_EDGE** — waits for both a trigger event and a ``bsync_event`` to
  coincide in the same clock cycle.
- **PHASE_READ** — latches the current phase target from the register map
  (CDC-synchronised).
- **TRIG_ADJUST** — counts ``trig_phase`` cycles of delay, then asserts
  ``trig_out`` for exactly ``bsync_ratio`` cycles, producing one trigger pulse
  per bsync_ratio-aligned window.

The effective delay from the trigger+BSYNC coincidence to the output rising edge
is:

.. math::

   t_{delay} = \left(2 \times BSYNC\_RATIO - 2 - TRIG\_PHASE\right) \times T_{device\_clk}

A ``TRIG_PHASE`` value of 0 places the output pulse as late as possible within
the current BSYNC window. Increasing ``TRIG_PHASE`` advances the pulse earlier.

The ``TRIG_STATE`` field in each channel register reflects the current FSM state
and is useful for diagnosing whether a channel is waiting for BSYNC, waiting for
a trigger, or actively adjusting its output.

Clock Domain Crossing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The IP operates across two asynchronous clock domains: ``s_axi_aclk`` (register
map) and ``device_clk`` (functional logic). All paths are handled in
``axi_adf4030_regmap.sv`` using ADI CDC primitives:

.. list-table::
   :header-rows: 1
   :widths: 40 20 40

   * - Signal(s)
     - Primitive
     - Direction
   * - Control bits (direction, select_trig, sw_reset, disable_internal_bsync,
       enable_misalign_check, enable_debug_trig, debug_trig)
     - ``sync_bits``
     - AXI → device_clk
   * - ``trig_channel_en``
     - ``sync_data`` (toggle handshake)
     - AXI → device_clk
   * - ``trig_channel_phase[N]``
     - ``sync_data`` per channel (toggle handshake)
     - AXI → device_clk
   * - ``manual_trig`` pulse
     - ``sync_event``
     - AXI → device_clk
   * - ``bsync_state``, ``bsync_ratio``, ``bsync_delay``
     - ``sync_data`` (toggle handshake)
     - device_clk → AXI
   * - ``bsync_ready``, ``bsync_captured``, ``bsync_alignment_error``
     - ``sync_bits``
     - device_clk → AXI
   * - ``trig_state[N]``
     - ``sync_data`` per channel (toggle handshake)
     - device_clk → AXI

All corresponding ``set_false_path`` constraints are generated at build time
from the ``axi_adf4030_constr.ttcl`` template.

Software Considerations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Recommended bring-up sequence:

1. Set DIRECTION=1 (receive) in the CONTROL register.
2. Wait for ``BSYNC_READY``\ =1 in the DEBUG register. This confirms that the
   BSYNC period has been measured and the regenerated clock is stable.
3. Configure per-channel ``TRIG_PHASE`` values in the TRIG_CHANNEL registers.
   Phase registers are only writable while the corresponding channel enable bit
   is set (``TRIG_CHANNEL_EN[n]``\ =1).
4. Set the desired trigger source via ``SELECT_TRIG``.
5. Enable individual channels by setting bits in ``TRIG_CHANNEL_EN``.
6. Issue triggers via the external pin or the MANUAL_TRIGGER register.

To recover from a ``BSYNC_ALIGNMENT_ERROR``, write 1 to the SW_RESET bit. This
restarts the ``bsync_generator`` FSM from IDLE without resetting the AXI
interface or the phase register values.

Known Limitations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- The IP is **Xilinx-only**: the bidirectional BSYNC uses ``IOBUFDS_DCIEN``,
  which is a Xilinx-specific primitive. No Intel/Altera variant is provided.
- The maximum supported ``CHANNEL_COUNT`` is 8. The TRIG_CHANNEL register array
  always occupies 8 entries (addresses 0x07–0x0E); registers beyond
  ``CHANNEL_COUNT`` read as zero.
- ``BSYNC_RATIO`` is a 16-bit field. The maximum measurable BSYNC half-period
  is 65535 ``device_clk`` cycles.
- The ``trigger_bsync_stretcher`` uses an asynchronous set/reset latch on the
  trigger signal edge. The bsync_stretcher module should only be used when
  setup/hold on ``trigger`` relative to ``external_bsync`` cannot be guaranteed.

References
--------------------------------------------------------------------------------

- HDL IP core at :git-hdl:`library/axi_adf4030`
- :adi:`ADF4030` product page

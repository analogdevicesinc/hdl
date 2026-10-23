.. _spi_translator:

SPI Translator
================================================================================

The SPI Translator is a store-and-forward bridge that lets a host with a single
SPI chip select reach several downstream SPI devices, each driven by its
unmodified Linux driver. The host sends a serialized
:ref:`SPI Engine <spi_engine>` instruction stream over one upstream SPI link;
the bridge checks each frame as a whole and only then replays it into a stock
:ref:`spi_engine execution` module, which drives the downstream bus. Read data
and bridge registers come back to the host over MISO.

.. important::

   This core is work in progress, see `Current limitations`_.

Features
--------------------------------------------------------------------------------

- Upstream SPI slave clocked by SCLK, any of the four SPI modes (fixed at
  synthesis)
- Upstream stream format is the SPI Engine instruction set, plus five bridge
  instructions
- Whole frames are checked before anything reaches a downstream device; a bad
  frame is dropped as a unit
- Up to four downstream targets with per-transaction mode, clock and word
  length, through a stock ``spi_engine_execution``
- Transactional CMD, SDO and response FIFOs, sized independently
- Two-frame reads (request, then FETCH), retryable
- A downstream transfer can be split over several frames, for cascading
  translators
- Register file with status, FIFO levels, last SYNC id and 8 GPIOs

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/spi_translator/spi_translator.v`
     - Top level.
   * - :git-hdl:`library/spi_translator/spi_translator_slave.v`
     - Upstream SPI slave, clocked by SCLK.
   * - :git-hdl:`library/spi_translator/spi_translator_decoder.v`
     - Frame parser, validation, bridge instructions, reply generation.
   * - :git-hdl:`library/spi_translator/spi_translator_execution.v`
     - CMD, SDO and response FIFOs, last SYNC id, status byte, engine reset
       on FLUSH.
   * - :git-hdl:`library/spi_translator/spi_translator_fifo.v`
     - Single-clock FIFO with commit and rollback.
   * - :git-hdl:`library/spi_translator/spi_translator_regmap.v`
     - Bridge register file and GPIOs.
   * - :git-hdl:`library/spi_translator/spi_translator_constr.xdc`
     - Clock-domain crossing constraints.
   * - :git-hdl:`library/spi_translator/spi_translator_ip.tcl`
     - Vivado IP packaging.
   * - :git-hdl:`library/spi_translator/tb/spi_translator_tb.v`
     - Self-checking testbench.

Block Diagram
--------------------------------------------------------------------------------

.. code-block:: text

   upstream SPI                                                 downstream SPI
   (one CS)                                                     (4 chip selects)

            +-----------+  rx bytes  +-----------+ instr +-----+  cmd
   CS  ---->|           |----------->|           |------>| CMD |------+
   SCLK --->|   slave   |   frame    |  decoder  |       +-----+      |
   MOSI --->| (SCLK clk)|   events   |  parse,   | data  +-----+  sdo v
   MISO <---|           |<-----------|  check,   |------>| SDO |--> spi_engine_ --> SCLK
            +-----------+  tx_data   |  bridge   |       +-----+    execution   --> SDO
                                     |  instr,   | commit /            |    ^   --> CS[3:0]
                                     |  replies  | rollback            |    |   <-- SDI
                                     +-----------+                     |    |
                                       |  ^   ^  FETCH (speculative)   v    |
                                 CTRL_W|  |   +------------------- +------+ |
                                       v  |CTRL_R                  | RESP | |
                                     +--------+     sdi            +------+ |
                         GPIO <----->| regmap |<--- SYNC id: last_sync      |
                                     +--------+                             |
                                                  FLUSH: engine reset ------+
                                                                  spi_resetn

Everything right of the slave runs on ``clk``. All three FIFOs are
transactional: the CMD and SDO FIFOs only show a frame to the engine once the
decoder commits it, and the response FIFO only releases what a FETCH read once
the FETCH frame commits.

Configuration Parameters
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Default
     - Description
   * - ``UP_CPOL``, ``UP_CPHA``
     - 0, 0
     - Upstream SPI mode. Fixed at synthesis, see `The upstream slave`_.
   * - ``HEADER_CRC_EN``
     - 1
     - Not used by this version.
   * - ``CMD_FIFO_ADDRESS_WIDTH``
     - 8
     - CMD FIFO depth, ``2**N`` instructions. 3 to 15.
   * - ``SDO_FIFO_ADDRESS_WIDTH``
     - 8
     - SDO FIFO depth, ``2**N`` bytes. 3 to 15.
   * - ``RESP_FIFO_ADDRESS_WIDTH``
     - 8
     - Response FIFO depth, ``2**N`` bytes. Up to 15.

The defaults are the minimum sizes for correct operation with the usual host
rules below; a project can size the FIFOs up as far as it needs. The lower
bound of 3 comes from CREDIT, the upper bound of 15 from the 16-bit room and
level registers.

FIFO sizing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A frame is only accepted if its instructions fit in the room left in the CMD
FIFO and its SDO bytes in the room left in the SDO FIFO. Bridge instructions
and filler bytes take no room.

.. list-table::
   :header-rows: 1

   * - FIFO
     - Minimum
     - Why
   * - SDO
     - 256 bytes
     - A TRANSFER's SDO bytes must arrive in the same frame as the
       instruction, and one TRANSFER carries up to 256 words. A host that
       limits its TRANSFER lengths can use less. Longer bursts are sent as
       several frames, see `Split transfers`_.
   * - Response
     - 256 bytes
     - It must hold all SDI bytes of one message: when it is full the engine
       stalls, so neither RESP_RDY nor SYNC_ID can show the message complete
       and the host never fetches. The host splits larger reads into several
       messages, or fetches by SDI_LEVEL while the engine runs.
   * - CMD
     - about 16 instructions
     - It must hold the instructions of one frame. A typical message (CFG,
       PRESCALE, CHIPSELECT, one or two TRANSFERs, CHIPSELECT, SYNC) is 6 to 8
       instructions.

At the minimum sizes a frame that fills a FIFO is only accepted once that FIFO
has drained, so frame *k + 1* cannot be received while frame *k* executes.
For that overlap, size the FIFOs to about twice the largest frame, e.g.
``SDO_FIFO_ADDRESS_WIDTH = 9``.

Interface
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Port
     - Direction
     - Description
   * - ``clk``
     - in
     - Core clock.
   * - ``resetn``
     - in
     - Active-low synchronous reset.
   * - ``cs``, ``sclk``, ``sdi``
     - in
     - Upstream SPI slave: chip select, clock, MOSI.
   * - ``sdo``
     - out
     - Upstream MISO.
   * - ``sdi_t``
     - out
     - MISO tristate control, high while CS is deasserted.
   * - ``cmd_*``, ``sdo_data_*``, ``sdi_data_*``, ``sync_*``
     - in/out
     - :ref:`SPI Engine control interface <spi_engine control-interface>`,
       master side. Connect to ``spi_engine_execution``.
   * - ``spi_resetn``
     - out
     - Reset for ``spi_engine_execution``; pulsed low by FLUSH.
   * - ``gpio_i[7:0]``, ``gpio_o[7:0]``, ``gpio_t[7:0]``
     - in/out
     - GPIOs, e.g. downstream reset lines. Connect through ``ad_iobuf``;
       ``gpio_t`` high means input.

The engine must be built with ``NUM_OF_CS = 4``, ``DATA_WIDTH = 8`` and
``NUM_OF_SDIO = 1``.

Register Map
--------------------------------------------------------------------------------

The bridge has 16 byte-wide registers, written with CTRL_W and read with
CTRL_R.

.. list-table::
   :header-rows: 1

   * - Address
     - Name
     - Access
     - Description
   * - ``0x0``
     - VERSION_MAJOR
     - R
     - ``0x01``.
   * - ``0x1``
     - VERSION_MINOR
     - R
     - ``0x00``.
   * - ``0x2``
     - VERSION_PATCH
     - R
     - ``0x00``.
   * - ``0x3``
     - PERIPHERAL_ID
     - R
     - Value of the regmap ``PERIPHERAL_ID`` parameter, ``0x00`` by default.
   * - ``0x4``
     - SCRATCH
     - RW
     - Scratch register.
   * - ``0x5``
     - STATUS
     - R
     - See `STATUS`_.
   * - ``0x6``
     - SYNC_ID
     - R
     - Id of the last SYNC executed by the engine. Kept across FLUSH.
   * - ``0x7``, ``0x8``
     - CMD_ROOM
     - R
     - Free CMD FIFO entries, low and high byte.
   * - ``0x9``, ``0xA``
     - SDO_ROOM
     - R
     - Free SDO FIFO bytes, low and high byte.
   * - ``0xB``, ``0xC``
     - SDI_LEVEL
     - R
     - SDI bytes waiting for FETCH, low and high byte.
   * - ``0xD``
     - GPIO_OUT
     - RW
     - Output value of each GPIO.
   * - ``0xE``
     - GPIO_DIR
     - RW
     - 1 = output, 0 = input. Resets to all inputs.
   * - ``0xF``
     - GPIO_IN
     - R
     - Pin level of each GPIO, synchronized to ``clk``.

STATUS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1

   * - Bit
     - Name
     - Description
   * - 7
     - BUSY
     - Committed work pending, or the engine not idle.
   * - 6
     - RESP_RDY
     - Nothing left to execute and SDI bytes waiting: everything sent so far
       has run and its SDI bytes can be fetched.
   * - 5:3
     - ERR
     - Sticky frame errors, see `Validation and errors`_. Cleared by FLUSH.
   * - 2:0
     - CREDIT
     - Free space in eighths of the fuller of the CMD and SDO FIFOs,
       saturated at 7. Exact values are in CMD_ROOM and SDO_ROOM.

GPIO writes take effect as soon as their CTRL_W is decoded, not in order with
engine instructions: queued instructions, including those of the same frame,
run after the change. To change a GPIO after earlier traffic has run, for
example to release a reset, wait for BUSY to clear first.

Theory of Operation
--------------------------------------------------------------------------------

Frames
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A frame is everything between upstream CS assert and deassert. Its content is
a serialized SPI Engine instruction stream:

- Instructions are sent MSB first: ``cmd[15:8]``, then ``cmd[7:0]``.
- A TRANSFER with its write bit set (``cmd[8]``) is followed by ``n + 1`` SDO
  bytes, ``n = cmd[7:0]``. A read-only TRANSFER is followed by nothing.
- Engine instructions use exactly the encodings of the
  :ref:`SPI Engine instruction set <spi_engine instruction-format>`.
- Apart from `Replies`_, all MISO bytes are ``0x00``.
- A frame with no bytes at all is ignored.

Engine instructions are written into the CMD FIFO and their SDO bytes into the
SDO FIFO as they arrive. At CS deassert the decoder either commits the frame to
both FIFOs in the same cycle, or rolls both back. Frame *k* executes while
frame *k + 1* is being received.

Bridge instructions act during the frame instead: CTRL_R and FETCH reply on
MISO, CTRL_W and FLUSH take effect as soon as they are decoded, and only the
bytes a FETCH reads wait for the commit to be released.

Bridge instructions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Instructions with bit 15 set, which the engine leaves reserved, belong to the
bridge and are never forwarded. Their high byte is ``{1, op[2:0], addr[3:0]}``.

.. list-table::
   :header-rows: 1

   * - Encoding
     - Op
     - Name
     - Action
   * - ``0x80xx``
     - 0
     - NOP
     - None.
   * - ``0x90nn`` + ``n + 2`` filler bytes
     - 1
     - FETCH
     - Reply with the next ``n + 1`` bytes of the response FIFO (1 to 256,
       counted like a TRANSFER).
   * - ``0xAadd``
     - 2
     - CTRL_W
     - Write ``dd`` to register ``a``, immediately.
   * - ``0xBa00``
     - 3
     - CTRL_R
     - Reply with register ``a``.
   * - ``0xC0xx``
     - 4
     - FLUSH
     - Immediately drop all queued work and SDI data, including the earlier
       part of its own frame, reset the engine (deasserting every downstream
       CS) and clear the ERR bits.

Opcodes 5 to 7 are reserved. ``addr`` must be 0 for NOP, FETCH and FLUSH, and
the low byte of CTRL_R must be ``0x00``. FETCH filler bytes are ignored.
Bridge and engine instructions can be mixed in one frame.

CTRL_W and FLUSH take effect about four ``clk`` cycles after their low byte,
as long as nothing earlier in the frame has failed: an instruction after an
error may be misaligned data, so it is ignored. They are not undone if the
frame is rejected later; register writes are absolute and FLUSH is idempotent,
so resending the frame is harmless. Consequently:

- several CTRL_W can be sent in one frame, and a CTRL_R after a CTRL_W reads
  the new value;
- the instructions after a FLUSH are kept and committed normally, so a frame
  such as ``FLUSH, CFG, PRESCALE, CS, ...`` recovers and starts again. The
  engine restarts from its reset configuration, so the frame sets the mode and
  clock again.

Replies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The decoder produces one MISO byte for every byte it receives, and the slave
loads it at the next byte boundary. A reply byte is therefore on MISO two bytes
after the byte that completes its request:

.. code-block:: text

   CTRL_R  MOSI  [0xBa][0x00][next hi]         the address is in the high byte;
           MISO  [ .. ][turn][ data  ]         the low byte is the turnaround

   FETCH   MOSI  [0x90][ nn ][fill][fill]    ... [fill]
           MISO  [ .. ][ .. ][turn][data 0]  ... [data n]

CTRL_R needs no filler: its data goes out during the first byte of whatever
instruction follows it. Register reads can therefore be chained at one per two
bytes, and a CTRL_R that ends a frame is followed by a NOP to clock its data
out:

.. code-block:: text

   MOSI  [CTRL_R a][CTRL_R b][CTRL_R c][NOP  ]
   MISO  [ ..  ..][a   ..  ][b   ..  ][c  ..]

Reads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A read costs two frames: the request, then a FETCH. Downstream, the engine
runs full-duplex and read transfers as usual and queues the SDI bytes in the
response FIFO; the child driver, blocked in ``spi_sync()``, gets its
``rx_buf`` once the shim has fetched them.

The host knows a read is complete in one of two ways:

- **SYNC_ID.** The host ends each message that reads with a SYNC and waits
  until SYNC_ID shows that id. The engine only reaches a SYNC once the
  transfers before it are done and their SDI bytes are queued, so the whole
  response can be fetched. This identifies one message even with other work
  queued behind it. Ids are 8 bits; compare them modulo 256.
- **RESP_RDY.** With nothing else queued, RESP_RDY in STATUS tells the same
  without tracking ids. It only means the request is complete once the host
  has sent all of it: with a transfer split over several frames, poll only
  after the last one. Bytes left over from an earlier, unfetched read would
  come out first, so after an error check SDI_LEVEL or FLUSH.

A FETCH with ``n = k - 1`` then returns that message's ``k`` SDI bytes, padded
with ``0x00`` if the FIFO runs out; one FETCH covers a full-length read
TRANSFER. **The bytes a FETCH reads are only released when its
frame commits.** If the frame is rejected, the read is rewound and a retried
FETCH returns the same bytes.

Writes need no FETCH: a posted write has nothing to return. A write that must
be confirmed ends with a SYNC, and the host checks SYNC_ID. For a fence over
all writes so far, the host waits for BUSY to clear and checks the ERR bits.

Validation and errors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A frame that fails any check is rolled back as a unit: nothing from it reaches
a downstream device, its FETCH reads are rewound, and the matching ERR bit in
STATUS is set. CTRL_W and FLUSH decoded before the failure stay applied;
those after it are ignored.

.. list-table::
   :header-rows: 1

   * - STATUS bit
     - Condition
   * - 3
     - Bad instruction: engine class ``101`` to ``111``, bridge opcode 5 to 7,
       reserved TRANSFER, WRITE or bridge fields, a CHIPSELECT selecting more
       than one target, or a word length outside 1..8.
   * - 4
     - The frame does not fit in the room left in the CMD or SDO FIFO.
   * - 5
     - The frame ends inside an instruction, its SDO data or a FETCH's
       filler bytes.

Split transfers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A frame may end with a target still selected. The engine then keeps that chip
select asserted, and the next frame continues the same downstream transaction:

.. code-block:: text

   frame 1   CS(select t)  WR(k)  data ...
   frame 2                 WR(m)  data ...  CS(release)

The target sees one CS-held transfer of ``k + m`` words. This lets a transfer
longer than the FIFOs be sent in pieces, and lets translators be cascaded,
where the first stage forwards portions of a transfer for the next one.

Each frame is still checked as a unit, so a bad piece never reaches the
target, but the pieces before it already have. If a later piece is rejected,
the target stays selected until the host sends a CHIPSELECT releasing it, or
FLUSH.

The upstream slave
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Everything in the SCLK domain is clocked on the sample edge: rising for
  modes 0 and 3, falling for modes 1 and 2. The inversion is a constant
  absorbed into the flip-flop clock input, which is why ``UP_CPOL`` and
  ``UP_CPHA`` are parameters: a register-selected inversion would put logic
  in the clock path.
- MISO is launched on the sample edge too, right after the master has sampled
  the previous bit, so each bit has a full SCLK period to reach the master.
- CS asynchronously resets the bit counter, since SCLK does not run while CS
  is high.
- **Receive crossing.** A completed byte is copied to a holding register and a
  toggle flipped on the 8th edge itself. Only the toggle is synchronized into
  ``clk``; the holding register is sampled once the toggle shows it is stable.
- **Transmit crossing.** ``tx_data`` only changes in the cycle after a byte has
  been received, so it is stable at every byte boundary, where the SCLK domain
  loads it.

Timing requirements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- One upstream byte (8 SCLK periods) must last more than about 6 ``clk``
  cycles, so each byte crosses between SCLK and ``clk`` before the next byte
  boundary.
- CS must stay high for at least about 4 ``clk`` cycles between frames.
- SCLK should enter on a clock-capable pin.

Design decisions
--------------------------------------------------------------------------------

Store-and-forward on SPI Engine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

With one chip select and no side-band signal, the FPGA cannot be both
bit-transparent and controllable. A store-and-forward bridge is the addressee
of every frame, so target selection travels in-band. Driver transparency is
kept by the Linux layering: the shim issues the request and FETCH frames
inside one ``transfer_one_message()`` while the child driver blocks in
``spi_sync()``.

SPI Engine was chosen for the downstream side (Option C of the FPGA SPI
Translator proposal) over four ``axi_quad_spi`` master cores (Option B). The
engine carries CPOL, CPHA, clock divider and word length inline per
transaction, so one stock engine serves heterogeneous targets and honours each
child's ``max_speed_hz`` at runtime, where ``axi_quad_spi`` fixes SCK ratio and
word width at synthesis. The cost is that SPI Engine has no slave, so the
upstream slave is new RTL.

SPI Engine instructions upstream
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sending engine instructions instead of a custom header removes the translation
layer: the FPGA only routes words and bytes, every engine feature is available,
and the Linux shim can reuse ``spi_engine_compile_message()`` from
``drivers/spi/spi-axi-spi-engine.c``. Because the host can send any
instruction, the decoder rejects what would be dangerous to the hardware: more
than one target selected, reserved encodings, and word lengths the 8-bit engine
cannot do. A frame ending with a target still selected is allowed on purpose,
see `Split transfers`_.

Bridge instructions use bit 15, which the engine leaves reserved, so they are
clearly apart from engine instructions and all engine classes stay available.
The register address sits in the high byte, which makes CTRL_W a single
2-byte instruction and lets CTRL_R reply during the next instruction, with no
filler. The price is a 16-register address space.

Whole frames buffered before forwarding
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Forwarding each word as it arrives was rejected. A frame cut short by CS, or
corrupted by a glitch, would already be partly on the downstream bus: a
register write with the wrong length or data, or the engine stalled waiting for
SDO bytes with a target's CS asserted. Buffering the frame gives the property
the design relies on: **a frame that fails any check never reaches a device**.
Checking each byte as it arrives does not replace this, because missing bytes
or a target left selected can only be judged at the end.

Transactional FIFOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A 16-bit CMD FIFO and an 8-bit SDO FIFO feed the engine, the same split
``axi_spi_engine`` uses. The engine takes a TRANSFER from ``cmd`` before it
asks for that transfer's SDO bytes, so the two streams need no tagging, and
the FIFOs can be sized independently. A plain FIFO would show data to the
engine as soon as it is written, so ``spi_translator_fifo`` keeps a
speculative pointer and a commit pointer; ``READ_TXN`` selects whether commit
and rollback act on the write side (CMD, SDO) or the read side (response). The
ADI library has no FIFO with rollback.

Last SYNC id in a register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SYNC ids are kept in a register, as in ``axi_spi_engine``, rather than queued
with the SDI data. Writes that end with a SYNC then leave nothing to fetch and
can never fill the response FIFO and stall the engine, and "this message is
done" is an exact comparison, so the host never fetches a response that is
still being written. The cost is that responses no longer carry an in-band
tag, so a FETCH cannot be checked against the message it belongs to.

SCLK-clocked slave
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An oversampled slave can filter glitches but is limited by synchronizer
latency on MISO, to roughly ``clk/4``, about 25 MHz at 100 MHz. Clocking the
slave from SCLK removes that latency, leaving the I/O round trip as the limit.
SCLK glitches then become clock edges and cannot be filtered, only detected by
the frame checks. An SCLK-clocked FIFO was rejected for the receive crossing
because a write needs further SCLK edges to become visible, and the last byte
of a frame never gets them.

Register map in the bridge
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Placing bridge registers inside ``spi_engine_execution`` was rejected: it forks
a stock core, the engine has three free WRITE addresses and no read-back, and
registers such as ERR clear or FLUSH must act immediately, not when the engine
reaches them behind queued frames.

Immediate CTRL_W and FLUSH
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CTRL_W and FLUSH act as soon as they are decoded rather than at the commit.
This allows several register writes per frame, read-after-write within a frame,
and a FLUSH that recovers and restarts in one frame. The cost is that they are
not part of the frame's all-or-nothing: if the frame is rejected later, they
stay applied. Without a CRC that loses nothing, since a corrupted CTRL_W would
be applied at the commit just the same. When CRC checkpoints are added, they
become the point at which CTRL_W and FLUSH take effect, keeping them protected
without returning to commit-time writes.

Immediate does not mean ordered with SPI traffic: the frame's engine
instructions only run after the commit, so a GPIO written by CTRL_W changes
before them. Timed GPIO sequences would need a GPIO instruction stored in the
CMD FIFO and executed by the bridge at the FIFO output, once the engine is idle.

Framing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The frame boundary is upstream CS, which requires the host controller to hold
CS across a whole message. This holds for ``spi-bcm2835`` (Raspberry Pi) and
must still be checked on the target host. A host that toggles CS mid-message
fails safe: the pieces are rejected and nothing wrong reaches a device, but the
link does not work.

Current limitations
--------------------------------------------------------------------------------

- **No CRC.** A corrupted frame that still parses is executed, and corrupted
  MISO data is not detected. A checkpoint instruction carrying a CRC over
  everything since the previous one is planned; CTRL_W and FLUSH will then take
  effect when the next checkpoint passes, so their meaning for the host stays
  the same.
- **No status byte on MISO.** Status is read through CTRL_R of STATUS; sending
  it in the first MISO byte of every frame, with the last SYNC id in the
  second, is planned.
- **Partial bytes** cut short by CS are dropped silently by the slave.
- **8-bit SDO words only** (engine ``DATA_WIDTH = 8``).
- **No downstream watchdog**; a hung engine is recovered with FLUSH.
- **GPIO writes are not ordered** with queued engine instructions.

Simulation
--------------------------------------------------------------------------------

The testbench drives the bridge with an upstream mode 0 SPI master task that
also captures MISO, in front of a stock ``spi_engine_execution`` and four
behavioural targets in modes 0 to 3, plus a GPIO pin model. The FIFOs are
built small (16 instructions, 32 SDO bytes) so they can be filled. It runs
with Vivado xsim:

.. shell::

   $cd library/spi_translator/tb
   $SIMULATOR=xsim MODE=batch ./spi_translator_tb

References
--------------------------------------------------------------------------------

- :ref:`spi_engine`
- :ref:`spi_engine instruction-format`
- :ref:`spi_engine control-interface`
- FPGA SPI Translator proposal (``fpga_spi_translator``)

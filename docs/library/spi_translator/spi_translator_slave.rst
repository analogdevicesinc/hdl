.. _spi_translator slave:

Slave Module
================================================================================

The slave module, IP ``spi_translator_slave``, is the core of the
:ref:`spi_translator`: the upstream SPI slave, the frame decoder, the
transactional CMD, SDO and response FIFOs, the register file and the GPIOs. It
drives the :ref:`spi_translator interconnect`, which feeds the engines.

.. important::

   This core is work in progress, see `Current limitations`_.

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/spi_translator/spi_translator_slave/spi_translator_slave.v`
     - Top level.
   * - :git-hdl:`library/spi_translator/spi_translator_slave/spi_translator_phy.v`
     - Upstream SPI slave physical layer, clocked by SCLK.
   * - :git-hdl:`library/spi_translator/spi_translator_slave/spi_translator_decoder.v`
     - Frame parser, validation, bridge instructions, reply generation.
   * - :git-hdl:`library/spi_translator/spi_translator_slave/spi_translator_execution.v`
     - CMD, SDO and response FIFOs, last SYNC id, status byte, engine reset
       on FLUSH.
   * - :git-hdl:`library/spi_translator/spi_translator_slave/spi_translator_fifo.v`
     - Single-clock FIFO with commit and rollback.
   * - :git-hdl:`library/spi_translator/spi_translator_slave/spi_translator_gpio.v`
     - GPIOs.
   * - :git-hdl:`library/spi_translator/spi_translator_slave/spi_translator_regmap.v`
     - Bridge register file.
   * - :git-hdl:`library/spi_translator/spi_translator_slave/spi_translator_constr.xdc`
     - Clock-domain crossing constraints.
   * - :git-hdl:`library/spi_translator/spi_translator_slave/spi_translator_slave_ip.tcl`
     - Vivado IP packaging.

Block Diagram
--------------------------------------------------------------------------------

.. code-block:: text

   upstream SPI                                                     to spi_translator_interconnect
   (one CS)                     spi_translator_slave                (spi_engine_ctrl, spi_resetn)
          +---------------------------------------------------------------------+
          |                                                                     |
          |  +-------------+  rx bytes  +-------------+  instr   +-----------+  |
   CS  ----->|             |----------->|             |--------->| spi_      |  |  cmd
   SCLK ---->| spi_        |   frame    | spi_        |  data    | trans-    |------------->
   MOSI ---->| translator_ |   events   | translator_ |--------->| lator_    |  |  sdo
   MISO <----| phy         |<-----------| decoder     |  commit, | execution |------------->
          |  | (SCLK clk)  |  tx_data   |             | rollback |           |  |  sdi
          |  +-------------+            | parse,      |--------->| CMD FIFO  |<-------------
          |                             | check,      |  FETCH   | SDO FIFO  |  |  sync
          |                             | bridge      |<---------| RESP FIFO |<-------------
          |                             | instr,      |  FLUSH   | last_sync |  |  spi_resetn
          |                             | replies     |--------->| status    |------------->
          |                             +-------------+          +-----------+  |
          |                                |  ^     |  ^               |        |
          |                            GPIO|  |     |  |CTRL_R         | status,|
          |                                v  |     v  |CTRL_W         | levels,|
          |                         +-----------+ +-----------+        | SYNC_ID|
          |                         | spi_      | | spi_      |        |        |
          |                         | translator| | translator|<-------+        |
          |                         | _gpio     | | _regmap   |                 |
          |                         +-----------+ +-----------+                 |
          |                               ^                                     |
          +-------------------------------|-------------------------------------+
                                          v
                                     gpio_i/o/t

The control interface on the right goes to the
:ref:`spi_translator interconnect`, which passes it to the selected engine, see
the :ref:`Engines <spi_translator engines>`; ``spi_resetn`` resets the
interconnect and all engines. Everything right of ``spi_translator_phy`` runs
on ``clk``. All three FIFOs are transactional: the CMD and SDO FIFOs only show
a frame to the engines once the decoder commits it, and the response FIFO only
releases what a FETCH read once the FETCH frame commits.

Configuration Parameters
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Default
     - Description
   * - ``PERIPHERAL_ID``
     - 0
     - Value of the PERIPHERAL_ID register.
   * - ``UP_CPOL``, ``UP_CPHA``
     - 0, 0
     - Upstream SPI mode. Fixed at synthesis, see `The upstream slave`_.
   * - ``UP_EARLY_LAUNCH``
     - 0
     - Upstream MISO timing: 0 = standard, MISO changes on the drive edge;
       1 = early launch, MISO changes on the sample edge. See
       `The upstream slave`_.
   * - ``NUM_OF_CS``
     - 4
     - Total number of downstream targets, 1 to 128, spread over
       ``ceil(NUM_OF_CS / 8)`` engines, see the :ref:`Engines <spi_translator engines>`.
   * - ``NUM_OF_GPIO``
     - 8
     - Number of GPIOs, 0 to 256. 0 leaves the GPIO logic out, see `GPIOs`_.
   * - ``GPIO_DEFAULT_DIR``
     - 0
     - Direction of each GPIO after reset, bit *g* for GPIO *g*: 0 = output,
       1 = input. 256 bits; bits from ``NUM_OF_GPIO`` up are ignored.
   * - ``GPIO_DEFAULT_OUT``
     - 0
     - Output value of each GPIO after reset, bit *g* for GPIO *g*. 256 bits;
       bits from ``NUM_OF_GPIO`` up are ignored.
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
       master side. Connect to the :ref:`spi_translator interconnect`.
   * - ``spi_resetn``
     - out
     - Reset for the interconnect and the engines; pulsed low by FLUSH.
   * - ``gpio_i``, ``gpio_o``, ``gpio_t``
     - in/out
     - ``NUM_OF_GPIO`` wide. Connect through ``ad_iobuf``; ``gpio_t`` high
       means input. Not present when ``NUM_OF_GPIO = 0``.

The engines are built with ``DATA_WIDTH = 8``, ``NUM_OF_SDIO = 1`` and
``NUM_OF_CS = 8``, the last one with the remainder of the core's
``NUM_OF_CS``. The :ref:`block design script <spi_translator block-design-script>` builds them that way.

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
   * - ``0xD``, ``0xE``
     - GPIO_NUM
     - R
     - ``NUM_OF_GPIO``, low and high byte; 0 means no GPIOs.
   * - ``0xF``
     - CS_NUM
     - R
     - ``NUM_OF_CS``, the number of downstream targets; they are spread over
       ``ceil(CS_NUM / 8)`` engines.

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

GPIOs are not in the register map; they are reached one pin at a time with
the GPIO instruction, see `GPIOs`_.

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

Bridge instructions act during the frame instead: CTRL_R, GPIO reads and FETCH
reply on MISO, CTRL_W, GPIO writes and FLUSH take effect as soon as they are
decoded, and only the bytes a FETCH reads wait for the commit to be released.
SELECT is the exception: it is queued with the engine instructions, see
the :ref:`Engines <spi_translator engines>`.

.. _spi_translator bridge-instructions:

Bridge instructions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Instructions with bit 15 set, which the engine leaves reserved, belong to the
bridge and are never forwarded. Their high byte is ``{1, op[2:0], field[3:0]}``.
Opcodes 0 to 3 act on the bridge itself (registers, pins), opcodes 4 to 7 on
the engine side (routing, responses, reset, commit).

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
   * - ``0x9add``
     - 1
     - CTRL_W
     - Write ``dd`` to register ``a``, immediately.
   * - ``0xAa00``
     - 2
     - CTRL_R
     - Reply with register ``a``.
   * - ``0xB?ii``
     - 3
     - GPIO
     - Access GPIO ``ii``. High byte ``{4'hB, rd, sel, value, 1'b0}``.
       With rd = 0 (``0xB0`` to ``0xB6``), write ``value`` immediately, to OUT
       for sel 0 or to DIR for sel 1 (0 = output, 1 = input). With rd = 1
       (``0xB8``, sel and value 0), reply with ``{5'b0, DIR, OUT, IN}``.
   * - ``0xC0ee``
     - 4
     - SELECT
     - Route the instructions that follow to engine ``ee``, in order with the
       stream. See the :ref:`Engines <spi_translator engines>`.
   * - ``0xD0nn`` + ``n + 2`` filler bytes
     - 5
     - FETCH
     - Reply with the next ``n + 1`` bytes of the response FIFO (1 to 256,
       counted like a TRANSFER).
   * - ``0xE0xx``
     - 6
     - FLUSH
     - Immediately drop all queued work and SDI data, including the earlier
       part of its own frame, reset the engine (deasserting every downstream
       CS) and clear the ERR bits.
   * - ``0xF0..``
     - 7
     - CHECK
     - Reserved for the frame integrity check; not implemented yet.

CHECK is rejected as a bad instruction until it is implemented, and so is GPIO
in a translator built without GPIOs. ``field`` must be 0 for NOP, SELECT,
FETCH and FLUSH, the low bit of a GPIO write high byte and the three low bits
of a GPIO read high byte must be 0, and the low byte of CTRL_R must be
``0x00``. FETCH filler bytes are ignored. Bridge and engine instructions can
be mixed in one frame.

CTRL_W, GPIO writes and FLUSH take effect about four ``clk`` cycles after their low byte,
as long as nothing earlier in the frame has failed: an instruction after an
error may be misaligned data, so it is ignored. They are not undone if the
frame is rejected later; register writes are absolute and FLUSH is idempotent,
so resending the frame is harmless. Consequently:

- several CTRL_W or GPIO writes can be sent in one frame, and a CTRL_R or
  GPIO read after a write reads the new value;
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

   CTRL_R  MOSI  [0xAa][0x00][next hi]         the address is in the high byte;
           MISO  [ .. ][turn][ data  ]         the low byte is the turnaround

   FETCH   MOSI  [0xD0][ nn ][fill][fill]    ... [fill]
           MISO  [ .. ][ .. ][turn][data 0]  ... [data n]

   GPIO rd MOSI  [0xB8][ ii ][next hi][next lo]  the index is in the low byte;
           MISO  [ .. ][ .. ][ turn  ][  pin  ]  the reply comes one byte later

CTRL_R needs no filler: its data goes out during the first byte of whatever
instruction follows it. Register reads can therefore be chained at one per two
bytes, and a CTRL_R that ends a frame is followed by a NOP to clock its data
out:

.. code-block:: text

   MOSI  [CTRL_R a][CTRL_R b][CTRL_R c][NOP  ]
   MISO  [ ..  ..][a   ..  ][b   ..  ][c  ..]

GPIO reads chain the same way, its reply landing in the low byte of the following
instruction.

GPIOs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each of the ``NUM_OF_GPIO`` pins has an output value (OUT), a direction (DIR,
0 = output, 1 = input, the same polarity as ``gpio_t``) and an input level (IN,
synchronized to ``clk``). A GPIO write sets one bit of OUT or DIR, a GPIO read
returns all three bits of one pin. An index at or above ``NUM_OF_GPIO`` is
ignored on write and reads 0. With an 8-bit index a translator has up to 256
GPIOs; cascaded translators each have their own.

A translator that needs no GPIOs, such as the first stage of a cascade whose
pins are all on the later stages, is built with ``NUM_OF_GPIO = 0``. The GPIO
logic is then left out, the IP has no GPIO ports, and the GPIO instruction is
rejected as bad instructions, so a host addressing the wrong stage gets an
error rather than silence. Software can tell which stages have GPIOs from
GPIO_NUM.

Reset state
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After reset each pin takes its bit of ``GPIO_DEFAULT_DIR`` and
``GPIO_DEFAULT_OUT``; by default every pin is an output driven low. Both
parameters are 256-bit strings whatever ``NUM_OF_GPIO`` is, so in a block
design they are set as hex values, e.g.
``CONFIG.GPIO_DEFAULT_OUT {0x...0002}`` with leading zeros up to 64 digits. The
parameters are set per project to match what the pins control. For the main
use, regulator enables of the downstream chips:

.. list-table::
   :header-rows: 1

   * - Pin
     - ``GPIO_DEFAULT_DIR`` bit
     - ``GPIO_DEFAULT_OUT`` bit
   * - Active-high enable (``EN``)
     - 0 (output)
     - 0: regulator off
   * - Active-low enable (``EN_N``, ``SHDN_N``)
     - 0 (output)
     - 1: regulator off
   * - Power-good or fault from a regulator (``PG``, ``FAULT_N``)
     - 1 (input)
     - --

Every regulator is then off after reset, and software switches them on in the
order the chips' power sequencing requires. A pin that another device drives
must default to input, or the two drive it against each other until software
reconfigures it.

Two points lie outside the core:

- Before the bitstream is loaded the FPGA pins are high-Z, possibly with
  pull-ups depending on the configuration settings. Each enable needs a board
  pull resistor to its off level, matching ``GPIO_DEFAULT_OUT``, so the
  regulators stay off from power-up until the core's reset drives the pins.
- Asserting ``resetn`` returns every pin to its default, switching the
  regulators off. Drive it from a system-level reset only. FLUSH does not
  affect the GPIOs.

The instructions match the Linux GPIO API, which sets and gets one line at a
time: a ``gpio_chip`` in the shim sends one small frame per call, and drivers
such as ``one-bit-adc-dac`` bind to the lines unmodified. Writing one pin never
touches the others, so no read-modify-write is needed.

A GPIO write acts immediately, like CTRL_W, so it is not ordered with the frame's
engine instructions, which only run after the commit. A pin that must change
after some SPI traffic, such as a load or reset line, is written in a later
frame once BUSY has cleared. Minimum hold times are kept by the host waiting
between frames; exact timing relative to SPI traffic would need the GPIO change
to travel in the instruction stream itself.

.. _spi_translator reads:

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
     - Bad instruction: engine class ``101`` to ``111``, CHECK, GPIO without
       GPIOs, reserved TRANSFER, WRITE or bridge fields, a CHIPSELECT selecting
       more than one target or one the selected engine does not have, a SELECT
       of a missing engine or of another engine while a target is selected, or
       a word length outside 1..8.
   * - 4
     - The frame does not fit in the room left in the CMD or SDO FIFO.
   * - 5
     - The frame ends inside an instruction, its SDO data or a FETCH's
       filler bytes.

.. _spi_translator split-transfers:

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
FLUSH. While it is selected, a SELECT of another engine is rejected.

The upstream slave
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The upstream SPI slave is ``spi_translator_phy``:

- MOSI is captured on the sample edge: rising for modes 0 and 3, falling for
  modes 1 and 2. The inversion is a constant
  absorbed into the flip-flop clock input, which is why ``UP_CPOL`` and
  ``UP_CPHA`` are parameters: a register-selected inversion would put logic
  in the clock path.
- MISO follows the SPI convention by default (``UP_EARLY_LAUNCH = 0``): it
  changes on the drive edge, the edge opposite the sample edge, and holds
  until the next one. This is what masters that sample late rely on, such as
  SPI Engine with ``SDI_DELAY`` or ``ECHO_SCLK``, which is the case for a
  cascaded translator, and SoC controllers with an RX sample delay.
- With ``UP_EARLY_LAUNCH = 1``, MISO changes on the sample edge instead,
  right after the master has sampled the previous bit, so each bit has a full
  SCLK period to reach the master instead of half: roughly 50 to 80 MHz instead
  of 25 to 40 MHz on Artix-7. Use it only when the master samples at its edge
  and the link has been verified by timing analysis; a master that samples
  later reads the next bit.
- The first MISO byte of a frame is undefined in both modes; replies start
  later.
- CS asynchronously resets the bit counter, since SCLK does not run while CS
  is high.
- **Receive crossing.** A completed byte is copied to a holding register and a
  toggle flipped on the 8th edge itself. Only the toggle is synchronized into
  ``clk``; the holding register is sampled once the toggle shows it is stable.
- **Transmit crossing.** ``tx_data`` only changes in the cycle after a byte has
  been received, so it is stable at every byte boundary, where the SCLK domain
  captures it on the sample edge in both modes. With the standard launch, the
  captured byte is then moved into the output shift register on the next drive
  edge, inside the SCLK domain, so the crossing is the same at any SCLK rate.

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
instructions only run after the commit, so a register written by CTRL_W changes
before them. Anything that must happen after some SPI traffic, such as a GPIO
sequence, is sent in a later frame once BUSY has cleared, see `GPIOs`_.

Framing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The frame boundary is upstream CS, which requires the host controller to hold
CS across a whole message. This holds for ``spi-bcm2835`` (Raspberry Pi) and
must still be checked on the target host. A host that toggles CS mid-message
fails safe: the pieces are rejected and nothing wrong reaches a device, but the
link does not work.

.. _spi_translator limitations:

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
- **Engines run one at a time**; there is no parallel traffic on different
  engines.

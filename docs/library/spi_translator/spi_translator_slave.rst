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
on ``clk``. All FIFOs are transactional: the CMD, SDO and bridge-write FIFOs
only release a frame once the decoder commits it, and the response FIFO only
frees what a FETCH read once a later frame acknowledges it.

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
   * - ``CRC_EN``
     - 1
     - 1: every frame must end with a CRC-16 CHECK, which also returns a CRC-16
       of the frame's MISO bytes, see `Frame check (CRC)`_. 0: CHECK is a bad
       instruction.
   * - ``CMD_FIFO_ADDRESS_WIDTH``
     - 8
     - CMD FIFO depth, ``2**N`` instructions. 3 to 15.
   * - ``SDO_FIFO_ADDRESS_WIDTH``
     - 8
     - SDO FIFO depth, ``2**N`` bytes. 3 to 15.
   * - ``RESP_FIFO_ADDRESS_WIDTH``
     - 8
     - Response FIFO depth, ``2**N`` bytes. Up to 15.
   * - ``BRIDGE_FIFO_ADDRESS_WIDTH``
     - 4
     - Bridge-write FIFO depth, ``2**N`` CTRL_W and GPIO writes per frame.
       2 to 8.

The defaults are the minimum sizes for correct operation with the usual host
rules below; a project can size the FIFOs up as far as it needs. The lower
bound of 3 comes from CREDIT, the upper bound of 15 from the 16-bit room and
level registers.

FIFO sizing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A frame is only accepted if its instructions fit in the room left in the CMD
FIFO, its SDO bytes in the room left in the SDO FIFO, and its CTRL_W and GPIO
writes in the bridge-write FIFO. Other bridge instructions and filler bytes
take no room.

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
     - It must hold all SDI bytes of one message, plus the last fetched batch
       until it is acknowledged (see `Reads`_): when it is full the engine
       stalls, so neither RESP_RDY nor SYNC_ID can show the message complete
       and the host never fetches. The host splits larger reads into several
       messages, fetches by SDI_LEVEL while the engine runs, or acknowledges
       the previous batch first.
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
     - Scratch register. Written when the frame commits.
   * - ``0x5``
     - STATUS
     - R/W1C
     - See `STATUS`_. Writing 1 to an ERR bit clears it, at the commit.
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
     - Committed work pending, the engine not idle, or in reset.
   * - 6
     - RESP_RDY
     - Nothing left to execute and SDI bytes waiting: everything sent so far
       has run and its SDI bytes can be fetched.
   * - 5:3
     - ERR
     - Sticky frame errors, see `Validation and errors`_: bit 5 integrity,
       4 overflow, 3 bad instruction. While any is set, frames are rejected,
       see `Error recovery`_. Cleared by FLUSH, or by CTRL_W writing 1s.
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
- MISO bytes 0 and 1 are the `Frame header`_. Apart from it, `Replies`_ and
  the MISO CRC, all MISO bytes are ``0x00``.
- With ``CRC_EN = 1`` the frame ends with a CHECK, see `Frame check (CRC)`_.
- A frame with no bytes at all is ignored.

**A frame takes effect as a whole when it commits, or not at all.** Engine
instructions are written into the CMD FIFO and their SDO bytes into the SDO
FIFO as they arrive, CTRL_W and GPIO writes into the bridge-write FIFO. At CS
deassert the decoder either commits the frame to all of them in the same
cycle, or rolls them back. Committed bridge writes are then applied, one per
``clk``; a FLUSH and an ERR clear act at the commit itself. Frame *k* executes
while frame *k + 1* is being received.

Only replies happen during the frame: CTRL_R, GPIO reads and FETCH answer on
MISO. A read therefore sees the writes of earlier frames, not those of its own
frame.

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
     - Write ``dd`` to register ``a``, at the commit.
   * - ``0xAa00``
     - 2
     - CTRL_R
     - Reply with register ``a``.
   * - ``0xB?ii``
     - 3
     - GPIO
     - Access GPIO ``ii``. High byte ``{4'hB, rd, sel, value, 1'b0}``.
       With rd = 0 (``0xB0`` to ``0xB6``), write ``value`` at the commit, to
       OUT for sel 0 or to DIR for sel 1 (0 = output, 1 = input). With rd = 1
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
       counted like a TRANSFER). At the commit, acknowledges the previous
       batch, see `Reads`_.
   * - ``0xD2nn`` + ``n + 2`` filler bytes
     - 5
     - FETCH retry
     - Reply again with the unacknowledged batch; acknowledges nothing.
   * - ``0xD100``
     - 5
     - FETCH ack
     - Acknowledge the previous batch at the commit; no read, no filler.
   * - ``0xE0xx``
     - 6
     - FLUSH
     - Only as the first instruction of a frame. At the commit, drop all work
       queued by earlier frames and all SDI data, reset the engines
       (deasserting every downstream CS) and clear the ERR bits. The rest of
       its frame is kept.
   * - ``0xF000`` + ``crc_hi``, ``crc_lo``
     - 7
     - CHECK
     - With ``CRC_EN = 1``, the last instruction of every frame, see
       `Frame check (CRC)`_.

CHECK without ``CRC_EN`` is a bad instruction, and so is GPIO in a translator
built without GPIOs, a FLUSH that is not the first instruction, and FETCH with
bits 9:8 = ``11``. ``field`` must be 0 for NOP, SELECT, FLUSH and CHECK,
bits 11:10 of FETCH must be 0, the low bit of a GPIO write high byte and the
three low bits of a GPIO read high byte must be 0, and the low byte of CTRL_R,
CHECK and a FETCH ack must be ``0x00``. FETCH filler bytes are ignored. Bridge
and engine instructions can be mixed in one frame. FETCH's flags sit in bits
9:8 like R and W of a TRANSFER, but only one may be set.

Because a frame acts as a whole:

- several CTRL_W or GPIO writes can be sent in one frame; they are applied in
  order after the commit, and a CTRL_R or GPIO read sees them from the next
  frame on;
- a rejected frame applies none of its writes, so resending it is harmless;
- a frame such as ``FLUSH, CFG, PRESCALE, CS, ...`` recovers and starts again:
  the FLUSH drops what earlier frames queued and resets the engines, and the
  rest of the frame runs once the reset is over. The engines restart from
  their reset configuration, so the frame sets the mode and clock again.

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
bytes, and a CTRL_R that ends a frame is followed by a NOP, or by the CHECK,
to clock its data out:

.. code-block:: text

   MOSI  [CTRL_R a][CTRL_R b][CTRL_R c][NOP  ]
   MISO  [ ..  ..][a   ..  ][b   ..  ][c  ..]

GPIO reads chain the same way, its reply landing in the low byte of the following
instruction.

Frame header
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The first two MISO bytes of every frame carry the bridge state, at no cost on
the wire:

.. code-block:: text

   MOSI  [ i0 ][ i1  ][ ... ]
   MISO  [STAT][SYNC ][ ... ]

- **Byte 0** is STATUS as it was a few ``clk`` after the previous frame ended,
  so its ERR bits tell the host whether that frame was committed, and CREDIT
  how much it may send. BUSY and RESP_RDY are as of that moment too; a CTRL_R
  of STATUS gives the live value.
- **Byte 1** is SYNC_ID at the start of the frame, so a host waiting for a
  SYNC needs no CTRL_R.

Byte 0 comes from a register in the ``clk`` domain that only changes between
frames; the slave drives its bit 7 from CS fall. See `Timing requirements`_.

Frame check (CRC)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

With ``CRC_EN = 1`` every frame ends with a CHECK, and both directions are
protected by CRC-16/CCITT-FALSE (polynomial ``0x1021``, MSB first, initial
value ``0xFFFF``, no final XOR; in Linux ``crc_itu_t(0xffff, buf, len)``,
check value ``0x29B1`` for ``"123456789"``):

.. code-block:: text

   MOSI  [ i0 ][ i1 ] ... [0xF0][0x00][crc_hi ][crc_lo ]
   MISO  [STAT][SYNC] ... [ r  ][ r  ][mcrc_hi][mcrc_lo]

- ``crc`` covers the MOSI bytes from byte 0 through CHECK's ``0x00``. The frame
  only passes if CHECK is its last instruction, complete, and ``crc`` matches.
- ``mcrc`` covers the MISO bytes from byte 0 through the one sent during
  CHECK's ``0x00``: the header, every reply, and the replies of the
  instructions just before CHECK (``r``). CHECK is recognized on its high
  byte, like CTRL_R, so ``mcrc`` goes out during its own CRC bytes and CHECK
  needs no filler. The host checks ``mcrc`` before using any reply; for FETCH
  data it then acknowledges or retries, see `Reads`_.
- CHECK adds 4 bytes to every frame. The verdict of a frame is not returned
  in the frame itself but in the header of the next one.

A frame that fails the check is rejected as a whole, with ERR bit 5 only.

Error recovery
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frames are pipelined: frame *k + 1* is usually sent before the host has seen
the verdict of frame *k*. To keep the order, a rejected frame blocks the ones
after it (go-back-N):

- A frame that starts while any ERR bit is set is rejected as a whole and adds
  no ERR bits, unless its first instruction **resumes**: a CTRL_W to STATUS
  (``0x95dd``) writing 1 to every set ERR bit, or FLUSH.
- Reads in a blocked frame still reply, but nothing of it takes effect.

When the header shows ERR, the host resends everything from the rejected
frame on, starting with the resume:

.. code-block:: text

   frame k     damaged                               -> rejected, ERR[5] set
   frame k+1   header shows ERR = 100                -> rejected, blocked
   frame k+2   CTRL_W(STATUS, 0x20)  <frame k>  <frame k+1>  CHECK
                                                     -> accepted, ERR cleared

Nothing after the rejected frame has run, so the engines, the queued work, the
response FIFO and any target held selected are exactly as frame *k - 1* left
them: a transfer split over frames simply continues. The host only writes 1s
for the bits it has seen, so an error it has not seen yet keeps blocking.
FLUSH is the coarse recovery, for when the state is unknown: it drops all
queued work and resets the engines, and the host resends the messages whose
SYNC id it has not seen and fetches their reads again.

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

A GPIO write is applied right after its frame commits, like CTRL_W, while the
frame's engine instructions run later, as the engine reaches them; the two are
not ordered. A pin that must change after some SPI traffic, such as a load or
reset line, is written in a later frame once BUSY has cleared. Minimum hold times are kept by the host waiting
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
TRANSFER. If the FETCH frame is rejected, the read is rewound and the same
FETCH, resent, returns the same bytes.

**The bytes a committed FETCH frame read stay in the response FIFO as an
unacknowledged batch**, so the host can read them again when they arrived
damaged (bad ``mcrc``, or simply not received):

- The next FETCH (``0xD0nn``) acknowledges the batch: when its frame commits,
  the batch is released and its room freed. A host that is happy with the
  data just carries on.
- A FETCH retry (``0xD2nn``) returns the unacknowledged batch again and
  acknowledges nothing.
- A FETCH ack (``0xD100``) only releases the batch. It is needed when the
  batch and the next response would not fit in the response FIFO together.

SDI_LEVEL and RESP_RDY count the bytes not fetched yet; the room taken by the
unacknowledged batch shows in neither.

Writes need no FETCH: a posted write has nothing to return. A write that must
be confirmed ends with a SYNC, and the host checks SYNC_ID. For a fence over
all writes so far, the host waits for BUSY to clear and checks the ERR bits.

Validation and errors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A frame that fails any check is rolled back as a unit: nothing from it reaches
a downstream device, none of its bridge writes is applied, its FETCH reads are
rewound, and the matching ERR bit in STATUS is set. The frames after it are
rejected until the host resumes, see `Error recovery`_.

.. list-table::
   :header-rows: 1

   * - STATUS bit
     - Condition
   * - 3
     - Bad instruction: engine class ``101`` to ``111``, CHECK without
       ``CRC_EN``, GPIO without GPIOs, FLUSH not first, reserved TRANSFER,
       WRITE or bridge fields, a CHIPSELECT selecting more than one target or
       one the selected engine does not have, a SELECT of a missing engine or
       of another engine while a target is selected, or a word length outside
       1..8.
   * - 4
     - The frame does not fit in the room left in the CMD, SDO or
       bridge-write FIFO.
   * - 5
     - Integrity. With ``CRC_EN = 1``: the frame does not end with a complete,
       matching CHECK (CRC mismatch, no CHECK, cut short, bytes after it).
       Without: the frame ends inside an instruction, its SDO data or a
       FETCH's filler bytes.

When bit 5 is set, bits 4 and 3 are not reported for that frame: a damaged
frame can look malformed, and the host's answer is the same, resending it.
Bits 4 and 3 therefore only mean a host-side problem in a frame that arrived
intact.

.. _spi_translator split-transfers:

Split transfers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A frame may end with a target still selected. The engine then keeps that chip
select asserted, and the next frame continues the same downstream transaction:

.. code-block:: text

   frame 1   CS(select t)  WR(k)  data ...
   frame 2                 WR(m)  data ...  CS(release)

The target sees one CS-held transfer of ``k + m`` words. This lets a transfer
longer than the FIFOs be sent in pieces.

Each frame is still checked as a unit, so a bad piece never reaches the
target, but the pieces before it already have. If a later piece is rejected,
the target stays selected and the frames after it are blocked; the host
resumes with a CTRL_W to STATUS and resends from the rejected piece, and the
target still sees one transfer, see `Error recovery`_. A FLUSH instead resets
the engines and so ends the transfer. While a target is selected, a SELECT of
another engine is rejected.

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
- MISO byte 0 is the STATUS byte of the `Frame header`_, from a register
  that only changes between frames. Its bit 7 is driven from CS fall; the
  following bits change on the same edge as all other MISO bits, so byte 0
  needs no SCLK edge before the first sample edge, also in modes 1 and 3.
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
- CS must stay high for at least about 12 ``clk`` cycles between frames: the
  frame is committed a few cycles after CS rises, and the header of the next
  frame is taken about 6 cycles after that.
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
registers such as ERR clear or FLUSH must act at the frame's commit, not when
the engine reaches them behind queued frames.

Bridge writes at the commit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CTRL_W, GPIO writes and FLUSH act when their frame commits, with or without
CRC, rather than when they are decoded. Every frame is then all-or-nothing:
a rejected frame changes nothing, so resending it never applies a write twice,
and with CRC a damaged byte that happens to decode as a write or FLUSH can
never act. The cost is read-after-write within a frame, which only register
tests used. FLUSH must be first in its frame, the only place it is useful, so
at the commit it simply drops everything queued before the frame.

Frame check, header and go-back-N
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The CRC is a single trailer per frame rather than per-instruction checks or
checkpoints: one CRC per frame is enough when the frame acts as a whole.
Returning the frame verdict in the frame itself would need filler bytes after
the CRC, 4 more bytes on every frame; instead the verdict rides in MISO byte
0 of the next frame, which was unused. Because the host learns about a failure
one frame late, frames after a failure are blocked until the host resumes:
otherwise a resent frame would run after frames sent later. The resume is a
CTRL_W to STATUS rather than FLUSH so that queued work and held chip selects
survive a CRC error.

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

- **Without CRC_EN** a corrupted frame that still parses is executed, and
  corrupted MISO data is not detected.
- **Partial bytes** cut short by CS are dropped silently by the slave.
- **8-bit SDO words only** (engine ``DATA_WIDTH = 8``).
- **No downstream watchdog**; a hung engine is recovered with FLUSH.
- **Engines run one at a time**; there is no parallel traffic on different
  engines.

.. _spi_translator:

SPI Translator
================================================================================

.. toctree::
   :hidden:

   Slave Module<spi_translator_slave>
   Interconnect Module<spi_translator_interconnect>

The SPI Translator is a store-and-forward bridge that lets a host with a single
SPI chip select reach several downstream SPI devices, each driven by its
unmodified Linux driver. The host sends a serialized
:ref:`SPI Engine <spi_engine>` instruction stream over one upstream SPI link;
the bridge checks each frame as a whole and only then replays it into one or
more stock :ref:`spi_engine execution` modules, which drive the downstream
buses. Read data and bridge registers come back to the host over MISO.

.. important::

   This core is work in progress, see :ref:`spi_translator limitations`.

Sub-modules
--------------------------------------------------------------------------------

* :ref:`spi_translator slave`: upstream SPI slave, frame decoder, bridge
  instructions, transactional FIFOs, register file and GPIOs (IP
  ``spi_translator_slave``).
* :ref:`spi_translator interconnect`: routes the instruction stream to the
  engine chosen by SELECT (IP ``spi_translator_interconnect``).
* :ref:`spi_engine execution`: the stock SPI Engine execution module, one per
  8 downstream chip selects.

The block design script builds all three as one hierarchy, see
`Block design script`_.

Features
--------------------------------------------------------------------------------

- Upstream SPI slave clocked by SCLK, any of the four SPI modes (fixed at
  synthesis)
- Upstream stream format is the SPI Engine instruction set, plus bridge
  instructions
- Whole frames are checked before anything reaches a downstream device; a bad
  frame is dropped as a unit
- Up to 128 downstream targets on up to 16 stock ``spi_engine_execution``
  instances, 8 per engine, selected in-band with SELECT; per-transaction mode,
  clock and word length
- A Tcl script builds the translator, interconnect and engines as one block
  design hierarchy
- Transactional CMD, SDO and response FIFOs, sized independently
- Two-frame reads (request, then FETCH), retryable
- A downstream transfer can be split over several frames
- Register file with status, FIFO levels and last SYNC id
- Up to 256 GPIOs, written and read one pin per instruction

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/spi_translator/spi_translator_slave`
     - Slave module, see :ref:`spi_translator slave`.
   * - :git-hdl:`library/spi_translator/spi_translator_interconnect`
     - Interconnect module, see :ref:`spi_translator interconnect`.
   * - :git-hdl:`library/spi_translator/scripts/spi_translator.tcl`
     - ``spi_translator_create``: builds the block design hierarchy, see
       `Block design script`_.
   * - :git-hdl:`library/spi_translator/tb/spi_translator_tb.v`
     - Self-checking testbench, one engine.
   * - :git-hdl:`library/spi_translator/tb/spi_translator_me_tb.v`
     - Self-checking testbench, two engines.

Block Diagram
--------------------------------------------------------------------------------

.. code-block:: text

   +--------------------------------------------------------------+
   | <name>: spi_translator_create hierarchy                      |
   |                                                              |
   |  +-----------------------------+                             |
   |  | <name>_slave                |<------------------------------- cs, sclk, sdi
   |  | IP spi_translator_slave     |-------------------------------> sdo, sdi_t
   |  |                             |<------------------------------> gpio_i/o/t
   |  +-----------------------------+                             |
   |        | spi_engine_ctrl   | spi_resetn (pulsed by FLUSH)    |
   |        v                   +------------------+-------+      |
   |  +-----------------------------+              |       |      |
   |  | <name>_interconnect         |<-------------+       |      |
   |  | IP spi_translator_          |                      |      |
   |  |    interconnect (SELECT)    |                      |      |
   |  +-----------------------------+                      |      |
   |     | m0_ctrl     | m1_ctrl        | m<N-1>_ctrl      |      |
   |     v             v                v                  |      |
   |  +-----------+ +-----------+    +-----------+  resetn |      |
   |  | <name>_   | | <name>_   |    | <name>_   |<--------+      |
   |  | execution | | execution | ...| execution |  (all          |
   |  | _0        | | _1        |    | _<N-1>    |   engines)     |
   |  +-----------+ +-----------+    +-----------+                |
   |     |             |                |                         |
   +-----|-------------|----------------|-------------------------+
         v             v                v
      m_spi_0       m_spi_1          m_spi_<N-1>   (spi_engine_rtl)

The slave module checks and queues each frame; the interconnect passes the
committed stream to the engine selected by the last SELECT, one engine at a
time.

.. _spi_translator engines:

Engines
--------------------------------------------------------------------------------

The ``NUM_OF_CS`` targets are spread over ``ceil(NUM_OF_CS / 8)`` engines, 8
each and the remainder on the last one, up to 16 engines and 128 targets.
A target is numbered ``{ee, cs[2:0]}``: the host sends SELECT ``ee``
(``0xC0ee``, the engine number in the low byte) with the upper bits, then the usual engine instructions, whose CHIPSELECT masks pick
one of the engine's chip selects with the lower bits.

.. code-block:: text

   target 11 = engine 1, chip select 3

   SELECT(1)  CFG  PRESCALE  CS(0xf7)  TRANSFER ...  CS(0xff)  SYNC(id)

The engines run one at a time, in stream order:

- SELECT is queued in the CMD FIFO like an engine instruction, so it takes
  effect after everything before it; the interconnect consumes it once the
  current engine is idle and has delivered all its SDI bytes. Reads from
  several engines in one message therefore come back in the order they were
  sent, and SYNC_ID keeps its meaning.
- Engine 0 is selected after reset and after FLUSH, so a translator with one
  engine needs no SELECT at all.
- An engine keeps its configuration (mode, clock divider, word length) when
  another is selected; the host sends the configuration of each message as
  usual, after its SELECT.
- A SELECT is rejected when ``ee`` is beyond the last engine, or when it names
  another engine while a target is still selected (see :ref:`spi_translator split-transfers`), so
  at most one target is ever active. A CHIPSELECT of a chip select that the
  selected engine does not have, possible on the last engine, is rejected as
  well.

The decoder checks these rules against the engine and chip select state that
the stream will leave behind, which it tracks per frame: kept when the frame
commits, restored when it is rolled back, and reset by FLUSH. CS_NUM tells
software how many targets the translator has.

.. _spi_translator block-design-script:

Block design script
--------------------------------------------------------------------------------

``spi_translator_create`` builds a hierarchy with the core, the interconnect
and the engines, and connects the control buses and resets:

.. code-block:: tcl

   source $ad_hdl_dir/library/spi_translator/scripts/spi_translator.tcl

   # name, num_cs, num_gpio, gpio_default_dir, gpio_default_out
   spi_translator_create spi_translator 12 4 0x0 0xA

   ad_connect spi_translator/m_spi_0 spi_eng0
   ad_connect spi_translator/m_spi_1 spi_eng1

Further optional arguments, in order: ``up_cpol``, ``up_cpha``,
``up_early_launch``, ``cmd_fifo_addr_width``, ``sdo_fifo_addr_width``,
``resp_fifo_addr_width``, ``sdi_delay`` and ``echo_sclk`` (the last two apply
to every engine). The hierarchy pins are ``clk``, ``resetn``, the upstream
``sclk``, ``sdi``, ``sdo``, ``sdi_t`` and ``cs``, ``gpio_i/o/t`` when there
are GPIOs, one ``m_spi_<k>`` interface per engine, and ``echo_sclk_<k>`` with
``echo_sclk = 1``. Inside, the slave module is ``<name>_slave``, the
interconnect ``<name>_interconnect`` and the engines ``<name>_execution_<k>``.

Design decision: one level of engines
--------------------------------------------------------------------------------

More than 8 targets are reached with several engines behind one translator
rather than with cascaded translators. A cascade adds a second store-and-forward
hop per transfer and nested framing on the host; the interconnect adds neither.
The engine is chosen in-band by SELECT, queued with the stream, so switching
needs no extra round trip and stays ordered with the transfers around it. The
engines run one at a time: a single response FIFO and SYNC_ID then stay exact,
and only one target is active at any moment. The engine number takes the whole
low byte of SELECT, like the index of GPIO and the count of FETCH, so the
encoding allows 256 engines; the hardware is built for up to 16 engines and
128 targets, a limit of the interconnect rather than of the protocol.

Simulation
--------------------------------------------------------------------------------

The testbenches drive the bridge with an upstream mode 0 SPI master task that
also captures MISO:

- ``spi_translator_tb``: one engine behind the interconnect, four behavioural
  targets in modes 0 to 3. The FIFOs are built small (16 instructions, 32 SDO
  bytes) so they can be filled. ``spi_translator_el_tb`` runs the same tests
  with ``UP_EARLY_LAUNCH = 1``.
- ``spi_translator_me_tb``: ``NUM_OF_CS = 12`` over two engines (8 + 4), the
  second with ``SDI_DELAY = 1``. Covers SELECT routing, reads from both engines
  in one message, SYNC_ID against the delayed last SDI byte, the SELECT and
  CHIPSELECT rejections, FLUSH back to engine 0, and a rejected frame leaving
  the selection unchanged.

They run with Vivado xsim:

.. shell::

   $cd library/spi_translator/tb
   $SIMULATOR=xsim MODE=batch ./spi_translator_tb
   $SIMULATOR=xsim MODE=batch ./spi_translator_el_tb
   $SIMULATOR=xsim MODE=batch ./spi_translator_me_tb

References
--------------------------------------------------------------------------------

- :ref:`spi_engine`
- :ref:`spi_translator slave`
- :ref:`spi_translator interconnect`
- :ref:`spi_engine instruction-format`
- :ref:`spi_engine control-interface`
- FPGA SPI Translator proposal (``fpga_spi_translator``)

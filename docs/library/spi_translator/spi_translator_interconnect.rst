.. _spi_translator interconnect:

Interconnect Module
================================================================================

The interconnect module, IP ``spi_translator_interconnect``, connects the :ref:`spi_translator slave` to up to 16
:ref:`spi_engine execution` modules and routes the translator's instruction
stream to one of them at a time. The engine is chosen in-band by the bridge
instruction SELECT, which the translator queues in its CMD FIFO with the
engine instructions; the interconnect consumes it and never forwards it.

It is normally instantiated by ``spi_translator_create``, see
:ref:`spi_translator block-design-script`, and driven by the
:ref:`spi_translator slave`.

Features
--------------------------------------------------------------------------------

- One SPI Engine control interface in, up to 16 out
- Engine switched by SELECT, in order with the instruction stream
- Switching only once the current engine is idle and has delivered all its SDI
  bytes
- SYNC only executed once the SDI bytes before it are queued

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/spi_translator/spi_translator_interconnect/spi_translator_interconnect.v`
     - Verilog source.
   * - :git-hdl:`library/spi_translator/spi_translator_interconnect/spi_translator_interconnect_ip.tcl`
     - Vivado IP packaging.

Block Diagram
--------------------------------------------------------------------------------

.. code-block:: text

                         +------------------------------+
                         |  spi_translator_interconnect |
   spi_translator_slave  |                              |      engines
                         |   SELECT --> sel             |
   s_ctrl  cmd  -------->|   cmd ---------------------->|---> m0_ctrl  engine 0
           sdo  -------->|   sdo  (to engine sel) ----->|---> m1_ctrl  engine 1
           sdi  <--------|   sdi  (from engine sel) <---|     ...
           sync <--------|   sync (from engine sel) <---|---> m15_ctrl engine 15
                         |                              |
                         |   SDI words due: sdi_pending |
                         +------------------------------+

Configuration Parameters
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Default
     - Description
   * - ``NUM_OF_ENGINES``
     - 1
     - Number of engines, 1 to 16; ``ceil(NUM_OF_CS / 8)`` of the translator.

Interface
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Port
     - Direction
     - Description
   * - ``clk``
     - in
     - Clock, the translator's ``clk``.
   * - ``resetn``
     - in
     - Active-low synchronous reset. Connect to the translator's
       ``spi_resetn``, so FLUSH returns to engine 0.
   * - ``s_*``
     - in/out
     - :ref:`SPI Engine control interface <spi_engine control-interface>`,
       slave side, from the translator.
   * - ``m<k>_*``
     - in/out
     - SPI Engine control interface, master side, to engine ``k``. Only
       present for ``k < NUM_OF_ENGINES``.

Theory of Operation
--------------------------------------------------------------------------------

Routing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The register ``sel`` holds the selected engine, 0 after reset. An instruction
with ``cmd[15:12] = 0xC`` is a SELECT (``0xC0ee``): when it is taken, ``sel``
becomes the engine number ``ee`` in ``cmd[7:0]``. Every other instruction and every SDO byte goes to engine
``sel``; SDI bytes and SYNC ids come from it. The other engines see no valid
data and get no ready.

The translator only queues a SELECT that names an existing engine and leaves
no target selected on the previous one, so the interconnect does not check it
again.

SDI words due
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An engine reports idle (``cmd_ready``) when a transfer is done, but with
``SDI_DELAY`` or ``ECHO_SCLK`` its last SDI word is still in its pipeline for
a few cycles. The interconnect therefore counts the SDI words still due: a
TRANSFER with its read bit set (``cmd[9]``) sets the count to ``n + 1``, each
word handed to the translator removes one. While words are due, no instruction
is taken (``s_cmd_ready`` low). As a result:

- a SELECT only switches once the old engine has delivered everything, so no
  word ends up with the wrong engine or the wrong message;
- a SYNC only executes once the SDI words before it are in the response FIFO,
  so SYNC_ID never runs ahead of the data;
- the translator's BUSY stays set meanwhile, so RESP_RDY cannot rise early.

The cost is a few ``clk`` cycles between a read TRANSFER and the next
instruction. The engine only takes the next instruction after the transfer is
done anyway, so at most one read is outstanding and the count is reloaded,
never accumulated.

References
--------------------------------------------------------------------------------

- :ref:`spi_translator`
- :ref:`spi_translator slave`
- :ref:`spi_engine control-interface`
- :ref:`spi_engine interconnect`

.. _spi_engine offload:

SPI Engine Offload Module
================================================================================

.. hdl-component-diagram::

The SPI Engine Offload peripheral allows to store a SPI Engine command and SDO
data stream in a RAM or ROM module. The command stream is executed when the
``trigger`` signal is asserted. This allows the execution of SPI transactions
with a very short delay in reaction to a event.

Files
--------------------------------------------------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/spi_engine/spi_engine_offload/spi_engine_offload.v`
     - Verilog source for the peripheral.
   * - :git-hdl:`library/spi_engine/spi_engine_offload/spi_engine_offload_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project for the
       peripheral.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - ASYNC_SPI_CLK
     - If set to 1 the ``ctrl_clk`` and ``spi_clk`` are assumed to be
       asynchronous.
   * - ASYNC_TRIG
     - If set to 1, the trigger input is considered asynchronous to the
       module.
   * - CMD_MEM_ADDRESS_WIDTH
     - Configures the size of the command stream storage. The size is
       ``2**CMD_MEM_ADDR_WIDTH`` entries.
   * - SDO_MEM_ADDRESS_WIDTH
     - Configures the size of the SDO data stream storage. The size is
       ``2**SDO_MEM_ADDR_WIDTH`` entries.
   * - DATA_WIDTH
     - Data width of the parallel data stream. Will define the transaction's
       granularity. Supported values: 8/16/24/32
   * - NUM_OF_SDI
     - Number of multiple SDI lines, (min: 1, max: 8)
   * - SDO_STREAMING
     - Enables the s_axis_sdo interface. This allows for sourcing the SDO data
       stream from a DMA or other similar sources, useful for DACs.

Signal and Interface Pins
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - ctrl_clk
     - The ``spi_engine_offload_ctrl`` signals are synchronous to this clock.
   * - spi_clk
     - The ``spi_engine_ctrl`` signals, ``offload_sdi`` signals and
       trigger are synchronous to this clock.
   * - spi_resetn
     - Synchronous active low reset
     - Resets the internal state machine of the core.
   * - trigger
     - When asserted the stored command and data stream is send out on the
       ``spi_engine_ctrl`` interface.
   * - spi_engine_offload_ctrl
     - :ref:`spi_engine offload-control-interface` subordinate.
       Control interface which allows to re-program the stored command and SDO
       data stream.
   * - spi_engine_ctrl
     - :ref:`spi_engine control-interface` controller.
       SPI Engine Control stream that contains commands and data.
   * - offload_sdi
     - Streaming AXI controller
       Output stream of the received SPI data.
   * - s_axis_sdo
     - Streaming AXI peripheral
       Input stream for SPI data to be sent. Only present when ``SDO_STREAMING`` parameter is set to 1.

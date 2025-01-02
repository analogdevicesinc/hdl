.. _cn0363_dma_sequencer:

CN0363 DMA Sequencer FPGA Peripheral
================================================================================

.. hdl-component-diagram::

The CN0363 Sequencer FPGA Peripheral is part of the 
:dokuwiki:`CN0363 HDL project documentation <resources/eval/user-guides/eval-cn0363-pmdz/reference_hdl>` 
and is responsible to sequence the various data channels to the DMA.

Files
--------------------------------------------------------------------------------

.. list-table::
    :header-rows: 1
    
    * - Name
      - Description
    * - :git-hdl:`/library/cn0363/cn0363_dma_sequencer/cn0363_dma_sequencer.v`
      - Verilog source for the peripheral.
    * - :git-hdl:`/library/cn0363/cn0363_dma_sequencer/cn0363_dma_sequencer_ip.tcl`
      - TCL script to generate the Vivado IP-integrator project for the 
        peripheral.

Signal and Interface Pins
--------------------------------------------------------------------------------

.. hdl-interfaces::

    * - clk
      - Clock
      - All other signals are synchronous to this clock.
    * - resetn
      - Synchronous active low reset
      - Resets the internal state machine of the core.
    * - phase
      - AXI-Stream slave
      - Phase data channel.
    * - data
      - AXI-Stream slave
      - Sample data channel.
    * - data_filtered
      - AXI-Stream slave
      - Filtered sample data channel.
    * - i_q
      - AXI-Stream slave
      - Demodulated I/Q sample data channel.
    * - i_q_filtered
      - AXI-Stream slave
      - Filtered demodulated I/Q sample data channel.
    * - dma_wr
      - FIFO Write Interface master
      - Low-level SPI bus interface that is controlled by peripheral.
    * - overflow
      - Output
      - The overflow signal is asserted if a overflow on the DMA interface is
        detected.
    * - channel_enable
      - Input
      - Data channel enable sequencer output enable.
    * - processing_resetn
      - Output
      - Reset signal for the processing pipeline

Theory of Operation
--------------------------------------------------------------------------------

The CN0363 DMA sequencer core acts as a link between the CN0363 processing
pipeline and the connected DMA controller. On one side it accepts data from the
processing pipeline and on the other side it sends the data to the DMA
controller. The core is only active when the DMA controller signals that it is
waiting for data, when it is inactive it also asserts the ``processing_resetn``
signal to keep the processing pipeline in reset. Since the DMA is running at a
much faster clock than the output data rate from the processing pipeline the
different channels are time-division-multiplexed and send one by one to the DMA
controller over the ``dma_wr`` interface.

When active the core cycles through the input channels in the following order.

#. phase (Reference channel)
#. data (Reference channel)
#. data_filtered (Reference channel)
#. i_q, I component (Reference channel)
#. i_q, Q component (Reference channel)
#. i_q_filtered, I component (Reference channel)
#. i_q_filtered, Q component (Reference channel)
#. phase (Sample channel)
#. data (Sample channel)
#. data_filtered (Sample channel)
#. i_q, I component (Sample channel)
#. i_q, Q component (Sample channel)
#. i_q_filtered, I component (Sample channel)
#. i_q_filtered, Q component (Sample channel)

Each of these has a corresponding bit in the ``channel_enable`` and only if the
bit is set the channel is sent to the ``dma_wr`` interface, otherwise it is
discarded. This allows an application to select which data channels it wants to
capture.

More Information
--------------------------------------------------------------------------------

-  :dokuwiki:`[Wiki] CN0363 HDL project documentation <resources/eval/user-guides/eval-cn0363-pmdz/reference_hdl>`

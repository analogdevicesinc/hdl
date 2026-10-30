.. _util_sample_join_fifo:

Sample Join FIFO
===============================================================================

.. hdl-component-diagram::

The :git-hdl:`Sample Join FIFO <library/util_sample_join_fifo>` core brings
channels that deliver words on their own clocks onto one output clock. The
n-th words of all channels always leave together, so the channels stay paired
word by word.


Features
-------------------------------------------------------------------------------

* Supports AMD Xilinx devices
* Up to 64 channels, each on its own ports
* Channel enables and the overflow of the sink cross along
* Optional start of a capture with the transfer request of the sink

Files
-------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/util_sample_join_fifo/util_sample_join_fifo.v`
     - Verilog wrapper with separate ports per channel.
   * - :git-hdl:`library/common/ad_sample_join_fifo.v`
     - Join FIFO.
   * - :git-hdl:`library/util_sample_join_fifo/util_sample_join_fifo_constr.ttcl`
     - Clock domain crossing constraints.

Configuration Parameters
-------------------------------------------------------------------------------

.. hdl-parameters::

   * - NUM_CHANNELS
     - Number of channels.
   * - DATA_WIDTH
     - Width of the data word of each channel in bits.
   * - ADDRESS_WIDTH
     - Address width of the FIFO of each channel.
   * - XFER_REQ_ENABLE
     - Drop the words while xfer_req is low and hold out_reset, so a capture
       starts with the words after the request.
   * - OVERFLOW_XFER_REQ
     - Report a word dropped by a full channel FIFO only while xfer_req is
       high.
   * - CHANNEL_ENABLE_XFER_HOLD
     - Keep out_enable_i while xfer_req is high.

Interface
-------------------------------------------------------------------------------

.. hdl-interfaces::

   * - clk_i, reset_i, valid_i, data_i, enable_i, overflow_i
     - Channel i, on clk_i.
   * - async_resetn
     - Asynchronous reset that empties all FIFOs, also while the clocks are
       stopped, e.g. the sync_n of the converters.
   * - out_clk, out_valid, out_data_i, out_enable_i, out_reset
     - Output side, on out_clk.
   * - out_overflow
     - Overflow of the sink; it pulses every overflow_i.
   * - xfer_req
     - Transfer request of the sink, on out_clk, with XFER_REQ_ENABLE.

Detailed Description
-------------------------------------------------------------------------------

Each channel writes into a small FIFO. The output takes one word of every
channel only when each has one. The channel clocks must come from the same
reference at the same frequency; they may start at different times. Clocks
from independent references drift apart, and a FIFO then overflows now and
then. When a channel stops, the output stops too.

The join FIFO does not align the conversion instants of the channels; it
pairs the words in the order they arrive.

References
-------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/util_sample_join_fifo`
* :ref:`util_sample_pack`

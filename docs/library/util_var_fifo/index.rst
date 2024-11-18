.. _util_var_fifo:

Util VAR FIFO
===============================================================================

.. hdl-component-diagram::

The :git-hdl:`Util VAR FIFO <library/util_var_fifo>` core
controls an external BRAM memory through which it allows
the storage of a variable number of samples before triggering.

Features
--------------------------------------------------------------------------------

* Variable depth

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/util_var_fifo/util_var_fifo.v`
     - Verilog source for the peripheral.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - DATA_WIDTH
     - Data width of the FIFO. The BRAM generator parameters should match this.
   * - ADDRESS_WIDTH
     - The BRAM generator parameters should match this. Gives the maximum depth
       of the FIFO

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - clk
     - Clock input. Should be synchronous to the input and the output data.
   * - rst
     - Reset input. Should be synchronous clk clock
   * - depth
     - Controls the depth of the FIFO. Should be less than the maximum depth.
       Controlled by an outside IP.
   * - data_in
     - Data to be stored.
   * - data_in_valid
     - Valid for the input data.
   * - data_out
     - Data forwarded to the DMA.
   * - data_out_valid
     - Valid for the output data.
   * - wea_w
     - Write signal.
   * - en_w
     - Write enable signal.
   * - addr_w
     - Address for the write pointer.
   * - din_w
     - Data to be written to the BRAM.
   * - en_r
     - Read enable signal.
   * - addr_r
     - Address for the read pointer.
   * - dout_r
     - Data read from the BRAM.

Detailed Description
--------------------------------------------------------------------------------

This IP controls an external BRAM. It has a two clock cycle latency even if
bypassed.
If valid is not always asserted, the latency is only one word instead of two.

Design Guidelines
--------------------------------------------------------------------------------

The IP should be used with an external BRAM, which can be optimized for power
or for speed, depending on the design requirements. It uses only one clock
domain, so everything should be synchronous to that clock domain.

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/util_var_fifo`
* :dokuwiki:`UTIL VAR FIFO on wiki <resources/fpga/docs/util_var_fifo>`

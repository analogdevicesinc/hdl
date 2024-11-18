.. _util_extract:

Util Extract
===============================================================================

.. hdl-component-diagram::

The :git-hdl:`Util Extract <library/util_extract>` core
allows the extraction of the trigger signal and restoration of the data signal
that was embedded in the data stream by the :ref:`axi_adc_trigger`.

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/util_extract/util_extract.v`
     - Verilog source for the peripheral.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - NUM_OF_CHANNELS
     - Number of channels
   * - DATA_WIDTH
     - Data width. It assumes the trigger is in bit (n*16)-1, with n being the
       channel number

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - clk
     - Clock input. Should be synchronous to the input and the output data
   * - data_in
     - Input data from the FIFO. Will replace each trigger bit with the sign
       extended version of the data. It should be data from the output of the
       variable fifo
   * - data_in_trigger
     - Data from which the trigger is extracted. It should be data from the
       input of the variable fifo
   * - data_valid
     - Valid for the input data
   * - data_out
     - Data without the embedded trigger
   * - valid_out
     - Valid for the output data
   * - trigger_out
     - Trigger output. Is an logic OR of the triggers from all the channels
       that are captured simulaneously

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/util_extract/util_extract.v`
* :dokuwiki:`UTIL EXTRACT on wiki <resources/fpga/docs/util_extract>`

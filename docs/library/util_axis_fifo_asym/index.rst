.. _util_axis_fifo_asym:

Asymmetric AXI Stream FIFO
================================================================================

.. hdl-component-diagram::

The :git-hdl:`Asymmetric AXI Stream FIFO <library/util_axis_fifo_asym>` core
is a simple FIFO (First Input First Output) with
AXI streaming interfaces, supporting synchronous and asynchronous operation
modes with an asymmetric data width on its salve and master interface. It can be
used to mitigate data width differences or transfer an AXI stream to a different
clock domain.

Features
--------------------------------------------------------------------------------

* Supports Intel/Altera and Xilinx devices
* Configurable data width and depth
* Asymmetric data width
* Support asynchronous (double clocked) mode
* Supports TLAST to indicate packet boundary
* Supports TKEEP to indicate valid data bytes
* Supports FULL/EMPTY and ALMOST_FULL/ALMOST_EMPTY status signals

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/util_axis_fifo_asym/util_axis_fifo_asym.v`
     - Verilog source for the peripheral.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - M_DATA_WIDTH
     - Data width of the Master AXI streaming interface.
   * - S_DATA_WIDTH
     - Data width of the Slave AXI streaming interface.
   * - S_ADDRESS_WIDTH
     - Width of the Slave AXI's address, defines the depth of the FIFO.
   * - ASYNC_CLK
     - Clocking mode, if set the FIFO operates on asynchronous mode.
   * - M_AXIS_REGISTERED
     - Add and additional register stage to the AXI stream master interface.
   * - ALMOST_EMPTY_THRESHOLD
     - Defines the offset (in data beats) between the almost empty and empty
       assertion.
   * - ALMOST_FULL_THRESHOLD
     - Defines the offset (in data beats) between the almost full and full
       assertion.
   * - TLAST_EN
     - Enable ``TLAST`` logical port on the AXI streaming interface.
   * - TKEEP_EN
     - Enable ``TKEEP`` logical port on the AXI streaming interface.

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - s_axis
     - Slave AXI stream.
   * - s_axis_aclk
     - Slave AXI stream clock signal
   * - s_axis_aresetn
     - Slave AXI stream reset signal (active low)
   * - s_axis_room
     - Indicates how much space (in data beats) is in the FIFO
   * - s_axis_almost_full
     - If set the FIFO is almost full
   * - m_axis
     - Master AXI stream.
   * - m_axis_aclk
     - Master AXI stream clock signal
   * - m_axis_aresetn
     - Master AXI stream reset signal (active low)
   * - m_axis_level
     - Indicates how much data is in the FIFO
   * - s_axis_full
     - If set the FIFO is full
   * - m_axis_almost_empty
     - If set the FIFO is almost empty
   * - m_axis_empty
     - If set the FIFO is empty

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: AXI_CLKGEN

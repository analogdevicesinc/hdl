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

* Supports Intel/Altera and AMD Xilinx devices
* Configurable data width and depth
* Asymmetric data width
* Supports asynchronous (double clocked) mode
* Supports TLAST to indicate packet boundary
* Supports TKEEP to indicate valid data bytes
* Supports TSTRB to indicate position bytes in the transfer
* Supports TUSER to transfer user-defined signals
* Supports TID to provide a stream identifier
* Supports TDEST to provide routing information
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
   * - ADDRESS_WIDTH
     - Defines the depth of the FIFO.
   * - ASYNC_CLK
     - Clocking mode. If set, the FIFO operates on asynchronous mode.
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
   * - TSTRB_EN
     - Enable ``TSTRB`` logical port on the AXI streaming interface.
   * - TUSER_EN
     - Enable ``TUSER`` logical port on the AXI streaming interface.
   * - USER_WIDTH
     - ``TUSER`` signal width if ``TUSER`` is enabled.
   * - TID_EN
     - Enable ``TID`` logical port on the AXI streaming interface.
   * - ID_WIDTH
     - ``TID`` signal width if ``TID`` is enabled.
   * - TDEST_EN
     - Enable ``TDEST`` logical port on the AXI streaming interface.
   * - DEST_WIDTH
     - ``TDEST`` signal width if ``TDEST`` is enabled.
   * - REDUCED_FIFO
     - Reduce the FIFO size when master and slave data widths are not equal

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

Detailed Description
--------------------------------------------------------------------------------

The FIFO is based on the
:git-hdl:`util_axis_fifo <library/util_axis_fifo/util_axis_fifo.v>`,
using it as its atomic building block.

The configuration of the atomic
:git-hdl:`util_axis_fifo <library/util_axis_fifo/util_axis_fifo.v>`
blocks are calculated as follows:

.. code:: verilog

   // define which interface has a wider bus
   localparam RATIO_TYPE = (S_DATA_WIDTH >= M_DATA_WIDTH) ? 1 : 0;
   // bus width ratio
   localparam RATIO = (RATIO_TYPE) ? S_DATA_WIDTH/M_DATA_WIDTH : M_DATA_WIDTH/S_DATA_WIDTH;
   // atomic parameters
   localparam A_DATA_WIDTH = (RATIO_TYPE) ? M_DATA_WIDTH : S_DATA_WIDTH;
   localparam A_ADDRESS_WIDTH = (REDUCED_FIFO) ? (ADDRESS_WIDTH-$clog2(RATIO)) : ADDRESS_WIDTH;
   localparam A_ALMOST_FULL_THRESHOLD = (REDUCED_FIFO) ? ((ALMOST_FULL_THRESHOLD+RATIO-1)/RATIO) : ALMOST_FULL_THRESHOLD;
   localparam A_ALMOST_EMPTY_THRESHOLD = (REDUCED_FIFO) ? ((ALMOST_EMPTY_THRESHOLD+RATIO-1)/RATIO) : ALMOST_EMPTY_THRESHOLD;
   localparam A_TUSER_WIDTH = (TUSER_WIDTH > 0) ? TUSER_WIDTH / RATIO : 1; // set to 1 when tuser width is 0 to avoid synthesis errors
   localparam A_TID_WIDTH = (TID_WIDTH > 0) ? TID_WIDTH : 1; // set to 1 when tid width is 0 to avoid synthesis errors
   localparam A_TDEST_WIDTH = (TDEST_WIDTH > 0) ? TDEST_WIDTH : 1; // set to 1 when tdest width is 0 to avoid synthesis errors

FIFO Depth Calculation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The FIFO Depth is calculated based on M_DATA_WIDTH, S_DATA_WIDTH,
ADDRESS_WIDTH and REDUCED_FIFO parameters:

- When M_DATA_WIDTH and S_DATA_WIDTH are equal or REDUCED_FIFO is disabled, the
  ADDRESS_WIDTH specified is not changed.
- When M_DATA_WIDTH and S_DATA_WIDTH are not equal and the REDUCED_FIFO is
  enabled, the ADDRESS_WIDTH is reduced by log2 ratio of the master and slave
  data widths. This change also affects the almost full and empty threshold
  values.

Status Signal Delays
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The FIFO has three different status indicator ports on both side, which
provides information about the state of the FIFO for both the source and
destination logic:

-  FULL or EMPTY - If these outputs are asserted the FIFO is full or empty. In
   case of a full FIFO all the write operations are suspended. In case of an
   empty FIFO all the read operations are suspended.
-  ALMOST_EMPTY/ALMOST_FULL - It can be used to foresee a potential FULL or
   EMPTY state, asserting before the EMPTY/FULL before a predefined number of
   words. The offset between ALMOST_EMPTY and EMPTY, and between ALMOST_FULL and
   FULL can be set by using the parameters ALMOST_EMPTY_THRESHOLD and
   ALMOST_FULL_THRESHOLD. The offset values are automatically adjusted according
   to M_DATA_WIDTH and S_DATA_WIDTH ratio when REDUCED_FIFO is enabled.
-  S_AXIS_ROOM - Indicate how many word can be written in the FIFO at the
   current moment, until the FIFO become FULL.
-  M_AXIS_LEVEL - Indicate how many word can be read from the FIFO at the
   current moment, until the FIFO become EMPTY.

.. important::

   In case of asynchronous mode, because of the delays introduced by the clock
   domain crossing logic, the ROOM and LEVEL indicators can not reflect
   the actual state of the FIFO in real time. Source and destination logic
   should take this into account when controlling the data stream into and
   from the FIFO. Carefully adjusting the ALMOST_EMPTY/ALMOST_FULL indicators
   can provide a save operating margin.

User Signal Transfer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The core support both TUSER bits being relevant to the entire transfer mode
TUSER bits per data byte mode. In the first case, TUSER_WIDTH can be set to any
length. In the case of each data byte having a set of user bits, the calculation
of the USER_WIDTH is done with the following formula for both interfaces:

.. math::

   TUSER_WIDTH = DATA_WIDTH / 8 * USER_BITS_PER_DATA_BYTE;

Where:

- **TUSER_WIDTH** - user width for one of the interfaces
- **DATA_WIDTH** - data bus width in bits for that specific interface
- **USER_BITS_PER_DATA_BYTE** - number of bits used for each data byte

.. important::

   For the TUSER_WIDTH IP parameter, the higher value **must** be used, and the
   TUSER_WIDTH ratio must be equal to the DATA_WIDTH ratio!

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/util_axis_fifo_asym`
* :dokuwiki:`Asymmetric AXI Stream FIFO Core on wiki <resources/fpga/docs/util_axis_fifo_asym>`

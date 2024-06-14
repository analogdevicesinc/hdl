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
   // atomic parameters - NOTE: depth is defined by master or slave and limitation attributes
   localparam A_WIDTH = (RATIO_TYPE) ? M_DATA_WIDTH : S_DATA_WIDTH;
   localparam A_ADDRESS = (ADDRESS_WIDTH_PERSPECTIVE) ?
       ((FIFO_LIMITED) ? ((RATIO_TYPE) ? (ADDRESS_WIDTH-$clog2(RATIO)) : ADDRESS_WIDTH) : ADDRESS_WIDTH) :
       ((FIFO_LIMITED) ? ((RATIO_TYPE) ? ADDRESS_WIDTH : (ADDRESS_WIDTH-$clog2(RATIO))) : ADDRESS_WIDTH);
   localparam A_ALMOST_FULL_THRESHOLD = (RATIO_TYPE) ? ALMOST_FULL_THRESHOLD : (ALMOST_FULL_THRESHOLD/RATIO);
   localparam A_ALMOST_EMPTY_THRESHOLD = (RATIO_TYPE) ? (ALMOST_EMPTY_THRESHOLD/RATIO) : ALMOST_EMPTY_THRESHOLD;

Status Signal Delays
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. important::

   In case of asynchronous mode, because of the delays introduced by the clock
   domain crossing logic, the ROOM and LEVEL indicators can not reflect
   the actual state of the FIFO in real time. Source and destination logic
   should take this into account when controlling the data stream into and
   from the FIFO. Carefully adjusting the ALMOST_EMPTY/ALMOST_FULL indicators
   can provide a save operating margin.

The FIFO has three different status indicator ports on both side, which
provides information about the state of the FIFO for both the source and
destination logic:

-  FULL or EMPTY - If these outputs are asserted the FIFO is full or empty. In
   case of a full FIFO all the write operations are suspended. In case of an
   empty FIFO all the read operations are suspended.
-  ALMOST_EMPTY/ALMOST_FULL - It can be used to foresee a potential FULL or
   EMPTY state, asserting before the EMPTY/FULL before a predefined number of
   word. The offset between ALMOST_EMPTY and EMPTY, and between ALMOST_FULL and
   FULL can be set by using the parameters ALMOST_EMPTY_THRESHOLD and
   ALMOST_FULL_THRESHOLD. The offset values are automatically adjusted
   according to M_DATA_WIDTH and S_DATA_WIDTH ratio.
-  S_AXIS_ROOM - Indicate how many word can be written in the FIFO at the
   current moment, until the FIFO become FULL.
-  M_AXIS_LEVEL - Indicate how many word can be read from the FIFO at the
   current moment, until the FIFO become EMPTY.

FIFO Depth Calculation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The FIFO Depth is calculated based on parameters M_DATA_WIDTH, S_DATA_WIDTH,
ADDRESS_WIDTH, FIFO_LIMITED and ADDRESS_WIDTH_PERSPECTIVE:

- ADDRESS_WIDTH_PERSPECTIVE is 1 and FIFO_LIMITED is 1 - This means that the
  address specified is from the perspective of the Master interface. Since
  the limit is enabled the FIFO size will be reduced if the S_DATA_WIDTH
  is > M_DATA_WIDTH, leading to a smaller FIFO implementation.
- ADDRESS_WIDTH_PERSPECTIVE is 1 and FIFO_LIMITED is 0 - This means that the
  address specified is from the perspective of the Master interface. Since
  the limit is disable the FIFO size will remain the same if the S_DATA_WIDTH
  is > M_DATA_WIDTH, leading to a bigger FIFO implementation.
- ADDRESS_WIDTH_PERSPECTIVE is 0 and FIFO_LIMITED is 1 - This means that the
  address specified is from the perspective of the Slave interface. Since
  the limit is enabled the FIFO size will be reduced if the S_DATA_WIDTH
  is < M_DATA_WIDTH, leading to a smaller FIFO implementation.
- ADDRESS_WIDTH_PERSPECTIVE is 0 and FIFO_LIMITED is 0 - This means that the
  address specified is from the perspective of the Slave interface. Since
  the limit is disable the FIFO size will remain the same if the S_DATA_WIDTH
  is < M_DATA_WIDTH, leading to a bigger FIFO implementation.

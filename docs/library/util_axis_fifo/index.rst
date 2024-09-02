.. _util_axis_fifo:

AXI Stream FIFO
================================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI Stream FIFO <library/util_axis_fifo>` core
is a simple FIFO (First Input First Output) with AXI
streaming interfaces, supporting synchronous and asynchronous operation modes.
It can be used to mitigate data rate differences or transfer an AXI stream to a
different clock domain.

Features
--------------------------------------------------------------------------------

* Supports Intel/Altera and AMD Xilinx devices
* Configurable data width and depth
* Supports asynchronous (double clocked) mode
* Supports TLAST to indicate packet boundary
* Supports FULL/EMPTY and ALMOST_FULL/ALMOST_EMPTY status signals
* Supports zero-deep implementation

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/util_axis_fifo/util_axis_fifo.v`
     - Verilog source for the peripheral.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - DATA_WIDTH
     - Data width of AXI streaming interface.
   * - ADDRESS_WIDTH
     - Width of the address, defines the depth of the FIFO.
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
     - If set, the FIFO is almost full
   * - m_axis
     - Master AXI stream.
   * - m_axis_aclk
     - Master AXI stream clock signal
   * - m_axis_aresetn
     - Master AXI stream reset signal (active low)
   * - m_axis_level
     - Indicates how much data is in the FIFO
   * - s_axis_full
     - If set, the FIFO is full
   * - m_axis_almost_empty
     - If set, the FIFO is almost empty
   * - m_axis_empty
     - If set, the FIFO is empty

Detailed Description
--------------------------------------------------------------------------------

The :git-hdl:`util_axis_fifo <library/util_axis_fifo/util_axis_fifo.v>`
is a generic First Input First Output module, that can be
used to control clock and data rate differences or to do data buffering on a
AXI4 stream based data path. FIFO's write interface is an AXI4 slave streaming
interface, and the FIFO's read interface is an AXI4 master streaming interface.
The depth of the FIFO is defined by the equation, which is a function of the
ADDRESS_WIDTH and DATA_WIDTH parameters:

**FIFO depth in bytes = DATA_WIDTH/8 \* 2 ^ ADDRESS_WIDTH**

The FIFO has three different status indicator ports on both side, which provides
information about the state of the FIFO for both the source and destination
logic:

-  FULL or EMPTY - If these outputs are asserted, the FIFO is full or empty. In
   case of a full FIFO, all the write operations are suspended. In case of an
   empty FIFO, all the read operations are suspended.
-  ALMOST_EMPTY/ALMOST_FULL - It can be used to foresee a potential FULL or
   EMPTY state, asserting before the EMPTY/FULL before a predefined number of
   words. The offset between ALMOST_EMPTY and EMPTY, and between ALMOST_FULL and
   FULL can be set by using the parameters ALMOST_EMPTY_THRESHOLD and
   ALMOST_FULL_THRESHOLD.
-  S_AXIS_ROOM - Indicate how many words can be written in the FIFO at the
   current moment, until the FIFO becomes FULL.
-  M_AXIS_LEVEL - Indicate how many words can be read from the FIFO at the
   current moment, until the FIFO becomes EMPTY.

.. important::

   In case of asynchronous mode, because of the delays introduced
   by the clock domain crossing logic, the ROOM and LEVEL indicators can not
   reflect the actual state of the FIFO in real time. Source and destination logic
   should take this into account when controlling the data stream into and from the
   FIFO. Carefully adjusting the ALMOST_EMPTY/ALMOST_FULL indicators can provide a
   safe operating margin.

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/util_axis_fifo`
* :dokuwiki:`AXI Stream FIFO Core on wiki <resources/fpga/docs/util_axis_fifo>`
* :dokuwiki:`Asymmetric AXI Stream FIFO Core on wiki <resources/fpga/docs/util_axis_fifo_asym>`

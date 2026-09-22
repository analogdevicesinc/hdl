.. _axi_clock_monitor:

AXI Clock Monitor
===============================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI Clock Monitor <library/axi_clock_monitor>` IP is used to
measure clocks in the system. It allows up to 16 clocks to be measured at a
time.

Features
--------------------------------------------------------------------------------

* Can measure up to 16 clocks (set to 1 by default)
* AXI-based configuration
* Vivado and Quartus compatible

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_clock_monitor/axi_clock_monitor.v`
     - Verilog source for the instance
   * - :git-hdl:`library/axi_clock_monitor/axi_clock_monitor_ip.tcl`
     - Tcl source describing the instance for Vivado
   * - :git-hdl:`library/axi_clock_monitor/axi_clock_monitor_hw.tcl`
     - Tcl source describing the instance for Quartus

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - ID
     - Core ID should be unique for each IP in the system.
   * - FPGA_TECHNOLOGY
     - Encoded value describing the technology/generation of the FPGA device (7series,ultrascale,ultradcale+,versal).
   * - NUM_OF_CLOCKS
     - Select number of CLOCKS.
   * - DIV_RATE
     - This parameter can take the following values: 1, 2, 4, 8.
     
Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::
   :path: library/axi_clock_monitor

Detailed Description
--------------------------------------------------------------------------------

The top module instantiates:

* the :git-hdl:`clock monitor module <library/common/up_clock_mon.v>`
* the :git-hdl:`AXI handling interface <library/common/up_axi.v>`

How to instantiate it in your project:

#. build this IP by going to the :git-hdl:`library/axi_clock_monitor` folder
   and running `make`. For more details on building this, check out our
   :ref:`guide <build_hdl>`. Another requirement is to have your desired
   project already built.
#. import the IP core to your block design, by opening the Block Design of
   the already built project, right-clicking in the Diagram then "Add IP"
   (or CTRL + I) and typing "axi_clock_monitor"
#. configure your IP by specifying how many clocks you want to monitor
#. connect the IP to the AXI interface
#. assign a base address to the IP core, such that it doesn't overlap with other
   components
#. assign clock signals to the clock inputs
#. build again the HDL (now containing this module as well) by clicking
   "Generate Bitstream" from "Program and Debug" section in Vivado

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: axi_clock_monitor
   :no-type-info:

Software Guidelines
--------------------------------------------------------------------------------

.. note::

   Only no-OS software is supported.

We use software to access the core's registers to get the data from the IP.

The following example contains a simple function that reads all the info
from the IP and prints it on the serial terminal:

.. code-block:: C
   :linenos:

   void clock_monitor_info (uint32_t core_base_addr, uint32_t axi_clock_speed_mhz) {
      uint32_t clock_ratio = 0;
      uint32_t clk1_addr = 0x40;
      uint32_t n_clocks = 0;
      uint32_t info_var = 0;
      uint8_t n = 0;

      info_var = axi_io_read(core_base_addr);
      printf("PCORE_VERSION = %d\n", info_var);

      info_var = axi_io_read(core_base_addr, 4);
      printf("ID = %d\n", info_var);

      n_clocks = axi_io_read((core_base_addr, 12));
      printf("n clocks = %d\n", n_clocks);

      info_var = axi_io_read(core_base_addr, 16);
      printf("RESET OUT = %d\n", info_var);

      while (n < n_clocks & n < 16) {
         clock_ratio = axi_io_read((core_base_addr, clk1_addr + 4*n));

         if (clock_ratio == 0) {
            printf("Measured clock_%d: off\n", n);
         } else {
            printf("Measured clock_%d: %d MHz\n", n,
               (clock_ratio * axi_clock_speed_mhz + 0x7fff) >> 16);
         }
         n++;
      }
   }

To call the function, consider the following parameters:

* `core_base_addr` will take the value of the base address set at step 5 of
  the HDL instantiation
* `axi_clock_speed_mhz` will be the reference frequency. In most cases, we
  assume this parameter to be 100 [MHz]

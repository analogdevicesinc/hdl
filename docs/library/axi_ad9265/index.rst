.. _axi_ad9265:

AXI AD9265
================================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI AD9265 <library/axi_ad9265>` IP core
can be used to interface the :adi:`AD9265` ADC, in 1, 2, or 4
data lines active.
More about the generic framework interfacing ADCs, that contains the
``up_adc_channel`` and ``up_adc_common modules``, can be read in :ref:`axi_adc`.

Features
--------------------------------------------------------------------------------

* AXI based configuration
* CRC validation flag
* Configurable number of active data lines
* Real-time data header access
* Vivado and Quartus compatible

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_ad9265/axi_ad9265.v`
     - Verilog source for the AXI AD9265.
   * - :git-hdl:`library/common/up_adc_common.v`
     - Verilog source for the ADC Common regmap.
   * - :git-hdl:`library/common/up_adc_channel.v`
     - Verilog source for the ADC Channel regmap.

Block Diagram
--------------------------------------------------------------------------------

.. image:: block_diagram.svg
   :alt: AXI AD9265 block diagram

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - ID
     - Core ID should be unique for each IP in the system
   * - FPGA_TECHNOLOGY
     - Used to select between devices
   * - ADC_DATAPATH_DISABLE
     - If set, the datapath processing is not generated and output data is
       taken directly from the AD9265
   * - IO_DELAY_GROUP
     - The delay group name which is set for the delay controller

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - adc_clk_in_P
     - LVDS input clock
   * - adc_clk_in_n
     - LVDS input clock
   * - adc_data_in_p
     - LVDS input data
   * - adc_data_in_n
     - LVDS input data
   * - adc_or_in_p
     - LVDS input over range
   * - adc_or_in_n
     - LVDS input over range
   * - delay_clk
     - Clock used by the IDELAYCTRL. Connect to 200MHz
   * - adc_clk
     - The input clock is passed through an IBUFGDS and a BUFG primitive and
       adc_clk reults. This is the clock domain that most of the modules of
       the core run on
   * - adc_rst
     - Output reset, on the adc_clk domain
   * - adc_enable
     - Set when the channel is enabled, activated by software
   * - adc_valid
     - Set when valid data is available on the bus
   * - adc_data
     - Data bus
   * - adc_dovf
     - Data overflow input, from the DMA
   * - s_axi
     - Standard AXI Slave Memory Map interface

Detailed Architecture
--------------------------------------------------------------------------------

.. image:: detailed_architecture.svg
   :alt: AXI AD9265 detailed architecture

Detailed Description
--------------------------------------------------------------------------------

The top module, axi_ad9265, instantiates:

* the lvds interface module
* the channel processing module
* the ADC common register map
* the AXI handling interface
* delay control module

The LVDS interface module, axi_ad9265_if, has as input the lvds signals for
clock, data[7:0] and over range. It uses IO block primitives inside of IP to
handle the input signals. The input clock is routed to a clock distribution
primitive from which it drives all the ADC related processing circuitry. The
data signals are passed through an IDELAYE2 so that each line can be delayed
independently through the delay controller register map. The IP outputs a data
value on every clock cycle, along with the over range signal. The latency
between input and output of the interface module is 3 clock cycles.
The data from the interface module is processed by the adc channel module.
The channel module implements:

* a PRBS monitor
* data format conversion
* DC filter
* the ADC CHANNEL register map

The data analyzed by the PRBS monitor is raw data received from the interface,
before being processed in any way. Selection between PN9 and PN23 sequences
can be done by programming the CHAN_CNTRL_3 register.

``up_adc_common`` module implements the ADC COMMON register map, allowing for basic
monitoring and control of the ADC.

The delay controller module, up_delay_cntrl, allows the dynamic
reconfiguration of the IDELAYE2 blocks. Changing the delay on each individual
line helps compensate trace differences between the data lines on the PCB. A
calibration procedure can be run on software by changing the delays and
monitoring the PRBS sequence.

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: COMMON
   :no-type-info:

.. hdl-regmap::
   :name: ADC_COMMON
   :no-type-info:

.. hdl-regmap::
   :name: ADC_CHANNEL
   :no-type-info:

Design Guidelines
--------------------------------------------------------------------------------

The IP was developed part of the
:dokuwiki:`AD9265 Native FMC Card Reference Design <resources/fpga/xilinx/fmc/ad9265>`.

The control of the AD9265 chip is done through a SPI interface, which is needed
at system level.

The *ADC interface signals* must be connected directly to the top file of the
design, as IO primitives are part of the IP.

The example design uses a DMA to move the data from the output of the IP to
memory.

If the data needs to be processed in HDL before moved to the memory, it can be
done at the output of the IP (at system level) or inside of the adc channel
module (at IP level).

The example design uses a processor to program all the registers. If no
processor is available in your system, you can create your own IP starting from
the interface module.

Software Guidelines
--------------------------------------------------------------------------------

The software for this IP can be found as part of the AD9265 Native FMC Card
Reference Design at: :git-no-OS:`projects/ad9265-fmc-125ebz`
Linux is supported also using :git-linux:`/`.

References
-------------------------------------------------------------------------------

* :git-hdl:`library/axi_ad9265`
* :adi:`AD9265`
* :git-linux:`/`
* :git-no-OS:`projects/ad9265-fmc-125ebz`
* :dokuwiki:`AD9265 Native FMC Card Reference Design <resources/fpga/xilinx/fmc/ad9265>`
* :xilinx:`Zynq-7000 SoC Overview <support/documentation/data_sheets/ds190-Zynq-7000-Overview.pdf>`
* :xilinx:`Zynq-7000 SoC Packaging and Pinout <support/documentation/user_guides/ug865-Zynq-7000-Pkg-Pinout.pdf>`

.. _axi_hmcad15xx:

AXI HMCAD15XX
================================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI HMCAD15XX <library/axi_hmcad15xx>` IP core can be used to
interface the :adi:`HMCAD1511, HMCAD1520` devices.
This documentation only covers the IP core and requires one to be
familiar with the device, for a complete and better understanding.

More about the generic framework interfacing ADCs can be read in :ref:`axi_adc`.

Features
--------------------------------------------------------------------------------

* Support for 8/12/14 bits
* Single/Dual/Quad channel
* Support for Dual 8-bit Quad Channel.
* Synchronization based on FCLK

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_hmcad15xx/axi_hmcad15xx.v`
     - Verilog source for the AXI HMCAD15xx.
   * - :git-hdl:`library/axi_hmcad15xx/axi_hmcad15xx_if.v`
     - Verilog source for the AXI HMCAD15xx physical interface.
   * - :git-hdl:`library/axi_hmcad15xx/axi_hmcad15xx_ip.tcl`
     - IP definition file (AMD tools)

Block Diagram
--------------------------------------------------------------------------------

.. image:: block_diagram.svg
   :alt: AXI HMCAD15XX block diagram

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - ID
     - Core ID should be unique for each IP in the system
   * - FPGA_TECHNOLOGY
     - Used to select between FPGA devices, auto set in project.
   * - NUM_CHANNELS
     - Used when selecting channel mode Single/Dual/Quad.
   * - FPGA_FAMILY
     - Used to select the family variant of the FPGA device, auto set
       in project.
   * - SPEED_GRADE
     - Used to set the FPGA’s speed-grade
   * - DEV_PACKAGE
     - Value describing the device package. The package might affect high-speed
       interfaces
   * - ADC_DATAPATH_DISABLE
     - If set, the datapath processing is not generated and output data is
       taken directly from the HMCAD15XX
   * - IO_DELAY_GROUP
     - The delay group name which is set for the delay controller
   * - IODELAY_CTRL
     - Enables the IO delay mechanism (controller + data delay) in the SERDES
       module

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - fclk_p
     - Positive side of the frame clock used to determine the start of sample.
   * - fclk_n
     - Negative side of the frame clock used to determine the start of sample.
   * - clk_in_p
     - LVDS input positive side of differential reference clock signal
   * - clk_in_n
     - LVDS input negative side of differential reference clock signal
   * - data_in_p
     - LVDS input positive side of differential data signal
   * - data_in_n
     - LVDS input negative side of differential data signal
   * - delay_clk
     - Delay clock input for IO_DELAY control, 200 MHz (7 series) or 300 MHz
       (Ultrascale)
   * - adc_dovf
     - Data overflow. Must be connected to the DMA
   * - s_axi
     - Standard AXI Slave Memory Map interface
   * - adc_clk
     - The clock used to shift data out of the IP
   * - adc_clk_g
     - Global version of adc_clk, used for clocking global resources (FIFOs,
       etc.)
   * - adc_valid
     - Indicates valid data
   * - adc_data
     - Received data output
   * - adc_resetn
     - Reset signal for the ADC

The IP also provides per-channel enable signals (``adc_enable_0`` through
``adc_enable_3``) directly from the ADC channel registers.

Internal Interface Description
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The axi_hmcad15xx operates as follows:

* The LVDS data is deserialized by the
  :git-hdl:`ad_serdes_in<library/xilinx/common/ad_serdes_in.v>` module with
  a 1:8 ratio.
* The data lanes are processed by
  :git-hdl:`sample_assembly<library/hmcad15xx/sample_assembly.v>` based
  on resolution and frame_data. For 8-bit resolution data gets packed into
  8-bit words, for 12/14 bit resolution data gets packed into 16-bit words.
* 14-bit resoltion works only in Quad Channel Mode.
* The bits in the sample are inverted by polarity_mask_s
* All of the samples are sent at the same time on adc_data when adc_valid
  asserts.

Register Map
--------------------------------------------------------------------------------

The register map of the core contains instances of several generic register maps
like ADC common, ADC channel,
:git-hdl:`up_delay_cntrl <library/common/up_delay_cntrl.v>`.
The following table presents the base addresses of each instance, after it you
can find the detailed description of each generic register map.

The absolute address of a register should be calculated by adding the instance
base address to the registers relative address. For a more detailed explanation,
see :ref:`ADC register access <generic-adc-register-access>`.

.. list-table:: Register Map base addresses for axi_hmcad15xx
   :header-rows: 1

   * - HDL reg
     - Software reg
     - Name
     - Description
   * - 0x0000
     - 0x0000
     - BASE
     - See the `Base <#hdl-regmap-COMMON>`__ table for more details.
   * - 0x0000
     - 0x0000
     - RX COMMON
     - See the `ADC Common <#hdl-regmap-ADC_COMMON>`__ table for more details.
   * - 0x0000
     - 0x0000
     - RX CHANNELS
     - See the `ADC Channel <#hdl-regmap-ADC_CHANNEL>`__ table for more details.
   * - 0x0000
     - 0x0800
     - IO_DELAY_CNTRL
     - See the `I/O Delay Control <#hdl-regmap-IO_DELAY_CNTRL>`__ table for
       more details.

.. hdl-regmap::
   :name: COMMON
   :no-type-info:

.. hdl-regmap::
   :name: ADC_COMMON
   :no-type-info:

.. hdl-regmap::
   :name: ADC_CHANNEL
   :no-type-info:

.. hdl-regmap::
   :name: IO_DELAY_CNTRL
   :no-type-info:

Design Guidelines
--------------------------------------------------------------------------------

The control of the HMCAD15xx chip is done through a SPI interface, which is
needed at system level.

The *ADC interface signals* must be connected directly to the top file of the
design, as I/O primitives are part of the IP.

The example design uses a DMA to move the data from the output of the IP to
memory.

If the data needs to be processed in HDL before moving it to the memory, it
can be done at the output of the IP (at system level) or inside of the ADC
channel module (at IP level).

The example design uses a processor to program all the registers. If no
processor is available in your system, you can create your own IP starting
from the interface module.

Software Guidelines
--------------------------------------------------------------------------------

.. list-table:: Main registers used to control the AXI HMCAD15xx IP
   :header-rows: 1

   * - Name
     - Register
     - BIT
     - Description
   * - RESOLUTION
     - 0x4C (ADC Common)
     - [1:0]
     - This value is used to select the resolution for the ADC.
       (2'b00 -> 8-bit resolution,
       2'b01 -> Dual 8-bit resolution, 2'b10 -> 12-bit resolution,
       2'b11 -> 14-bit resolution)
   * - MODE
     - 0x4C (ADC Common)
     - [4:2]
     - This field specifies the Channel Mode. (3'b001 -> Single Channel,
       3'b010 -> Dual Channel, 3'b100 -> Quad Channel)
   * - POLARITY_MASK_S
     - 0x80 (ADC Common)
     - [7:0]
     - Used to invert data coming from each lane. (E.g.
       polarity_mask_s == 8'b11010000 => bits coming on lanes 7, 6 and 4
       will be inverted)

.. note::

  \* The register already exist in ADC Common. This is just a detailed
     explanation.

Software Suppport
--------------------------------------------------------------------------------
* Linux support at :git-linux:`/`

References
-------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/axi_hmcad15xx`
* HDL project at :git-hdl:`projects/hmcad1520_ebz`
* HDL project documentation at :ref:`hmcad1520_ebz`
* :adi:`HMCAD1520`
* :xilinx:`Zynq-7000 SoC Overview <support/documentation/data_sheets/ds190-Zynq-7000-Overview.pdf>`
* :xilinx:`Zynq-7000 SoC Packaging and Pinout <support/documentation/user_guides/ug865-Zynq-7000-Pkg-Pinout.pdf>`

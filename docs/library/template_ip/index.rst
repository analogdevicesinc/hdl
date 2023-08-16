:orphan:

.. _template_ip:

IP Template
================================================================================

Features
--------------------------------------------------------------------------------

* AXI-based configuration
* Vivado and Quartus Compatible

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`master:library/axi_dmac/axi_dmac.v`
     - Verilog source for the peripheral.


Block Diagram
--------------------------------------------------------------------------------

.. image:: ../axi_dmac/block_diagram.svg
   :alt: Template IP block diagram
   :align: center

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::
   :path: library/spi_engine/spi_engine_interconnect

   * - DATA_WIDTH
     - Data width of the parallel SDI/SDO data interfaces.

.. _template_ip interface:

Interface
--------------------------------------------------------------------------------

.. list-table:: Clock and reset
   :header-rows: 1

   * - Name
     - Type
     - Description
   * - ``clk``
     - input
     - All signals are synchronous to this clock.
   * - ``resetn``
     - input
     - Synchronous active low resey.

.. list-table:: DMA_TX interface
   :header-rows: 1

   * - Name
     - Type
     - Description
   * - ``dac_enable_*``
     - output
     -  If set, the channel is enabled (one for each channel).
   * - ``dac_valid``
     - output
     - Indicates valid data request for all channels

.. list-table:: AXI_S_MM interface
   :header-rows: 1

   * - Name
     - Type
     - Description
   * - ``s_axi_*``
     -
     - Standard AXI Slave Memory Map interface .

Detailed Architecture
--------------------------------------------------------------------------------

::

   .. image:: detailed_architecture.svg
      :alt: Template IP detailed architecture
      :align: center

Detailed Description
--------------------------------------------------------------------------------

The top module instantiates

* The ADC channel register map.
* The ADC common register map.
* The AXI handling interface.

The data from the interface module is processed by the ADC channel module.
The Up_adc_common  module implements the ADC COMMON register map, allowing for
basic monitoring and control of the ADC.
The Up_adc_channel module implements the ADC CHANNEL register map, allowing for
basic monitoring and control of the ADC's channel.

Register Map
--------------------------------------------------------------------------------

.. csv-table:: Base (common to all cores)
   :file: ../common/regmap_base.csv
   :class: regmap
   :header-rows: 2

.. csv-table:: ADC Common (axi_ad*)
   :file: ../common/regmap_adc_common.csv
   :class: regmap
   :header-rows: 2

.. csv-table:: ADC Channel (axi_ad*)
   :file: ../common/regmap_adc_channel.csv
   :class: regmap
   :header-rows: 2

Design Guidelines
--------------------------------------------------------------------------------

The control of the chip is done through an SPI interface, which is needed at the
system level.
The :ref:`template_ip interface` must be connected directly to the top file of
the design, as IO primitives are part of the  IP.

The example design uses a DMA to move the data from the output of the IP to memory.
If the data needs to be processed in HDL before moving to the memory, it can be
done at the output of the IP (at the  system level) or inside the ADC interface
module (at the IP level).
The example design uses a processor to program all the registers.
If no processor is available in your system, you  can create your IP starting
from the interface module.

Software Guidelines
--------------------------------------------------------------------------------

Linux is supported also using :git-linux:`/`.

References
--------------------------------------------------------------------------------

* :git-hdl:`/`, :git-hdl:`library/axi_ad777x` library.
* :git-linux:`/`.
* :xilinx:`Zynq-7000 SoC Overview:support/documentation/data_sheets/ds190-Zynq-7000-Overview.pdf`.
* :xilinx:`Zynq-7000 SoC Packaging and Pinout:support/documentation/user_guides/ug865-Zynq-7000-Pkg-Pinout.pdf`.

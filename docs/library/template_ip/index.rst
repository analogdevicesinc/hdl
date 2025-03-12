:orphan:

.. _template_ip:

IP Template
===============================================================================

.. hdl-component-diagram::
   :path: library/spi_engine/spi_engine_execution

Features
-------------------------------------------------------------------------------

- AXI-based configuration
- Vivado and Quartus Compatible

Files
-------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_dmac/axi_dmac.v`
     - Verilog source for the peripheral.


Block Diagram
-------------------------------------------------------------------------------

.. image:: ../axi_dmac/block_diagram.svg
   :alt: Template IP block diagram
   :align: center

Configuration Parameters
-------------------------------------------------------------------------------

.. hdl-parameters::
   :path: library/spi_engine/spi_engine_interconnect

   * - DATA_WIDTH
     - Data width of the parallel SDI/SDO data interfaces.

.. _template_ip interface:

Interface
-------------------------------------------------------------------------------

.. hdl-interfaces::
   :path: library/axi_ad9783

Detailed Architecture
-------------------------------------------------------------------------------

::

   .. image:: detailed_architecture.svg
      :alt: Template IP detailed architecture
      :align: center

Detailed Description
-------------------------------------------------------------------------------

The top module instantiates

- The ADC channel register map.
- The ADC common register map.
- The AXI handling interface.

The data from the interface module is processed by the ADC channel module.
The :git-hdl:`up_adc_common <library/common/up_adc_common.v>` module implements
the ADC COMMON register map, allowing for basic monitoring and control of
the ADC.

The :git-hdl:`up_adc_channel <library/common/up_adc_channel.v>` module
implements the ADC CHANNEL register map, allowing for basic monitoring and
control of the ADC's channel.

Register Map
-------------------------------------------------------------------------------

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
-------------------------------------------------------------------------------

The control of the chip is done through an SPI interface, which is needed at the
system level.
The :ref:`template_ip interface` must be connected directly to the top file of
the design, as IO primitives are part of the  IP.

The example design uses a DMA to move the data from the output of the IP to memory.
If the data needs to be processed in HDL before moving to the memory, it can be
done at the output of the IP (at the system level) or inside the ADC interface
module (at the IP level).

The example design uses a processor to program all the registers.

If no processor is available in your system, you can create your IP starting
from the interface module.

Software Guidelines (if necessary)
-------------------------------------------------------------------------------

To note all the details needed by the software to be in a certain way.

Software Support
-------------------------------------------------------------------------------

- Linux device driver at :git-linux:`/`
- Linux device tree at :git-linux:`/`
- Linux documentation at ...
- No-OS device driver at :git-no-os:`/`
- No-OS project at :git-no-os:`/`
- No-OS documentation at ...
- IIO support at ...

References
-------------------------------------------------------------------------------

- HDL IP core at :git-hdl:`library/axi_ad9783`
- HDL project at :git-hdl:`projects/ad9783_ebz`
- HDL project documentation at :ref:`ad9783_ebz`
- :adi:`AD9783`
- :xilinx:`Zynq-7000 SoC Overview <support/documentation/data_sheets/ds190-Zynq-7000-Overview.pdf>`.
- :xilinx:`Zynq-7000 SoC Packaging and Pinout <support/documentation/user_guides/ug865-Zynq-7000-Pkg-Pinout.pdf>`.

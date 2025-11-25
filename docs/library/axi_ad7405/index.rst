.. _axi_ad7405:

AXI AD7405
================================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI AD7405 <library/axi_ad7405>` IP core
can be used to interface the :adi:`AD7405` device using an
FPGA. The core has a AXI Memory Map interface for configuration, supports the
data interface of the device, and has a simple FIFO interface for the
DMAC.

More about the generic framework interfacing ADCs, that contains the
``up_adc_channel`` and ``up_adc_common modules``, can be read in :ref:`axi_adc`.

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_ad7405/axi_ad7405.v`
     - Verilog source for the AXI AD7405.
   * - :git-hdl:`library/common/util_dec256sinc24b.v`
     - Verilog source for the AXI AD7405 interface.
   * - :git-hdl:`library/common/up_adc_common.v`
     - Verilog source for the ADC Common regmap.
   * - :git-hdl:`library/common/up_adc_channel.v`
     - Verilog source for the ADC Channel regmap.

Block Diagram
--------------------------------------------------------------------------------

.. image:: axi_ad7405.svg
   :alt: AXI AD7405 block diagram

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - adc_data_in
     - Data in
   * - adc_data_out
     - Data out
   * - adc_data_en
     - ADC enable channel
   * - clk_in
     - ADC clock
   * - s_axi
     - Standard AXI Slave Memory Map interface

Register Map
--------------------------------------------------------------------------------

The register map of the core contains instances of several generic register maps
like ADC common, ADC channel.
The following table presents the base addresses of each instance, after it you
can find the detailed description of each generic register map.

The absolute address of a register should be calculated by adding the instance
base address to the registers relative address. For a more detailed explanation,
see :ref:`ADC register access <generic-adc-register-access>`.

.. list-table:: Register Map base addresses for axi_ad7405
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

.. hdl-regmap::
   :name: COMMON
   :no-type-info:

.. hdl-regmap::
   :name: ADC_COMMON
   :no-type-info:

.. hdl-regmap::
   :name: ADC_CHANNEL
   :no-type-info:

Software Support
--------------------------------------------------------------------------------

Linux driver at: :git-hdl:`drivers/iio/adc/ad7405.c`

Refereces
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/axi_ad7405`
* HDL project at :git-hdl:`projects/ad7405_fmc`
* HDL project documentation at :ref:`ad7405_fmc`
* :adi:`AD7405`

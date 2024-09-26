.. _util_sigma_delta_spi:

Sigma-Delta SPI Util FPGA Peripheral
===============================================================================

.. hdl-component-diagram::

ADCs from the Analog Devices Sigma-Delta converter family use a low-level
communication protocol that multiplexes the SPI bus MISO signal and the data
ready interrupt signal over the same physical wire (DOUT/RDY).
The :git-hdl:`Util-Sigma-Delta-SPI <library/util_sigma_delta_spi>` peripheral
can be used to de-multiplex these signals inside a FPGA.

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/util_sigma_delta_spi/util_sigma_delta_spi.v`
     - Verilog source for the peripheral.
   * - :git-hdl:`library/util_sigma_delta_spi/util_sigma_delta_spi_ip.tcl`
     - TCL script to generate the Vivado IP-integrator project for the
       peripheral

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - IDLE_TIMEOUT
     - Number of clock cycles after SPI bus activity before data ready is
       detected.
   * - NUM_OF_CS
     - Number of total chip-select pins on the SPI bus.  
   * - CS_PIN
     - Chip-select pin used for the Sigma-Delta converter. 

Signal and Interface Pins
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - clk
     - Clock input. All other signals are synchronous to this clock.
   * - resetn
     - Resets the internal state machine of the core.
   * - spi_active
     - Indicates whether a SPI transaction is active on the SPI bus.
       (Active high).
   * - data_ready
     - Indicates when a data ready condition is detected. (Active high).
   * - s_spi
     - SPI bus interface connected to the upstream SPI controller.
   * - m_spi
     - SPI bus interface connected to the downstream SPI bus.

Theory of Operation
--------------------------------------------------------------------------------

The Sigma-Delta Util Peripheral monitors the SPI bus that is connected to the
s_spi interface for the converters data ready condition. The m_spi interface is
directly connected to the s_spi interface. In a typical configuration the s_spi
interface is connected to a SPI controller and the m_spi interface is connected
to external SPI bus pins.

The data_ready signal is level active high and will be asserted as long as the
data ready condition is detected. It can for example be connected to a interrupt
controller to start a interrupt service routine that will read the converted
data sample from the ADC or it can be connected to a HDL block like the SPI
Engine Offload block that will generate a SPI transaction to read the converted
signal.

The data ready condition is only detected if the chip-select signal which is
connected to the converter is asserted and the spi_active signal is de-asserted
and both signals have been in that state for at least IDLE_TIMEOUT clock cycles.
The timeout is used to avoid spurious signal detection and the IDLE_TIMEOUT
parameter should be configured so that the period it takes to complete
IDLE_TIMEOUT clock cycles with the clk clock is larger than the “CS falling edge
to DOUT/RDY active time” and “SCLK inactive edge to DOUT/RDY high/low” as
specified in the datasheet for the converter.

Supported devices
-------------------------------------------------------------------------------

-  :adi:`AD7172-2`
-  :adi:`AD7173-8`
-  :adi:`AD7175-2`
-  :adi:`AD7176-2`
-  :adi:`AD7190`
-  :adi:`AD7192`
-  :adi:`AD7195`
-  :adi:`AD7780`
-  :adi:`AD7785`
-  :adi:`AD7787`
-  :adi:`AD7788`
-  :adi:`AD7789`
-  :adi:`AD7790`
-  :adi:`AD7791`
-  :adi:`AD7792`
-  :adi:`AD7793`
-  :adi:`AD7794`
-  :adi:`AD7795`
-  :adi:`AD7796`
-  :adi:`AD7797`
-  :adi:`AD7798`
-  :adi:`AD7799`

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/util_sigma_delta_spi/util_sigma_delta_spi.v`
* :dokuwiki:`UTIL SIGMA DELTA SPI on wiki <resources/fpga/peripherals/util_sigma_delta_spi>`

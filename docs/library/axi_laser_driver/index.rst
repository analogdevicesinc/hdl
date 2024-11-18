.. _axi_laser_driver:

AXI Laser Driver
================================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI Laser Driver <library/axi_laser_driver>` IP core
generates all the necessary control signals for the
``ad_fmclidar1_ebz`` prototyping platform, to drive the laser, switch between the
TIA channels and synchronize all the data flow inside the FPGA. This
documentation covers the main functionality of the IP core and its software
programmable registers.

Features
--------------------------------------------------------------------------------

* PWM generator with a free running counter
* Software configurable frequency and pulse width for the PWM
* Control and status lines for the ADP3624 MOSFET driver
* Software configurable interrupts
* Software configurable TIA channel sequencer

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_laser_driver/axi_laser_driver.v`
     - Verilog source for the peripheral.

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - ID
     - Core ID should be unique for each instance of the IP
   * - ASYNC_CLK_EN
     - Bit must be set if the core clock is different from the AXI Memory
       Mapped interface clock
   * - PULSE_WIDTH
     - The pulse width of the generated signal. The resolution is the core
       clock's time period.
   * - PULSE_PERIOD
     - The period of the generated signal. The resolution is the core clock's
       time period.

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - s_axi
     - Standard AXI Slave Memory Map interface
   * - ext_clk
     - An external clock input. If ASYNC_CLK_EN is set, this clock will be used
       as the core clock.
   * - driver_en_n
     - This line will control the MOSFET driver's shot down pin. If set the
       MOSFET driver is not working.
   * - driver_pulse
     - Generated pulse, which is used to drive the laser
   * - driver_otw_n
     - Over temperature warning flag of the MOSFET driver.
   * - driver_dp_reset
     - A reset signal, which asserts right before the generated pulse. This
       signal can be used for preconditioning various IPs of the data path.
   * - tia_chsel
     - Control lines for the TIA channel multiplexer.
   * - irq
     - Interrupt signal.

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: AXI_LASER_DRIVER

References
-------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/axi_laser_driver`
* :dokuwiki:`AXI Laser Driver on wiki <resources/fpga/docs/axi_laser_driver>`

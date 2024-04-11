.. _axi_pwm_gen:

AXI PWM Generator
================================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI PWM Generator <library/axi_pwm_gen>` IP core is used to generate
a maximum of 16 configurable signals (Pulse-Width Modulations).
The pulses are generated according to the state of a counter; there is one counter
for each pulse.

Features
--------------------------------------------------------------------------------

* Up to 16 configurable signals(period, width, offset)
* External synchronization
* External clock

The offset feature will synchronize counters 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
11, 12, 13, 14, 15 to an offset counter.

The AXI PWM Generator core can be synchronized by an external signal.
The offset counter will wait for a HIGH -> LOW transition of the synchronization
pulse. 

If another synchronization is needed, the ``external_sync`` signal should be set
HIGH and the ``load_config`` should be toggled (by register write). This will
cause the counters to wait for another ``external_sync`` HIGH -> LOW transition.
To disable a PWM, write 0 to its ``period`` register.

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_pwm_gen/axi_pwm_gen.sv`
     - SystemVerilog source for the peripheral.

Block Diagram
--------------------------------------------------------------------------------

.. image:: block_diagram.svg
   :alt: AXI PWM Generator block diagram

Configuration Parameters
--------------------------------------------------------------------------------

.. note::

   Both pulse width and pulse offset are in number of clock cycles.

.. hdl-parameters::

   * - ID
     - Core ID should be unique for each IP in the system.
   * - ASYNC_CLK_EN
     - Use external clock, asynchronous to s_axi_aclk.
   * - N_PWMS
     - Number of pulses/pwms.
   * - PWM_EXT_SYNC
     - PWM offset counter uses external sync.
   * - EXT_ASYNC_SYNC
     - The external sync for pulse 0 is asynchronous.

.. _axi_pwm_gen interface:

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - ext_clk
     - External clock.
   * - ext_sync
     - External sync signal, synchronizes pulses to an external signal.
   * - pwm_*
     - Output PWM, up to 16, indexed from 0 to 15.

Detailed Description
--------------------------------------------------------------------------------

The AXI PWM Generator offers the possibility of four output signals (PWMs).
Pulse 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 can have offsets in
reference to the pwm counter.

The pulse generator is based on incrementing counters.
In a pulse period, the first interval of the signal, until the level transition,
the signal level is HIGH (pulse_width) and the second interval is LOW
(pulse_period-pulse_width).

By default, all counters start at the same time. When a different phase (delay
is needed between the pulses, the offset value is calculated in number of clock cycles:

The below timing diagram, shows the ``external_sync`` functionality:

.. wavedrom::

   { "signal" : [
     { "name": "clk", "wave": "P............................"},
     { "name": "external_sync", "wave": "1.....0......................"},
     { "name": "pwm 0", "wave": "l.............h..l....h..l..."},
     { "name": "pwm 1", "wave": "l.................h..l....h.."},
     { "name": "counter 0", "wave": "=......444444455555555444444=","data":["1","2","3","4","5","6","7","8","1","2","3","4","5","6","7","8","1","2","3","4","5","6"]},
     { "name": "counter 1", "wave": "=..........44444445555555544=","data":["1","2","3","4","5","6","7","8","1","2","3","4","5","6","7","8","1","2"]}],
   foot: {text: ['tspan', 'External sync example'],tock:-6
   }}

The timing diagram below, shows the ``load_config`` functionality:
All four pulses are active and all four pulses have the same period.

.. wavedrom::

   { "signal" : [
     { "name": "clk", "wave": "P............................"},
     { "name": "load_config", "wave": "10..........................."},
     { "name": "pulse 0", "wave": "l...........h....l.....h....l"},
     { "name": "pulse 1", "wave": "l...........h..l.......h..l.."},
     { "name": "pulse 2", "wave": "l..............h....l.....h.."},
     { "name": "pulse 3", "wave": "l....................h..l...."},
     { "name": "counter 0", "wave": "x=44444444445555555555544444=","data":["1","2","3","4","5","6","7","8","9","10","11","1","2","3","4","5","6","7","8","9","10","11","1","2","3","4","5"]},
     { "name": "counter 1", "wave": "x=44444444445555555555544444=","data":["1","2","3","4","5","6","7","8","9","10","11","1","2","3","4","5","6","7","8","9","10","11","1","2","3","4","5"]},
     { "name": "counter 2", "wave": "x=...44444444445555555555544=","data":["1","2","3","4","5","6","7","8","9","10","11","1","2","3","4","5","6","7","8","9","10","11","1","2"]},
     { "name": "counter 3", "wave": "x=.........44444444445555555=","data":["1","2","3","4","5","6","7","8","9","10","11","1","2","3","4","5","6","7",]}],
   foot: {text: ['tspan', 'Load config example'],tock:-1
   }}

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: axi_pwm_gen
